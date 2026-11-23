# Task 9 existing database upgrade proposal

Status: **proposed; not authorized for application to existing data**.
Prepared under the [approved compatibility correction](task9-runtime-compatibility-proposal-2026-11-23.md).
Only a private restored copy has been migrated. The existing external PostgreSQL
volume selected by the reviewed platform configuration remains unchanged.

## Verified input and change

The existing database has earlier room/task tables, no conversation tables and
an empty `_sqlx_migrations` ledger. An empty ledger is not permission to replay
earlier initialization scripts. This upgrade applies only the already approved
broker migrations at source `673294e66fed2b6e98d73e08cfe4a23a0e5e4d48`:

| Migration | SHA-256 |
| --- | --- |
| `0006_agent_conversations.sql` | `0704c17c443d583c0b60557598ee94945a8380b82e4e0ea146187095a5f6952c` |
| `0007_conversation_lifecycle.sql` | `e36a2102a8a09c9d7456831261ea4b5a935fa07d229de4a95722697197ddc766` |

The migration bodies are combined inside one transaction, replacing only each
outer `BEGIN`/`COMMIT`. Local lock timeout is 5 seconds; statement timeout is
30 seconds. Verified combined SQL SHA-256:
`bdb5ca91432378d50399020de58f87e6a75ef59adb8cac1cab5d41a644c6f928`.
No room data is rewritten or removed and no migration ledger history is invented.
The schema adds conversation tables, lifecycle fields, keys, indexes and checks,
including the required composite room-event uniqueness constraint.

An owner-only custom-format backup was restored to an owned network-none database
fixture. Both migrations passed, retained table counts and row fingerprints
matched before/after, all new tables were empty, and invalid-generation/unbound-
update inserts were rejected. An additional restored database verified the
combined transaction: a forced final error rolled back both migrations; the
successful transaction then created the required schema. The additional database
was removed. Private data, credentials and backups are outside Git.

## Proposed execution after separate approval

1. Verify the existing target container/volume and migration hashes. Quiesce room
   writes and agent dispatch during the maintenance window; keep Codex disabled.
   Take a fresh owner-only backup and record current schema plus retained-data
   fingerprints privately. Refuse application if the expected earlier schema
   differs or any conversation tables are already present.
2. Re-restore that fresh backup privately and run the exact combined transaction
   and current read-only schema readiness verifier. Proceed only on success.
3. Apply the same verified SQL once to the existing database using `psql -X`
   with `ON_ERROR_STOP=1`. On any error, retain the diagnostic privately and
   verify transaction rollback before restoring ordinary room availability.
4. Run the read-only schema readiness verifier and compare earlier table data
   fingerprints. Restore normal base-service availability only after checks
   pass. Record success against the exact SQL/source/backup checkpoint.

The volume must not be deleted or reinitialized. Applying earlier migrations,
rewriting data, changing authentication and restoring over the existing volume
are outside this proposal. If an unexpected post-commit discrepancy occurs,
keep writes quiesced and present the concrete restore plan for approval.

Approval of this proposal would permit only this existing-database maintenance.
It would not authorize source publication, changed-input Codex activation,
provider/tool calls or Task 9 acceptance.
