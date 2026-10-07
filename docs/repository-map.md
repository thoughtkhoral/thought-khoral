# ThoughtKhoral repository map

ThoughtKhoral is organized as independently versioned repositories. The
catalog in [`project-catalog.yaml`](project-catalog.yaml) is the metadata source
for this map; repository status changes must be made through an issue and
reviewed with the relevant specification update.

## Product and governance

| Repository | Purpose | Status | Maturity |
| --- | --- | --- | --- |
| [`thought-khoral`](https://github.com/thoughtkhoral/thought-khoral) | Architecture, specifications, roadmap, and cross-project release coordination. | `active-development` | active |

## MVP components

| Repository | Purpose | Status | Maturity |
| --- | --- | --- | --- |
| [`thought-khoral-contracts`](https://github.com/thoughtkhoral/thought-khoral-contracts) | Versioned JSON Schema, protocol documentation, and compatibility fixtures. | `mvp` | active |
| [`thought-khoral-room-gateway`](https://github.com/thoughtkhoral/thought-khoral-room-gateway) | Authenticated WebSocket room service and governed event boundary. | `mvp` | active |
| [`thought-khoral-workspace-ui`](https://github.com/thoughtkhoral/thought-khoral-workspace-ui) | Browser workspace, chat stream, memory drawer, and decision controls. | `mvp` | active |
| [`thought-khoral-platform`](https://github.com/thoughtkhoral/thought-khoral-platform) | Local rootless deployment and Kubernetes-manifest validation. | `mvp` | active |

## Incubating integrations

| Repository | Purpose | Status | Maturity |
| --- | --- | --- | --- |
| [`thought-khoral-memory-engine`](https://github.com/thoughtkhoral/thought-khoral-memory-engine) | Room-scoped ingestion and provenance proof; Cognee and durable storage deferred. | `active-development` | incubating |
| [`thought-khoral-agent-gateway`](https://github.com/thoughtkhoral/thought-khoral-agent-gateway) | Mediated local deterministic A2A reference-agent integration; remote admission and MCP deferred. | `active-development` | incubating |
| [`thought-khoral-codex-agent`](https://github.com/thoughtkhoral/thought-khoral-codex-agent) | Provider-free Codex POC and reviewed room-integration candidates pushed to the owning repositories' `main` branches; release, packaged-stack, and live-verification gates remain. | `active-development` | incubating |

## Dependency direction

The contracts repository is the compatibility authority. The room gateway and
agent gateway pin contract artifacts; the UI implements the retained v1 room
interface. See the [compatibility matrix](compatibility-matrix.md) for the
current revision and boundary. The platform builds checked-out or pinned room
gateway, memory engine, agent gateway, and UI sources, then composes those with
the reference agent for local integration. The memory engine remains
separately task-gated and Compose-only; neither incubating integration grants
remote-agent or production authority.

The independently versioned Codex agent establishes an agent implementation
boundary for future bring-your-own-agent support. Its foundation includes
specification-driven documentation and Apache 2.0 licensing. The provider-free worker and reviewed contracts, broker, mediator, UI, and
opt-in platform integration have been pushed to their owning repositories'
GitHub `main` branches for POC development. This is experimental code, not a
production-readiness claim: the v1.1 defaults artifact has no release or tag,
and packaged-stack and separately authorized live verification remain pending.
See the [coordinated implementation plan](../.ai/specs/how/codex-room-conversations-implementation-plan.md)
for exact pushed integration commits and evidence.

## Where to contribute

Start with an issue in the repository that owns the behavior. The organization
[contribution guide](https://github.com/thoughtkhoral/.github/blob/main/CONTRIBUTING.md)
describes issue triage, specification approval, implementation, and supporting
documentation updates.
