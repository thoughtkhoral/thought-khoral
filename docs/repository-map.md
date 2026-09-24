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

## Dependency direction

The contracts repository is the compatibility authority. The room gateway and
agent gateway pin contract artifacts; the UI implements the retained v1 room
interface. See the [compatibility matrix](compatibility-matrix.md) for the
current revision and boundary. The platform builds checked-out or pinned room
gateway, memory engine, agent gateway, and UI sources, then composes those with
the reference agent for local integration. The memory engine remains
separately task-gated and Compose-only; neither incubating integration grants
remote-agent or production authority.

## Where to contribute

Start with an issue in the repository that owns the behavior. The organization
[contribution guide](https://github.com/thoughtkhoral/.github/blob/main/CONTRIBUTING.md)
describes issue triage, specification approval, implementation, and supporting
documentation updates.
