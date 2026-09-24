# 005 — Room-scoped POC memory

## Status

Accepted

The requirement below to keep the deterministic `Decision:` parser live was
superseded by [decision 008](008-slash-decisions-and-facilitator-boundary.md).
The room scope, facilitator-port ownership, and human approval boundary remain
in force. The remaining parser references record this decision's original
baseline, not the current runtime.

## Context

The governed-room MVP treats a room as one conversation: one event log, one
chat stream, and one collective-memory ledger of human-activated decisions. The
deterministic `Decision:` facilitator proposes drafts; humans Confirm, Edit, or
Dismiss; only active decisions appear in collective memory.

A longer-term product shape may treat a room as a project that contains
multiple topic conversations, with separate project-level and topic-level
memory. The first Cognee integration must not invent that hierarchy, and must
not flatten memory in a way that makes the later split expensive.

The facilitator currently exists to prove that something may emit
`decision.proposed` and that nothing in that path may activate context. Its
body is a pure `Decision:` prefix parser. A memory system later needs the same
propose-only boundary.

## Decision

For the first collective-memory / Cognee capability, a room remains one
conversation. All derived facts, draft proposals, and activated memory are
scoped to that `roomId`.

A project-with-many-topic-conversations model, including distinct project-level
and topic-level memory, is an explicit non-goal of this POC. Introducing a
conversation identifier, a parent project identifier, or dual-scope memory
requires a later accepted decision and, if the wire contract must change, a
new approved contract version.

The existing human approval boundary is unchanged: only Confirm, Edit, or
Dismiss may make a draft active.

The facilitator is the room’s draft-proposal port. After a room event is
persisted, the gateway asks that port for zero or more drafts and records them
as `decision.proposed`. The port must not invoke `decision.transition`, call
unmediated tools, or write active context.

The current implementation of that port is the deterministic `Decision:`
parser. It remains the live implementation until a later approved
implementation plan switches or adds a memory-engine implementation behind the
same port. Cognee occupies that port; it does not sit beside it as a second
independent proposer, and it does not replace the port.

This decision supersedes the earlier sit-beside clause recorded in the first
draft of this document.

## Alternatives considered

- Specify project and topic memory in the first Cognee plan, and add nested
  conversations now. Rejected: the POC room path is not yet using Cognee, and
  the current `n2n.room.v1` contract has no conversation identifier.
- Replace the facilitator role with Cognee immediately. Rejected: that removes
  the propose-only port and couples the only draft path to an unproven
  extraction dependency inside or beside the gateway.
- Run Cognee as a second proposer beside `Decision:`. Rejected: two independent
  propose paths make provenance, failure isolation, and later memory backends
  harder without buying a governance benefit.
- Allow Cognee to write graph facts only, with no path to drafts. Rejected as
  the end state: the existing UI already governs drafts through decision cards.
  Graph-only work may precede a live Cognee facilitator implementation, but
  drafts from memory must enter through the facilitator port.

## Consequences

- `thought-khoral-memory-engine` What and How documents for this POC must
  partition derived memory by `roomId`, list project/topic memory as an
  exclusion, and treat the facilitator port as the only draft-creation path
  from room events.
- The retained `n2n.room.v1` methods, including `decision.propose` and
  `decision.transition`, stay sufficient for this pass. A conversation or
  project identifier is not added.
- Gateway facilitator tests for `Decision:` remain the proof of the port until
  a memory-engine implementation is approved.
- Later hierarchy work can introduce a parent scope around rooms without
  having to un-mix a global unpartitioned graph.
- Runtime Cognee integration still requires a dedicated How design,
  implementation plan, approval, and dependency license/compatibility evidence.

## Overrides

None.
