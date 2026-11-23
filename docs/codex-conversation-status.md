# Codex room conversations: cross-project status

**Status as of 2026-11-23: experimental POC.** The provider-free worker and
reviewed room-integration changes are pushed to the owning repositories'
`main` branches. Packaged-stack and separately authorized live verification are
still open. This guide describes the coordinated milestone across the parent
repository and all seven direct-child projects; it is derived from their
approved specifications and coordinated implementation plan, which remain the
source of truth. The [current workspace guide](workspace-status.md) separates
canonical mains, the published v1.1 artifact and integrated consumer/profile
branches, including exact frozen source paths after integration HEADs advance.

The four release/consumer/profile branches are integrated and pushed to their
component mains. Task C package/environment/operator preflight is in progress;
the [integration procedure](../.ai/specs/how/task9-integration-2026-11-23.md)
records its scope. The frozen profile, contract tag and component source inputs
are unchanged. Earlier unmerged descriptions retain their historical meaning.

Native worker portability is verified: all four AMD64/ARM64 Rust 1.85.0/1.93.1
cells and both production-package/policy-capture jobs passed at `9bcdbde`.
The evidence-only `8d233e4` revision also passed all six jobs. This is worker
evidence; full Codex room-stack, rendered-browser and live-provider gates remain open.

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
| [Contracts](https://github.com/thoughtkhoral/thought-khoral-contracts) | Versioned conversation schemas and compatibility fixtures | Published v1.0.0 is unchanged. V1.1.0 is published and downloaded bytes verified; release tooling and released broker/UI consumers are integrated into main. |
| [Codex agent](https://github.com/thoughtkhoral/thought-khoral-codex-agent) | Independent provider-facing worker and native Codex session adapter | Adapter, durable receipts, authenticated transport and native history are implemented. Native Linux runtime/package-policy checks passed on AMD64/ARM64 at both supported compiler versions. Room storage stays outside the worker; provider credentials remain private to its operator/runtime. |
| [Room gateway](https://github.com/thoughtkhoral/thought-khoral-room-gateway) | Room authority, conversation reservation, authorized history, and persistence | Room-scoped conversation storage and reservation, bounded authorized history, lifecycle projections, and mediated defaults discovery are implemented. |
| [Agent gateway](https://github.com/thoughtkhoral/thought-khoral-agent-gateway) | Admission and mediation between the broker and Codex worker | Pinned Codex catalog, receipt, and normalized conversation mediation are implemented; Codex remains opt-in. |
| [Workspace UI](https://github.com/thoughtkhoral/thought-khoral-workspace-ui) | Human selection, shared session controls, settings, and context status | Explicit Codex targeting, shared continue/reset controls, model/effort settings, and context-usage status are implemented. |
| [Platform](https://github.com/thoughtkhoral/thought-khoral-platform) | Local service packaging and restricted provider egress | Opt-in packaging/egress and corrected source-copy inputs are published. The default deterministic stack passed its separately scoped smoke; full Codex packaged-stack acceptance remains open. |
| [Memory engine](https://github.com/thoughtkhoral/thought-khoral-memory-engine) | Separate room-scoped memory proof | Incubating graph and private mediated-ingestion proof only. It is not integrated into Codex milestone one; durable storage and Cognee remain deferred. |

## Evidence and limits

Component suites and the synthetic composed checkpoint are recorded by exact
source and integration revisions in the [coordinated implementation plan](../.ai/specs/how/codex-room-conversations-implementation-plan.md).
Provider-free checks cover history disclosure, durable recovery boundaries,
conversation lifecycle, settings behavior, and synthetic worker turns. They do
not establish a live provider conversation, real browser/Keycloak behavior,
packaged deployment, or production readiness. The v1.0.0 contract artifact is
unchanged. The [v1.1.0 contract release](https://github.com/thoughtkhoral/thought-khoral-contracts/releases/tag/thought-khoral-agent-conversation-v1.1.0)
is published at source `f1c8621`; fresh TAR/lock/sidecar downloads and all 156
payload hashes match the reviewed inputs. Canonical broker/UI now use released-v1.1
imports; historical candidate and v1.0 vendors remain unchanged.
Component verification does not establish assembled-stack interoperability.

The [approved native-worker How](https://github.com/thoughtkhoral/thought-khoral-codex-agent/blob/main/.ai/specs/how/linux-worker-acceptance.md)
and [retained evidence](https://github.com/thoughtkhoral/thought-khoral-codex-agent/blob/main/docs/evidence/linux-worker-acceptance-44599536091.json)
record clean source/final-lock identities, 46 tests per native compiler cell,
both immutable package builds and exact CLI proofs (44 model/effort cases across
eight models, resume and six unsolicited-tool refusals per architecture).
Both cleanup reports show zero owned containers remaining. Synthetic loopback
capture performs no provider inference. The [resumption report](resumption-status-2026-11-19.md)
distinguishes this evidence from historical emulated builds, default-stack smoke
and the still-open full Codex room-stack/browser/live checks.

## Remaining milestone-one work

Local preparation on 2026-11-20 completed reviewed released-v1.1 broker/UI
consumers and an exact packaged acceptance profile. The
[preparation report](task9-packaged-profile-preparation-2026-11-20.md) records
160 broker tests, 193 UI tests, 46 profile/guard tests and actual provider-free
worker package/capture/preflight evidence. These branches were subsequently
integrated and pushed on 2026-11-23; historical fixture pins and frozen acceptance
inputs remain unchanged.
The assembled packaged stack, real browser and live-provider gates remain open.

The [2026-11-20 approved acceptance procedure](../.ai/specs/how/task9-packaged-acceptance-2026-11-20.md)
turns the remaining gates into an ordered review/run checklist. It identifies
the current source baseline, the v1.1 release/consumer prerequisite and the
historical live runner's older pins. Local implementation is authorized;
no packaged/browser/live gate is closed by that approval.

The provider-free history, recovery, and synthetic integration checks are
recorded complete. Task 9 and milestone acceptance still require:

- A separately authorized live multi-human check: an intervening room fact,
  worker restart and continuation on the same thread, then an explicit fresh
  session with the authorized room baseline.
- Live model/effort changes, restored settings, denied-model behavior, and
  context telemetry against the configured runtime.
- Packaged-stack acceptance and live tool/egress isolation checks, followed by
  the final cross-project evidence and release review.

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
