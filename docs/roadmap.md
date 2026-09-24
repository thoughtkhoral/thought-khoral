# ThoughtKhoral capability roadmap

This is a status view as of 2026-09-24, not a dated release commitment. The
[root specifications](../.ai/specs/README.md) and accepted decisions govern
scope; the [repository map](repository-map.md) identifies the owner of each
component.

| Capability | Current state | Next gate |
| --- | --- | --- |
| Governed room MVP | Authenticated room, ordered event replay, mention-aware delivery, human `/decisions` workflow, and audited decision deletion implemented. | Verify cross-component releases against the retained room contract. |
| Local agent tasks | In-process Action Items Agent and one deterministic A2A reference agent with two skills implemented. | Keep task context, citations, credentials, and egress within the approved local boundary. |
| Room-scoped memory | In-memory graph/provenance and private mediated ingestion proof implemented. | Evaluate Cognee integration and a separate facilitator-port activation plan. |
| External agents and MCP | Remote admission and MCP transport deferred. | Approve admission, isolation, trust, and contract specifications before implementation. |
| Production platform | Local rootless Compose and Kubernetes manifest validation implemented. | Define production workload identity, networking, storage, and deployment requirements separately. |

The former `Decision:` chat-prefix facilitator is retired. A memory-derived
draft implementation may later occupy the gateway-owned facilitator port;
human approval remains the only way to activate normative room context.
