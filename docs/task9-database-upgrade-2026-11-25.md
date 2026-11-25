# Task 9 existing database upgrade — 2026-11-25

The approved upgrade is complete. The existing database now passes the required
conversation/lifecycle schema check. All six earlier tables' data and existing
ownership/grants were preserved at the post-transaction check. Normal base-service
availability is restored; Codex remains off.

Authority: [approved maintenance plan](../.ai/specs/how/task9-existing-database-upgrade-proposal-2026-11-23.md)
and [execution record](../.ai/specs/how/task9-database-upgrade-execution-2026-11-24.md).
The [sanitized receipt](evidence/task9-database-upgrade-2026-11-25.json) records
the exact operation and its limits.

Before downtime, an isolated reference built from the frozen earlier migrations
matched the existing columns, constraints, indexes, append-only trigger and
function definitions. During maintenance only the previously running room
gateway was stopped. A fresh complete custom-format backup was retained in an
owner-only private directory, including ownership and grant recovery metadata.

The fresh backup restored successfully into a network-none clone. The exact
approved transaction passed there, retained data matched and negative checks
confirmed append-only, generation and foreign-key enforcement. The same verified
transaction was then applied once to the original database after reconfirming
target identity, quiescence and unchanged data.

| Verified input | Identity |
| --- | --- |
| Broker migration source | `673294e66fed2b6e98d73e08cfe4a23a0e5e4d48` |
| Applied migration bodies | `0006_agent_conversations.sql`, `0007_conversation_lifecycle.sql` |
| Combined transaction SHA-256 | `bdb5ca91432378d50399020de58f87e6a75ef59adb8cac1cab5d41a644c6f928` |
| Private recovery checkpoint | `80f28ac187b64cf19c15ec88b501ee42` |

The transaction uses a five-second lock timeout and 30-second statement timeout.
New tables were empty at the post-transaction check, and the migration ledger
remains empty. Earlier initialization migrations were not replayed against the
existing database. No volume was deleted/reinitialized and no backup was restored
over existing data. Private backup bytes, row fingerprints and credentials remain
outside Git.

After the upgrade, the gateway passed its actual health check, UI/Keycloak HTTP
returned 200 and seven base services were running. The previously stopped mediator
and three Codex-side services remain stopped. The owned clone/reference fixture
was removed; the existing PostgreSQL container and external volume are preserved.

This verifies the database prerequisite only. The [local firewall correction](task9-loopback-health-2026-11-24.md)
and worker compatibility changes remain on local branches. Source integration/
publication, changed-input stack activation, rendered-browser and provider/live
acceptance are not granted or completed by database maintenance.
