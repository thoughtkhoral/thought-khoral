# History-aware Codex room conversations implementation plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task after its execution gates pass. Steps use checkbox syntax. Delegation is optional and requires the user's chosen execution mode.

**Goal:** Let humans explicitly address a shared Codex room participant that uses authorized room conversation history and survives ordinary restart.

**Architecture:** Keep the retained room socket and deterministic Reference Agent unchanged. A separately versioned HTTP conversation API creates atomic public prompts/tasks, mediates revision-bound room context through the agent gateway, and records accepted Codex replies as ordinary room messages. An independent Rust A2A worker owns pinned Codex app-server processes, native history, and SQLite execution receipts.

**Tech stack:** Rust edition 2024/minimum 1.85; Axum 0.8.9, Tokio, SQLx 0.8.6 (PostgreSQL in the broker, SQLite in the worker); existing reviewed A2A core/client/server versions; Codex CLI 0.160.0; JSON Schema Draft 2020-12 and locked Ajv 8.20.0/ajv-formats 3.0.1; existing React/TypeScript/PatternFly UI; rootless Podman Compose.

**Spec:** [root requirements](../what/codex-chat-agent.md), [root design](codex-chat-agent.md), and [Decision 009](../decisions/009-codex-chat-agent.md). Exact wire rules live in the [contracts profile](https://github.com/thoughtkhoral/thought-khoral-contracts/blob/thought-khoral-agent-conversation-v1.0.0/.ai/specs/how/agent-conversation-profile.md). Each child specification index links its local requirements/design.

## Status and execution gates

Prepared on 2026-10-02 and approved by the project maintainer on 2026-10-05,
including root/local What/How/decisions and the exact contracts profile. The
maintainer explicitly authorized the six accepted issues and contracts Task 1.
Tasks below remain planned work until their verification is recorded; release
publication and live service activation retain separate authorization gates.

- [x] Maintainer accepted [owning feature issue 1](https://github.com/thoughtkhoral/thought-khoral-codex-agent/issues/1) and the five linked contributions on 2026-10-05 under root Decision 004. See the [issue brief](codex-conversation-issue-brief.md) for all actual URLs.
- [x] Maintainer approved root/local runtime What/How/decisions, contracts Decision 003 and exact profile, and this plan on 2026-10-05. Approval is recorded in each governing source before Task 1.
- [x] Contracts Task 1 published [thought-khoral-agent-conversation-v1.0.0](https://github.com/thoughtkhoral/thought-khoral-contracts/releases/tag/thought-khoral-agent-conversation-v1.0.0) on 2026-10-05 at `85baf86e574276fcd036e53e23641af6aad602f9`. Consumer tasks pin the attached TAR and verified digest recorded below.
- [x] Pin/review worker dependencies, the CLI binary/image digest, license notices, and generated stable app-server schemas before worker packaging. Existing sibling pins are the baseline, not proof of a new dependency graph's safety.
- [ ] Provider credentials and default-deny egress are configured outside Git before opt-in live verification. Do not create live keys or enable a service during this spec pass.

## Global constraints

- Profile identifier: thought-khoral.agent-conversation.v1; browser prefix /api/agent-conversations/v1; workload prefix /internal/agent-conversations/v1.
- One active conversation per room/admitted agent; requester identity belongs to each task. Explicit human addressing only. No automatic agent-to-agent turns.
- Complete authorized room-wide baseline, then ordered deltas; exclude all targeted content. Current invoking text appears once. Never silently truncate history.
- Existing retained room wire values, schemas, clients, deterministic result validation, ten-second Reference Agent deadline, database identifiers, and persisted data keep their meanings.
- Initial bounds: 8,000 prompt characters, 1 MiB context, 2,000 transcript records, 1 MiB JSONL line, 4 MiB parsed output, 64 KiB final text, 180-second turn deadline, five-second interrupt grace, four live subprocesses, catalog page limit 100.
- Distinct provider and invocation credentials; no Codex runtime in the mediator, room database access in agents, provider keys in gateways, or private room fixtures.
- Initial tools are disabled: shell, filesystem, external MCP, plugins, hooks, and client tools. Read-only sandbox and never-approve policy remain enabled. Fixed instructions only.
- Public replies are ordinary persisted room messages; profile terminal state is separate. Render assistant text once from the transcript.
- Every uncertain submission fails interrupted and requires explicit new; completed receipts replay stored results. No exactly-once provider execution promise.
- Guidance bundles, memory writes/retrieval, autonomous participation, targeted Codex chats, cancellation UI, streaming tokens, production/Kubernetes rollout, and arbitrary agent admission are outside milestone one.

## File ownership and order

Paths below are relative to the named independent repository. Existing filenames are taken from this workspace; new names are the assigned decomposition. Do not revert unrelated working-tree changes. Contracts owns wire artifacts, root owns coordinated intent/plan, and children own implementation. Each task is independently reviewed and committed in its owning repository with issue/spec references. Tasks 2 and 3 build the broker; Tasks 4 and 5 the worker; Task 6 the mediator; Task 7 the UI; Task 8 deployment; Task 9 final integration. Directory guidance is a separate future plan.

### Task 1 — Publish contract artifacts and compatibility evidence

**Owner:** thought-khoral-contracts.

**Create:** schemas/agent-conversation-v1/{turn,view,catalog,task,input,update,result,error,ack}.schema.json; fixtures/agent-conversation-v1/{valid,invalid}/; test/validate-conversation-fixtures.mjs.
**Modify:** package.json test script, protocol.md to link the separate profile without altering retained semantics, README.md artifact instructions.
**Consumes:** exact profile/Decision 003; retained schemas and fixture validator.
**Produces:** immutable thought-khoral-agent-conversation-v1.0.0 release with actual commit/hash, typed shape definitions and canonicalization vectors consumed by all children.

- [x] Add the profile's literal request example as valid/first-turn.json. Create negative variants with forbidden delivery, requesterId, native thread ID, duplicate mention ID, invalid generation, and byte overflow. Preserve all existing fixtures.
- [x] Add a focused real-schema test, run it before schema implementation, and observe rejection of the new valid request. The negative cases must fail after implementation for their stated reasons.

```javascript
import assert from 'node:assert/strict';
import fs from 'node:fs';
import Ajv2020 from 'ajv/dist/2020.js';
import addFormats from 'ajv-formats';
const ajv = new Ajv2020({ allErrors: true, strict: true });
addFormats(ajv);
const schema = JSON.parse(fs.readFileSync('schemas/agent-conversation-v1/turn.schema.json'));
const request = JSON.parse(fs.readFileSync('fixtures/agent-conversation-v1/valid/first-turn.json'));
const validate = ajv.compile(schema);
assert.equal(validate(request), true, JSON.stringify(validate.errors));
assert.equal(validate({ ...request, requesterId: request.roomId }), false);
assert.equal(validate({ ...request, delivery: 'mentioned' }), false);
```

- [x] Implement closed schemas and the exact semantic validators from the profile: safe integers, UUID/mention uniqueness, cross-field branches, UTF-8 caps, room/trigger/base binding, and canonical digest. The new fixture runner dispatches fixtures by named schema/semantic case, not an untyped catch-all.
- [x] Use an independently derived digest expectation:

```javascript
import { createHash } from 'node:crypto';
assert.equal(createHash('sha256').update('{"a":[1,"x\\n"],"z":"é"}', 'utf8').digest('hex'),
  '089204610aca5bd0285b6c1285dee671b94a7afe21bf9af07f0a9a1b8a704a94');
```

- [x] Run npm test including both fixture suites; valid profile/retained fixtures pass and every invalid fixture is rejected. Also validate ordinary human/Codex message events under unchanged retained schemas. Run git diff --check.
- [x] Commit schema/fixture/docs artifacts with accepted issue references. Prepared branch `codex-conversation-v1` resolves to `85baf86e574276fcd036e53e23641af6aad602f9`.
- [x] Maintainer separately authorized publication on 2026-10-05. Published [thought-khoral-agent-conversation-v1.0.0](https://github.com/thoughtkhoral/thought-khoral-contracts/releases/tag/thought-khoral-agent-conversation-v1.0.0); consumer tasks record the actual commit/archive pin when vendoring.

Task 1 artifact evidence (2026-10-05): nine schema entry points and 125 named
fixtures pass with the retained suite unchanged. Independent read-only review
found no outstanding critical/important findings after binding regressions were
fixed. The identity verifier admits only the exact retained version field in
the two named public-message projection fixtures; its regression suite rejects
legacy text and unenumerated neighboring fixtures. The isolated contracts branch
is `codex-conversation-v1`. Prepared commit: `85baf86e574276fcd036e53e23641af6aad602f9`. The reproducible `git archive` TAR
with `thought-khoral-contracts/` prefix has SHA-256
`0038fdbf858db013c4a269aeedbca51a5db9128a2f1d6e39754f92ba60fd8f36`. The extracted final archive passes both suites after
`npm ci --ignore-scripts --no-audit`. The development-only fast-uri security
patch is 3.1.8; a network-enabled npm audit of the exact lock reports zero
vulnerabilities. The maintainer subsequently authorized publication on 2026-10-05; the
[GitHub release](https://github.com/thoughtkhoral/thought-khoral-contracts/releases/tag/thought-khoral-agent-conversation-v1.0.0) is published with the reviewed TAR and checksum file.
The remote annotated tag peels to the reviewed commit; GitHub's asset digest
and a downloaded copy both match the checksum above. Both fixture suites pass
from that downloaded archive. The checksum describes the [attached TAR](https://github.com/thoughtkhoral/thought-khoral-contracts/releases/download/thought-khoral-agent-conversation-v1.0.0/thought-khoral-agent-conversation-v1.0.0.tar),
not GitHub's automatically generated source downloads. Task 1 is complete;
Task 2 gateway storage is complete on its reviewed local branch; Tasks 3 onward have not begun.

### Task 2 — Add broker conversation storage and atomic reservation

**Owner:** thought-khoral-room-gateway.

**Create:** migrations/0006_agent_conversations.sql; src/conversation_store.rs; src/conversation_protocol.rs; tests/conversation_store_test.rs; tests/conversation_protocol_test.rs; contracts/agent-conversation-v1/ pinned artifacts/lock.
**Modify:** src/lib.rs exports, src/rooms.rs authorization integration, src/config.rs opt-in agent policy, Cargo.lock only for required dependencies.
**Consumes:** Task 1 TurnRequest, AcceptedTurn, state rules, exact field/byte limits; existing Actor/PgPool/room request ledger.
**Produces:** public validate_turn_request(&serde_json::Value) -> Result<serde_json::Value, ConversationError>; ConversationStore::new(PgPool); async reserve(&Actor, &serde_json::Value, authorization_expires_at: DateTime<Utc>) -> Result<serde_json::Value, ConversationError>. Returned Value is AcceptedTurn. ConversationError maps to the profile's safe error enum, not arbitrary strings.

- [x] Write a real validator test from the pinned first-turn fixture: request succeeds; delivery, spoofed requester, wrong agent, and duplicate canonical mentions fail. Before implementation run cargo test --locked --test conversation_protocol_test and observe the missing behavior.
- [x] Create storage tests using a dedicated migrated DATABASE_URL as in existing agent_task_store_test.rs. Use two reserve calls with the same actor/request and assert equal taskId/triggerEventId; change text under the same key and assert duplicate_conflict. Race two distinct requests for the same room/agent and assert one AcceptedTurn and one conversation_busy with one persisted prompt/task.
- [x] Implement the migration with conversation generations, tasks, profile updates, and disclosure manifests. Enforce a partial unique active room/agent row, unique room/request ledger key, task/update uniqueness, and positive generations. Store frozen input, selected settings, source manifest, policy revision, authorization expiry, and receipt acknowledgement. Native thread IDs do not enter these tables.
- [x] Lock the room conversation and request ledger in one transaction. Resolve current mode/defaults only after idempotency comparison, persist prompt and reservation together, and mark prior generation superseded on explicit new. Reject busy or invalid authority before message persistence. Commit no partial state on context/model errors.
- [x] Run the two new test targets, existing agent_task_store_test/protocol_test, and cargo fmt --check. Confirm old deterministic start/claim behavior is unchanged. Commit storage and validation as one reviewed unit.

### Task 2 execution evidence — 2026-10-05

Task 2 was authorized after the contract publication checkpoint. The reviewed
`codex-conversation-storage` branch in the isolated room-gateway worktree is
committed at `4f4d014194a7887c06722215181fd7451ca50f55`, based on `dca68a8`.
It is a local commit, without publication, merge or service activation.
The source record is the gateway's local
`.ai/specs/how/codex-room-participation.md` verification section.

- All 135 vendored schema/fixture files match the published release artifact and
  independent lock. The retained contract and Cargo lock are unchanged.
- Real PostgreSQL 16 tests cover same-key replay, changed intent/requester,
  concurrent distinct and identical requests, disabled/expired authority,
  rollback, room/generation binding, reset, disclosure filtering, frozen
  settings/context, native acknowledgements, coalesced ordinals and ready cursors.
- `cargo test --locked --all-targets`: 121 passed, one existing live reference-agent
  test ignored. One initial room-flow timeout did not reproduce in the unchanged
  23-test target rerun or final complete run. The final focused library/protocol/
  storage run after lint cleanup passed 34 tests.
- `cargo fmt --check`, `cargo clippy --locked --all-targets -- -D warnings`,
  and `git diff --check` pass. Independent read-only review corrections have
  regression coverage; final review has no Critical or Important findings.
- Root specification, reference and identity validation/regression gates pass,
  including the isolated gateway snapshot. Only the two exact retained wire
  fixture fields were added to the consumer identity exception.

A private snapshot helper freezes bounded context in the reservation transaction;
Task 3 extracts the context module without reconstructing a later snapshot.
Conversation configuration stays disabled by default. No new HTTP/workload
routes, claims, reply transitions, provider calls or Codex runtime are activated.
Task 3 is the next implementation unit; guided workspace/memory remains the
separate second milestone.

### Task 3 — Deliver bounded history and profile HTTP/workload routes

**Owner:** thought-khoral-room-gateway.

**Create:** src/conversation_context.rs; src/conversation_service.rs; tests/conversation_context_test.rs; tests/conversation_service_test.rs.
**Modify:** src/ws.rs app router, src/rooms.rs existing room-message persistence integration, src/auth.rs only to reuse validated identity/expiry access, src/lib.rs exports.
**Consumes:** Task 2 store, Task 1 API/input/update/ack schemas, existing room events and workload authentication.
**Produces:** canonical_context_bytes(&Value) -> Result<Vec<u8>, ConversationError>; build_context(roomId, generation, baseRevision, triggerEventId) bound by the store transaction; profile routes listed in the exact contract. Internal /claim is agent-specific; receipts never grant launch authority.

- [x] Write tests with public messages by Maya and Leo, one targeted secret, then a Codex trigger. Assert baseline order/author/source IDs, absent secret, one trigger text, and exact revision. Add delta with ordinary intervening chat and a native-reply binding; assert no duplicate text and valid hidden sequence gaps.
- [x] Before implementation run cargo test --locked --test conversation_context_test. Use the literal canonical digest from Task 1 in Rust; do not derive expected values using the code under test.

```rust
use serde_json::json;
use sha2::{Digest, Sha256};
use thought_khoral_room_gateway::conversation_context::canonical_context_bytes;
#[test]
fn unicode_vector_has_the_published_digest() {
    let bytes = canonical_context_bytes(&json!({"z":"é", "a":[1,"x
"]})).unwrap();
    assert_eq!(format!("{:x}", Sha256::digest(bytes)),
      "089204610aca5bd0285b6c1285dee671b94a7afe21bf9af07f0a9a1b8a704a94");
}
```

- [x] Implement baseline/delta filtering and the complete active-decision projection. Exclude decisions with undisclosable provenance. Compute frozen digest over the profile's exact digest object and record its source manifest. Fail context_too_large rather than trimming.
- [x] Implement HTTP bearer authentication, configured origin/CORS checks, safe errors, model query mediation, browser task polling projection, workload claims/context/updates/authority/receipt, and terminal message commit. Scope reads to requested room/task and derive identities from authentication. Profile updates stay outside the retained event stream.
- [x] Integration tests POST the same turn twice and verify one ordinary prompt; submit the bound final reply and verify one ordinary assistant message, terminal TaskView, committed cursor and acknowledgement. Replay accepted final output without another room message; reject stale lease/generation/digest, another room, invalid citations, expired requester authority, and policy narrowing. Retained chat.send must never invoke Codex.
- [x] Run new targets plus authorization_test, room_flow_test, replay_test, agent_service_test with a real isolated database. Verify no browser Leave or durable membership behavior is added. Commit routes/context/result handling.

### Task 3 execution evidence — 2026-10-05

Local commit `53d8fb78e27b2d9f71f99ae47fd013008d131dd7` on `codex-conversation-routes` extends Task 2
`4f4d014194a7887c06722215181fd7451ca50f55`. The branch remains isolated and
unpublished. Three literal canonicalization tests and 18 HTTP/database tests
verify public baseline/delta history, native bindings, authentication/CORS,
strict input, mediated catalog pagination, leases, replay, current authority,
citations, polling, coalescing and atomic ordinary-message reply commit.

- Final `cargo test --locked --all-targets`: 142 passed; one existing live
  reference-agent test ignored because its external binary is not running.
  PostgreSQL 16 uses a dedicated tmpfs container and synthetic per-server schemas.
- `cargo fmt --check`, `cargo clippy --locked --all-targets -- -D warnings`,
  `git diff --check`, pinned contract/hash tests and unchanged retained/Cargo
  locks pass. Root spec/reference/identity gates and regressions pass, including
  an isolated gateway snapshot. Codex repository documentation checks pass.
- Independent read-only review findings were corrected with reproducing
  regressions; final review reports no Critical or Important findings.
- Bounded new-work roster admission follows immutable replay lookup and reads
  identity metadata only. Codex-only requests bypass that query. Ordinary
  retained chat never invokes Codex; no browser Leave or durable membership
  behavior is added.

The nonterminal maximum-safe-integer exhaustion guard preserves a representable
terminal successor; terminal maximum ordinals and increasing gaps remain valid.
The published profile needs this explicit semantic clarification before
cross-language activation. The local How records this boundary and rationale.
The executable defaults to disabled and supplies no catalog bridge; Task 6
connects the mediator adapter. No provider call, deployment or activation took
place. Task 4 is next; guided workspace/memory remains the second milestone.

### Task 4 — Implement independent Codex app-server adapter

**Owner:** thought-khoral-codex-agent.

**Create:** Cargo.toml/Cargo.lock; src/lib.rs; src/config.rs; src/protocol.rs; src/app_server.rs; src/catalog.rs; src/usage.rs; tests/app_server_test.rs; tests/catalog_usage_test.rs; tests/support/fake_app_server.py; contracts/agent-conversation-v1/ approved artifact pin.
**Consumes:** Task 1 immutable contract; CLI 0.160.0 stable generated protocol; fixed instruction revision.
**Produces:** RuntimeRequest {packet: Value, thread_id: Option<String>}; async AppServer::execute(RuntimeRequest, before_submit: submission barrier) -> Result<RuntimeOutcome, RuntimeError>, where RuntimeOutcome {thread_id: String, turn_id: String, reply: Value} and reply validates as InternalReply. These internal types never cross the browser API. Worker host owns process handles and cancellation. The barrier is an async
closure receiving the exact thread ID and returning Result<(), RuntimeError>;
the host persists thread mapping/submission intent before releasing it. An error
from the barrier aborts before turn/start. Task 5 owns its SQLite implementation.

- [x] Record CLI version, generated schema hash, dependency/license evidence, and explicit no-tool configuration. Use Rust edition 2024/minimum 1.85. Reuse reviewed A2A pins and SQLx 0.8.6 SQLite only as needed; do not copy gateway code or vendor its patched client into the worker without separate dependency review.
- [x] Write the fake executable as a deterministic JSONL process that accepts only initialize/initialized, thread/start or exact-ID thread/resume, model/list pagination, turn/start, and turn/interrupt. Record parsed requests in a test-owned temporary file. Fixtures emit commentary then final agentMessage and matching turn/completed; other scenarios emit malformed lines, wrong IDs, failed/interrupted completion, early exit, overflow, and ignored interrupts.
- [x] Run cargo test --locked --test app_server_test before adapter implementation. Tests assert the captured real process requests and resulting public reply: correct handshake/order, exact resume ID, one trigger inclusion, explicit model/effort, read-only/never-approve settings, no client tool execution, and no success from commentary or incomplete deltas.
- [x] Implement argument-vector spawning, bounded stdout/stderr, RPC correlation, final-message selection, deadline interruption/process-tree reap, and closed schema validation. The provider call occurs only after the host durably records submission intent in Task 5; expose a pre-submit callback/future barrier owned by the worker host, not a second history service.
- [x] Implement all catalog pages, deployment allowlist, opaque option mapping, unsupported-effort rejection, confirmed/null settings, turn-bound reroutes, and usage freshness. Table tests cover last vs total, cached/reasoning tokens without double-counting, zero/missing window, wrong thread, out-of-order report, new/reset, model switch, compaction and over-capacity text.
- [x] Run both new targets, cargo fmt --check, cargo clippy --locked --all-targets -- -D warnings, and the documentation checks. Commit adapter/library/tests as a provider-free testable deliverable; do not advertise live isolation from this fake.

### Task 4 execution evidence — 2026-10-05

Local commit `e61a5f79568ce24e411f559efc5290000638395a` on `codex-app-server-adapter` extends Codex
repository foundation `44b0448bb2ec098ea6cde732f2525bc6609890ac`. The worktree at
`/private/tmp/codex-conversation-task4/codex-agent` is clean, isolated and
unpublished. No gateway implementation or direct room database dependency was
copied. The source owns its generated native schema, published profile pin,
argument-vector process adapter, catalog and usage normalization.

- Final `cargo test --locked --offline`: 21 passed (15 external-process tests,
  five catalog/usage tests, one close-cancellation test), zero ignored/failed.
  Initial process tests failed before implementation; review regressions also
  reproduced cancellation, generation binding, old-model telemetry and
  cancelled-close defects before their fixes.
- `cargo fmt --check`, `cargo clippy --locked --offline --all-targets -- -D warnings`,
  `python3 scripts/check_contract_pins.py` (139 exact files), documentation checks
  and `git diff --check` pass. Root reference/spec/identity gates and identity
  regressions pass, including an isolated complete worker source snapshot.
- CLI `codex-cli 0.160.0`; unmodified stable v2 generated schema SHA-256
  `81a88c04ae4984b16d73080f4109d0477682bc76c8adbe483e371175ce54c054`;
  initialize-response SHA-256
  `62ad689c2cb6379913c1d72749cfd8de5089d35760214123518eb92eef11acc9`.
  Generator used an isolated home without experimental protocol or inference.
- `Cargo.lock` and docs/dependency-evidence.json record 139 registry packages,
  checksums, declared/selected licenses and packaged legal-file hashes. Codex
  0.160.0 LICENSE/NOTICE are retained. No A2A or SQLx dependency is needed yet.
  Rust/Cargo 1.93.1 on aarch64-apple-darwin was exercised. Rust 1.85 remains the
  declared host minimum, not directly tested; inactive WASI wasip2 needs 1.87.
- Independent read-only review reports no remaining Critical or Important
  findings. Tests prove exact-ID resume, one trigger, host submission barrier,
  model/effort/no-tool request configuration, bounded streams/text, matching
  final completion, deadlines, group termination/reaping, catalog filtering,
  settings confirmation/reroutes and telemetry invalidation.

One sandboxed full-suite run could not execute ps for descendant inspection;
its rerun with approved process inspection passed. This was a test-environment
restriction, not omitted coverage. Only the two exact unchanged published
ordinary-message compatibility fields were added to the worker identity
allowance, with a regression rejecting additional occurrences.

No provider access, live tool/egress isolation, deployment, merge or publication
occurred. Task 5 is next: durable SQLite receipts, authenticated worker transport
and packaging. CLI image/binary provenance for the Linux package and distributed
dependency notices remain packaging gates. Guided workspace/memory stays the
separate second milestone.

### Task 5 — Persist receipts and expose authenticated worker transport

**Owner:** thought-khoral-codex-agent.

**Create:** src/receipts.rs; src/worker.rs; src/a2a_service.rs; src/bin/thought-khoral-codex-agent.rs; migrations/0001_worker_receipts.sql; tests/receipt_recovery_test.rs; tests/worker_service_test.rs; Containerfile; .github/workflows/runtime.yml; docs/runtime.md.
**Consumes:** Task 4 adapter/RuntimeRequest/RuntimeOutcome and Task 1 A2A/control/ack rules.
**Produces:** async Worker::execute(packet: Value) -> Result<Value, WorkerError>; receipt(taskId: UUID) -> Value; authenticated Agent Card/task transport and /control/v1/models, /control/v1/receipts/{taskId}. Returned result is the pinned InternalReply, never a Codex-native type. SQLite receipts are worker-owned, not shared with gateways.

- [x] Write real temporary-SQLite tests: reserved receipt before thread creation; submission-intent without returned turn ID; completed before broker acknowledgement; lost acknowledgement; ordinary restart with retained thread; missing native file; two simultaneous turns; changed generation/policy; provider denial. Check provider invocation count using the fake process's captured turn requests, not a mocked store.
- [x] Run cargo test --locked --test receipt_recovery_test before implementation. Each uncertain submission must return conversation_interrupted and produce zero new turn/start records on recovery; completed replay must return identical stored output.
- [x] Implement transaction ordering and durable SQLite synchronization, mapping/receipt schema migration, per-conversation mutexes and a global four-process semaphore. Reconcile accepted room reply acknowledgement before next resume. Close idle processes after reconciliation; enforce process reaping on all terminal paths.
- [x] Add authenticated A2A/card/control routes, packet validation and task-ID binding, safe responses, admission expiry, and cancellation. Reject redirects, arbitrary artifact URLs, extra parts, handoffs, unsupported client tools, and unauthenticated control access. No provider key is returned by any response or diagnostic.
- [x] Build the independent image with pinned CLI/version verification, UID/GID 10003, fixed instructions, no host configuration, and dedicated state paths. Add runtime CI using fake protocol and SQLite only. Add README/runtime docs derived from these specifications and maintain Apache/third-party notices.
- [x] Run both new test targets plus cargo test --locked, cargo fmt --check, clippy, independent image build, python3 scripts/check_docs.py, and git diff --check. Commit worker transport/durability/package. Activation remains Task 8's isolation gate.

### Task 5 execution evidence — 2026-10-06

Local commit `b23cf7cd002270de16a7b572a0e810e2fd9ff15d` on `codex-worker-receipts` extends the
Task 4 adapter commit `e61a5f79568ce24e411f559efc5290000638395a`. The isolated
worktree `/private/tmp/codex-conversation-task5/codex-agent` is clean, unmerged
and unpublished. Original scaffold/source and other repositories' changes are
preserved. No direct room database access or gateway runtime code was added.

- Final `cargo test --locked --offline`: 37 passed, zero failed/ignored (21
  adapter tests, 12 real-SQLite receipt tests, four authenticated HTTP tests).
  Missing-module/empty-router tests failed before implementation. Regressions
  reproduced and fixed cancellation during blocked SQLite completion, duplicate
  native reply entries, missing expected native bindings and policy rollback.
- Completed output replays without another turn; uncertain restart never
  resubmits. Native continuation requires durable broker acknowledgement,
  correct context/cursor/generation/policy and exact retained history. Four
  slots bound processes; cancellation and shutdown close/reap work. Missing
  expected bindings or policy invalidation persist a fresh-baseline requirement.
- The reviewed A2A server handler interface and native types are used through an
  integer-preserving bounded Axum JSON-RPC wrapper. Its stock protobuf router
  coerces profile integers into floats; this wrapper preserves the approved
  artifact unchanged. Card/task/catalog/receipt/ack routes require a separate
  hashed invocation credential, live admission, exact task/context binding and
  supported payloads only. No credentials or native session IDs are returned.
- Formatting, Clippy with warnings denied, 139 exact profile/native hashes,
  477 retained legal-file hashes for 275 locked crates plus Ratatui, documentation,
  whole-commit whitespace and root spec/reference/identity checks pass. Identity
  regression tests and a complete isolated worker snapshot pass too. Upstream
  legal-file bytes remain unmodified; only license paths have a Git whitespace
  exemption. Rust/Cargo 1.93.1 was exercised; exact 1.85 was not.
- Final ARM64 independent image ID `sha256:ec1591d137c2203c2f994d4ba9ea9b5a420ba3b9948b8a32665355fad76c893e`
  builds the worker and verifies the Codex 0.160.0 musl release archive, CLI
  version and both generated schema hashes. Network-none/read-only package
  verification confirms UID/GID 10003. Unconfigured startup exits before
  inference. Native and SQLite state are separate private directories; the
  service activation flag remains gated on Task 8. x86_64 CI is defined but not
  exercised locally. Base-image and both architecture archive pins, source
  notices and detailed package evidence live in the independent repository.
- Final independent read-only review reports no remaining Critical or Important
  findings; its three external review regressions and 16 worker tests pass.

A sandboxed run denied ps inspection; the complete approved-inspection rerun
passed. Concurrent builds exposed short worker fixture deadlines and an
unbounded synchronization wait; fixtures now have ten-second execution budgets
and a bounded turn-binding wait. An obsolete stalled test process was stopped;
the final full suite is green. This is test robustness, not omitted coverage.

No provider inference, live isolation, deployment activation, merge or publication
occurred. Task 6 is next: pinned Codex gateway mediation, catalog/receipt/control
queries and normalized result validation. Guided workspace/memory remains the
separate second milestone.

### Task 6 — Add pinned Codex mediation without relaxing Reference Agent validation

**Owner:** thought-khoral-agent-gateway.

**Create:** src/conversation_dispatcher.rs; src/conversation_validation.rs; tests/conversation_dispatcher_test.rs; tests/conversation_validation_test.rs; contracts/agent-conversation-v1/ approved artifact pin.
**Modify:** src/registry.rs; src/config.rs; src/room_client.rs; src/a2a_adapter.rs; src/lib.rs; src/bin/thought-khoral-agent-gateway.rs.
**Consumes:** Tasks 3 and 5 workload/worker endpoints; exact catalog/receipt/update/result schemas.
**Produces:** conversation-specific dispatcher, pinned registration 74686f75-6768-746b-686f-72616c000004 at http://thought-khoral-codex-agent:9091, catalog/receipt mediation, authorized normalized updates. Existing deterministic Dispatcher and exact validator remain independently usable.

- [x] Add registration tests rejecting unknown card identity/skill/profile/endpoint, redirects, capability drift, and unapproved model choices. Add result tests for wrong task/generation/digest/turn, forged usage, unknown citations, and arbitrary artifacts. Run the new validation target before implementation.
- [x] Add one real local A2A fake-worker endpoint plus broker fixture service to dispatcher tests. Complete one task, then lose result acknowledgement and verify stored-result replay without another A2A/provider invocation. A recovered running worker receipt must produce interrupted, not another send. Test expired authority/lost lease cancellation and late output rejection.
- [x] Implement separate Codex claim/routing/update paths and authenticated bounded catalog/control queries. Persist transport task/context bindings; poll authority every second. Distinct invocation credential is held only in the mediator and worker host, never forwarded into Codex. Keep the Reference Agent's ten-second execution and loopback-only pin.
- [x] Run cargo test --locked --test conversation_dispatcher_test and conversation_validation_test, then existing config_test/registry_test/dispatcher_test/a2a_adapter_test/reference_agent_test/room_client_test. Run fmt/clippy and git diff --check. Commit admission/mediation after independent review.

### Task 6 execution evidence — 2026-10-06

Gateway mediation is committed locally at `1900f8d127d744ffb996021fdc2f3fb34858fbda` on
`codex-conversation-mediation`. The broker catalog adapter is committed at
`50d293491ae65250e0603d26645d4bcc4e692b90` on `codex-broker-catalog-bridge`, extending Task 3
`53d8fb78e27b2d9f71f99ae47fd013008d131dd7`. Corrected worker source is
`9dfc90189526bdc63bd1be8c189da2b665f3387f`, with image evidence at
`bd4d70c4d0ddf3940eb0efabcfb79507c1ac9069` on `codex-worker-transport-contract`. These independent worktrees
remain local, unmerged and unpublished; original source checkouts are preserved.

- Gateway: 66 provider-free tests pass, including all 44 deterministic baseline
  tests. Exact card/profile/endpoint admission, authenticated bounded controls,
  integer-preserving A2A packet envelopes, durable private transport records,
  authority polling/cancellation, artifact-to-receipt native binding comparison,
  prior disclosed citation IDs and normalized result/settings/usage validation
  have real local HTTP fixture coverage. Native IDs never enter broker updates.
- Completed or uncertain worker receipts never cause another provider turn.
  Both lost committed acknowledgement and uncommitted terminal POST recover
  from exact stored output. Verified failed/revoked/expired recovery is durably
  quarantined; transient per-record failures do not starve unrelated rooms.
- The production broker CatalogQuery connects to the fixed authenticated
  mediator catalog bridge at `thought-khoral-agent-gateway:9092`,
  `GET /internal/agent-conversations/v1/models`. Its separate bridge credential
  is distinct from worker invocation and workload credentials. The adapter
  locally paginates the bounded catalog using content/revision-bound cursors;
  browser cursors remain broker-scoped. Both services remain disabled by default.
- Worker: 39 tests pass. Its closed `{profileVersion, packet}` input and private
  `{reply, runtimeBinding}` completed artifact now conform to the existing
  approved profile. Completed-only receipt bindings come from SQLite. The
  deadline cannot exceed its lease, with rejection before any runtime request.
  The rebuilt ARM64 image is
  `sha256:95145520f4249ac1e843c0f13a817e0c42cfc578735abef5fa7b760333596a1b`.
  Archive/CLI/both schema checks and network-none/read-only package verification
  pass; UID/GID is 10003 and unconfigured startup exits 1 before inference.
- Formatting, Clippy with warnings denied, contract pins, documentation links,
  whole-change whitespace and root specification/reference/identity gates pass.
  The mediator preserves the existing 299-package lock graph; broker's eight
  added exact HTTP dependency archives/checksums/licenses were independently
  reviewed. Worker retains 139 protocol files and 477 legal-file hashes.
  Identity exceptions add only the two exact published mediator fixture fields,
  with a RED/GREEN regression rejecting other legacy occurrences.
- Independent reviews reproduced and corrected terminal-recovery starvation,
  lease inequality, catalog pagination and null-window freshness validation.
  Final scoped review has no remaining Critical or Important findings.

Broker full offline all-target suite: 148 passed, one existing ignored. Detailed
review evidence is recorded in its local How and independent Task 6 packet. An existing live Reference Agent test
remains ignored; no live coverage is inferred from that omission. All runtime
execution here used synthetic fixtures. x86_64 packaging, Rust 1.85 execution,
provider inference, tool/egress isolation, activation and full-stack verification
remain later gates. Task 7 is the room UI; Tasks 8–9 own opt-in packaging and
end-to-end evidence. Guided workspace/memory remains milestone two.

### Task 7 — Add room UI controls and single-reply transcript behavior

**Owner:** thought-khoral-workspace-ui.

**Create:** src/features/room/conversationApi.ts; conversationApi.test.ts; CodexConversationControls.tsx; CodexConversationControls.test.tsx; useAgentConversation.ts; useAgentConversation.test.tsx; profile fixture JSON under src/features/room/__fixtures__/.
**Modify:** src/api.tsx only for valid ordinary Codex message attribution; src/features/room/RoomPage.tsx, MentionComposer.tsx, ChatStream.tsx and their tests; existing participant drawer capability display.
**Consumes:** Tasks 1/3/6 browser profile and catalog/state; existing access-token bootstrap and retained room socket.
**Produces:** sendTurn(token: string, request: TurnRequest) -> Promise<AcceptedTurn>; getConversation(token, roomId, agentId) -> Promise<ConversationView>; listModels(token, roomId, agentId, cursor?) -> Promise<CatalogPage>; getTask(token, roomId, taskId) -> Promise<TaskView>. Types come from the pinned exact profile. Polling hook stops on completion/Leave/auth failure and restores only server-confirmed state.

- [x] Write UI tests with real controls and a mocked HTTP boundary: selecting/directly mentioning Codex sends one profile request and no chat.send; an alias/quoted mention stays ordinary chat. Test targeted-delivery rejection, shared reset disclosure, busy rejection preserving draft text, and unsent model choices remaining local.
- [x] Run npm test -- src/features/room/CodexConversationControls.test.tsx before implementation; test behavior and accessible roles rather than component-private state or exact wording.
- [x] Implement profile HTTP client with Authorization header, same trusted gateway origin, strict response parsing, safe errors, and catalog pagination. Tests assert token never enters URL/body/local storage and response native IDs never become resume parameters.
- [x] Implement controls/polling/restoration with existing PatternFly primitives. Require acknowledgement of an unsupported effort default after model change, show selected vs active/confirmed settings, and show last-request context estimate or unavailable. Poll once per second only for an active task and stop on terminal/Leave/unmount/auth loss.
- [x] Test two humans sharing server session, fresh-thread reset, browser reload, unavailable capabilities, settings/usage freshness, out-of-order polling, and one assistant transcript bubble when both room reply and terminal TaskView arrive. Keep existing deterministic task rendering untouched.
- [x] Run npm test, npm run build, and npm run test:preview. Run git diff --check and commit the UI unit with governing specs/issue references.

### Task 7 execution evidence — 2026-10-06

UI implemented locally at `e4afe0562306d7996f1ed232bc7499ee64d6bc1c` on
`codex-room-conversation-ui`, based on `1c098f60db6fa9d51c7d016fd36b02a2e588824e`.
The isolated worktree is `/private/tmp/codex-conversation-task7/workspace-ui`;
original runtime checkouts remain preserved and changes are unmerged/unpublished.

Final independent review: approved — source `fb42fae..e4afe056`; all three
Important findings and the null-window Minor invariant are addressed, with no
new blocking findings in the correction. The existing chunk advisory is deferred.

- Explicit selected/direct Codex addressing sends one conversation-profile HTTP
  request; aliases, quotations, Markdown code and ordinary messages retain chat.
  Targeted Codex delivery is rejected and busy failures preserve the draft.
- Shared new/continue controls restore server generation/defaults, disclose shared
  reset semantics, require reset and unsupported-effort acknowledgements, and
  leave unsent choices local. Runtime confirmation and last-request usage remain
  distinct from selection; current null metadata does not resurrect prior values.
- Active-task polling is non-overlapping and once per second, stopping on terminal,
  Leave, unmount and auth loss. Late old-generation responses are ignored. Valid
  timeout/interruption tasks support safe failure display and explicit New session.
- Closed, bounded JSON/schema/semantic parsing uses the exact published profile,
  trusted gateway origin and Authorization-only access tokens. Native IDs never
  become resume authority. Catalog pages use opaque cursors. Persisted ordinary
  Codex replies render once; TaskView status does not add a second assistant bubble.
- A closed optional host admission manifest gates all Codex controls and profile
  reads; absent/invalid configuration remains disabled. It carries only reviewed
  profile/agent/capability metadata. Task 8 supplies opt-in bootstrap; broker
  authorization remains authoritative. Optional controls hide independently.
- Controller independently reran **116 tests in 12 files**, retaining all 83 baseline
  tests; TypeScript/Vite production build and production-bundle JSDOM preview pass.
  Preview's 19 transcript tests pass. All 135 exact artifact hashes, immutable lock,
  tamper regressions, local documentation targets and whitespace checks pass.
  Existing Vite >500 kB chunk warning remains documented; no clean-warning claim.
- Exact Ajv 8.20.0/ajv-formats 3.0.1 and their added dependencies retain reviewed
  archive integrities/licenses. Narrow DOMPurify 3.4.16 and source-map-js 1.2.2
  patches resolve baseline advisories; final npm audit reports zero. Two exact
  immutable UI fixture fields join root identity exceptions with RED/GREEN tests.
- Independent review reproduced and corrected failed-terminal projection mismatch,
  prior metadata fallback, Markdown code invocation and stale/null-window acceptance.
  Focused regressions failed before correction and passed afterward.

Evidence remains provider-free/synthetic. Real host OIDC/CORS, two-human deployed
broker behavior, durable native reset/history, worker sandbox/egress and provider
entitlement remain later gates. Browser automation tools failed to start, so no
real-browser screenshot or visual coverage is claimed. The temporary loopback
preview server was stopped. Task 8 is opt-in platform packaging/egress; Task 9
owns fake-stack/end-to-end and separately authorized live evidence. Guided
workspace/memory remains milestone two.

### Task 8 — Package opt-in local service and provider egress

**Owner:** thought-khoral-platform; worker image stays owned by thought-khoral-codex-agent.

**Create:** compose.codex.yaml; containers/codex-provider-proxy.Containerfile; proxy/codex-provider.conf; scripts/test-codex-egress.py; scripts/test-codex-compose.sh; docs/codex-local.md.
**Modify:** scripts/agent-egress.sh only to permit admitted mediator-to-worker traffic; scripts/build-remote.sh and test-build-remote.sh to stage a pinned Codex image/source when opted in; ui bootstrap configuration to expose admitted profile availability.
**Consumes:** Tasks 3/5/6/7 reviewed images and contracts; existing rootless Compose/egress patterns.
**Produces:** opt-in Compose overlay, persistent state and separate secrets, default-deny worker egress through api.openai.com:443-only proxy, readiness checks. Existing base Compose invocation does not require provider credentials or advertise Codex.

- [x] Write Compose/egress tests before changes: base deployment succeeds without Codex secrets; opted-in deployment fails on missing key/volume ownership/version mismatch; denied direct IPv4/IPv6 and arbitrary CONNECT host/port cannot reach a controlled listener; proxy/policy failure stops Codex. Tests use a local controlled TLS/proxy target for policy behavior, never public provider inference.
- [x] Run bash scripts/test-codex-compose.sh and python3 scripts/test-codex-egress.py to observe the missing opt-in behavior, then implement the overlay/proxy constraints from platform What/How. Do not share the unrestricted platform network or reference-agent loopback namespace with the Codex process.
- [x] Mount distinct secret files and persistent native/SQLite directories, disable all initial tools with a verified pinned configuration, and enforce non-root/read-only/drop-capabilities/no-host-port settings. Provider key goes only to the worker; no gateway/provider secret is inherited by model tools. Verify UID 10003 ownership before startup.
- [x] Extend immutable remote builds with an optional explicit Codex commit/tag; preserve the existing four-argument default mode and reject an opted-in build missing the fifth source revision before any build begins. Existing contracts are separately pinned artifacts, not another source-built runtime.
- [x] Run new tests, bash scripts/test-build-remote.sh, sh scripts/test-validate-kube.sh, and existing deterministic egress smoke in an authorized local test environment. Base Kubernetes manifests stay deterministic-only. Commit opt-in deployment and derived docs.

### Task 8 execution evidence — 2026-10-07

Task 8 local packaging and worker tool-policy correction — 2026-10-07.

Independent review: approved. No Critical or Important findings. Two Minor harness improvements are recorded for the next capture; prescribed initial whole-suite first-red chronology is not established by the retained report.

- Platform branch `codex-opt-in-platform`, base `860fe0c54f50e2c6a7ac3b6fba0f4b307953ca8c`, committed `9626bc46f8b74c2a58b2578c4f744996f3d41317`.
- Worker branch `codex-worker-tool-policy`, base `bd4d70c4d0ddf3940eb0efabcfb79507c1ac9069`, runtime `ab0432e27f80c731cffde04f75403505332ace6d`, evidence `d40e4a8cd5efc77c7161742aec7ade289efb357a`.
- Corrected Linux ARM64 worker image `sha256:c5aea93b30d2e70ccbd66bcb6fdef01b8332eea872aaa46a634fa007c44c1b1a`; proxy image `sha256:5f7a8ad30098b2df613293631bf1695281b387868cefdafb5a82c3e1f3b4c326`.

Opt-in overlay isolates worker UID10003 and proxy UID10004 behind a dedicated owner namespace. Base Compose remains provider-free and Kubernetes manifests unchanged. Worker direct IPv4/IPv6/DNS traffic is denied; proxy accepts only api.openai.com:443 CONNECT, with worker end-to-end TLS. Transparent proxy cannot inspect encrypted redirect responses; another origin has no usable route. Actual isolated kernel fixtures proved positive controls, denied traffic, and dependent shutdown on proxy/policy loss. Mediator UID10001 admitted calls and broker reply path preserve UID10002 restrictions.

Three distinct credentials and native/receipt/mediator state are separated. Startup rejects missing or shared credentials, imported native configuration/authentication, invalid ownership/mode, mutable image references and wrong CLI versions. Trusted authenticated readiness renews a closed host admission envelope expiring within five seconds. A cold loader rejects stale admission after abrupt namespace exit; instantaneous withdrawal from already-open UI is not claimed. Remote builds preserve four default source arguments and require the explicit fifth worker revision when opted in.

Pinned CLI0.160.0 required an independent worker correction: feature flags alone left metadata-selected tools available. The restricted catalog changes only six tool-selection fields, preserves native model/effort semantics and disables dynamic unsanitized discovery. Package verification binds actual CLI binary, controls, catalog and committed proof. Actual network-none local HTTP/SSE capture covers44 model/effort cases across eight visible models, fresh-process resume, recursively empty tools arrays, and six unsolicited tool refusals without client requests or filesystem canary. Three hidden descriptors are sanitized but not execution-admitted. Linux x86_64 remains gated on equivalent actual capture; these results establish no account/model availability.

Recorded verification:

- Worker44 provider-free Rust tests;143 contract/native pins;11 catalog descriptors and six-field-only sanitation;2 resolver tests;94 local documentation links;477 retained notice files/275 locked crates.
- Real kernel dual-stack/TLS/DNS/proxy-loss/policy-loss fixture (session5020), retained deterministic actual egress fixture (session10836), unit and startup checks.
- Compose real parser/host-preflight tests, closed bootstrap tests, four/five-source remote-build regression, retained Kubernetes validation/bootstrap/egress checks.
- Controller corrected-image package fixture (session90097) and old version-only image refusal fixture (session79771): ten gates each, exit0, no inference. Package fixture preserved wrong modes with seeded synthetic state rather than weakening production checks.

Runtime changes remain committed only on isolated local branches. Original checkouts retain their runtimes/scaffold. No merge, push, publication, service activation or public-provider inference occurred. Task9 remains end-to-end history/recovery/integration and separately authorized live verification; memory/spec-guided workspace is a later milestone.

### Task 9 — Verify end-to-end history, restart, isolation, and release evidence

**Owner:** root coordinates; thought-khoral-platform owns runnable smoke scripts.

**Create:** platform scripts/smoke-codex-conversation.mjs and docs/codex-verification.md. Root records accepted milestone evidence linked to individual repository revisions.
**Consumes:** Tasks 1–8 and configured provider access/egress.
**Produces:** reproducible fake-stack integration plus opt-in live verification evidence. Each result names revision/image/contract/CLI and whether inference was fake or live.

- [x] Run a provider-free integration with Maya's ordinary public fact, Leo's ordinary public correction, a targeted secret, and a later explicit Codex invocation. Inspect packet baseline/delta, trigger/source IDs, room reply, and failure projections. Assert public history is present, secret absent, duplicate requests produce one logical turn, and another room cannot bind its conversation ID.
- [x] Run restart/recovery tests at each durable boundary: before thread creation, after submission intent, after thread/turn binding, after normalized completion, and after broker commit before acknowledgement. Validate counts structurally from receipts/app-server requests, not only model answers.
- [ ] After explicit opt-in activation with configured API-key access, run node scripts/smoke-codex-conversation.mjs --live. Have one human state a unique fact without invoking Codex, another address it, add intervening discussion, restart worker, continue, then explicitly reset. Verify same thread on resume and a distinct thread plus authorized room baseline on reset. Old public facts can remain available after reset; do not use model forgetting as proof of isolation.
- [ ] Change model/effort between turns and verify runtime confirmation, preserved history, restored defaults, denied model errors without fallback, and last-request telemetry/unavailable state. Exercise a second model only if accessible and record any unavailable coverage.
- [ ] Run live tool/egress isolation checks: model requests for shell, file access, external tools, and arbitrary destinations cannot execute; provider-key content cannot be read into a reply. If pinned CLI configuration cannot prove that restriction, keep Codex disabled and record the failure; do not bypass sandboxing to make the smoke pass.
- [ ] Run existing contracts/gateway/UI/platform regressions and root spec/reference/identity gates. Review licenses, secret/session exclusion, contract pins, documentation/source links, accepted issue references, and independent worker build/release boundaries. Commit verification evidence before requesting release/deployment approval.



## Task 9 synthetic verification and correction checkpoint — 2026-10-07

This is the pre-amendment review snapshot. The following defaults amendment and
local synthetic checkpoint supersede its F1/default-discovery disposition only;
Task 9 and milestone acceptance remain open for the separately gated work below.

Provider-free checkpoint only; Task 9 and the milestone remain open.

Task-scoped verification review: Approved. Broad implementation review: Partial
spec compliance; quality Needs follow-up. B1–B3 (pending-ack recovery, omitted
shared settings and receipt-correlated safe failures) are addressed. B4 is
partial: explicit initial/reset selection works for full-capability admission,
but automatic server-default display requires an approved interface amendment.
F1: unresolved Important reasoning-only UI deadlock. Optional capabilities are
independent; an effort-only admission cannot establish the guard-required model
through its hidden selector. This prevents initial/reset invocation and blocks
whole-milestone/merge readiness. No second broad fix wave or waiver is implied.

| Owner | Final reviewed local revision |
|---|---|
| contracts | `85baf86e574276fcd036e53e23641af6aad602f9` |
| broker | `fd05cb48b8508e7939f9cdf9df275742a06fc4f8` |
| mediator | `6c3d96b4763871b9addc9bc7223e71ee7d38abd9` |
| worker | `b0d43ec2b5b0c8da035d4ccff754545132b978d4` |
| ui | `e51d67e9e1a986601df6b5e1acf68aaf7ae0870d` |
| platform | `637a69279f0fe5019560b1e54d28f48c1c715897` |

All six reviewed worktrees were clean when this checkpoint was prepared.
Runtime is committed only on isolated local branches; originals retain their
runtime/scaffold and unrelated edits. Contracts v1.0.0 and dependency lockfiles
remain unchanged.

Controller final verification on platform revision above: `node
scripts/smoke-codex-conversation.mjs --fake` (session85023) exit0, six original
crash/commit boundaries, 11 fake native turns, exact baseline/delta/source IDs,
targeted/cross-room exclusion, duplicate=one logical turn, worker restart and
fresh reset, shared omitted settings, rejected-completion recovery and exact
execution_failed/session_unavailable/runtime_unavailable projections. `node
--test scripts/tests/codex-conversation-smoke.test.mjs` (session23304) exit0,
13 passed, zero failed. This is synthetic native/identity/private-DNS adapter
coverage, not whole packaged Compose, real Keycloak/browser or provider proof.

Inspected owner logs and independent review record broker150 passed + one
pre-existing ignored live test; mediator65 passed, zero failed/ignored (correcting
the earlier reported68); worker46; UI121 + pin/tamper checks and production
build. Owner fixture tests3, actual assertion-failure/SIGTERM/SIGINT cleanup3,
package/startup checks10 passed. Earlier contracts/regression/legal/pin evidence
is retained with original attribution, not presented as rerun here.

New ARM64 worker image:
`sha256:2d8bfade27802f910cf68e832722c93b4a2acc2addb825711e1223617a4cd385`.
Compiled runtime revision `b418a76e0e7ca047b5fe995eb17519aced369a06`; worker
head above adds evidence documentation. Immutable image readiness checks used
network-none/read-only/cap-drop-all, both admission markers; default invocation
refused as expected. Actual native 44-setting/eight-model/resume/six unsolicited
tool refusal evidence remains attributed to its earlier source/image, not this
new image. CLI/catalog/control hashes are unchanged. x86_64 native admission and
Rust1.85 minimum-version checks remain unrun.

At this checkpoint, default discovery was pending specification approval. The
local proposed How is
`thought-khoral-codex-agent/.ai/specs/how/default-settings-discovery-proposal.md`.
It proposes a read-only authenticated defaults query in a new immutable v1.1.0
artifact and independent mixed-capability controls, covering absent conversation
and explicit New/reset. It authorizes no runtime or published contract changes.
Live provider verification: pending. Account/model availability, actual native
history, live tool/egress/key isolation, packaged deployment/private DNS and real
browser/identity evidence remain separately gated. At the time of this checkpoint, no merge, push, publication,
service activation or provider inference occurred.

Independent review artifacts are retained outside Git at
`/private/tmp/codex-conversation-task9/final-fix-review.md`,
`final-implementation-review.md`, and `task9-fix-review.md`; owner evidence at
`/private/tmp/Task9-final-fix-evidence/`. Final root/documentation/source-reference
and identity gate results will be recorded in the controller checkpoint after
these source-derived record updates. The aggregate release checklist remains
unchecked; passing synthetic checks do not resolve F1 or default discovery.

## Acceptance traceability and second milestone

Root acceptance criteria 1–4 map to Tasks 3–5/7/9; 5–8 to Tasks 2–6/9; deterministic compatibility criterion 9 to Tasks 1–3/6–9; model/effort and usage criteria 10–12 to Tasks 4/6/7/9; independent boundary criterion 13 to Tasks 1/5/6/8; trigger criterion 14 to Tasks 2/3/7/9; history/provenance criterion 15 to Tasks 1/3/5/9; revocation/recovery criterion 16 to Tasks 2–6/9; bounds criterion 17 to Tasks 1–5/8/9.

After milestone one is accepted, prepare a separate plan for the [guided workspace](https://github.com/thoughtkhoral/thought-khoral-codex-agent/blob/main/.ai/specs/what/guided-workspace.md): reviewed immutable bundle publication, instruction/spec/source loading, visible revision and fresh generation on bundle change, and guidance-specific evaluation. Memory-engine retrieval or durable writes need their own interface and human-review policy. No task in this plan enables that later extension.

## Approved defaults-discovery amendment — 2026-10-07

The maintainer approved the [visible server defaults design](https://github.com/thoughtkhoral/thought-khoral-codex-agent/blob/main/.ai/specs/how/default-settings-discovery-proposal.md) in
this conversation on 2026-10-07 after an explicit specification approval request.
It authorizes coordinated local implementation and synthetic verification of
the additive authenticated defaults query and independently optional model/effort
controls, including the F1 initial/reset effort-only deadlock. The accepted
design is the governing amendment to earlier default-visibility wording.

The contracts owner defines `ResolvedSettingsView` at
`GET /api/agent-conversations/v1/rooms/{roomId}/agents/{agentId}/defaults` in
new immutable artifact `thought-khoral-agent-conversation-v1.1.0`, retaining the
v1 profile/namespace and all existing published v1.0 schema/fixture bytes.
The broker validates authenticated room/agent authority, current admission,
catalog revision, policy-default pair and five-second bound before responding.
The read has no task/event/conversation/lease/native-state mutation, exposes no
effective-settings confirmation, credentials or private/native identifiers,
uses the existing safe ProfileError/HTTP mapping and `Cache-Control: no-store`.
There is no inferred catalog-order model or inference fallback.

The UI resolves and displays the concrete explicit next-turn pair when absent
or explicitly New/reset; restored continuation uses accepted shared settings.
Both capabilities allow both controls; effort-only keeps the resolved model
read-only; model-only keeps the displayed model-specific catalog default effort
read-only; neither capability retains the settings-free path. Unsupported
controls stay uneditable and no hidden control blocks a valid required choice.
Catalog/pair mismatch requires bounded refresh or an explicit unavailable state.
A still-valid explicit pair is not replaced after a deployment-default-only change.

As a scoped exception to the earlier published-artifact-first execution order,
isolated consumers may pin a reproducible local candidate from an exact committed
contracts revision, verified archive and per-file SHA-256 values, clearly marked
unreleased. This exception is only for this amendment's local pre-publication
development and synthetic testing. Published v1.0 provenance/bytes remain intact.
No release publication, shipped interoperability, merge, push, provider use or
service activation is authorized. Whole milestone/Task9 acceptance remains open.

Approved defaults extension execution plan: [four coordinated local tasks](https://github.com/thoughtkhoral/thought-khoral/blob/main/.ai/specs/how/codex-default-settings-implementation-plan.md). The pre-amendment Task 9 checkpoint above remains a historical snapshot. The amendment and F1 correction are accepted for the local synthetic candidate. Task 9 and milestone acceptance remain open pending packaged-stack and separately authorized live verification.

## Defaults discovery local synthetic checkpoint — 2026-10-07

All four defaults-amendment tasks passed their independent reviews. The final
whole-branch review passed. F1 (initial/New reasoning-only settings deadlock) and
visible defaults discovery are accepted for this local synthetic candidate.

| Source | Exact local revision | Retained worktree |
| --- | --- | --- |
| contracts | `1ea828f28725ddaaefa21d083473f9abbd777975` | `/private/tmp/codex-conversation-defaults/contracts` |
| broker | `2e7d23b467c572819f498c3b9bf14d74a62dc821` | `/private/tmp/codex-conversation-defaults/room-gateway` |
| mediator | `6c3d96b4763871b9addc9bc7223e71ee7d38abd9` | `/private/tmp/codex-conversation-final-fix/agent-gateway` |
| worker | `b0d43ec2b5b0c8da035d4ccff754545132b978d4` | `/private/tmp/codex-conversation-final-fix/worker` |
| ui | `79e5e7310a450efea561548cd87871446c1939aa` | `/private/tmp/codex-conversation-defaults/workspace-ui` |
| platform | `2d856773078a7caa542d719e539b55a5ab2dafaa` | `/private/tmp/codex-conversation-defaults/platform` |

The composed run was executed at `f9afeb20b746200daa9cdef0406c03f88a422b68`.
The subsequent path-provenance correction was tested and scoped-reviewed at
`220f6e0c74a29c000d7de81c0cb77823de0bd15c`;
the final platform revision above adds completion metadata only. The original
repositories retain their runtime; local implementation branches remain unmerged.

The unreleased candidate contract source is
`1ea828f28725ddaaefa21d083473f9abbd777975`, proposed release
`thought-khoral-agent-conversation-v1.1.0`. Its archive SHA-256 is
`fab59a486f6498b843467202debcb0768403bd57ba7dda41be2a01e5f23fdda8`
and externally anchored lock SHA-256 is
`7914d32eae2487879a68405b5095a6b9aa91355f87529c43f4055844821902a9`.
All 156 candidate payload files match in broker/UI; published v1.0 bytes remain
unchanged. The profile and API namespace stay v1. This is not a published release.

Evidence: retained 125 contract fixtures plus 16 additive cases and 6 candidate
integrity tests; broker serial suite 158 passed with 1 existing live-only test
ignored; UI full suite 190 passed with 1 intentional composed skip, followed by
scoped harness/TypeScript checks; 26 source-pin and 13 retained runner guards;
5 fixture unit tests; 3 actual failure/SIGTERM/SIGINT cleanup cases. The composed
candidate passed 12 capability/lifecycle cases, 3 display/send mutation cases,
15 actual HTTP UI children with 90 test passes, and 24 synthetic native turns
(11 retained baseline plus 13 added). Stale/removed pairs allocate no task/event
or native turn, retain the prompt and require explicit Refresh. Default-only
changes preserve the displayed explicit pair; unavailable replay is immutable.
Paused-publisher regressions verified RED before and GREEN after atomic exclusive
handshake publication. Owned processes, containers and staging files were cleaned.

The current composed state is `/var/folders/70/5kxy5kys3bj0252chp3ck8900000gn/T/Task9-codex-conversation-j9py6w`. Full provenance,
task/thread bindings, raw log references, limitations and review reports remain in
`/private/tmp/codex-conversation-defaults/defaults-reviewed-checkpoint.json` and
`/private/tmp/codex-conversation-defaults/task-4-logs/`. Root hierarchy/reference/
identity, scaffold documentation and whitespace results are recorded separately
in `/private/tmp/codex-conversation-defaults/final-gates.json` after synchronization.
The old parallel broker fixture port collision and Vite chunk advisory are
retained limitations; no passing parallel broker-suite claim is made.

Publication: pending

Packaged-stack verification: pending

Live provider verification: pending

The composed gate uses jsdom, a synthetic room socket, actual conversation HTTP
and storage, and a fake native executable. It does not establish packaged Compose,
real browser/Keycloak, provider, architecture-minimum or new-image acceptance.
Task 9 and milestone aggregate gates remain open. Specification/memory-guided
working directories remain the separately scoped future extension.

## Local main integration checkpoint — 2026-10-07

The reviewed provider-free Task 4 adapter and Task 5 durable worker/package
were merged into the Codex agent repository's local `main` in commit
`6159233`. The merge includes worker transport, tool-policy and recovery
corrections. It does not merge the separate contracts, broker, mediator, UI or
platform repositories, or authorize a push, release, service activation or
provider use. The defaults amendment remains an unreleased local candidate;
packaged-stack and live-provider gates remain open.

## Local multi-repository integration checkpoint — 2026-10-07

After the user's explicit authorization, the reviewed candidate commits were
merged into the owning repositories' local `main` branches. The source commits
remain the exact reviewed revisions used by the provider-free verification;
the integration merge commits are:

| Repository | Reviewed source commit | Local `main` merge commit |
| --- | --- | --- |
| Contracts | `1ea828f28725ddaaefa21d083473f9abbd777975` | `0499740cfc2af4c14572ebd6367b6f82dc8c8097` |
| Room gateway | `2e7d23b467c572819f498c3b9bf14d74a62dc821` | `d70d0e3d99de4bc1bfb3ff74bb8c993457a12f2a` |
| Agent gateway mediator | `6c3d96b4763871b9addc9bc7223e71ee7d38abd9` | `efb29b3f9afa3ed51ddad409a66cd48cf8bf59dd` |
| Codex worker | `b0d43ec2b5b0c8da035d4ccff754545132b978d4` | `6159233f6512150184b5e016fa01a211f8e6995e` |
| Workspace UI | `79e5e7310a450efea561548cd87871446c1939aa` | `0c8b599616a94d7dc73b335fb704407e15bbb9cc` |
| Platform | `2d856773078a7caa542d719e539b55a5ab2dafaa` | `251f10f8ad975b6035640adc4a03bbdd34ef4e36` |

Fresh verification passed for the serial Codex worker, contracts integrity tests,
room-gateway tests against an isolated migrated PostgreSQL database, mediator,
UI, platform candidate pin checks, and the provider-free composed defaults smoke.
The smoke exercised 12 rendered UI lifecycle phases and 24 synthetic native turns.
One broker live-reference-agent test and one UI composed test remain intentionally
ignored in their ordinary suites. No remote branches were pushed. The v1.1
contract remains an unreleased local candidate; packaged-stack validation,
publication, service activation, and live-provider evidence remain pending.

## Pushed POC integration checkpoint — 2026-10-07

After explicit user authorization, the reviewed integration commits were pushed
by fast-forward to GitHub `main` in the coordinating workspace and all six
affected component repositories. The memory-engine repository was unchanged.

| Repository | Pushed integration commit |
| --- | --- |
| `thought-khoral` | `2115f50e86a71d6e420f0cf53ce1e64822b8d2d6` |
| `thought-khoral-contracts` | `b930b225ea7de12bb124f4cc4cdf7a87a27c7a50` |
| `thought-khoral-room-gateway` | `d70d0e3d99de4bc1b1fb3ff74bb8c993457a12f2a` |
| `thought-khoral-agent-gateway` | `efb29b3f9afa3ed51ddad409a66cd48cf8bf59dd` |
| `thought-khoral-codex-agent` | `c2c0660948673b573de753ed66fa6a1fadda24e7` |
| `thought-khoral-workspace-ui` | `0c8b599616a94d7dc73b335fb704407e15bbb9cc` |
| `thought-khoral-platform` | `251f10f8ad975b6035640adc4a03bbdd34ef4e36` |

These pushes publish experimental POC source on `main`; they do not publish a
v1.1.0 contract release/tag, activate services, or establish production
readiness. The published v1.0.0 contract artifact remains unchanged. The
provider-free and synthetic evidence above remains the limit of demonstrated
interoperability; packaged-stack validation and separately authorized live
verification remain open. No live provider call or service activation was part
of this publication checkpoint.
