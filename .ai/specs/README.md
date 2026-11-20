# ThoughtKhoral specification index

This directory is the source of truth for the ThoughtKhoral human-to-agent collaborative workspace.

## Structure

- `what/` defines product intent, scope, outcomes, and acceptance criteria.
- `how/` defines approved technical designs and implementation constraints.
- `decisions/` records durable architectural and governance decisions, including permitted child-project overrides.

## Spec-first rule

Before any code is created or modified, the applicable specification must be updated and approved. The required order is: decision record (when needed), What specification, How specification, contract change, implementation, then tests and supporting documentation.

Every direct-child project is independently versioned and must contain its own `.ai/specs/what`, `.ai/specs/how`, and `.ai/specs/decisions` directories. Child specifications inherit root requirements unless an approved local decision explicitly records an override.

The seven independent direct-child repositories are `thought-khoral-contracts`, `thought-khoral-room-gateway`, `thought-khoral-workspace-ui`, `thought-khoral-memory-engine`, `thought-khoral-agent-gateway`, `thought-khoral-platform`, and `thought-khoral-codex-agent`. The memory engine has an approved, task-gated room-scoped POC implementation plan and an incubating ingestion proof; Cognee integration remains deferred. The agent gateway has a local deterministic A2A reference implementation under Decision 007 and its implementation plan; remote admission and production deployment remain deferred. Neither project is specification-only.

For the current Codex conversation goal, project ownership, evidence limits, remaining milestone-one gates, and later guidance/memory scope, see the [cross-project status guide](../../docs/codex-conversation-status.md). It is derived context; root and child specifications remain authoritative.

The Codex agent has an approved repository foundation and milestone-one runtime
specifications. Its provider-free Task 4 adapter and Task 5 durable worker/package,
along with reviewed contracts, broker, mediator, UI, and opt-in platform candidates,
were pushed to their owning GitHub `main` branches under user authorization on
2026-10-07. These are experimental POC commits. The additive v1.1 defaults
artifact was subsequently published on 2026-11-20 from verified source
`f1c8621`; consumer released-provenance transition remains pending.
Packaged-stack and separately authorized live verification remain pending.
Exact pushed integration commits are listed in the coordinated plan.

Historical native verification checkpoint — 2026-11-19: the approved worker maintenance
and native Linux acceptance changes are published. Four native AMD64/ARM64
Rust 1.85.0/1.93.1 cells and both final-lock package/policy-capture jobs passed.
The [coordinated plan](how/codex-room-conversations-implementation-plan.md)
records exact source, runs and retained evidence. This closes worker-native
portability gates only; Task 9 packaged room-stack, rendered-browser, live-provider,
v1.1 contract publication and production/release acceptance remain open.

Latest contract checkpoint — 2026-11-20: v1.1 publication is now complete under
explicit maintainer authorization. Fresh downloaded assets and all 156 payload
hashes match the reviewed source; the coordinated plan retains the exact tag,
source, archive and lock identities. This supersedes the older open-publication
status above. Consumer transition, current packaged/browser/live and production
gates remain open.

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

The conversation contract additionally enumerates
`thought-khoral-contracts/fixtures/agent-conversation-v1/valid/ordinary-human-message.json`
and `ordinary-codex-message.json` in that same directory. Only their exact
retained `contractVersion` line is a compatibility exception; other fields and
neighboring profile files remain subject to the identity gate. The verified
room-gateway consumer pin additionally enumerates only those two filenames in
`thought-khoral-room-gateway/contracts/agent-conversation-v1/fixtures/valid/`,
with the same exact retained field exception. The independent worker pin adds
only those same two filenames under
`thought-khoral-codex-agent/contracts/agent-conversation-v1/fixtures/valid/`.
The mediator pin adds only those two filenames under
`thought-khoral-agent-gateway/contracts/agent-conversation-v1/fixtures/valid/`,
with the same exact retained field exception. Consumer fixture hashes must
match the separately published artifact lock.

Each exception combines an enumerated file with an exact schema field,
configuration key/value, source-code use, migration assertion, or documented
compatibility statement. A compatibility token by itself is not sufficient.
The scan fails closed when its scanner is unavailable or returns an error. It
does not permit a whole project, source tree, documentation tree, validator
script, or deployment path.

The default scan checks the canonical workspace and direct-child repositories,
but skips duplicate `.worktrees` snapshots and Git metadata. Before merging a
linked feature worktree, scan its source root explicitly, for example:

`bash scripts/verify-thoughtkhoral-identity.sh .worktrees/a2a-agent-gateway-foundation`

## Current root specifications

- [Current workspace state and source boundaries](how/workspace-state.md)
- [Specification-to-document reconciliation — 2026-11-20](how/documentation-reconciliation-2026-11-20.md)
- [Approved Task 9 packaged-stack/browser acceptance procedure — 2026-11-20](how/task9-packaged-acceptance-2026-11-20.md) — local implementation authorized; publication/activation/provider gates retained.
- [Maintenance specification audit and acceptance traceability — 2026-11-19](how/spec-driven-maintenance-audit-2026-11-19.md)
- [Draft What: product vision and intent](what/product-vision.md)
- [Draft What: usage scenarios](what/usage-scenarios.md)
- [What: solution architecture](what/n2n-solution-architecture.md)
- [What: ThoughtKhoral product identity](what/thoughtkhoral-product-identity.md)
- [What: open-source organization documentation](what/open-source-documentation.md)
- [What: room agent task participation](what/agent-task-participation.md)
- [How: agent spec-authoring roadmap](how/spec-authoring-roadmap.md)
- [Draft How: architecture evolution](how/architecture-evolution.md)
- [How: ThoughtKhoral MVP foundation implementation plan](how/n2n-mvp-foundation-implementation-plan.md)
- [How: GitHub organization publication](how/github-organization-publication.md)
- [How: ThoughtKhoral identity migration](how/thoughtkhoral-identity-migration.md)
- [How: room agent task dispatch](how/agent-task-dispatch.md)
- [How: message mentions and delivery](how/message-mentions-and-delivery.md)
- [Decision: workspace governance](decisions/001-workspace-governance.md)
- [Decision: ThoughtKhoral product identity](decisions/003-thoughtkhoral-product-identity.md)
- [Decision: issue-first contribution and change management](decisions/004-contribution-and-change-management.md)
- [Decision: room-scoped POC memory](decisions/005-room-scoped-poc-memory.md)
- [Decision: initial room agent task dispatch](decisions/006-agent-task-dispatch.md)
- [Decision: A2A agent gateway foundation](decisions/007-a2a-agent-gateway-foundation.md)
- [Decision: slash decisions and facilitator boundary](decisions/008-slash-decisions-and-facilitator-boundary.md)
- [Decision: independent Codex chat agent](decisions/009-codex-chat-agent.md) — approved milestone-one design; provider-free adapter and durable worker implemented locally.
- [What: Codex chat conversations](what/codex-chat-agent.md)
- [How: headless Codex agent](how/codex-chat-agent.md)
- [Implementation plan: history-aware Codex room participation](how/codex-room-conversations-implementation-plan.md)

The [contribution issue brief](how/codex-conversation-issue-brief.md) records the six accepted repository issue links filed on 2026-10-05; maintainer approval and traceability are recorded in the coordinated plan.

The coordinated proposal uses a shared room thread, full authorized room-wide
history followed by revision-bound deltas, and a separate versioned conversation
API. The exact contract and repository tasks were approved on 2026-10-05 with
accepted issue traceability. Consumer implementation requires released contract
artifacts; release publication and activation retain their separate gates.

The UI vendors those same two immutable conversation fixtures under
`thought-khoral-workspace-ui/contracts/agent-conversation-v1/fixtures/valid/`.
Only their exact retained contractVersion fields are compatibility exceptions;
other legacy occurrences remain rejected.

## Approved defaults-discovery amendment — 2026-10-07

The [approved design](https://github.com/thoughtkhoral/thought-khoral-codex-agent/blob/main/.ai/specs/how/default-settings-discovery-proposal.md) authorizes local defaults discovery and
independent optional controls, with verified unreleased candidate contract pins.
Implementation and synthetic verification follow the amendment plan. Publication,
provider use, activation, and push remain separate gates.

Approved defaults extension execution plan: [four coordinated local tasks](https://github.com/thoughtkhoral/thought-khoral/blob/main/.ai/specs/how/codex-default-settings-implementation-plan.md). The pre-amendment Task 9 checkpoint below remains a historical review snapshot. The later amendment and synthetic checkpoint record F1/default-discovery acceptance for this local candidate. Task 9 and milestone acceptance remain open for packaged-stack and separately authorized live verification.

The approved defaults amendment's separate unreleased candidate pins additionally
enumerate `ordinary-human-message.json` and `ordinary-codex-message.json` under
`contracts/agent-conversation-v1.1-candidate/fixtures/agent-conversation-v1/valid/`
in the broker and UI repositories. Only the exact retained contractVersion field
is allowed; other fields and neighboring files remain rejected. Independent
candidate hash verification must confirm these bytes match the unchanged release.

## Approved released-defaults transition — 2026-11-20

After v1.1 publication/download verification, the maintainer instructed local
broker/UI released-provenance transition and packaged-profile preparation to
proceed. The owning specifications are
`.ai/specs/how/released-defaults-consumption.md` in each isolated consumer
branch. Production resolved-settings schema imports move to a separately pinned
`contracts/agent-conversation-v1.1/` directory while all historical v1.0 and
candidate vendor bytes and fixture sources remain unchanged.

The identity gate additionally enumerates only ordinary-human-message.json
and ordinary-codex-message.json under each broker/UI released vendor's
`fixtures/agent-conversation-v1/valid/` directory. As with their already approved
candidate counterparts, only the exact retained contractVersion field is an
exception. Test extra fields, neighboring paths and root/symlink tampering;
never allow an entire vendor directory. This implements existing compatibility
requirements without changing product identity or any wire field.

The new `thought-khoral-platform/scripts/tests/codex-packaged-pins.test.mjs`
also retains the exact existing human-role claim when constructing synthetic
private tokens for positive/negative CLI preflight tests. Its single token
constructor line has the same narrow authentication-field exception as the
historical live guard suite; neighboring legacy fields or names remain rejected.
