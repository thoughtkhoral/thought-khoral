# Corrected-stack timed readiness — 2026-11-25

Subsequent source checkpoint — 2026-11-25: the approved
[worker/platform/workspace source integration](task9-compatibility-integration-2026-11-25.md)
is published. Earlier local/unmerged or approval-pending descriptions below
retain their dated scope; historical evidence/source identities are unchanged.

The approved provider-isolated readiness check passed: **662.743 seconds**, with
22 health/isolation samples and no service restart. The mediator and Codex are
stopped after the bounded check; seven base services remain healthy.

The [approved procedure](../.ai/specs/how/task9-readiness-window-renewal-2026-11-25.md),
[execution record](../.ai/specs/how/task9-readiness-renewal-execution-2026-11-25.md)
and [sanitized receipt](evidence/task9-readiness-renewal-2026-11-25.json) retain
exact source, image, network, timing and shutdown evidence.

All eleven immutable service images and their mount/namespace bindings matched.
Actual Codex interfaces/routes remained confined to two internal-only networks;
provider access was blocked. Both fixture humans received HTTP 200 for models
and defaults before and after observation: eight successful reads, the configured
model, all six expected effort choices and the medium default. Private DNS and
base health checks passed. The maximum sample gap was 31.972 seconds.

No model/provider/tool calls or room turns were requested. All conversation and
recovery counts remain zero. PostgreSQL, Keycloak and memory retained their exact
container IDs; the existing database volume and all persistent worker state are
preserved. The fixed admission deadline was not renewed, and opt-in services
were stopped before it. Existing credentials were reused without a new API key.

The earlier [partial startup report](task9-corrected-startup-2026-11-25.md) remains
historical evidence; its open timed gate is superseded by this run. This result
accepts corrected-stack timed readiness only. Local worker/platform changes are
still unmerged/unpublished; source integration review, rendered-browser proof,
provider/live conversation checks and aggregate Task 9 remain open.
