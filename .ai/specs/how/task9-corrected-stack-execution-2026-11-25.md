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
