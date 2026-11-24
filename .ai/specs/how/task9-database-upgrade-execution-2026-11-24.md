# Task 9 database maintenance execution — 2026-11-24

Authority: explicit maintainer approval of the [verified upgrade plan](task9-existing-database-upgrade-proposal-2026-11-23.md).
Apply only the approved 0006/0007 bodies as one transaction, SQL SHA-256
`bdb5ca91432378d50399020de58f87e6a75ef59adb8cac1cab5d41a644c6f928`.
No existing-volume replacement, earlier-migration replay, invented migration
ledger history, source publication or changed-input Codex activation is authorized.

## Procedure and boundaries

1. Verify the existing PostgreSQL container identity, image, external volume,
   version, table set, empty ledger and absent conversation schema. Build a
   disposable network-none reference database from the frozen earlier migrations
   and compare columns, keys/indexes, append-only trigger and function definitions.
   Earlier migrations run only in that empty disposable reference, never against
   the existing database.
2. Record initially running application services. Quiesce room writes and agent
   dispatch using only their existing containers; keep Codex off and refuse
   unexplained remaining client sessions. Create a fresh owner-only custom-format
   backup, private schema snapshots and deterministic retained-data fingerprints.
3. Restore the fresh backup into the owned network-none clone. Recheck schema and
   data, run the exact approved transaction and bounded read-only readiness checker,
   and verify preserved data plus required new constraints before existing-data DDL.
4. Reconfirm target identity, quiescence and unchanged data. Apply the exact SQL
   once with `psql -X` and `ON_ERROR_STOP=1`. Then verify actual readiness, original
   table data and append-only enforcement, empty new tables and unchanged ledger.
5. Resume only services that were running before maintenance. Never start Codex
   or previously stopped mediators. Check normal base availability, retain the
   private backup/receipt and remove only the owned database fixture.

Before commit, any failure must preserve the existing schema/data and permit
restoring the previous base-service state after verification. An uncertain or
unexpected post-commit result keeps writes quiesced for a concrete reviewed
restore plan; never automatically restore over the existing volume.
All private rows, credentials, backup bytes and data fingerprints stay outside Git.

## Progress

Approval recorded. Read-only target inspection confirms the expected earlier
table set and absent conversation tables. No existing-data migration is yet applied.
