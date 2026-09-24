# ThoughtKhoral compatibility matrix

This matrix records the implemented local development interfaces as of
2026-09-24. The [contracts repository](https://github.com/thoughtkhoral/thought-khoral-contracts)
owns the normative schemas and protocol rules. Component releases and their
contract locks remain the authority for a particular build.

| Component | Room contract relationship | Local integration boundary |
| --- | --- | --- |
| Contracts | Publishes the retained `n2n.room.v1` JSON Schemas, protocol, and compatibility fixtures. | Contract artifacts only; no runtime library. |
| Room gateway | Vendors the retained v1 schemas at the commit recorded in [`contracts/lock.json`](https://github.com/thoughtkhoral/thought-khoral-room-gateway/blob/main/contracts/lock.json). | Authenticated browser WebSocket and a separate internal task service. |
| Workspace UI | Sends and projects retained v1 room requests and events. | Uses the platform's OIDC and WebSocket adapters; it does not validate room authority. |
| Agent gateway | Pins the same contract source revision in its [`contracts/lock.json`](https://github.com/thoughtkhoral/thought-khoral-agent-gateway/blob/main/contracts/lock.json). | Uses authenticated internal task calls and one pinned local A2A reference agent. |
| Memory engine | Receives committed room events through private authenticated ingestion. | Compose-only ingestion proof; no direct room database access or active facilitator switch. |
| Platform | Builds the four source components from sibling checkouts or immutable refs. | Composes eight local services; the memory proof has no Kubernetes workload yet. |

The gateway and agent gateway currently pin contracts commit
`1a44b6cfc19a4f5e668afb1ddb5241b2a0f1f72d`. A later contract commit is
not automatically adopted by either consumer. The UI's retained-v1 constant
does not constitute a schema-artifact pin; compatibility must be checked when
its request or event handling changes. See the [room protocol](https://github.com/thoughtkhoral/thought-khoral-contracts/blob/main/protocol.md)
and each component's local specification index before updating an interface.

Remote A2A/MCP admission, Cognee-backed memory, durable memory storage, and
production deployment have no compatibility claim in this matrix.
