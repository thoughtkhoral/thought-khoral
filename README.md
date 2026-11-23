# ThoughtKhoral

ThoughtKhoral is a human-to-agent collaborative workspace in which people and
role-specific agents deliberate together while humans retain authority over
room context and decisions.

This repository is the cross-project governance and documentation home for the
ThoughtKhoral organization. Runtime components are maintained in independently
versioned repositories.

## Start here

- [Current workspace status and exact source checkouts](docs/workspace-status.md)
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
their canonical mains. Task C package/environment/operator preflight is in
progress. The [workspace guide](docs/workspace-status.md) distinguishes current
integration commits from frozen acceptance inputs and remaining gates.

## Specification-first project

Accepted issues become the input to maintainer-authored specification changes.
Implementation and supporting documentation follow the approved specifications;
see the [specification index](.ai/specs/README.md) and the organization
[contribution policy](https://github.com/thoughtkhoral/.github/blob/main/CONTRIBUTING.md).
