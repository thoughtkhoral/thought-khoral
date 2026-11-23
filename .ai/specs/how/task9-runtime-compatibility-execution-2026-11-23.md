# Task 9 runtime compatibility execution

Authority: the maintainer approved the [bounded compatibility proposal](task9-runtime-compatibility-proposal-2026-11-23.md)
on 2026-11-23. This record tracks local work only; it adds no publication,
changed-input activation, existing-data upgrade or provider/tool authority.

## Work and dependency order

1. Worker: record approved native protocol requirements locally, demonstrate
   failing timestamped-notification regressions, implement bounded handling and
   run required host checks. Owner: worker isolated branch.
2. Platform: record approved Compose/DNS requirements locally, demonstrate actual
   generated-argv regressions, implement reproducible configuration and schema
   readiness checks. Owner: platform isolated branch. The new profile waits for
   the final worker source/image.
3. Investigations: diagnose watchdog and mediator stops in owned provider-free
   fixtures; compare advertised catalog/admission semantics. Back up existing
   database privately, restore separately and test approved 0006/0007 migrations.
   Never upgrade or delete the existing database. Owner: root orchestration.
4. Package: build the clean corrected worker source, verify actual adapter
   initialize/model-list in network-none fixture, rerun package/tool-policy
   probes and prepare a separate exact compatibility profile. Owner: root plus
   platform branch after tasks 1–3.
5. Review: independently review changes, verify source/profile/evidence bindings
   and update derived documentation. Keep local branches for review.

The worker and platform branches are independent until package/profile binding;
they share no edited files. Investigations use uniquely named fixtures and
owner-only artifacts outside Git. Existing running services and frozen acceptance
inputs remain unchanged. Canonical runtime checkouts remain on their original
main branches. Native worktree tools operate only on the root task repository;
the independent child repositories use Git worktrees under ignored `.worktrees/`.

## Progress

- Approval recorded; isolated worker/platform branches created from clean mains.
- Worker correction committed locally at `423d4e84985eb535caa66c7522c4191c6dbccad6`
  after spec-first `cd73cee`. Two new catalog/turn regressions failed before
  correction; 50 tests pass after it, with fmt/clippy/pins/notices/catalog/docs
  checks. Independent review found no actionable issue and reran all four new
  test functions. The actual rebuilt image/adapter proof below also passes.
- Platform approved How `d163c76` precedes Compose/DNS fix `bdb1ed6`.
  Actual generated-argv regressions reproduce both defects and pass after the
  correction. Final clean platform source is
  `8edcca07d5ae90c1a66c2f7f8915ead7edf9f0d3`: 54 combined guards, five Compose
  tests and input/startup/host-admission/mediator/proxy checks pass. The original
  profile bytes and historical inputs remain unchanged. Optional historical
  cleanup tests are obstructed by the current stack's occupied port 8080.
- Private backup restored into a network-none owned database fixture. Approved
  0006/0007 migrations pass; original rows match before/after, new tables are
  empty and invalid generation/unbound update inserts are rejected. The existing
  database is unchanged. Actual read-only schema verification rejects the
  original database and accepts the migrated private clone. An additional
  private restore verifies atomic application and forced-error rollback of both
  migrations. The [existing-data upgrade proposal](task9-existing-database-upgrade-proposal-2026-11-23.md)
  remains unapproved and unapplied.
- Mediator original log contains only `Error: Rejected`; its historical cause
  is not established. Fresh workload-token/read-only authentication succeeds;
  no task was claimed by diagnosis. Watchdog diagnosis reproduces local proxy
  connect timeout under unchanged policy/timeout, and separate metadata/counter
  observations show incomplete TCP teardown. Causation between these findings
  remains unproved. The [loopback-policy amendment](task9-loopback-health-policy-amendment-2026-11-23.md)
  is prepared for separate approval before any security behavior change.
- New ARM64 image:
  `sha256:1ac229b25167845b4d7cec217304f3064b02d65d60c53f35b07c5ae3e3683b3b`.
  Exact source and unchanged Cargo-lock labels are attached. Ten package/startup
  probes pass; actual native 44-case/eight-model/resume/six-refusal capture matches
  the retained proof byte-for-byte. All policy probes use a network-none local
  synthetic provider, not public-provider inference.
- Actual production adapter regression: old image HTTP 503; corrected image HTTP
  200, six normalized efforts, zero conversations/task receipts/requested turns.
- Separate profile `packaged-v1.1-runtime-compat`, SHA-256
  `14c5a784a1f6d8c944f25570f1b0dda741831178348ad7052ecb7301529d2f0c`,
  passes actual clean-source/image/package/read-only-clone-schema helper binding.
  The original profile remains frozen. A private draft admission policy matches
  the six advertised efforts while retaining the original model/medium defaults;
  it is proposed for future activation review, not applied.
- Independent worker/platform reviews found no actionable implementation issue.
  Root records/reports identify the remaining security and existing-data gates.
  No merge, push, changed-input activation, existing-data migration or public
  provider call has occurred. Live Codex remains disabled; Task 9 is not accepted.
