# Task 9 fresh readiness execution — 2026-11-25

Authority: the maintainer approved the [fresh-window procedure](task9-readiness-window-renewal-2026-11-25.md).
The supervisor completed provider-isolated timed readiness and then stopped the
mediator and all three Codex services. Seven base services remain healthy.

## Verified inputs and preparation

Actual clean executing platform source: `f51ec3e57b711c311f2bebfebf4e987549551cf7`; worker source:
`423d4e84985eb535caa66c7522c4191c6dbccad6`. All six frozen-source snapshots were
clean, all eleven immutable images matched the reviewed override, and the
compatibility profile hash remained
`14c5a784a1f6d8c944f25570f1b0dda741831178348ad7052ecb7301529d2f0c`.
The actual existing database/schema passed its read-only check. Conversation and
recovery counts were zero before startup. Recovery checks used the corrected
read-only source/private tmpfs SQLite snapshot, including any journal files.

The supervisor opened one new fixed 60-minute admission window only after
preflight, with no renewal during the run. The eight affected containers were
recreated in dependency order without removing volumes. Full Compose startup
used no builds, no pulls and `--no-recreate` to protect PostgreSQL, Keycloak and
memory; their exact IDs are preserved. Eleven service images, mounted paths,
read-only roots and PID/network owner IDs matched after startup.

## Timed and authenticated readiness passed

The fresh `thought-khoral-codex-readiness-provider-20261125-r2` network and existing
Codex internal network were engine-verified internal. Before dependent startup
and throughout sampling, actual interfaces and complete routes matched those
networks, without an external gateway, host networking, published ports or a
route through another namespace. Both prior provider networks were preserved.
Private mediator and worker DNS checks passed from the real namespaces.

Both fixture humans authenticated via PKCE before and after observation. All
eight model/default GETs returned HTTP 200 and `no-store`, with only
`gpt-6.1-sol`, the six normalized efforts and `effort-medium` default. No room,
conversation or turn request was sent; no inference or provider/tool probe ran.

The same supervisor retained 22 monotonic samples over **662.743 seconds**.
The maximum sample gap was 31.972 seconds, within the 60-second limit. Every
sample verified all eleven services running, all configured container health
checks passing, unchanged container IDs/start times, internal-only Codex networking
and zero conversation allocations. The run met the 660-second minimum and 900-second
maximum. The mediator has no container healthcheck; its authenticated catalog
path passed before and after observation. The earlier watchdog/mediator shutdown
did not recur in this bounded window; no broader reliability or historical-cause
claim follows.

## Shutdown and evidence limits

The mediator and all three Codex services were explicitly verified stopped before
the recorded admission expiry `2026-11-25T18:13:36Z`. Final checks confirmed seven base
services available, actual health checks passing, UI/Keycloak HTTP 200, unchanged
protected IDs and preserved existing database container/volume. All five
conversation-allocation counts and worker/mediator recovery counts remain zero.
Owned snapshot probes were removed. Credentials, bearer tokens, native state and
private receipts remain outside Git.

The [sanitized evidence](../../../docs/evidence/task9-readiness-renewal-2026-11-25.json)
and [report](../../../docs/task9-readiness-renewal-2026-11-25.md) close only corrected-
stack provider-isolated timed readiness. Original failed/partial receipts remain
historical evidence. No migrations, source integration/publication, browser
acceptance, provider connectivity or aggregate Task 9 acceptance is claimed.

Independent scoped review verified the public duration/sample/gap arithmetic and
outcome consistency, with no actionable finding or privacy exposure. Workspace
and platform link checks, specification hierarchy, repository references, product
identity and patch-format checks pass. The immutable production image inputs are
unchanged; this operation adds evidence and documentation only.
