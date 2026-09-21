# A2A Agent Gateway Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build one locally controlled deterministic A2A agent that receives a complete authorized room-context packet, sends visible progress, and returns source-cited results through the new agent gateway.

**Architecture:** The room gateway remains the only room authorization, persistence, event-delivery, and decision authority. It persists/leasing tasks and builds snapshots. The agent gateway has no database credentials; it claims task leases through authenticated internal HTTP, invokes the pinned local agent via the official A2A client, and submits normalized updates. The UI renders persisted events only.

**Tech Stack:** Rust 2024, Tokio, Axum, SQLx/PostgreSQL, official `a2aproject/a2a-rs`, JSON Schema, React 19, PatternFly, Vite/Vitest, Keycloak client credentials, Podman Compose.

**Spec:** `.ai/specs/decisions/007-a2a-agent-gateway-foundation.md`; `thought-khoral-agent-gateway/.ai/specs/{what,how}/a2a-agent-gateway-foundation.md`

## Global Constraints

- Pin a reviewed Apache-2.0 release of the official A2A Rust SDK; record release, commit, license, advisory-check date, bindings, and Rust MSRV before Cargo adoption.
- All cross-project protocol changes are additive, fixture-backed, and release/vendored before consumers change.
- The agent gateway/reference agent receive no PostgreSQL credentials, filesystem write access, shell, or unrestricted outbound network authority.
- Packets contain full ordered history visible to the invoking human, delegated only to the named task/agent, plus active decisions, task/room/requester/agent bindings, revision, issue time, expiry, and integrity hash.
- Authenticate every service call with a short-lived Keycloak client-credentials token scoped to the room-gateway audience. Validate every agent input, rate-limit/coalesce progress, and make updates idempotent.
- Never auto-open/embed an agent handoff. Render a validated HTTPS link only after a human click.
- Initial registered identity: `74686f75-6768-746b-686f-72616c000003` / `Reference Agent`; skills: `summarize-context`, `extract-action-items`.

## Files and boundaries

| Area | Files | Ownership |
| --- | --- | --- |
| Contracts | `thought-khoral-contracts/schemas/{rpc,room-event}.schema.json`, `protocol.md`, fixtures | Browser request and persisted event compatibility. |
| Room gateway | `src/{protocol,store,rooms,auth,config,ws,agent_service}.rs`, migration, tests | Task authority, packet filtering, internal service API. |
| Agent gateway | `Cargo.toml`, `src/**`, `tests/**` | Registry, A2A transport, deterministic reference agent, no room-store access. |
| UI | `src/api.tsx`, `features/room/**` | Task composer and safe progress/result/citation projection. |
| Platform | Compose, containers, Keycloak, Kubernetes, smoke scripts | Local isolation and workload identity. |

### Task 1: Publish additive external-agent task contract

**Files:**
- Modify: `thought-khoral-contracts/schemas/rpc.schema.json`, `thought-khoral-contracts/schemas/room-event.schema.json`, `thought-khoral-contracts/protocol.md`, `thought-khoral-contracts/test/validate-fixtures.mjs`
- Create: `thought-khoral-contracts/fixtures/{valid/agent-task-start.json,invalid/agent-task-start-unknown-skill.json,events/valid/agent-task-progressed.json,events/valid/agent-task-summary-succeeded.json,events/invalid/agent-task-result-unknown-citation.json}`
- Modify: `thought-khoral-room-gateway/contracts/<current-room-contract>/**`, `thought-khoral-room-gateway/contracts/lock.json`

**Interfaces:** Produces browser RPC `agent.task.start { agentId, skillId, input }` and additive events `agent.task.requested|progressed|awaiting_external_input|succeeded|failed`.

- [ ] **Step 1: Write the fixtures and failing validator assertions**

Use the fixed UUID and this request shape:

```json
{"jsonrpc":"2.0","id":"agent-task-start-1","method":"agent.task.start","params":{"contractVersion":"<retained-room-contract-version>","requestId":"81000000-0000-4000-8000-000000000001","roomId":"10000000-0000-4000-8000-000000000001","occurredAt":"2026-09-21T12:00:00Z","agentId":"74686f75-6768-746b-686f-72616c000003","skillId":"summarize-context","input":"Summarize the room."}}
```

The invalid fixture differs only by `skillId: "unregistered-skill"`.

- [ ] **Step 2: Run fixtures red**

Run: `cd thought-khoral-contracts && npm test`

Expected: FAIL because `agent.task.start` is unknown.

- [ ] **Step 3: Add bounded discriminated schemas**

Define skills as exactly `summarize-context|extract-action-items`; input ≤ 8000. Every new event requires `taskId`, `agentId`, `requesterId`, `skillId`, and `contextRevision`. Progress has phase `accepted|retrieving-context|working|finalizing`, text ≤ 512, optional percent 0–100. Success is one of `context-summary.v1 {summary,citations}` or `action-items.v1 {actionItems,citations}`. Preserve current Action Items task fixtures unchanged.

- [ ] **Step 4: Document event order and safe handoff semantics**

State that progress is durable only at meaningful changes; terminal events never coalesce; citations name packet-visible UUID sources; a handoff holds only instruction, HTTPS URL, host, and expiry; browser/agent secrets never enter the contract.

- [ ] **Step 5: Verify green and vendor the released snapshot**

Run: `npm test`

Expected: PASS. Release a patch contract tag, copy that exact artifact into the room gateway vendor directory, and update its lock with tag/commit/hashes.

- [ ] **Step 6: Commit**

```bash
cd thought-khoral-contracts && git add schemas protocol.md fixtures test && git commit -m "feat: add governed external agent task contract"
```

### Task 2: Persist, lease, and start external tasks in the room gateway

**Files:**
- Create: `thought-khoral-room-gateway/migrations/0005_agent_tasks.sql`, `thought-khoral-room-gateway/tests/agent_task_store_test.rs`
- Modify: `thought-khoral-room-gateway/src/{protocol,store,rooms,lib}.rs`, `thought-khoral-room-gateway/tests/{protocol_test,room_flow_test,authorization_test}.rs`

**Interfaces:** Produces `AgentTaskStart`, `AgentTaskRecord`, `AgentTaskLease`, `claim_agent_task`, `context_for_lease`, `record_agent_task_update`, and human-only task creation.

- [ ] **Step 1: Write failing transactional-store tests**

```rust
#[tokio::test]
async fn task_start_creates_one_requested_event_and_one_queued_record() {
    let store = test_store().await;
    let result = store.start_agent_task(test_task_start()).await.unwrap();
    assert_eq!(result.events.iter().filter(|event| event.kind == "agent.task.requested").count(), 1);
    assert_eq!(store.agent_task(result.task_id).await.unwrap().state, AgentTaskState::Queued);
}
#[tokio::test]
async fn expired_lease_can_be_claimed_again_but_live_lease_cannot() {
    let store = test_store().await;
    let task = store.start_agent_task(test_task_start()).await.unwrap().task_id;
    assert!(store.claim_agent_task(task, first_lease_owner(), now()).await.unwrap().is_some());
    assert!(store.claim_agent_task(task, second_lease_owner(), now()).await.unwrap().is_none());
    assert!(store.claim_agent_task(task, second_lease_owner(), expired_lease_time()).await.unwrap().is_some());
}
#[tokio::test]
async fn duplicate_update_id_returns_prior_events_without_reappend() {
    let store = test_store().await;
    let task = claimed_test_task(&store).await;
    let first = store.record_agent_task_update(task, test_progress_update()).await.unwrap();
    let replay = store.record_agent_task_update(task, test_progress_update()).await.unwrap();
    assert_eq!(first.events, replay.events);
    assert_eq!(store.room_event_count(test_room_id()).await.unwrap(), 2);
}
```

- [ ] **Step 2: Run red**

Run: `cd thought-khoral-room-gateway && cargo test --test agent_task_store_test`

Expected: FAIL because task types/store are absent.

- [ ] **Step 3: Add types, migration, and idempotent transaction behavior**

Add `AgentTaskStart` to `ValidatedRequest` and all match/fingerprint methods:

```rust
pub struct AgentTaskStart { pub id: String, pub contract_version: String, pub request_id: Uuid, pub room_id: Uuid, pub occurred_at: DateTime<Utc>, pub agent_id: Uuid, pub skill_id: AgentSkillId, pub input: String }
pub enum AgentSkillId { SummarizeContext, ExtractActionItems }
```

Create `agent_tasks` (task/room/requester/agent/skill/input/revision/state/lease/timestamps) and `agent_task_updates` with primary key `(task_id, update_id)`. Append `agent.task.requested`, allocate the revision after that event, and create the row in the existing room transaction.

- [ ] **Step 4: Enforce human authority**

Only `ActorRole::Human` may start a task. Duplicate browser request IDs return the original event. The room gateway does not invoke an agent synchronously and does not provide database credentials outside itself.

- [ ] **Step 5: Verify green**

Run: `cargo test --test agent_task_store_test --test protocol_test --test room_flow_test --test authorization_test`

Expected: PASS; no duplicate task and no agent caller can start one.

- [ ] **Step 6: Commit**

```bash
cd thought-khoral-room-gateway && git add migrations src tests && git commit -m "feat: persist governed external agent tasks"
```

### Task 3: Expose zero-trust room context and update endpoints

**Files:**
- Create: `thought-khoral-room-gateway/src/agent_service.rs`, `thought-khoral-room-gateway/tests/agent_service_test.rs`
- Modify: `thought-khoral-room-gateway/src/{auth,config,ws,rooms,lib}.rs`, `thought-khoral-platform/keycloak/thought-khoral-dev-realm.json`

**Interfaces:** `POST /internal/v1/agent-tasks/claim`; `GET /internal/v1/agent-tasks/{taskId}/context`; `POST /internal/v1/agent-tasks/{taskId}/updates`.

- [ ] **Step 1: Write failing internal-API integration tests**

Assert missing/user/wrong-audience tokens get 401/403; a valid agent-gateway client token can claim; an incorrect lease token reveals no context; duplicate `updateId` returns prior events.

- [ ] **Step 2: Run red**

Run: `cargo test --test agent_service_test`

Expected: FAIL because no routes or workload identity exist.

- [ ] **Step 3: Add Keycloak workload identity and internal token validation**

Create a confidential, service-account-enabled Keycloak client named `thought-khoral-agent-gateway` whose client-credentials token has audience `thought-khoral-room-gateway`. Add an internal validator that requires that audience and authorized-party/client ID; it must not map this token to a room `human|agent` role.

- [ ] **Step 4: Implement the narrow handlers and packet**

```rust
pub struct ClaimRequest { pub lease_owner: Uuid }
pub struct ContextResponse { pub packet: RoomContextPacket, pub lease_token: Uuid }
pub struct TaskUpdateRequest { pub update_id: Uuid, pub context_revision: i64, pub update: NormalizedAgentTaskUpdate }
```

Refactor WebSocket replay’s visibility predicate so packet creation filters all events through the requesting human’s current delivery visibility. Include ordered wire events through the revision, active decisions, task input, expiry, and a SHA-256 canonical-packet hash. Persist/broadcast only validated update events.

- [ ] **Step 5: Verify all gateway checks**

Run: `cargo fmt --check && cargo clippy --all-targets -- -D warnings && cargo test --all-targets`

Expected: PASS; browser and reference-agent credentials cannot call internal routes.

- [ ] **Step 6: Commit**

```bash
cd thought-khoral-room-gateway && git add src tests && git commit -m "feat: broker authorized room context for agent tasks"
```

### Task 4: Create the agent gateway, registry, and pinned official A2A client

**Files:**
- Create: `thought-khoral-agent-gateway/{Cargo.toml,Cargo.lock,docs/dependencies/a2a-rs.md}`
- Create: `thought-khoral-agent-gateway/src/{lib,config,domain,registry,room_client}.rs`, `thought-khoral-agent-gateway/src/bin/thought-khoral-agent-gateway.rs`
- Create: `thought-khoral-agent-gateway/tests/{config,registry,room_client}_test.rs`

**Interfaces:** Produces `RegisteredAgent`, `RoomContextPacket`, `AgentTaskLease`, and `RoomGatewayClient::{claim,fetch_context,submit_update}`.

- [ ] **Step 1: Record official dependency evidence**

Write `docs/dependencies/a2a-rs.md` with official repo/release URL, exact crate/version, tag/commit, Apache-2.0 evidence, supported HTTP/JSON-RPC/SSE bindings, MSRV, and advisory-check command/date. Use only official core/client crates in this slice.

- [ ] **Step 2: Write failing config/registry/client tests**

```rust
#[test] fn registry_rejects_card_endpoint_or_skill_drift() {
    let mut card = fixed_reference_card();
    card.skills.clear();
    assert!(RegisteredAgent::from_pinned_card(reference_registration(), card).is_err());
}
#[test] fn config_rejects_non_loopback_agent_or_unallowlisted_handoff_host() {
    assert!(GatewayConfig::parse(test_env("https://remote-agent.invalid", "allowed.example")).is_err());
    assert!(GatewayConfig::parse(test_env("http://127.0.0.1:9090", "unregistered.example")).is_err());
}
#[tokio::test] async fn room_client_never_forwards_a_user_access_token() {
    let server = recording_mock_room_gateway().await;
    RoomGatewayClient::for_test(server.url(), service_token_provider()).claim(test_claim()).await.unwrap();
    assert_eq!(server.last_authorization().await, Some("Bearer service-token".into()));
}
```

- [ ] **Step 3: Run red**

Run: `cargo test --test config_test --test registry_test --test room_client_test`

Expected: FAIL because the crate is absent.

- [ ] **Step 4: Implement strict local configuration and registry**

```rust
pub struct RegisteredAgent { pub id: Uuid, pub display_name: String, pub card_url: Url, pub allowed_skills: BTreeSet<SkillId>, pub allowed_handoff_hosts: BTreeSet<String> }
```

Require Keycloak token URL/client ID/secret, exact room-gateway origin, fixed Agent Card URL/host, allowed skills, lease/poll/rate limits. Pin Card identity, skills, binding, and endpoint at startup. `RoomGatewayClient` uses client credentials only for the configured room-gateway origin.

- [ ] **Step 5: Pin the SDK and verify green**

Run: `cargo metadata --locked --format-version 1 && cargo tree -i a2a-client-lf && cargo test --all-targets`

Expected: PASS; only the selected official A2A release is locked.

- [ ] **Step 6: Commit**

```bash
cd thought-khoral-agent-gateway && git add Cargo.toml Cargo.lock src tests docs/dependencies && git commit -m "feat: add zero-trust A2A agent gateway foundation"
```

### Task 5: Implement deterministic A2A reference agent and dispatch worker

**Files:**
- Create: `thought-khoral-agent-gateway/src/{reference_agent,a2a_adapter,dispatcher,update_validation}.rs`
- Create: `thought-khoral-agent-gateway/src/bin/thought-khoral-reference-agent.rs`
- Create: `thought-khoral-agent-gateway/tests/{reference_agent,dispatcher,a2a_adapter}_test.rs`, `thought-khoral-agent-gateway/fixtures/{agent-card,context-packet}.json`
- Modify: `thought-khoral-agent-gateway/src/{lib,bin/thought-khoral-agent-gateway}.rs`

**Interfaces:** Consumes task leases and packets; produces idempotent normalized progress/terminal updates.

- [ ] **Step 1: Write failing A2A black-box tests**

Require fixed Agent Card and this stream:

```text
submitted → working("Reading authorized room context") → working("Preparing cited result") → completed
```

Assert `summarize-context` is stable from room ID/revision/decision titles/message count and cites included event IDs. Assert `extract-action-items` parses only `- text | owner: value | due: value` from task input and cites the invocation event.

- [ ] **Step 2: Run red**

Run: `cargo test --test reference_agent_test --test dispatcher_test --test a2a_adapter_test`

Expected: FAIL because no agent/dispatcher exists.

- [ ] **Step 3: Implement reference server and safe adapter**

Expose official A2A JSON-RPC/HTTP+JSON only on a local-only listener protected by the agent-gateway bearer secret. Reject unknown/expired/mismatched packet, citation, and skill data. No filesystem, database, shell, model, tools, URLs, or external network calls.

- [ ] **Step 4: Implement lease-to-terminal dispatch**

Claim one lease, fetch/verify task/agent/revision/hash/expiry, call the pinned A2A skill, and map allowed statuses/artifacts to `NormalizedAgentTaskUpdate`. Derive update IDs from `(task_id, A2A event ordinal, kind)`, coalesce repeated phase text by interval, always submit terminal result, and submit only safe `invalid_agent_response|context_expired|execution_failed` failures.

- [ ] **Step 5: Add handoff validation without navigation**

Allow only non-empty instruction, HTTPS URL, unexpired handoff, packet/task/revision binding, and registered destination host. Treat the URL as data: never fetch, spawn a browser, or shell it.

- [ ] **Step 6: Verify and commit**

Run: `cargo fmt --check && cargo clippy --all-targets -- -D warnings && cargo test --all-targets`

Expected: PASS; ordered progress/results are emitted once and invalid updates create no room submission.

```bash
cd thought-khoral-agent-gateway && git add src tests fixtures && git commit -m "feat: dispatch deterministic A2A room tasks"
```

### Task 6: Render explicit task start, progress, citations, and handoffs

**Files:**
- Create: `thought-khoral-workspace-ui/src/features/room/{AgentTaskComposer,AgentTaskComposer.test}.tsx`
- Modify: `thought-khoral-workspace-ui/src/{api,api.test}.tsx`, `thought-khoral-workspace-ui/src/features/room/{ChatStream,ChatStream.test,ChatStream.css,RoomPage}.tsx`

**Interfaces:** Consumes Task 1 events; produces `agent.task.start` only for human users.

- [ ] **Step 1: Write failing UI tests**

Test requested → progressed → succeeded for both skills. Assert an accessible task card includes phase/result/citation. Assert the handoff anchor has `target="_blank"` and `rel="noopener noreferrer"`, host text, and no automatic navigation.

- [ ] **Step 2: Run red**

Run: `cd thought-khoral-workspace-ui && npm test -- --run src/api.test.ts src/features/room/ChatStream.test.tsx src/features/room/AgentTaskComposer.test.tsx`

Expected: FAIL because new event types/composer are absent.

- [ ] **Step 3: Extend strict projection and add composer**

Add discriminated task result/progress/handoff validation to `api.tsx` without weakening existing Action Items parsing. Add a human-only `AgentTaskComposer` with fixed Reference Agent, two-skill selection, ≤8000 input, and:

```ts
createRpcRequest('agent.task.start', roomId, { agentId: REFERENCE_AGENT_ID, skillId, input: input.trim() })
```

Do not make free-text `@` delivery invoke external work.

- [ ] **Step 4: Render safely and verify green**

Render citations as controls that focus/scroll to existing event IDs. Use no returned HTML and no `window.open`.

Run: `npm test && npm run build && npm run test:preview`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
cd thought-khoral-workspace-ui && git add src && git commit -m "feat: show governed external agent tasks"
```

### Task 7: Compose isolated local services and prove the vertical slice

**Files:**
- Create: `thought-khoral-platform/containers/{agent-gateway,reference-agent}.Containerfile`, `thought-khoral-platform/kube/{agent-gateway,reference-agent}.yaml`, `thought-khoral-platform/scripts/smoke-agent-gateway.mjs`
- Modify: `thought-khoral-platform/{compose.yaml,README.md,keycloak/thought-khoral-dev-realm.json,scripts/smoke.sh,scripts/validate-kube.sh}`
- Create: `thought-khoral-agent-gateway/docs/verification/a2a-foundation.md`

**Interfaces:** Runs room gateway, agent gateway, and reference agent with internal-only service paths.

- [ ] **Step 1: Write smoke assertions before Compose changes**

Require services `thought-khoral-agent-gateway` and `thought-khoral-reference-agent`; neither may publish a host port or get `DATABASE_URL`. Require non-root/read-only/no-new-privileges/tmpfs. Require an internal task for both skills to emit progress then exactly one cited terminal result.

- [ ] **Step 2: Run red**

Run: `cd thought-khoral-platform && bash scripts/smoke.sh`

Expected: FAIL because services and assertions are missing.

- [ ] **Step 3: Add Compose/container/Kubernetes identity and isolation**

Build two agent-gateway binaries, configure only Keycloak service credentials/room endpoint/Card endpoint/shared inbound secret, and do not expose reference-agent port. Add matching non-root read-only internal Kubernetes Services; leave production mTLS/workload identity configuration to deployment secret management, never checked-in certificates.

- [ ] **Step 4: Add full smoke and platform validation**

`smoke-agent-gateway.mjs` authenticates Alice, creates a fresh room, invokes both skills, waits for expected event order, validates citations, and asserts a hidden targeted message is absent from the captured packet test endpoint/harness.

Run: `bash scripts/validate-kube.sh && bash scripts/smoke.sh`

Expected: PASS.

- [ ] **Step 5: Run cross-project gate and document evidence**

Run:

```bash
cd thought-khoral-contracts && npm test
cd ../thought-khoral-room-gateway && cargo fmt --check && cargo clippy --all-targets -- -D warnings && cargo test --all-targets
cd ../thought-khoral-agent-gateway && cargo fmt --check && cargo clippy --all-targets -- -D warnings && cargo test --all-targets
cd ../thought-khoral-workspace-ui && npm test && npm run build && npm run test:preview
cd ../thought-khoral-platform && bash scripts/validate-kube.sh && bash scripts/smoke.sh
cd .. && bash scripts/verify-spec-hierarchy.sh
```

Expected: all commands exit 0. If the identity verifier has unrelated baseline allowlist failures, list every path and do not claim a passing release gate until they are fixed.

- [ ] **Step 6: Commit platform and verified exclusions**

```bash
cd thought-khoral-platform && git add compose.yaml containers keycloak kube scripts README.md && git commit -m "feat: compose local A2A agent gateway foundation"
cd ../thought-khoral-agent-gateway && git add docs/verification README.md .ai/specs && git commit -m "docs: verify local A2A gateway foundation"
```

## Self-review

| Approved requirement | Tasks |
| --- | --- |
| Official A2A transport/Agent Card/task updates/artifacts | 4–5 |
| Local deterministic two-skill agent | 4–5 |
| Complete authorized context, revision, citations | 2–5 |
| Room authority and no direct agent DB access | 2–4, 7 |
| Progress, results, handoff presentation | 1–3, 5–7 |
| Zero trust | 2–5, 7 |
| Additive compatibility/fixtures/e2e evidence | 1, 6–7 |

The plan introduces every interface before later tasks consume it. It intentionally excludes remote admission, MCP, models/tools, context compaction/retrieval, agent-to-agent invocation, and ThoughtKhoral-owned human-interaction forms.
