# ThoughtKhoral

ThoughtKhoral is a human-to-agent collaborative workspace in which people and
role-specific agents deliberate together while humans retain authority over
room context and decisions.

This repository is the cross-project governance and documentation home for the
ThoughtKhoral organization. Runtime components are maintained in independently
versioned repositories.

## Start here

- [Current workspace status and exact source checkouts](docs/workspace-status.md)
- [Completed database maintenance](docs/task9-database-upgrade-2026-11-25.md)
- [Corrected startup subchecks and open stability gate](docs/task9-corrected-startup-2026-11-25.md)
- [Next bounded observation-window review](.ai/specs/how/task9-readiness-window-renewal-2026-11-25.md)
- [Latest local firewall correction and verification](docs/task9-loopback-health-2026-11-24.md)
- [Approved local runtime compatibility correction](docs/task9-runtime-compatibility-2026-11-23.md)
- [Earlier activation failure and remaining acceptance](docs/task9-activation-2026-11-23.md)
- [Integrated sources, built images and operator preflight](docs/task9-integration-preflight-2026-11-23.md)
- [Workspace documentation requirements](.ai/specs/what/open-source-documentation.md)
- [Individual project documentation and source contracts](docs/workspace-status.md#project-documentation)
- [Released consumers and packaged-profile preparation](docs/task9-packaged-profile-preparation-2026-11-20.md)
- [Project overview](docs/project-overview.md)
- [Codex room conversations: cross-project status](docs/codex-conversation-status.md)
- [Historical resumption checks and corrections: 2026-11-19](docs/resumption-status-2026-11-19.md)
- [Usage examples](docs/usage-examples.md)
- [Architecture: current and possible future boundaries](docs/architecture.md)
- [Repository map](docs/repository-map.md)
- [Compatibility matrix](docs/compatibility-matrix.md)
- [Capability roadmap](docs/roadmap.md)
- [Project specifications](.ai/specs/README.md)
- [Maintenance specification audit and change traceability](.ai/specs/how/spec-driven-maintenance-audit-2026-11-19.md)
- [Contribution workflow](https://github.com/thoughtkhoral/.github/blob/main/CONTRIBUTING.md)
- [Contracts and protocol](https://github.com/thoughtkhoral/thought-khoral-contracts)
- [Local MVP platform](https://github.com/thoughtkhoral/thought-khoral-platform)

The current MVP proves an authenticated governed room, real-time room events,
known-participant `@` mentions with room-wide or targeted delivery, and a human
`/decisions` workflow for governed creation, editing, confirmation, dismissal,
and audited deletion. The facilitator port remains available for later derived
drafts but no longer parses `Decision:` chat prefixes. An incubating
memory-engine proof and a locally controlled deterministic A2A reference
integration are also in development.

A separate, experimental Codex conversation POC spans the contracts, room
gateway, agent gateway, worker, UI, and opt-in platform packaging. Its
provider-free worker, synthetic integration and native AMD64/ARM64 worker
runtime/package-policy evidence are recorded. Full Codex packaged room-stack,
rendered-browser and separately authorized live-provider verification remain
open. See the [cross-project status guide](docs/codex-conversation-status.md).

Conversation v1.1.0 is published. Its release tooling, released-defaults broker/UI
consumers and exact packaged acceptance profile are integrated and pushed to
their canonical mains. Nine production images are built; private operator
configuration now reuses existing shell Codex authentication and passes actual
state/credential/Compose preflight. Authorized startup then exposed adapter,
packaging and database-readiness blockers. Seven services remain running and the
UI is reachable; Codex is disabled. No model turn was requested. The
[activation report](docs/task9-activation-2026-11-23.md) records the failed P1 gate
and compatibility correction subsequently approved for local implementation.
The [correction report](docs/task9-runtime-compatibility-2026-11-23.md) tracks
isolated fixes and package evidence. The separately approved
[database maintenance](docs/task9-database-upgrade-2026-11-25.md) is now complete,
with data and permissions preserved. Subsequent corrected startup and
authenticated catalog/default checks passed with provider access blocked. The
[latest report](docs/task9-corrected-startup-2026-11-25.md) keeps the timed stability
gate open; Codex and mediator are off and seven base services are healthy.
The [workspace guide](docs/workspace-status.md) distinguishes current
integration commits from frozen acceptance inputs and remaining gates.

## Specification-first project

Accepted issues become the input to maintainer-authored specification changes.
Implementation and supporting documentation follow the approved specifications;
see the [specification index](.ai/specs/README.md) and the organization
[contribution policy](https://github.com/thoughtkhoral/.github/blob/main/CONTRIBUTING.md).
