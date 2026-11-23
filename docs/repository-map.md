# ThoughtKhoral repository map

ThoughtKhoral is organized as independently versioned repositories. The
catalog in [`project-catalog.yaml`](project-catalog.yaml) is the metadata source
for this map; repository status changes must be made through an issue and
reviewed with the relevant specification update.

## Product and governance

| Repository | Purpose | Status | Maturity |
| --- | --- | --- | --- |
| [`thought-khoral`](https://github.com/thoughtkhoral/thought-khoral) | Cross-project architecture, specifications, roadmap, and release coordination. | `active-development` | active |

## MVP components

| Repository | Purpose | Status | Maturity |
| --- | --- | --- | --- |
| [`thought-khoral-contracts`](https://github.com/thoughtkhoral/thought-khoral-contracts) | Versioned JSON Schema, room protocol documentation, and compatibility fixtures. | `mvp` | active |
| [`thought-khoral-room-gateway`](https://github.com/thoughtkhoral/thought-khoral-room-gateway) | Authenticated WebSocket room service, event persistence, replay, and authorization. | `mvp` | active |
| [`thought-khoral-workspace-ui`](https://github.com/thoughtkhoral/thought-khoral-workspace-ui) | React collaborative room UI, chat stream, memory drawer, and decision controls. | `mvp` | active |
| [`thought-khoral-platform`](https://github.com/thoughtkhoral/thought-khoral-platform) | Rootless local composition, development identity, and Kubernetes validation. | `mvp` | active |

## Incubating integrations

| Repository | Purpose | Status | Maturity |
| --- | --- | --- | --- |
| [`thought-khoral-memory-engine`](https://github.com/thoughtkhoral/thought-khoral-memory-engine) | Room-scoped POC collective memory, provenance, and temporal lineage. | `active-development` | incubating |
| [`thought-khoral-agent-gateway`](https://github.com/thoughtkhoral/thought-khoral-agent-gateway) | Mediated local A2A reference-agent foundation; remote admission and MCP deferred. | `active-development` | incubating |
| [`thought-khoral-codex-agent`](https://github.com/thoughtkhoral/thought-khoral-codex-agent) | Independent experimental Codex worker with native package evidence and integrated released consumers/profile; packaged-stack, browser, live-provider and production gates remain open. | `active-development` | incubating |

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
production-readiness claim. The v1.1 defaults artifact was published and its
downloaded assets verified on 2026-11-20. Release tooling, released broker/UI
consumers and the packaged profile were integrated and pushed on 2026-11-23;
package/environment/operator preflight is in progress. Packaged-stack and
separately authorized live verification remain pending.
The 2026-11-19 maintenance changes are published. Native AMD64/ARM64 worker tests
passed on Rust 1.85.0/1.93.1; both Rust 1.93.1-built package-policy captures passed.
This evidence leaves lifecycle/maturity values unchanged and does not close the
full Codex room-stack/browser/live gates.
See the [coordinated implementation plan](../.ai/specs/how/codex-room-conversations-implementation-plan.md)
for exact pushed integration commits and evidence.

## Where to contribute

Start with an issue in the repository that owns the behavior. The organization
[contribution guide](https://github.com/thoughtkhoral/.github/blob/main/CONTRIBUTING.md)
describes issue triage, specification approval, implementation, and supporting
documentation updates.
