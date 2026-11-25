# Corrected-stack startup — 2026-11-25

Startup and authenticated catalog/default checks passed. Eleven-minute stability
remains unverified. Codex and the mediator are stopped; the seven base services
are healthy and the existing database volume is preserved.

The [approved plan](../.ai/specs/how/task9-corrected-stack-startup-2026-11-25.md),
[execution record](../.ai/specs/how/task9-corrected-stack-execution-2026-11-25.md)
and [sanitized evidence](evidence/task9-corrected-startup-2026-11-25.json) govern
the exact scope. Runtime sources remain local and unmerged.

The first owner-only startup exposed existing stopped-container dependencies
that prevented replacement. The actual attachment check rejected the old network
before the proxy, worker or mediator started. Dependency-order recreation with
the same approved images/configuration resolved that orchestration problem.
PostgreSQL, Keycloak and memory were protected from recreation and retained their
exact IDs. All eleven service images, relevant mounts and namespace owners were
verified directly, rather than inferred from Compose's exit code.

The corrected Codex namespace had two internal-only networks, matching interfaces
and connected routes without an external gateway. Both fixture humans obtained
HTTP 200 for models and defaults: `gpt-6.1-sol`, six normalized effort choices and
the `medium` default. All responses used `no-store`. No conversation or task was
allocated, and no model/provider/tool call was requested. This does not verify
provider account availability or connectivity.

Continuous observation did not begin in time to satisfy the fifteen-minute
attempt limit; only a 27.286-second sample was retained. The controller therefore
stopped Codex and restored base availability. A retry stopped before service
startup when its read-only SQLite recovery check could not open the database.
The corrected reader successfully checked a private disposable copy of the
quiescent database and journal files, leaving the source read-only. Final
PostgreSQL conversation counts and worker/mediator recovery counts are zero.

The original admission deadline was not extended. The next step is the
[fresh bounded observation procedure](../.ai/specs/how/task9-readiness-window-renewal-2026-11-25.md),
which requires approval for a new window. It integrates startup, authentication
and observation in one supervised operation. Browser, provider/live, source
publication and aggregate Task 9 acceptance remain open.
