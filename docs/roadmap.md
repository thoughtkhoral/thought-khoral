# ThoughtKhoral capability roadmap

This is a status view as of 2026-11-25, not a dated release commitment. The
[root specifications](../.ai/specs/README.md) and accepted decisions govern
scope; the [repository map](repository-map.md) identifies each component owner.

| Capability | Current state | Next gate |
| --- | --- | --- |
| Governed room MVP | Authenticated rooms, ordered event replay, mention-aware delivery, human `/decisions` workflow, and audited decision deletion are implemented. | Verify cross-component releases against the retained room contract. |
| Local agent tasks | In-process Action Items Agent and one deterministic A2A reference agent with two skills are implemented. | Keep task context, citations, credentials, and egress within the approved local boundary. |
| Codex room conversations | Experimental history-aware worker and room integration are implemented. Conversation v1.1 defaults, released consumers and the original packaged profile are published. Worker/platform corrections are integrated and pushed at `423d4e8`/`60ec83c`; immutable profiles/images retain their exact source identities. The existing database upgrade and 662.743-second provider-isolated readiness check passed. Codex/mediator are off after that check. | Observe actual CI in the [source publication record](task9-compatibility-integration-2026-11-25.md), then complete rendered-browser and separately approved provider/live acceptance. Task 9, registry-image and production acceptance remain open. See the [status guide](codex-conversation-status.md). |
| Room-scoped memory | Incubating in-memory graph/provenance and private mediated-ingestion proof are implemented; Codex does not use this proof. | Keep durable storage, Cognee, and any facilitator activation separately designed and approved. |
| External agents and MCP | Remote admission and MCP transport are deferred. | Approve admission, isolation, trust, and contract specifications before implementation. |
| Platform | Local rootless Compose and Kubernetes manifest validation are implemented; Codex packaging is opt-in. | Complete the Codex packaged-stack gate; define other production workload identity, networking, storage, and deployment requirements separately. |

The former `Decision:` chat-prefix facilitator is retired. A memory-derived
draft implementation may later occupy the gateway-owned facilitator port;
human approval remains the only way to activate normative room context.
Specification- and memory-guided Codex working directories are also a separate
future milestone, not current runtime behavior.
