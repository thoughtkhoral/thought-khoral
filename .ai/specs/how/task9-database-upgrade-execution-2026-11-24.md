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

## Preparation checkpoint

Approval was recorded before execution. Read-only preparation confirmed the
expected earlier table set and absent conversation tables, before any existing-data DDL.

Execution continued on 2026-11-25 without changing the approved scope. The owned
network-none reference database matches the existing earlier columns, constraints,
indexes, append-only trigger and function definitions. Exact SQL hash and bounded
read-only fingerprint queries pass before downtime. Operational review required
two refinements before apply: retain ownership/grants in the complete recovery
archive (suppress them only for the disposable restore), and require actual
gateway health plus base HTTP readiness before reporting restored availability.
The helper also compares earlier ownership/grants before and after maintenance.
At that preparation checkpoint no existing application had been stopped and no
existing-data DDL had run.

## Completed maintenance — 2026-11-25

Maintenance checkpoint `80f28ac187b64cf19c15ec88b501ee42` completed successfully.
Only the previously running room gateway was stopped; the mediator and Codex
services were already off and were not started. A fresh complete owner-only
custom-format recovery backup, including ownership/grants, was retained privately.
Its fresh restore matched earlier schema and all six original table fingerprints.
The exact approved transaction passed on the isolated clone, including read-only
schema readiness and negative append-only/generation/foreign-key checks.

After rechecking the target, zero unexpected clients and unchanged source data,
the same SQL was applied once to the existing database. All original table data,
ownership/grants, append-only metadata and the empty migration ledger were
preserved; new conversation tables were empty at the post-transaction check.
No earlier migrations were applied to existing data and no automatic restore occurred.

The existing database passes the read-only 0006/0007 readiness checker. The room
gateway resumed with its actual health check passing; UI and Keycloak HTTP return
200. Seven base services remain running, the original PostgreSQL container/volume
is preserved, all owned database fixtures are removed and Codex remains off.
The [sanitized evidence](../../../docs/evidence/task9-database-upgrade-2026-11-25.json)
binds the migration source, exact SQL and private recovery checkpoint without
exposing private rows, fingerprints, credentials or backup paths.

This closes only the existing-database schema prerequisite. Source publication,
local source integration, changed-input activation, browser/provider/live checks
and aggregate Task 9 acceptance remain separate gates.
