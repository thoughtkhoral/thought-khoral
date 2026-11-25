# Task 9 fresh readiness window — 2026-11-25

> **For agentic workers:** Use superpowers:executing-plans after approval.
> Execute startup, authentication, observation and shutdown in one supervisor.

**Status:** Approved by the maintainer with “approved”, followed by the explicit
instruction to return to the n2n work and abandon the unrelated EnMaaS review.
This authorizes one fresh window under the limits below. It does not extend or
reuse the previous window.

**Goal:** Complete the remaining eleven-minute stability check without inference.

**Architecture:** Reuse the exact reviewed images, private credentials, database
and worker state. A fresh internal-only provider network prevents public provider
access. One supervised operation performs the timed checks and stops Codex and
the mediator afterward, leaving the seven base services available.

**Tech stack:** Existing rootless Podman Compose, PostgreSQL and pinned worker.

**Specs:** [Original startup scope](task9-corrected-stack-startup-2026-11-25.md)
and [actual execution record](task9-corrected-stack-execution-2026-11-25.md).
This proposal replaces only their executing documentation HEAD, bounded admission
window and dedicated network name. All original prohibitions remain in force.

## Exact review inputs

Use clean platform checkout `.worktrees/task9-platform-runtime-compat` at
`f51ec3e57b711c311f2bebfebf4e987549551cf7`. The intervening commits are operational
specs/docs only; production image inputs are unchanged from the reviewed build.
Worker checkout remains `423d4e84985eb535caa66c7522c4191c6dbccad6`.
The original compatibility profile SHA-256 remains
`14c5a784a1f6d8c944f25570f1b0dda741831178348ad7052ecb7301529d2f0c`;
its six frozen sources and contract/policy/package identities are unchanged.

Reuse the [same eleven immutable images](../../../docs/evidence/task9-corrected-stack-images-2026-11-25.json)
and apply the [fresh internal-network override](../../../docs/evidence/task9-readiness-renewal-network-2026-11-25.json).
The new network is `thought-khoral-codex-readiness-provider-20261125-r2` with
`internal: true`. Both earlier provider networks are preserved. The new namespace
owner may attach only to this network and the existing internal Codex network.

Reuse the existing three distinct private credentials and engine-native state.
No new OpenAI key, host config or host session import is required. Keep the one
model, six normalized effort capabilities and medium default already reviewed.
Only after approval and successful read-only preparation, set admission expiry
once to UTC startup time plus 60 minutes. Record it privately and do not renew it.

## Task 1: Bind preparation before opening the window

- [ ] Verify clean HEADs, profile hash, all image IDs and the preserved original
  database container/volume. No builds, pulls, migrations or volume replacement.
- [ ] Capture exact IDs and mounts of the eight potentially affected containers;
  skip absent containers. Record PostgreSQL/Keycloak/memory IDs as protected.
  Read-only queries must show zero Codex allocations and no pending recovery.
- [ ] Check worker recovery using a quiescent snapshot: source state is mounted
  read-only in a network-none disposable probe; copy SQLite plus any WAL/SHM
  files to private tmpfs, verify source sizes/mtimes unchanged, and query only
  the copy. Reject pending work or any unclassified record; remove the probe.
- [ ] Verify the new network name is absent, validate separated credentials and
  exact Compose render privately, and establish the exclusive operator window.
  Keep provider/tool approvals false and publish no secret values or private rows.

## Task 2: One supervised startup and observation

- [ ] Start one supervisor invocation with the already reviewed local engine
  permissions. It must own all subsequent startup, login, timed observation and
  shutdown steps; do not defer observation to a later approval/tool invocation.
  Compute the new fixed expiry once at this boundary and revalidate its render.
- [ ] Stop and remove only the captured affected UI, mediator, reference agent,
  agent namespace owner, worker, proxy, Codex namespace owner and broker in
  dependency order. Use plain removal on stopped exact-ID containers without
  volumes. Preserve PostgreSQL, Keycloak, memory and every persistent state mount.
- [ ] Create the fresh internal network, record its ID/labels and verify it is
  internal and empty. Recreate only the Codex namespace owner first, then verify
  actual interfaces and complete routes match the two internal networks, with
  no external gateway, published port, host networking or alternate forwarding.
- [ ] Start the reviewed four-file Compose project with `up --no-build --pull never
  --no-recreate -d`. Explicit recreation above applies reviewed broker policy and
  namespace bindings; `--no-recreate` protects all retained containers. Check all
  eleven actual images, relevant mounts, read-only roots and namespace owner IDs.
- [ ] Verify health and DNS, and perform only the existing two fixture-human PKCE
  logins and authenticated model/default GETs. Require four HTTP 200 responses,
  the one model, all six efforts and the medium default. Never send turn requests.
- [ ] Begin sampling immediately in the same process. Use a monotonic clock;
  retain an initial sample and samples no more than 60 seconds apart, checking
  health, unchanged container IDs/start times, isolation and zero allocations.
  Accept only after at least 660 seconds and before 900 seconds of observation.
  If startup leaves less than 900 seconds before the fixed admission expiry,
  stop without beginning observation. Never extend the deadline automatically.
- [ ] Any failed gate stops Codex and restores the seven-service deterministic
  base using explicit services, exact images, preserved volumes and controlled
  dependencies. Verify protected IDs, actual health and UI/Keycloak HTTP 200.
  A stop failure must attempt all dependents and report unverified shutdown.
- [ ] After successful observation, stop the mediator and all three Codex
  services, verify the seven base services remain available, and retain a
  sanitized report and receipt. No stack is left beyond its bounded window.

Source integration/publication, browser proof, provider connectivity and live
conversation acceptance remain separately scoped. Completing this procedure
would accept only corrected-stack timed readiness, not aggregate Task 9.
