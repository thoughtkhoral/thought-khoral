# N:N specification index

This directory is the source of truth for the N:N Human-to-Agent Collaborative Workspace.

## Structure

- `what/` defines product intent, scope, outcomes, and acceptance criteria.
- `how/` defines approved technical designs and implementation constraints.
- `decisions/` records durable architectural and governance decisions, including permitted child-project overrides.

## Spec-first rule

Before any code is created or modified, the applicable specification must be updated and approved. The required order is: decision record (when needed), What specification, How specification, contract change, implementation, then tests and supporting documentation.

Every direct-child project is independently versioned and must contain its own `.ai/specs/what`, `.ai/specs/how`, and `.ai/specs/decisions` directories. Child specifications inherit root requirements unless an approved local decision explicitly records an override.

## Current root specifications

- [What: solution architecture](what/n2n-solution-architecture.md)
- [What: ThoughtKhoral product identity](what/thoughtkhoral-product-identity.md)
- [How: agent spec-authoring roadmap](how/spec-authoring-roadmap.md)
- [How: N:N MVP foundation implementation plan](how/n2n-mvp-foundation-implementation-plan.md)
- [How: ThoughtKhoral identity migration](how/thoughtkhoral-identity-migration.md)
- [Decision: workspace governance](decisions/001-workspace-governance.md)
- [Decision: ThoughtKhoral product identity](decisions/003-thoughtkhoral-product-identity.md)
