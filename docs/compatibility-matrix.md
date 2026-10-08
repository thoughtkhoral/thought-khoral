# ThoughtKhoral compatibility matrix

This matrix records the local interface boundaries as of 2026-10-07. The
[contracts repository](https://github.com/thoughtkhoral/thought-khoral-contracts)
owns the normative room schemas and the separate Codex conversation profile.
Component releases and their contract locks remain the authority for a
particular build.

| Component | Contract relationship | Local integration boundary |
| --- | --- | --- |
| Contracts | Publishes the retained `n2n.room.v1` JSON Schemas, protocol, and compatibility fixtures. | Contract artifacts only; no runtime library. |
| Room gateway | Retains the published room contract and pins conversation profile v1.0.0. The unreleased v1.1 defaults candidate is pinned separately for provider-free development. | Authenticated room WebSocket, task APIs, and separate /api/agent-conversations/v1 routes; room authority and persistence stay here. |
| Workspace UI | Retains the room v1 interface and vendors the published conversation profile; its defaults candidate pin remains explicitly unreleased. | Uses OIDC and WebSocket adapters; Codex controls require explicit host admission and do not own authorization. |
| Agent gateway | Retains its room-task contract pin and consumes published conversation profile v1.0.0. | Mediates the pinned reference agent and opt-in Codex worker; it has no direct room database access. |
| Codex agent | Pins the published conversation profile and uses a private authenticated worker transport. | Owns the provider-facing app-server adapter and native thread/session state; it does not connect to room storage. |
| Memory engine | Uses private authenticated ingestion rather than a browser room-protocol implementation. | Receives committed room events through the gateway; it remains separate from Codex milestone one. |
| Platform | Composes the pinned room, agent, and browser interfaces; Codex packaging is opt-in. | Local rootless Compose and Kubernetes-manifest validation; no production deployment claim. |

The contracts repository also owns the separate versioned Codex conversation
profile. Its v1.0.0 artifact is published and unchanged; the additive v1.1
defaults candidate is unreleased.

The room gateway and agent gateway continue to pin retained room-contract
commit 1a44b6cfc19a4f5e668afb1ddb5241b2a0f1f72d. Updating that artifact is a
separate compatibility decision. The UI's retained-v1 constant does not replace
the contract artifact pin.

The conversation API uses the separate `/api/agent-conversations/v1` namespace.
The published v1.0.0 profile and archive are unchanged. The additive v1.1
defaults-discovery candidate, including `ResolvedSettingsView`, is present on
the contracts `main` branch but has no release or tag. Broker and UI candidate
pins support only the approved provider-free synthetic integration; they do
not establish released interoperability. See the
[cross-project Codex status guide](codex-conversation-status.md) and the
[conversation plan](../.ai/specs/how/codex-room-conversations-implementation-plan.md)
for exact gates and evidence.

Remote third-party A2A/MCP admission, Cognee-backed memory, durable memory
storage, and production deployment have no compatibility claim in this matrix.
Live-provider and packaged-stack verification for the Codex POC remain open.
