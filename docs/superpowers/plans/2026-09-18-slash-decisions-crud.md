# Slash Decisions CRUD Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the legacy `Decision:` instruction with a local `/decisions` CRUD workflow whose successful mutations are audited by the gateway and reported in room chat.

**Architecture:** Extend the retained `n2n.room.v1` contract additively with `decision.delete` and `decision.deleted`, while allowing empty source evidence for `decision.propose`. The gateway records a deletion event and physically deletes the decision row in one transaction. The workspace intercepts `/decisions`, runs a human-only PatternFly workflow, correlates accepted mutation events by request ID, and posts one result message through `chat.send`.

**Tech Stack:** JSON Schema + Node/AJV contract fixtures; Rust 2024, Tokio, Axum, SQLx/PostgreSQL, and JSON-RPC gateway tests; React 19, TypeScript, PatternFly React, PatternFly Chatbot, Vitest, and Testing Library.

**Spec:** [`docs/superpowers/specs/2026-09-18-slash-decisions-crud-design.md`](../specs/2026-09-18-slash-decisions-crud-design.md)

## Global Constraints

- `/decisions` is recognized only as the exact trimmed command and is never sent as `chat.send`.
- Create requires a title and summary and permits an empty `sourceEventIds` array.
- Update is available only for draft decisions.
- Delete is human-only, permanently removes the decision row, and preserves an immutable `decision.deleted` event with the deleted row’s audit snapshot.
- Cancel sends no gateway request and no chat message.
- Result messages are sent only after a matching normalized mutation event and must not begin with the legacy `Decision:` prefix.
- The append-only `room_events` table and audit history are never physically deleted.
- No new protocol major version or general slash-command registry is introduced.

---

## File and repository map

| Repository | Files | Responsibility |
| --- | --- | --- |
| `thought-khoral-contracts` | `schemas/rpc.schema.json`, `schemas/room-event.schema.json`, `protocol.md`, `fixtures/valid/decision-delete.json`, `fixtures/valid/decision-propose-empty-sources.json`, `fixtures/invalid/decision-delete-missing-id.json`, `test/validate-fixtures.mjs` | Define and validate the wire contract and fixtures. |
| `thought-khoral-room-gateway` | `src/protocol.rs`, `src/rooms.rs`, `src/facilitator.rs`, `src/lib.rs`, `tests/protocol_test.rs`, `tests/authorization_test.rs`, `tests/room_flow_test.rs`, `tests/replay_test.rs`, `tests/facilitator_test.rs` | Parse the new RPC, enforce human authorization, delete transactionally, project deletion events, and remove the legacy message-prefix proposal path. |
| `thought-khoral-workspace-ui` | `src/api.tsx`, `src/features/room/useRoomSocket.tsx`, `src/features/room/ChatStream.tsx`, `src/features/room/ChatStream.test.tsx`, `src/features/room/RoomPage.tsx`, `src/features/room/RoomPage.test.tsx`, `src/features/decisions/DecisionCommandDialog.tsx`, `src/features/decisions/DecisionCommandDialog.test.tsx`, `src/features/decisions/DecisionCreateForm.tsx` | Intercept `/decisions`, render the CRUD workflow, send existing and new RPCs, correlate events, and post result messages. |

## Task 1: Extend and verify the room contract

**Files:**
- Modify: `thought-khoral-contracts/schemas/rpc.schema.json`
- Modify: `thought-khoral-contracts/schemas/room-event.schema.json`
- Modify: `thought-khoral-contracts/protocol.md`
- Create: `thought-khoral-contracts/fixtures/valid/decision-delete.json`
- Create: `thought-khoral-contracts/fixtures/valid/decision-propose-empty-sources.json`
- Create: `thought-khoral-contracts/fixtures/invalid/decision-delete-missing-id.json`
- Modify: `thought-khoral-contracts/test/validate-fixtures.mjs` only if a focused assertion is needed beyond fixture validation.

**Interfaces:**
- Produces the JSON-RPC method `decision.delete` with `decisionId` and the normalized event type `decision.deleted`.
- Changes `decision.propose.params.sourceEventIds.minItems` to `0`.
- Requires `decision.deleted.payload` to contain `decisionId`, `priorStatus`, `title`, `summary`, and `sourceEventIds`.

- [ ] **Step 1: Write the new fixtures first.** Add a valid delete request using the common envelope and a valid create request with `sourceEventIds: []`. Add an invalid delete request with no `decisionId`.

```json
{
  "jsonrpc": "2.0",
  "id": "delete-1",
  "method": "decision.delete",
  "params": {
    "contractVersion": "n2n.room.v1",
    "requestId": "44444444-4444-4444-8444-444444444444",
    "roomId": "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa",
    "occurredAt": "2026-09-18T12:00:00Z",
    "decisionId": "cccccccc-cccc-4ccc-8ccc-cccccccccccc"
  }
}
```

- [ ] **Step 2: Run the contract fixture test and verify the new fixtures fail for the intended schema reason.**

Run: `npm test` in `thought-khoral-contracts`

Expected: the new valid fixtures fail validation because the method, event, and empty-source rules are not yet in the schema; the invalid fixture remains rejected.

- [ ] **Step 3: Update `rpc.schema.json`.** Add `decision.delete` to the method enum and add a `oneOf` branch requiring the common envelope plus UUID `decisionId`. Change the create branch’s `sourceEventIds` to allow zero items.

- [ ] **Step 4: Update `room-event.schema.json`.** Add `decision.deleted` to the event enum and add a conditional schema branch for that event requiring `payload.decisionId`, `payload.priorStatus`, `payload.title`, `payload.summary`, and `payload.sourceEventIds` (an array that may be empty). Leave unrelated event payloads governed by the existing generic object rule.

- [ ] **Step 5: Update `protocol.md`.** Document `decision.delete`, `decision.deleted`, the human-only rule, atomic row deletion plus audit event, and the empty-source create rule. State that `dismiss` remains a state transition and is not delete.

- [ ] **Step 6: Run the contract test and verify it passes.**

Run: `npm test` in `thought-khoral-contracts`

Expected: all valid fixtures validate, all invalid fixtures reject, and the output reports all fixtures were checked.

- [ ] **Step 7: Commit the contract slice.**

```sh
git add schemas/rpc.schema.json schemas/room-event.schema.json protocol.md fixtures test
git commit -m "feat: extend decision contract for CRUD deletion"
```

## Task 2: Add typed gateway request parsing and retire the legacy prefix path

**Files:**
- Modify: `thought-khoral-room-gateway/src/protocol.rs`
- Modify: `thought-khoral-room-gateway/src/facilitator.rs`
- Modify: `thought-khoral-room-gateway/src/lib.rs`
- Modify: `thought-khoral-room-gateway/src/rooms.rs`
- Modify: `thought-khoral-room-gateway/tests/protocol_test.rs`
- Modify: `thought-khoral-room-gateway/tests/facilitator_test.rs`

**Interfaces:**
- Produces `DecisionDelete { id, contract_version, request_id, room_id, occurred_at, decision_id }`.
- Adds `ValidatedRequest::DecisionDelete(DecisionDelete)` and includes it in `id`, `room_id`, `request_id`, and fingerprint matching.
- Removes `propose_from_message` and the `chat.send` call path that turns `Decision:` text into a second event. Retain `NewDecisionProposal` and `validate_memory_engine_proposal` for the existing memory-engine port.

- [ ] **Step 1: Add protocol tests that consume the new fixture.** Extend `tests/protocol_test.rs` with a `DECISION_DELETE` include and assert that `validate_request` returns `ValidatedRequest::DecisionDelete` with the expected UUIDs. Add a test that a `decision.propose` request with `sourceEventIds: []` still parses.

```rust
#[test]
fn validates_decision_delete_as_a_typed_request() {
    let request = validate_request(DECISION_DELETE).expect("delete fixture must validate");
    let ValidatedRequest::DecisionDelete(delete) = request else {
        panic!("expected DecisionDelete");
    };
    assert_eq!(delete.decision_id, Uuid::parse_str("cccccccc-cccc-4ccc-8ccc-cccccccccccc").unwrap());
}
```

- [ ] **Step 2: Run the focused gateway protocol tests and verify failure.**

Run: `cargo test --test protocol_test validates_decision_delete_as_a_typed_request` in `thought-khoral-room-gateway`

Expected: FAIL because the fixture is not yet included in the typed request enum/parser.

- [ ] **Step 3: Implement `DecisionDelete` and parser support.** Add the serde struct, enum variant, fingerprint fields, room/request ID accessors, method allow-list entry, schema dispatch branch, and public re-export needed by tests.

- [ ] **Step 4: Add a regression test for the retired prefix behavior.** Change the facilitator unit test to assert that both `Decision: adopt JSON-RPC` and ordinary conversation return `None`. Update the gateway flow test so a `chat.send` containing `Decision:` produces only `message.created` and never `decision.proposed`.

- [ ] **Step 5: Remove the legacy auto-proposal call path.** Delete the `propose_from_message` function and its public export. In `rooms.rs`, make `ValidatedRequest::ChatSend` append only the message event; remove `persist_draft_proposal` if it has no remaining caller. Do not remove the memory-engine proposal validator or its types.

- [ ] **Step 6: Run focused gateway tests and verify they pass.**

Run: `cargo test --test protocol_test --test facilitator_test`

Expected: typed delete parsing passes, empty-source parsing passes, and legacy `Decision:` messages remain ordinary chat.

- [ ] **Step 7: Commit the parser and legacy-behavior slice.**

```sh
git add src/protocol.rs src/facilitator.rs src/lib.rs src/rooms.rs tests/protocol_test.rs tests/facilitator_test.rs
git commit -m "feat: parse decision deletion and retire prefix proposals"
```

## Task 3: Implement transactional physical deletion and audit replay

**Files:**
- Modify: `thought-khoral-room-gateway/src/rooms.rs`
- Modify: `thought-khoral-room-gateway/tests/authorization_test.rs`
- Modify: `thought-khoral-room-gateway/tests/room_flow_test.rs`
- Modify: `thought-khoral-room-gateway/tests/replay_test.rs`

**Interfaces:**
- `GatewayState::process` accepts `ValidatedRequest::DecisionDelete` only for `ActorRole::Human`.
- The delete branch returns one `RoomEvent` with `event_type == "decision.deleted"`.
- The request ledger stores the same event so an identical retry returns it without requiring the decision row to exist.

- [ ] **Step 1: Write the human authorization test.** Add a gateway test that creates a decision, submits `decision.delete` as an agent, and expects error code `-32003`; assert the decision row remains.

- [ ] **Step 2: Write the physical-delete and audit test.** As a human, propose a decision, delete it, assert the response event has `decision.deleted` and the complete prior snapshot, assert `SELECT count(*) FROM decisions WHERE decision_id = $1` is zero, and assert the corresponding `room_events` row remains.

- [ ] **Step 3: Write the replay test.** Join/replay a room containing `decision.proposed` followed by `decision.deleted`, then assert the event stream contains both events in sequence. The UI projection test in Task 5 will assert that the final decision map is empty.

- [ ] **Step 4: Run the new gateway tests and verify failure.**

Run: `cargo test --test authorization_test --test room_flow_test --test replay_test decision`

Expected: FAIL because `DecisionDelete` is parsed but not handled by `GatewayState::process`.

- [ ] **Step 5: Implement the transaction.** Add the human-only authorization match, select the row by room and decision ID with `FOR UPDATE`, return `RpcError::not_found()` when absent, append `decision.deleted` with `decisionId`, `priorStatus`, `title`, `summary`, and `sourceEventIds`, delete the row, and let the existing request-ledger insert and transaction commit cover both writes.

```rust
let event = append_event_in_transaction(
    &mut transaction,
    NewEvent {
        room_id: request.room_id,
        request_id: request.request_id,
        event_type: "decision.deleted".to_owned(),
        actor_id: actor.id,
        actor_role: actor.role.as_str().to_owned(),
        actor_display_name: Some(actor.display_name.clone()),
        payload: json!({
            "decisionId": request.decision_id,
            "priorStatus": status,
            "title": title,
            "summary": summary,
            "sourceEventIds": source_event_ids,
        }),
        occurred_at: request.occurred_at,
    },
).await.map_err(|_| RpcError::internal_error())?;
sqlx::query("DELETE FROM decisions WHERE decision_id = $1 AND room_id = $2")
    .bind(request.decision_id)
    .bind(request.room_id)
    .execute(&mut *transaction)
    .await
    .map_err(|_| RpcError::internal_error())?;
```

- [ ] **Step 6: Add idempotency and not-found assertions.** Retry the same request ID and payload after the first commit and assert the same event is returned without a second event. Submit a new request ID for the already-deleted decision and assert `-32004`.

- [ ] **Step 7: Run the focused and full gateway suites.**

Run: `cargo test --test authorization_test --test room_flow_test --test replay_test`

Expected: PASS, including human-only deletion, audit retention, physical removal, replay ordering, retry idempotency, and not-found behavior.

- [ ] **Step 8: Commit the gateway deletion slice.**

```sh
git add src/rooms.rs tests/authorization_test.rs tests/room_flow_test.rs tests/replay_test.rs
git commit -m "feat: add audited physical decision deletion"
```

## Task 4: Extend workspace protocol types and event projection

**Files:**
- Modify: `thought-khoral-workspace-ui/src/api.tsx`
- Modify: `thought-khoral-workspace-ui/src/api.test.ts`

**Interfaces:**
- `RoomEventType` includes `decision.deleted`.
- `RpcRequest['method']` includes `decision.propose` and `decision.delete`.
- `projectRoomEvents` removes a decision from its map when it sees `decision.deleted`.
- `createRpcRequest` remains the single request-ID generator.

- [ ] **Step 1: Add projection tests before implementation.** Add a `decision.proposed` followed by `decision.deleted` fixture to `src/api.test.ts` and assert `projectRoomEvents(events).decisions` is empty. Add an event-validation assertion that `isRoomEvent` accepts `decision.deleted`.

- [ ] **Step 2: Run the focused API test and verify failure.**

Run: `npm test -- --run src/api.test.ts` in `thought-khoral-workspace-ui`

Expected: FAIL because `decision.deleted` is not in the accepted event set and projection logic.

- [ ] **Step 3: Implement the type and projection changes.** Add the event and methods, handle deletion before title/summary extraction by calling `decisions.delete(decisionId)`, and preserve existing edit/confirm/dismiss behavior.

- [ ] **Step 4: Run the focused API test and verify it passes.**

Run: `npm test -- --run src/api.test.ts` in `thought-khoral-workspace-ui`

Expected: PASS.

- [ ] **Step 5: Commit the workspace contract-projection slice.**

```sh
git add src/api.tsx src/api.test.ts
git commit -m "feat: project deleted decisions and new RPC methods"
```

## Task 5: Make socket sends correlate request IDs

**Files:**
- Modify: `thought-khoral-workspace-ui/src/features/room/useRoomSocket.tsx`
- Modify: `thought-khoral-workspace-ui/src/features/decisions/DecisionCard.test.tsx` or create `src/features/room/useRoomSocket.test.tsx` if the existing combined test becomes unwieldy.

**Interfaces:**
- `send(method, params)` returns `string | false`: the generated request ID on a successful socket send, or `false` when no usable connection exists.
- Existing callers may ignore the return value.

- [ ] **Step 1: Add a socket test that captures the return value.** Open the fake socket, call `send('decision.delete', { decisionId })`, parse the sent JSON, and assert the returned string equals both `id` and `params.requestId`.

- [ ] **Step 2: Run the focused socket test and verify failure.**

Run: `npm test -- --run src/features/room/useRoomSocket.test.tsx` in `thought-khoral-workspace-ui`

Expected: FAIL because `send` currently returns only a boolean.

- [ ] **Step 3: Return the request ID from the socket hook.** Store the result of `createRpcRequest`, send it, and return `request.params.requestId`; retain the existing gateway error path and `false` return for disconnected sockets.

- [ ] **Step 4: Run the socket and existing room tests.**

Run: `npm test -- --run src/features/room/useRoomSocket.test.tsx src/features/decisions/DecisionCard.test.tsx`

Expected: PASS.

- [ ] **Step 5: Commit the request-correlation slice.**

```sh
git add src/features/room/useRoomSocket.tsx src/features/room/useRoomSocket.test.tsx src/features/decisions/DecisionCard.test.tsx
git commit -m "feat: expose request IDs for room mutations"
```

## Task 6: Build the local `/decisions` workflow

**Files:**
- Create: `thought-khoral-workspace-ui/src/features/decisions/DecisionCommandDialog.tsx`
- Create: `thought-khoral-workspace-ui/src/features/decisions/DecisionCommandDialog.test.tsx`
- Create: `thought-khoral-workspace-ui/src/features/decisions/DecisionCreateForm.tsx`
- Modify: `thought-khoral-workspace-ui/src/features/room/ChatStream.tsx`
- Modify: `thought-khoral-workspace-ui/src/features/room/ChatStream.test.tsx`

**Interfaces:**
- `ChatStreamProps` adds `onCommand?: (command: 'decisions') => void` and `canManageDecisions: boolean`.
- The composer trims submitted text; exact `/decisions` invokes `onCommand?.('decisions')` when `canManageDecisions` is true and never calls `onSendMessage`.
- `DecisionCommandDialog` accepts `decisions`, `messages`, `onCreate`, `onUpdate`, `onDelete`, and `onCancel` callbacks. Its create callback is `{ title: string; summary: string; sourceEventIds: string[] }`; update is `{ decisionId: string; editedTitle: string; editedSummary: string }`; delete is `{ decisionId: string }`.

- [ ] **Step 1: Write ChatStream command tests.** Cover exact `/decisions` interception, surrounding whitespace, normal message passthrough, non-command slash text passthrough, and agent/non-manager behavior.

```tsx
it('consumes /decisions as a local command', async () => {
  const onCommand = vi.fn();
  const onSendMessage = vi.fn();
  const user = userEvent.setup();
  render(<ChatStream isConnected canManageDecisions messages={[]} onCommand={onCommand} onSendMessage={onSendMessage} />);

  await user.type(screen.getByRole('textbox', { name: 'Message' }), '/decisions');
  await user.click(screen.getByRole('button', { name: /send/i }));

  expect(onCommand).toHaveBeenCalledWith('decisions');
  expect(onSendMessage).not.toHaveBeenCalled();
});
```

- [ ] **Step 2: Run the ChatStream test and verify failure.**

Run: `npm test -- --run src/features/room/ChatStream.test.tsx` in `thought-khoral-workspace-ui`

Expected: FAIL because the MessageBar currently forwards every non-empty value to `onSendMessage`.

- [ ] **Step 3: Implement exact command interception in `ChatStream`.** Keep the existing connection-disabled behavior and message trimming. Branch only on `text === '/decisions'`; invoke the local callback for human managers and otherwise preserve the existing send behavior for ordinary text.

- [ ] **Step 4: Write dialog tests before implementation.** Test that the action chooser renders Create, Update, Delete, and Cancel; Cancel calls only `onCancel`; Create accepts an empty source selection; Update lists drafts but not active decisions; Delete lists existing decisions and requires confirmation.

- [ ] **Step 5: Implement `DecisionCreateForm`.** Use PatternFly `Form`, `TextInput`, `TextArea`, selectable message rows keyed by `RoomMessage.eventId`, required title and summary validation, and a Cancel button. Submit trimmed values and an empty or selected `sourceEventIds` array.

- [ ] **Step 6: Implement `DecisionCommandDialog`.** Use a PatternFly modal or inline dialog with a top-level action chooser, per-action form state, destructive Delete confirmation, and Cancel callbacks. Do not call gateway methods from this component; emit typed callbacks to `RoomPage`.

- [ ] **Step 7: Run focused command and dialog tests.**

Run: `npm test -- --run src/features/room/ChatStream.test.tsx src/features/decisions/DecisionCommandDialog.test.tsx`

Expected: PASS for local interception, create validation/source selection, draft-only update selection, delete confirmation, and silent cancel.

- [ ] **Step 8: Commit the local workflow slice.**

```sh
git add src/features/room/ChatStream.tsx src/features/room/ChatStream.test.tsx src/features/decisions/DecisionCommandDialog.tsx src/features/decisions/DecisionCommandDialog.test.tsx src/features/decisions/DecisionCreateForm.tsx
git commit -m "feat: add local slash decisions workflow"
```

## Task 7: Integrate workflow mutations and result messages in `RoomPage`

**Files:**
- Modify: `thought-khoral-workspace-ui/src/features/room/RoomPage.tsx`
- Create: `thought-khoral-workspace-ui/src/features/room/RoomPage.test.tsx`
- Modify: `thought-khoral-workspace-ui/src/features/decisions/DecisionCard.tsx` only if the existing card needs a Delete action removed or its read-only projection clarified.

**Interfaces:**
- `RoomPage` owns `isDecisionCommandOpen`, pending mutation records keyed by request ID, and the event-to-result effect.
- Pending record shape: `{ kind: 'create' | 'update' | 'delete'; decisionId?: string; title?: string; replacementObserved?: boolean }`.
- Mutation callbacks call `send('decision.propose' | 'decision.transition' | 'decision.delete', params)` and store the returned request ID only when it is not `false`.

- [ ] **Step 1: Add RoomPage integration tests for command launch and Cancel.** Enter a room, type `/decisions`, assert the workflow appears, click Cancel, assert it disappears, and assert the fake socket has no `chat.send`, `decision.propose`, `decision.transition`, or `decision.delete` request from that interaction.

- [ ] **Step 2: Add mutation request tests.** Select Create with title/summary and no sources and assert `decision.propose` has `sourceEventIds: []`. Select a draft for Update and assert `decision.transition` has action `edit`. Select an existing decision for Delete, confirm, and assert `decision.delete` has the selected ID.

- [ ] **Step 3: Add result timing tests.** After each mutation request, assert no result chat message is sent before the matching normalized event. Deliver the event with the request ID, then assert exactly one `chat.send` result. Deliver a gateway error instead and assert no result. For Update, deliver both `decision.edited` and replacement `decision.confirmed` and assert only one result.

- [ ] **Step 4: Run the new RoomPage tests and verify failure.**

Run: `npm test -- --run src/features/room/RoomPage.test.tsx` in `thought-khoral-workspace-ui`

Expected: FAIL because RoomPage does not yet open the workflow, send the new methods, or track pending request IDs.

- [ ] **Step 5: Add workflow state and command callback wiring.** Pass `canManageDecisions={participantRole === 'human'}` and `onCommand={() => setIsDecisionCommandOpen(true)}` to `ChatStream`. Render `DecisionCommandDialog` with the current room decisions and messages.

- [ ] **Step 6: Implement Create, Update, and Delete send callbacks.** Use `send` with the exact contract parameters. Capture the returned request ID and store the human-readable result context in a ref. Close the dialog only after the request is accepted for processing; leave gateway errors visible through the existing alert.

- [ ] **Step 7: Implement normalized-event correlation.** Track the highest processed event sequence or a processed-event set so rerenders do not duplicate results. For Create, match `decision.proposed`; for Update, wait for both `decision.edited` and its replacement `decision.confirmed`; for Delete, match `decision.deleted`. Post result text such as `Created decision "...".`, `Updated decision "...".`, or `Deleted decision "...".` via `send('chat.send', { text })`.

- [ ] **Step 8: Run the RoomPage integration tests and verify they pass.**

Run: `npm test -- --run src/features/room/RoomPage.test.tsx`

Expected: PASS with no command-as-chat message, correct CRUD requests, silent Cancel, result-after-event behavior, one result per mutation, and no result after failure.

- [ ] **Step 9: Commit the RoomPage integration slice.**

```sh
git add src/features/room/RoomPage.tsx src/features/room/RoomPage.test.tsx src/features/decisions/DecisionCard.tsx
git commit -m "feat: integrate audited decisions CRUD commands"
```

## Task 8: Run cross-repository verification and update implementation notes

**Files:**
- Modify: `thought-khoral-workspace-ui/README.md` only if the command behavior needs to be documented for contributors.
- Modify: owning repository implementation/spec notes only when the accepted implementation differs from this plan; do not edit the approved design to hide a behavior change.

- [ ] **Step 1: Run contract verification.**

Run: `npm test` in `thought-khoral-contracts`

Expected: PASS for all valid/invalid JSON fixtures.

- [ ] **Step 2: Run the full gateway verification.**

Run: `cargo fmt --check && cargo test` in `thought-khoral-room-gateway`

Expected: PASS for formatting, protocol parsing, authorization, facilitator migration, deletion transactions, replay, and existing room behavior.

- [ ] **Step 3: Run the full workspace verification.**

Run: `npm test && npm run build && npm run test:preview` in `thought-khoral-workspace-ui`

Expected: PASS for unit tests, TypeScript/Vite build, and static preview lazy-module smoke test.

- [ ] **Step 4: Inspect all three worktrees for unintended changes.**

Run: `git status --short` separately in each repository and `git diff --check` in each repository.

Expected: only the planned contract, gateway, UI, test, and contributor-documentation files are modified; no credentials, generated bundles, or dependency lockfile churn appears.

- [ ] **Step 5: Commit any narrowly scoped documentation update.**

```sh
git add README.md
git commit -m "docs: describe slash decisions workflow"
```
