# Codex room conversations: cross-project status

**Status as of 2026-10-07: experimental POC.** The provider-free worker and
reviewed room-integration changes are pushed to the owning repositories'
`main` branches. Packaged-stack and separately authorized live verification are
still open. This guide describes the coordinated milestone across the parent
repository and all seven direct-child projects; it is derived from their
approved specifications and coordinated implementation plan, which remain the
source of truth.

## Goal and boundary

Let a human explicitly address Codex in a ThoughtKhoral room. Codex uses
authorized room-wide conversation history, including relevant discussion that
happened while it was not responding. Authorized humans share the Codex thread
and can explicitly start a fresh thread without deleting the room transcript.
The independent Codex worker runs through the agent gateway and never connects
to room storage directly.

Milestone one is history-aware room participation. Directory-based
specification guidance and memory retrieval or writes are a separate future
milestone; they are not enabled by the current integration.

## Project responsibilities and current state

| Project | Responsibility | Current state |
| --- | --- | --- |
| [ThoughtKhoral root](https://github.com/thoughtkhoral/thought-khoral) | Product scope, cross-project contracts, decisions, and coordinated execution | Approved Codex What/How and implementation plan govern the milestone; Task 9 and aggregate acceptance remain open. |
| [Contracts](https://github.com/thoughtkhoral/thought-khoral-contracts) | Versioned conversation schemas and compatibility fixtures | Published v1.0.0 is unchanged. The additive v1.1 defaults candidate is on `main` but has no release or tag. |
| [Codex agent](https://github.com/thoughtkhoral/thought-khoral-codex-agent) | Independent provider-facing worker and native Codex session adapter | Provider-free app-server adapter, durable receipts, authenticated transport, and native thread/session handling are implemented. Provider credentials and room storage remain outside the worker. |
| [Room gateway](https://github.com/thoughtkhoral/thought-khoral-room-gateway) | Room authority, conversation reservation, authorized history, and persistence | Room-scoped conversation storage and reservation, bounded authorized history, lifecycle projections, and mediated defaults discovery are implemented. |
| [Agent gateway](https://github.com/thoughtkhoral/thought-khoral-agent-gateway) | Admission and mediation between the broker and Codex worker | Pinned Codex catalog, receipt, and normalized conversation mediation are implemented; Codex remains opt-in. |
| [Workspace UI](https://github.com/thoughtkhoral/thought-khoral-workspace-ui) | Human selection, shared session controls, settings, and context status | Explicit Codex targeting, shared continue/reset controls, model/effort settings, and context-usage status are implemented. |
| [Platform](https://github.com/thoughtkhoral/thought-khoral-platform) | Local service packaging and restricted provider egress | Opt-in local packaging and egress controls are implemented; packaged-stack acceptance remains open. |
| [Memory engine](https://github.com/thoughtkhoral/thought-khoral-memory-engine) | Separate room-scoped memory proof | Incubating graph and private mediated-ingestion proof only. It is not integrated into Codex milestone one; durable storage and Cognee remain deferred. |

## Evidence and limits

Component suites and the synthetic composed checkpoint are recorded by exact
source and integration revisions in the [coordinated implementation plan](../.ai/specs/how/codex-room-conversations-implementation-plan.md).
Provider-free checks cover history disclosure, durable recovery boundaries,
conversation lifecycle, settings behavior, and synthetic worker turns. They do
not establish a live provider conversation, real browser/Keycloak behavior,
packaged deployment, or production readiness. The v1.0.0 contract artifact is
unchanged; the v1.1 candidate is unpublished.

## Remaining milestone-one work

The provider-free history, recovery, and synthetic integration checks are
recorded complete. Task 9 and milestone acceptance still require:

- A separately authorized live multi-human check: an intervening room fact,
  worker restart and continuation on the same thread, then an explicit fresh
  session with the authorized room baseline.
- Live model/effort changes, restored settings, denied-model behavior, and
  context telemetry against the configured runtime.
- Packaged-stack acceptance and live tool/egress isolation checks, followed by
  the final cross-project evidence and release review.
- Portability evidence for Linux x86_64 native tool-policy capture/admission
  and execution on the specified Rust 1.85 minimum.

The POC must not be described as having live-provider, full-stack, or
production-readiness evidence until the relevant gates are recorded. Task-level
criteria and evidence are maintained in the coordinated plan.

## Later specification- and memory-guided workspace

The Codex repository's [guided-workspace What](https://github.com/thoughtkhoral/thought-khoral-codex-agent/blob/main/.ai/specs/what/guided-workspace.md)
is a draft future direction, not an implementation task. It proposes reviewed,
immutable guidance bundles, visible revisions, and a fresh native thread when
guidance changes. Before implementation, the projects need an approved bundle
format and publication/review process, provenance and retention rules, an
instruction-loading design for the pinned Codex version, and a separately
governed interface with the memory engine. Automatic memory writes and
arbitrary host paths remain outside the approved milestone-one scope.

## Governing references

- [Root specification index](../.ai/specs/README.md)
- [Codex conversation requirements](../.ai/specs/what/codex-chat-agent.md)
- [Codex runtime design](../.ai/specs/how/codex-chat-agent.md)
- [Codex coordinated implementation plan and evidence](../.ai/specs/how/codex-room-conversations-implementation-plan.md)
- [Codex component status](https://github.com/thoughtkhoral/thought-khoral-codex-agent/blob/main/docs/project-status.md)
