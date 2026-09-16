# ThoughtKhoral MVP Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deliver a locally runnable, authenticated ThoughtKhoral room in which multiple people can exchange messages, a deterministic facilitator can propose a decision, and a human approval creates auditable active room context.

**Architecture:** The six direct-child repositories remain independently versioned. `thought-khoral-contracts` defines versioned JSON Schema artifacts; the Rust room gateway validates and persists events, while the React UI renders and transitions them. `thought-khoral-platform` composes the independently built services with rootless Podman and provides the local Kubernetes-manifest validation route.

**Tech Stack:** TypeScript, JSON Schema Draft 2020-12, Node.js test runner, Rust, Tokio, Axum, SQLx, PostgreSQL with pgvector, Keycloak, React, Vite, PatternFly, Playwright, Podman, Podman Compose, Kubernetes manifests.

**Spec:** `.ai/specs/what/n2n-solution-architecture.md`; `.ai/specs/decisions/001-workspace-governance.md`

## Global Constraints

- Runtime projects are direct children of the workspace root and independently versioned; this workspace is not a monorepo.
- Each project contains Markdown-only `.ai/specs/what`, `.ai/specs/how`, and `.ai/specs/decisions` directories.
- Update and approve the applicable specification before creating or changing code.
- A project-level override must be an accepted decision record identifying the parent rule, override, rationale, scope, approval status, and consequences.
- `thought-khoral-contracts` owns language-neutral schemas, protocol documentation, and compatibility fixtures; it is not a shared runtime library.
- The gateway is the sole mediator of room events and active-context updates; agents never receive database credentials, filesystem access, arbitrary shell execution, or unmediated side-effecting tools.
- A human Confirm, Edit, or Dismiss action is required before a proposed decision can affect active room context.
- Inbound data is untrusted. Reject malformed JSON-RPC, unsupported contract versions, expired context, unauthorized rooms, and invalid decision transitions with structured errors.
- Verify component maturity, protocol compatibility, and transitive licensing from authoritative sources before adopting a dependency.

---

## Planned repository structure

```text
thought-khoral-contracts/
  .ai/specs/{what,how,decisions}/
  schemas/{envelope,room-event,rpc}.schema.json
  fixtures/{valid,invalid}/
  protocol.md
  package.json

thought-khoral-room-gateway/
  .ai/specs/{what,how,decisions}/
  Cargo.toml
  src/{main,config,protocol,auth,rooms,store,ws,error}.rs
  migrations/0001_room_events.sql
  tests/{protocol,room_flow,replay,authorization}_test.rs

thought-khoral-workspace-ui/
  .ai/specs/{what,how,decisions}/
  src/{api,features/room,features/decisions,components,main}.tsx
  src/**/*.test.tsx
  e2e/governed-decision.spec.ts

thought-khoral-platform/
  .ai/specs/{what,how,decisions}/
  compose.yaml
  keycloak/thought-khoral-dev-realm.json
  kube/{namespace,postgres,keycloak,gateway,ui}.yaml
  scripts/{smoke,validate-kube}.sh
```

`thought-khoral-memory-engine` and `thought-khoral-agent-gateway` receive their own plans after the governed-room MVP is accepted. They are intentionally not created in this plan: the deterministic facilitator exercises the required propose-and-approve boundary without prematurely choosing extraction, embedding, A2A, MCP, sandbox, or agent-runtime dependencies.

## Contract interfaces used by all MVP projects

The first release is `n2n.room.v1`. Every JSON-RPC request has `jsonrpc: "2.0"`, a string `id`, a `method`, and an object `params`; every application payload includes `contractVersion: "n2n.room.v1"` and an RFC 4122 `requestId`.

| Method | Parameters | Success result |
| --- | --- | --- |
| `session.authenticate` | `accessToken` | authenticated participant identity and role |
| `room.join` | `roomId`, `afterSequence?` | ordered room snapshot and events after the cursor |
| `chat.send` | `roomId`, `requestId`, `text` | normalized `message.created` event |
| `decision.propose` | `roomId`, `requestId`, `title`, `summary`, `sourceEventIds` | `decision.proposed` event |
| `decision.transition` | `roomId`, `requestId`, `decisionId`, `action`, `editedTitle?`, `editedSummary?` | `decision.confirmed`, `decision.edited`, or `decision.dismissed` event |

Valid actions are `confirm`, `edit`, and `dismiss`. `session.authenticate` is the only method accepted before an identity is bound to a WebSocket. Valid actions require the `human` role. `confirm` transitions `draft → active`; `dismiss` transitions `draft → dismissed`; `edit` transitions the old draft to `superseded`, creates a new active decision whose `derivedFromDecisionId` is the old identifier, and emits both immutable events in one database transaction.

Structured JSON-RPC errors use: `-32600` invalid request; `-32601` unknown method; `-32001` unauthenticated; `-32003` forbidden; `-32004` room or decision not found; `-32009` unsupported contract version; `-32010` invalid state transition; `-32011` expired context packet; and `-32012` duplicate request with a different payload.

### Task 1: Establish each repository’s local specification baseline and root tracking rules

**Files:**
- Create: `.gitignore`
- Create: `thought-khoral-contracts/.ai/specs/{README.md,what/mvp-contracts.md,how/implementation.md,decisions/README.md}`
- Create: `thought-khoral-room-gateway/.ai/specs/{README.md,what/mvp-room.md,how/implementation.md,decisions/README.md}`
- Create: `thought-khoral-workspace-ui/.ai/specs/{README.md,what/mvp-ui.md,how/implementation.md,decisions/README.md}`
- Create: `thought-khoral-platform/.ai/specs/{README.md,what/local-mvp.md,how/implementation.md,decisions/README.md}`
- Test: shell assertions for the required hierarchy and references to the root specification

**Interfaces:**
- Consumes: root What specification and decision 001.
- Produces: approved local requirements for the four implementation repositories.

- [ ] **Step 1: Write a failing workspace-structure assertion**

Create `scripts/verify-spec-hierarchy.sh` at the root. It must fail unless every planned MVP repository contains all three local specification directories and its local `README.md` links to `../../.ai/specs/README.md` or a correctly resolved equivalent.

- [ ] **Step 2: Run the assertion before creating child specifications**

Run: `bash scripts/verify-spec-hierarchy.sh`

Expected: non-zero exit status naming each missing project specification hierarchy.

- [ ] **Step 3: Write the local Markdown specifications before any runtime code**

Each project What specification must name its sole MVP responsibility, acceptance criteria, interfaces from `n2n.room.v1`, and explicit exclusions. Each How document must link to this root plan and say that implementation begins only after the relevant task is approved. Each project README must index its three local specification areas.

Use the following cross-project statement verbatim in all four READMEs:

```markdown
Parent requirements in the ThoughtKhoral root `.ai/specs/` apply here. This project may diverge only through an accepted local decision record that identifies the overridden parent rule and its consequences.
```

- [ ] **Step 4: Add root tracking protection and make the assertion pass**

Add direct-child runtime repositories to the root `.gitignore` using these exact entries:

```gitignore
/thought-khoral-contracts/
/thought-khoral-room-gateway/
/thought-khoral-workspace-ui/
/thought-khoral-platform/
```

Retain the root `.ai/` and `scripts/` files under root Git control. Run: `bash scripts/verify-spec-hierarchy.sh`

Expected: exit status 0.

- [ ] **Step 5: Initialize and commit each child specification repository**

Initialize each direct-child repository before any runtime code. Commit its local specification baseline in that repository; do not track child files in the root governance repository.

```bash
for project in thought-khoral-contracts thought-khoral-room-gateway thought-khoral-workspace-ui thought-khoral-platform; do
  (
    cd "$project"
    git init
    git add .ai/specs
    git commit -m "docs: define local MVP specifications"
  )
done
```

- [ ] **Step 6: Commit the root spec-governance change**

```bash
git add .gitignore scripts/verify-spec-hierarchy.sh .ai/specs
git commit -m "docs: define MVP project specifications"
```

### Task 2: Create and release the `n2n.room.v1` contract artifact

**Files:**
- Create: `thought-khoral-contracts/schemas/envelope.schema.json`
- Create: `thought-khoral-contracts/schemas/rpc.schema.json`
- Create: `thought-khoral-contracts/schemas/room-event.schema.json`
- Create: `thought-khoral-contracts/fixtures/valid/{join,chat-send,decision-propose,decision-edit}.json`
- Create: `thought-khoral-contracts/fixtures/invalid/{bad-version,missing-request-id,invalid-action}.json`
- Create: `thought-khoral-contracts/protocol.md`
- Create: `thought-khoral-contracts/package.json`, `thought-khoral-contracts/test/validate-fixtures.mjs`
- Test: `thought-khoral-contracts/test/validate-fixtures.mjs`

**Interfaces:**
- Consumes: `n2n.room.v1` interface table and error codes in this plan.
- Produces: immutable versioned JSON Schema and valid/invalid fixtures consumed by gateway and UI CI.

- [ ] **Step 1: Write the failing fixture-validation test**

In `test/validate-fixtures.mjs`, load `schemas/rpc.schema.json` with Ajv configured for JSON Schema Draft 2020-12. Assert every file in `fixtures/valid/` validates and every file in `fixtures/invalid/` fails. Initially leave schemas absent so the test fails with a missing-file error.

- [ ] **Step 2: Run the test and record the expected failure**

Run: `npm test`

Expected: FAIL because `schemas/rpc.schema.json` does not yet exist.

- [ ] **Step 3: Implement schemas and fixtures**

`envelope.schema.json` must require `contractVersion` equal to `n2n.room.v1`, `requestId` with UUID format, `roomId` with UUID format, and `occurredAt` in RFC 3339 `date-time` format. `rpc.schema.json` must reject unknown methods and constrain every listed method’s parameter object. `room-event.schema.json` must require a monotonically assigned integer `sequence`, UUID `eventId`, UUID `roomId`, an event type, actor `{id, role}`, and payload.

`protocol.md` must document the method table, error codes, decision transitions, WebSocket close behavior for authentication failure, and the compatibility rule: additive optional fields are minor-compatible; required-field, enum, method, or semantic changes require a new major contract version.

- [ ] **Step 4: Run contract validation**

Run: `npm test`

Expected: PASS; all valid examples validate and all invalid examples are rejected.

- [ ] **Step 5: Initialize and commit the independent contracts repository**

```bash
cd thought-khoral-contracts
git add .
git commit -m "feat: publish ThoughtKhoral room v1 contracts"
git tag n2n-room-v1.0.0
```

### Task 3: Build the gateway’s contract-validation and persistence foundation

**Files:**
- Create: `thought-khoral-room-gateway/Cargo.toml`, `Cargo.lock`
- Create: `thought-khoral-room-gateway/src/{main,config,error,protocol,store}.rs`
- Create: `thought-khoral-room-gateway/migrations/0001_room_events.sql`
- Create: `thought-khoral-room-gateway/tests/protocol_test.rs`
- Test: `thought-khoral-room-gateway/tests/protocol_test.rs`

**Interfaces:**
- Consumes: a checked-out `n2n.room.v1` schema release stored under `thought-khoral-room-gateway/contracts/n2n.room.v1/` with its tag and SHA-256 recorded in `contracts/lock.json`.
- Produces: `validate_request(&str) -> Result<ValidatedRequest, RpcError>` and `append_event(NewEvent) -> Result<RoomEvent, StoreError>`.

- [ ] **Step 1: Write failing Rust protocol tests**

Write tests that call `validate_request` with the valid `chat.send` fixture and assert a typed `ChatSend` result, then call it with `bad-version.json`, `missing-request-id.json`, and an unknown method and assert errors `-32009`, `-32600`, and `-32601` respectively.

- [ ] **Step 2: Run the focused test**

Run: `cargo test --test protocol_test`

Expected: FAIL because the crate and `validate_request` do not exist.

- [ ] **Step 3: Implement validation and append-only storage**

Define `ValidatedRequest::{Join,ChatSend,DecisionPropose,DecisionTransition}` and `RpcError { code: i32, message: &'static str }` in `src/protocol.rs`. Validate JSON-RPC envelope fields before deserializing method parameters. Embed the pinned contract schemas using `include_str!` and validate them with a maintained Rust JSON Schema validator selected only after recording its license and compatibility in the gateway How specification.

The migration creates `room_events` with `event_id UUID PRIMARY KEY`, `room_id UUID NOT NULL`, `sequence BIGINT NOT NULL`, `request_id UUID NOT NULL`, `event_type TEXT NOT NULL`, `actor_id UUID NOT NULL`, `actor_role TEXT NOT NULL`, `payload JSONB NOT NULL`, `occurred_at TIMESTAMPTZ NOT NULL`, `UNIQUE(room_id, sequence)`, and `UNIQUE(room_id, request_id)`. It also creates `decisions` with `decision_id UUID PRIMARY KEY`, `room_id UUID NOT NULL`, `status TEXT NOT NULL`, `title TEXT NOT NULL`, `summary TEXT NOT NULL`, `derived_from_decision_id UUID NULL`, `source_event_ids UUID[] NOT NULL`, and timestamps. Use one SQL transaction to allocate the next room sequence and insert each event.

- [ ] **Step 4: Run focused tests and database migration test**

Run: `cargo test --test protocol_test && sqlx migrate run`

Expected: PASS; migration creates both tables and protocol tests map every rejection to its specified error.

- [ ] **Step 5: Commit the independent gateway foundation**

```bash
cd thought-khoral-room-gateway
git add .
git commit -m "feat: add validated room event store"
```

### Task 4: Add gateway authentication, room WebSocket, replay, and human-only governance

**Files:**
- Create: `thought-khoral-room-gateway/src/{auth,rooms,ws}.rs`
- Modify: `thought-khoral-room-gateway/src/main.rs`, `src/store.rs`, `src/protocol.rs`
- Create: `thought-khoral-room-gateway/tests/{room_flow,replay,authorization}_test.rs`
- Test: `thought-khoral-room-gateway/tests/{room_flow,replay,authorization}_test.rs`

**Interfaces:**
- Consumes: `ValidatedRequest`, `append_event`, OIDC bearer JWT with `sub` and `n2n_role` claims.
- Produces: WebSocket JSON-RPC endpoint `/ws`; broadcast `RoomEvent`; `transition_decision(actor, request) -> Result<Vec<RoomEvent>, RpcError>`.

- [ ] **Step 1: Write failing integration tests**

Add an authorization test asserting an unauthenticated WebSocket upgrade receives `-32001`, an agent role receives `-32003` for `decision.transition`, and a human role may confirm. Add a room-flow test with two human clients where one `chat.send` causes both clients to receive the same persisted `message.created` sequence. Add a replay test that reconnects with `afterSequence` and receives only later events in sequence order.

- [ ] **Step 2: Run the integration suite**

Run: `cargo test --test authorization_test --test room_flow_test --test replay_test`

Expected: FAIL because WebSocket routing, JWT validation, broadcast, and replay do not exist.

- [ ] **Step 3: Implement the bounded gateway behavior**

Validate Keycloak-issued bearer JWTs against configured issuer and JWKS values. Map `n2n_role` only to `human` or `agent`; reject every other value. Use an Axum state object holding a PostgreSQL pool and a per-room Tokio broadcast channel. On accepted requests, persist first, then broadcast the normalized persisted event.

For `decision.transition`, enforce the state table defined in this plan. `edit` must execute the old-decision supersession, new-decision insert, and both resulting events in one transaction. On an identical duplicate `requestId`, return the original successful event; if the request body differs, return `-32012`. Log only event identifiers, room identifiers, actor identifiers, and error codes for rejected payloads.

- [ ] **Step 4: Run the suite, formatter, and linter**

Run: `cargo fmt --check && cargo clippy -- -D warnings && cargo test --test authorization_test --test room_flow_test --test replay_test`

Expected: PASS.

- [ ] **Step 5: Commit the governed room gateway**

```bash
cd thought-khoral-room-gateway
git add src tests migrations contracts .ai/specs Cargo.toml Cargo.lock
git commit -m "feat: add governed WebSocket rooms"
```

### Task 5: Create the PatternFly workspace UI with decision controls

**Files:**
- Create: `thought-khoral-workspace-ui/package.json`, `vite.config.ts`, `tsconfig.json`
- Create: `thought-khoral-workspace-ui/src/{main,api}.tsx`
- Create: `thought-khoral-workspace-ui/src/features/room/{RoomPage,ChatStream,useRoomSocket}.tsx`
- Create: `thought-khoral-workspace-ui/src/features/decisions/{MemoryDrawer,DecisionCard,DecisionEditForm}.tsx`
- Create: `thought-khoral-workspace-ui/src/features/decisions/DecisionCard.test.tsx`
- Test: `thought-khoral-workspace-ui/src/features/decisions/DecisionCard.test.tsx`

**Interfaces:**
- Consumes: OIDC access token, `/ws`, `n2n.room.v1` event types and errors.
- Produces: `RoomPage`; Confirm/Edit/Dismiss JSON-RPC calls; read-only collective-memory drawer.

- [ ] **Step 1: Write the failing decision-card component test**

Render `DecisionCard` with a draft decision and a human participant. Assert Confirm, Edit, and Dismiss are visible; selecting Confirm invokes `onTransition({ action: "confirm", decisionId })`. Render the same card with role `agent` and assert no action control is present.

- [ ] **Step 2: Run the component test**

Run: `npm test -- DecisionCard.test.tsx`

Expected: FAIL because the Vite project and component do not exist.

- [ ] **Step 3: Implement the UI around normalized room events**

Use PatternFly page layout, `@patternfly/chatbot` for the chat stream, and a PatternFly Drawer for `MemoryDrawer`. `useRoomSocket` sends `room.join` after access-token acquisition, retains the last received sequence, and reconnects with `afterSequence`. It renders server-normalized events only; it must not optimistically mark a decision active.

`DecisionCard` renders title, summary, source-event identifiers, status, and controls only for a draft viewed by a human. `DecisionEditForm` requires non-empty title and summary, then sends `decision.transition` with action `edit`. Surface structured gateway errors in an accessible PatternFly alert without exposing JWTs or raw stack traces.

- [ ] **Step 4: Run the component suite and production build**

Run: `npm test -- DecisionCard.test.tsx && npm run build`

Expected: PASS; human-only controls and structured-error rendering are covered before the live-stack end-to-end test is added in Task 8.

- [ ] **Step 5: Commit the independent UI project**

```bash
cd thought-khoral-workspace-ui
git add .
git commit -m "feat: add governed collaborative room UI"
```

### Task 6: Implement the deterministic facilitator boundary

**Files:**
- Create: `thought-khoral-room-gateway/src/facilitator.rs`
- Modify: `thought-khoral-room-gateway/src/{main,rooms,protocol}.rs`
- Create: `thought-khoral-room-gateway/tests/facilitator_test.rs`
- Test: `thought-khoral-room-gateway/tests/facilitator_test.rs`

**Interfaces:**
- Consumes: persisted `message.created` events.
- Produces: an agent-attributed `decision.proposed` event; never a decision transition.

- [ ] **Step 1: Write failing facilitator tests**

Define a message fixture containing `Decision: adopt JSON-RPC for room events.` Assert the facilitator produces one draft proposal with the source message event ID. Assert an ordinary conversational message produces no proposal. Assert no facilitator method can invoke `transition_decision`.

- [ ] **Step 2: Run the focused test**

Run: `cargo test --test facilitator_test`

Expected: FAIL because `facilitator` is absent.

- [ ] **Step 3: Implement deterministic proposal extraction**

Implement `propose_from_message(event: &RoomEvent) -> Option<NewDecisionProposal>`. It accepts only messages whose trimmed text begins with `Decision:` and whose remaining title is non-empty. Set actor role to `agent`, source event IDs to the triggering event, and persist/broadcast only `decision.proposed`. Do not call external models, tools, databases other than the gateway store, or operating-system commands.

- [ ] **Step 4: Run focused and regression tests**

Run: `cargo test --test facilitator_test --test room_flow_test --test authorization_test`

Expected: PASS; the new agent can propose but cannot activate context.

- [ ] **Step 5: Commit the facilitator feature**

```bash
cd thought-khoral-room-gateway
git add src/facilitator.rs src/main.rs src/rooms.rs src/protocol.rs tests/facilitator_test.rs .ai/specs
git commit -m "feat: add deterministic decision facilitator"
```

### Task 7: Compose rootless local development and Kubernetes parity validation

**Files:**
- Create: `thought-khoral-platform/compose.yaml`
- Create: `thought-khoral-platform/keycloak/thought-khoral-dev-realm.json`
- Create: `thought-khoral-platform/kube/{namespace,postgres,keycloak,gateway,ui}.yaml`
- Create: `thought-khoral-platform/scripts/{smoke,validate-kube}.sh`
- Create: `thought-khoral-platform/README.md`
- Test: `thought-khoral-platform/scripts/smoke.sh`, `scripts/validate-kube.sh`

**Interfaces:**
- Consumes: images built from checked-out sibling repositories and Keycloak OIDC configuration.
- Produces: `podman-compose up` local stack, `podman play kube` validation, fixture realm with human and agent identities.

- [ ] **Step 1: Write failing platform smoke checks**

`scripts/smoke.sh` must fail unless PostgreSQL reports ready, Keycloak’s realm discovery endpoint responds, the gateway health endpoint responds, and the UI serves its document. `scripts/validate-kube.sh` must fail unless `podman play kube --replace --start=false` accepts all manifests.

- [ ] **Step 2: Run checks before authoring deployment assets**

Run: `bash scripts/smoke.sh && bash scripts/validate-kube.sh`

Expected: FAIL because Compose configuration and manifests do not exist.

- [ ] **Step 3: Create the rootless platform definitions**

Compose services are `postgres`, `keycloak`, `gateway`, and `ui`; use named volumes, non-root images where available, explicit health checks, and no host-network mode. Enable the pgvector extension through the PostgreSQL initialization path. Import a development-only realm with two human users and one agent user, `n2n_role` claims, and redirect URIs limited to the local UI origin.

Kubernetes manifests must use the same service names and environment-variable contracts as Compose. Give every container `runAsNonRoot: true`, `allowPrivilegeEscalation: false`, and a read-only root filesystem except PostgreSQL’s declared data volume. Do not include production credentials in tracked files.

- [ ] **Step 4: Run platform checks**

Run: `podman-compose up --build -d && bash scripts/smoke.sh && bash scripts/validate-kube.sh && podman-compose down`

Expected: PASS; all four local services become healthy and manifests are accepted locally without starting workloads.

- [ ] **Step 5: Commit the independent platform project**

```bash
cd thought-khoral-platform
git add .
git commit -m "feat: add rootless ThoughtKhoral MVP platform"
```

### Task 8: Run the end-to-end release gate and document verified exclusions

**Files:**
- Modify: `thought-khoral-platform/scripts/smoke.sh`, `thought-khoral-platform/README.md`
- Modify: `thought-khoral-room-gateway/.ai/specs/what/mvp-room.md`
- Modify: `thought-khoral-workspace-ui/.ai/specs/what/mvp-ui.md`
- Create: `thought-khoral-workspace-ui/e2e/governed-decision.spec.ts`
- Test: full contract, gateway, UI, and platform suites

**Interfaces:**
- Consumes: independently passing repositories and a running local platform stack.
- Produces: reproducible MVP evidence and a clear boundary for the next memory-engine and agent-gateway plans.

- [ ] **Step 1: Add a failing end-to-end test and release-gate script**

In Playwright, sign in two fixture humans, open the same room, send a message, receive a deterministic facilitator draft, confirm it from the first browser, and assert the second browser’s drawer shows the decision as active. Attempt the agent fixture path and assert it cannot transition the decision. Extend `thought-khoral-platform/scripts/smoke.sh` to execute the gateway integration suite and that Playwright test only after service health checks pass. It must stop on the first failure and always run `podman-compose down` through a shell `trap`.

- [ ] **Step 2: Run the release gate**

Run: `bash scripts/smoke.sh`

Expected: FAIL until the end-to-end test, cross-repository commands, and cleanup trap are implemented.

- [ ] **Step 3: Implement release evidence and scope documentation**

Record exact commands, required environment variables, and expected success indicators in `thought-khoral-platform/README.md`. Update the two MVP What documents with the verified exclusions: Cognee-RS extraction, embeddings, external A2A/MCP connections, local models, Wasm/crun sandboxes, SPIFFE/SPIRE, Kafka, service mesh, and OpenShift production services are not enabled by the MVP.

- [ ] **Step 4: Run the complete gate**

Run: `cd ../thought-khoral-contracts && npm test && cd ../thought-khoral-room-gateway && cargo fmt --check && cargo clippy -- -D warnings && cargo test && cd ../thought-khoral-workspace-ui && npm test && npm run test:e2e && cd ../thought-khoral-platform && bash scripts/smoke.sh && bash scripts/validate-kube.sh`

Expected: PASS.

- [ ] **Step 5: Commit release-gate documentation in each affected repository**

```bash
cd thought-khoral-room-gateway && git add .ai/specs && git commit -m "docs: record MVP gateway boundary"
cd ../thought-khoral-workspace-ui && git add .ai/specs && git commit -m "docs: record MVP UI boundary"
cd ../thought-khoral-platform && git add scripts README.md .ai/specs && git commit -m "test: add MVP release gate"
```

## Spec coverage review

| Root requirement | Plan task |
| --- | --- |
| Direct-child independent repositories with local specs | Task 1 |
| Versioned language-neutral contracts | Task 2 |
| Validated Rust gateway and append-only events | Tasks 3–4 |
| PatternFly dual-pane UI and decision cards | Task 5 |
| Agent can propose but not activate context | Task 6 |
| Rootless Podman, Keycloak, PostgreSQL/pgvector, and local Kubernetes validation | Task 7 |
| Auditable MVP evidence and deferred-capability boundary | Task 8 |

## Deliberate follow-on plans

After the MVP passes its release gate, continue from the accepted [room-scoped POC memory decision](../decisions/005-room-scoped-poc-memory.md) and the approved memory-engine POC What and How. The next authorized memory-engine artifact is an implementation plan for Cognee-RS ECL, graph extraction, embeddings, and temporal lineage, all partitioned by `roomId`. Project/topic memory hierarchy is excluded from that plan. `thought-khoral-agent-gateway` still needs its own later plan (A2A/MCP compatibility, mediated hydration, remote admission, and Wasm/crun or microVM isolation). Dependency adoption requires the authoritative compatibility and licensing verification required by the root specification.
