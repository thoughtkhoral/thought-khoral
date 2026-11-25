# ThoughtKhoral capability roadmap

This is a status view as of 2026-11-25, not a dated release commitment. The
[root specifications](../.ai/specs/README.md) and accepted decisions govern
scope; the [repository map](repository-map.md) identifies each component owner.

| Capability | Current state | Next gate |
| --- | --- | --- |
| Governed room MVP | Authenticated rooms, ordered event replay, mention-aware delivery, human `/decisions` workflow, and audited decision deletion are implemented. | Verify cross-component releases against the retained room contract. |
| Local agent tasks | In-process Action Items Agent and one deterministic A2A reference agent with two skills are implemented. | Keep task context, citations, credentials, and egress within the approved local boundary. |
| Codex room conversations | Experimental worker and synthetic integration support explicit targeting and authorized room history. Native AMD64/ARM64 tests passed on Rust 1.85.0/1.93.1; both Rust 1.93.1-built package captures passed. Profile v1.0.0 is unchanged; v1.1 defaults is published; released consumers/profile are integrated and pushed to main. Nine production images are built; operator preflight passes using existing cached shell authentication. Authorized startup partially failed: seven services remain running, Codex is disabled and the mediator is stopped. P1 failed; browser B1 is unavailable. | Local compatibility fixes and the new exact profile are verified. The approved [loopback correction](task9-loopback-health-2026-11-24.md) resolves the reproduced teardown defect. The separately approved [database upgrade](task9-database-upgrade-2026-11-25.md) is complete. Review the [corrected-stack startup procedure](../.ai/specs/how/task9-corrected-stack-startup-2026-11-25.md) without model calls. Publication and activation remain separately gated. Packaged-stack/browser/provider acceptance remains open; see the [activation report](task9-activation-2026-11-23.md). See the [status guide](codex-conversation-status.md). |
| Room-scoped memory | Incubating in-memory graph/provenance and private mediated-ingestion proof are implemented; Codex does not use this proof. | Keep durable storage, Cognee, and any facilitator activation separately designed and approved. |
| External agents and MCP | Remote admission and MCP transport are deferred. | Approve admission, isolation, trust, and contract specifications before implementation. |
| Platform | Local rootless Compose and Kubernetes manifest validation are implemented; Codex packaging is opt-in. | Complete the Codex packaged-stack gate; define other production workload identity, networking, storage, and deployment requirements separately. |

The former `Decision:` chat-prefix facilitator is retired. A memory-derived
draft implementation may later occupy the gateway-owned facilitator port;
human approval remains the only way to activate normative room context.
Specification- and memory-guided Codex working directories are also a separate
future milestone, not current runtime behavior.
