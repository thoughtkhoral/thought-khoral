# ThoughtKhoral specification index

This directory is the source of truth for the ThoughtKhoral human-to-agent collaborative workspace.

## Structure

- `what/` defines product intent, scope, outcomes, and acceptance criteria.
- `how/` defines approved technical designs and implementation constraints.
- `decisions/` records durable architectural and governance decisions, including permitted child-project overrides.

## Spec-first rule

Before any code is created or modified, the applicable specification must be updated and approved. The required order is: decision record (when needed), What specification, How specification, contract change, implementation, then tests and supporting documentation.

Every direct-child project is independently versioned and must contain its own `.ai/specs/what`, `.ai/specs/how`, and `.ai/specs/decisions` directories. Child specifications inherit root requirements unless an approved local decision explicitly records an override.

The six independent direct-child repositories are `thought-khoral-contracts`, `thought-khoral-room-gateway`, `thought-khoral-workspace-ui`, `thought-khoral-memory-engine`, `thought-khoral-agent-gateway`, and `thought-khoral-platform`. The memory engine POC What and How for room-scoped Cognee memory are approved; it and the agent gateway remain specification-only until separately approved implementation plans authorize runtime code.

The identity migration preserves the `n2n.room.v1` wire value and excludes
database identifiers, database contents, and persisted values.

## ThoughtKhoral identity release gate

Run `bash scripts/verify-thoughtkhoral-identity.sh` from the workspace root
after cross-project changes. The gate scans ignored child repositories as well
as root files and rejects every legacy display or machine-name occurrence that
is not one of these exact compatibility or migration contexts:

- `n2n.room.v1` and its schema identifiers in contract schemas, fixtures,
  protocol documentation, pinned gateway archives, and runtime consumers;
- immutable `n2n-room-v1.*` release tags and the old-to-new identifiers in the
  approved ThoughtKhoral migration records;
- the existing PostgreSQL database and role `n2n`, physical volume
  `n2n_postgres-data`, development-only persisted credential values
  `n2n-dev-only` and `n2n-admin-dev-only`, and OIDC claim `n2n_role`; and
- database tables, persisted records, event fields, and persisted values that
  the approved migration explicitly excludes from this rename.

Each exception combines an enumerated file with an exact schema field,
configuration key/value, source-code use, migration assertion, or documented
compatibility statement. A compatibility token by itself is not sufficient.
The scan fails closed when its scanner is unavailable or returns an error. It
does not permit a whole project, source tree, documentation tree, validator
script, or deployment path.

## Current root specifications

- [What: solution architecture](what/n2n-solution-architecture.md)
- [What: ThoughtKhoral product identity](what/thoughtkhoral-product-identity.md)
- [What: open-source organization documentation](what/open-source-documentation.md)
- [How: agent spec-authoring roadmap](how/spec-authoring-roadmap.md)
- [How: ThoughtKhoral MVP foundation implementation plan](how/n2n-mvp-foundation-implementation-plan.md)
- [How: GitHub organization publication](how/github-organization-publication.md)
- [How: ThoughtKhoral identity migration](how/thoughtkhoral-identity-migration.md)
- [Decision: workspace governance](decisions/001-workspace-governance.md)
- [Decision: ThoughtKhoral product identity](decisions/003-thoughtkhoral-product-identity.md)
- [Decision: issue-first contribution and change management](decisions/004-contribution-and-change-management.md)
- [Decision: room-scoped POC memory](decisions/005-room-scoped-poc-memory.md)
