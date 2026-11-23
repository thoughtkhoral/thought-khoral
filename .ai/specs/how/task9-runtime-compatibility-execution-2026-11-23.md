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
- Worker protocol correction: pending.
- Platform compatibility correction: pending.
- Shutdown/policy/database investigations: pending.
- New image and exact compatibility profile: pending.
- Independent review and final verification: pending.
