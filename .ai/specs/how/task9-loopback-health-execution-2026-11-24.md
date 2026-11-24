# Task 9 loopback health execution — 2026-11-24

Authority: explicit maintainer approval of the [bounded firewall amendment](task9-loopback-health-policy-amendment-2026-11-23.md).
Use the existing clean isolated platform branch; preserve canonical main and
the frozen original/compatibility profile bytes. This work adds no existing-data
upgrade, source publication, changed-input activation or provider authority.

1. Record approved local How before implementation.
2. Reproduce original-policy teardown in an owned network-none fixture. Add only
   nonterminating counter predicates while identifying rejected ACK state,
   direction and socket ownership; do not grant traffic on a hypothesis.
3. Test the approved exception only if the exact socketless ESTABLISHED reply
   predicate is confirmed. Verify zero payload and all existing connection/UID
   limits. A different predicate or unsafe representation stops the correction.
4. If eligible, implement with regression tests, real-kernel RED/GREEN, long
   health observation and fail-stop/negative-egress checks. Otherwise retain the
   diagnostic result and prepare a precise replacement amendment.
5. Independently review, update workspace/project specifications and derived
   documentation, clean owned fixtures and commit local reviewable checkpoints.

Progress: approval recorded; diagnosis pending. No allow rule has been added.
