# Task 9 corrected-stack execution — 2026-11-25

Authority: the maintainer approved the [startup plan](task9-corrected-stack-startup-2026-11-25.md).
Only provider-isolated readiness is authorized. No inference, tools, migrations,
source publication or aggregate acceptance is included.

## Preflight

Clean platform/worker HEADs, six fresh frozen-source snapshots and all eleven
local immutable images match the approved inputs. The existing database identity
and external volume are preserved, schema readiness passes, and fresh counts show
zero conversation/task/update allocations and no mediator/worker recovery work.
The exact installed Compose render validates the approved aliases, image inputs,
credential separation and internal-only readiness network. Admission expiry was
recorded once privately and will not be renewed during this attempt.

## Initial isolation gate

The first owner-only Compose operation returned success despite removal/create
errors. Stopped dependents retained engine `--requires` references, blocking owner
replacement. The old owner therefore still had its old network attachments. The
actual-attachment check rejected this before any proxy, worker or mediator startup.
All three Codex services are verified stopped; actual health checks and UI/Keycloak
HTTP confirm the seven base services remain available. The failed receipt and
diagnostics are retained privately. This attempt grants no readiness acceptance.

## Same-input orchestration correction

Independent operational review permits dependency-order recreation within the
approved startup scope; no runtime inputs or admission expiry change. Capture IDs
and complete mount bindings before removal. Repeat zero-work/recovery checks and
bind the already created empty internal readiness network to its exact recorded
ID and labels.

Recreate only the UI, mediator, reference agent, agent namespace owner, Codex worker,
proxy, Codex namespace owner and room gateway. Remove their stopped containers in
dependency order using plain container removal without volumes. The room gateway
requires the already approved six-effort admission configuration; its image and
database are unchanged. PostgreSQL, Keycloak and memory containers must never be
removed or recreated. Use `--no-recreate` for the ensuing full Compose startup so
their preservation is enforced before execution, then verify their exact IDs.

Recreate and inspect only the new Codex namespace owner first. Require both
networks internal and actual interfaces/routes confined to their connected
prefixes. Start dependents only after this gate. Verify every image, mount,
read-only root and PID/network namespace owner directly; a Compose exit code is
insufficient. Observe healthy services for eleven minutes and perform only the
approved two-human catalog/default GET checks. Unexpected allocation, restart or
isolation failure invalidates the attempt.

If startup fails, stop all Codex containers with verified bounded fallback and
restore only the seven base services using their unchanged exact images and
preserved state, with the deterministic base configuration and explicit service
selection. Verify protected container IDs, actual health and base HTTP before
reporting restored availability. Never reconnect external provider networking.

## Outcome: startup/catalog verified, timed gate open

The dependency-order correction started all eleven exact-image services. Actual
mounts, read-only roots and PID/network namespace ownership matched. The new owner
had exactly two internal interfaces and only their connected routes, with no
external gateway or provider-network attachment. PostgreSQL, Keycloak and memory
retained their exact container IDs. The previous mediator exit did not recur
during the retained startup/catalog checks; its historical cause remains unknown.

Both fixture humans authenticated with PKCE. All four model/default GETs returned
HTTP 200 and `no-store`, advertising only `gpt-6.1-sol`, normalized efforts
`effort-low`, `effort-medium`, `effort-high`, `effort-xhigh`, `effort-max`,
`effort-ultra`, and default `effort-medium`. No room turn was requested and no
conversation/task/update allocation occurred. Provider connectivity was blocked.

Only the initial 27.286-second health sample was retained. Continuous observation
was not established within the approved fifteen-minute attempt bound, so eleven-
minute stability is unverified. The controller stopped Codex and restored the
seven base services rather than accepting that gate. A same-expiry retry stopped
in preflight because opening the stopped worker's SQLite database directly from a
read-only mount failed. No services restarted in that retry. The reader was then
corrected to copy the quiescent SQLite database and any journal/shared-memory
files into private disposable tmpfs before querying the copy; source file
size/mtime checks and its read-only source mount guard against source mutation.
This verification passed with zero worker/mediator recovery records.

Final checks confirm Codex and the mediator off, seven base services healthy,
UI/Keycloak HTTP 200, protected container IDs and the existing database volume
preserved, and all five conversation-allocation counts zero. The original
admission expiry was not renewed. No migrations, model/tool/provider calls,
source integration/publication or Task 9 acceptance occurred.

The [sanitized receipt](../../../docs/evidence/task9-corrected-startup-2026-11-25.json)
and [report](../../../docs/task9-corrected-startup-2026-11-25.md) separate successful
subchecks from the open timed gate. A
[fresh-window procedure](task9-readiness-window-renewal-2026-11-25.md) is prepared
for review; it is not authorized by the previous window.

Independent scoped review found the final receipt/report and fresh-window
proposal consistent, with no further actionable finding. Documentation links,
specification hierarchy, repository references and product identity checks pass.
