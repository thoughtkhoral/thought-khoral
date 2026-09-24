# ThoughtKhoral repository map

ThoughtKhoral is organized as independently versioned repositories. The
catalog in [`project-catalog.yaml`](project-catalog.yaml) is the metadata source
for this map; repository status changes must be made through an issue and
reviewed with the relevant specification update.

## Product and governance

| Repository | Purpose | Status |
| --- | --- | --- |
| [`thought-khoral`](https://github.com/thoughtkhoral/thought-khoral) | Architecture, specifications, roadmap, and cross-project release coordination. | Active development |

## MVP components

| Repository | Purpose | Status |
| --- | --- | --- |
| [`thought-khoral-contracts`](https://github.com/thoughtkhoral/thought-khoral-contracts) | Versioned JSON Schema, protocol documentation, and compatibility fixtures. | MVP / active |
| [`thought-khoral-room-gateway`](https://github.com/thoughtkhoral/thought-khoral-room-gateway) | Authenticated WebSocket room service and governed event boundary. | MVP / active |
| [`thought-khoral-workspace-ui`](https://github.com/thoughtkhoral/thought-khoral-workspace-ui) | Browser workspace, chat stream, memory drawer, and decision controls. | MVP / active |
| [`thought-khoral-platform`](https://github.com/thoughtkhoral/thought-khoral-platform) | Local rootless deployment and Kubernetes-manifest validation. | MVP / active |

## Incubating integrations

| Repository | Purpose | Status |
| --- | --- | --- |
| [`thought-khoral-memory-engine`](https://github.com/thoughtkhoral/thought-khoral-memory-engine) | Room-scoped ingestion and provenance proof; Cognee and durable storage deferred. | Active development / incubating |
| [`thought-khoral-agent-gateway`](https://github.com/thoughtkhoral/thought-khoral-agent-gateway) | Mediated local deterministic A2A reference-agent integration; remote admission and MCP deferred. | Active development / incubating |

## Dependency direction

The contracts repository is the compatibility authority. The gateway and UI
consume pinned contract artifacts. The platform composes checked-out or pinned
room-gateway, UI, and agent-gateway builds for local integration, alongside the
reference agent and Compose-only memory proof. The memory engine remains
separately task-gated; neither
incubating integration grants remote-agent or production authority.

## Where to contribute

Start with an issue in the repository that owns the behavior. The organization
[contribution guide](https://github.com/thoughtkhoral/.github/blob/main/CONTRIBUTING.md)
describes issue triage, specification approval, implementation, and supporting
documentation updates.
