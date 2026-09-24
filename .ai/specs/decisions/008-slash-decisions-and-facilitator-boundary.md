# 008 — Slash decisions and the facilitator boundary

## Status

Accepted — 2026-09-24

## Context

The governed room now uses a human-initiated `/decisions` workflow. Its
retained room-v1 wire contract includes `decision.delete` and
`decision.deleted`, and the gateway treats a message beginning with
`Decision:` as ordinary chat. Root [decision 005](005-room-scoped-poc-memory.md)
still described the deterministic prefix parser as the live facilitator
implementation until a memory-engine switch. That historical implementation
requirement conflicts with the tested contract, gateway, and workspace UI.

## Decision

The exact `/decisions` command is a local workspace action for a human
participant. It opens Create, Update, Delete, or Cancel controls; the command
itself is not sent as chat. Create uses the governed `decision.propose` method,
Update uses `decision.transition` for a draft, and Delete uses human-only
`decision.delete`. A successful mutation is reported to room chat only after
its matching persisted event. Cancel sends neither a mutation nor a result.

The gateway's `Decision:` message-prefix parser is retired. Such text is
ordinary chat and does not automatically produce a draft. Human-proposed
decisions are distinct from memory-derived drafts: the gateway-owned
facilitator port remains the only path for drafts derived from persisted room
events. No automatic prefix implementation is active. A later approved
memory-engine implementation may occupy that port, but may not run beside a
second independent derived-draft proposer or activate context itself.

Deleting a decision physically removes only its current decision row. The
gateway atomically retains the immutable `decision.deleted` audit event and
request-ledger record; it never deletes room history. Only a human may delete
or transition decisions, and only human-approved active decisions are
normative room context. Room-scoped memory and provenance remain governed by
decision 005.

This decision supersedes **only** decision 005's requirements that the
deterministic `Decision:` parser remain live and serve as the regression proof
until a Cognee switch. It does not supersede its room partition, facilitator
port, derived-memory, or human-approval boundaries. Historical MVP and
memory-engine plans that name the parser describe their former baseline; any
future facilitator activation must be planned against this decision.

## Consequences

- Contracts, gateway, workspace UI, and memory-engine active What/How specs
  must describe this boundary; historical plans may retain their original
  steps only with a clear supersession note.
- The gateway's accepted local slash-decisions decision must identify the
  overridden parser rule and this replacement rule explicitly.
- The retained room-v1 wire identity and existing immutable events remain
  unchanged. No new protocol major version or automatic agent authority is
  introduced.

## Alternatives considered

- Restore the prefix parser beside `/decisions`. Rejected: duplicate draft
  creation paths would contradict the current tested behavior and blur
  provenance and human intent.
- Remove the facilitator port entirely. Rejected: room-scoped derived memory
  still needs a mediated, propose-only path under decision 005.
