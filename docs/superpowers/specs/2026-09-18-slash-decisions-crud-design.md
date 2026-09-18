# Slash Decisions CRUD Design

**Date:** 2026-09-18  
**Status:** Proposed for implementation  
**Scope:** `thought-khoral-contracts`, `thought-khoral-room-gateway`, and `thought-khoral-workspace-ui`

## Goal

Replace the legacy `Decisions:` instruction pattern with a Codex-style
`/decisions` command. The command opens a local decision-management workflow
for human participants. The workflow supports Create, Update, Delete, and
Cancel. A successful mutation posts a concise result into the room chat;
Cancel closes the workflow without sending a request or a message.

## UX

The chat composer recognizes the exact trimmed command `/decisions`. It is
consumed locally and is never sent as `chat.send`.

The command opens a PatternFly decision workflow with these actions:

- **Create:** collect a required title and summary, with an optional selector
  for one or more existing chat messages to use as source evidence. The
  source-event list may be empty.
- **Update:** choose a draft decision and edit its title and summary. Active,
  dismissed, and superseded decisions are not editable.
- **Delete:** choose an existing decision and confirm permanent deletion.
- **Cancel:** close the workflow without a gateway request and without a chat
  message.

Delete is presented as a destructive operation and requires an explicit
confirmation. It is available for any decision row that still exists in the
authoritative decision table. Agents do not receive mutation controls; the
existing human-only governance boundary remains in force.

When a mutation is accepted by the gateway, the UI waits for the normalized
event carrying the mutation request ID before posting a result with
`chat.send`. Result text must not use the legacy `Decision:` prefix, so a
result cannot be mistaken for a facilitator proposal instruction. A failed
request produces no result message and remains visible through the existing
gateway error alert.

## Contract changes

The retained `n2n.room.v1` contract gains additive decision deletion support:

- Add `decision.delete` to the RPC method enum. Its parameters are the common
  envelope plus `decisionId`.
- Add `decision.deleted` to the room-event enum.
- Add `decision.deleted` payload requirements for `decisionId`, the prior
  status, title, summary, and source-event IDs. These values are the audit
  snapshot of the physically deleted row.
- Change `decision.propose.sourceEventIds.minItems` from `1` to `0`.
- Document the new method, event, authorization behavior, and error behavior.
- Add valid and invalid fixtures covering deletion, empty source evidence, and
  malformed deletion requests.

The existing `decision.transition` actions remain `confirm`, `edit`, and
`dismiss`. Dismiss continues to be a state transition; it is not the physical
delete operation.

The gateway's legacy `Decision:` message-prefix facilitator path is removed.
Messages beginning with `Decision:` are ordinary chat messages after this
change. The UI's `/decisions` Create flow is the only human-facing decision
creation path, and it invokes the governed `decision.propose` RPC directly.

## Gateway behavior

`decision.delete` is accepted only for a human participant. In one database
transaction the gateway:

1. Locks the decision row for the requested room and ID.
2. Copies its ID, status, title, summary, and source-event IDs into a
   `decision.deleted` event.
3. Deletes the decision row.
4. Commits the audit event, row deletion, and request-ledger record together.

The event remains in the append-only `room_events` table after the decision
row is removed. Replaying a room applies `decision.deleted` by removing the
decision from the current projection. A missing decision returns the existing
not-found error; a non-human caller returns the existing forbidden error.
Existing request-ledger idempotency applies to retries, including a retry
after the row has already been deleted.

## UI data flow

`ChatStream` owns slash-command recognition and exposes a local command
callback. `RoomPage` owns the workflow state because it has the current
decision projection, chat messages, participant role, and authenticated socket
sender.

The UI must add the existing contract's `decision.propose` method to its RPC
type and add `decision.delete`. It tracks the generated request ID for each
decision mutation. A matching normalized event completes the pending action:

- `decision.proposed` → post a created result.
- `decision.edited` plus its replacement confirmation → post an updated
  result once for the operation.
- `decision.deleted` → post a deleted result.

The result itself is sent through `chat.send`, so it is persisted and visible
to all room participants as a normal room message. Cancel and failed gateway
requests do not send this follow-up message.

## Testing and verification

Contract tests will verify the new method and event schemas, empty source
evidence, required deletion fields, and rejection of malformed payloads.

Gateway tests will verify human-only authorization, transactional physical
deletion, the complete audit snapshot, replay behavior, not-found handling,
idempotent retries, and the removal of automatic proposals from `Decision:`
messages.

Workspace tests will verify exact `/decisions` interception, no chat send for
the command itself, the Create/Update/Delete/Cancel workflow, optional source
selection, draft-only Update, Delete confirmation, silent Cancel, result
messages only after matching normalized events, and no result after failure.

The standard checks remain the owning repositories' existing test and build
commands, plus the workspace static-preview smoke check.

## Out of scope

- A new protocol major version.
- Physical deletion of room messages or audit events.
- Editing active, dismissed, or superseded decisions.
- A general slash-command registry beyond `/decisions`.
- Client-side authority over decision state; the gateway remains authoritative.
