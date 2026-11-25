# Task 9 corrected-stack startup plan — 2026-11-25

> **For agentic workers:** Use superpowers:executing-plans to execute these
> operational steps after maintainer approval. No implementation change is planned.

**Status:** Approved by the maintainer on 2026-11-25 with “approved”, after
review of this exact startup scope. Execution is authorized only with the
internal-only provider network and without provider/model/tool calls.
The [execution record](task9-corrected-stack-execution-2026-11-25.md) tracks
observed results, including the same-input orchestration correction.

Independent scoped review found and resolved the automatic-dispatch omission
through the isolation and current-state checks below. Rereview found no further
actionable issue. This review did not start services or grant activation.

**Goal:** Start the corrected local stack and verify readiness without requesting
model turns or running the live acceptance suite.

**Architecture:** Retain the existing database, private credentials and worker
state. Use the reviewed platform Compose sources and immutable local images;
observe the mediator and restricted Codex namespace through authenticated reads.

**Tech stack:** Rootless Podman Compose, PostgreSQL 17.8, pinned Codex CLI 0.160.0.

**Specs:** [Coordinated plan](codex-room-conversations-implementation-plan.md),
[compatibility execution](task9-runtime-compatibility-execution-2026-11-23.md),
[firewall execution](task9-loopback-health-execution-2026-11-24.md) and
[completed database maintenance](task9-database-upgrade-execution-2026-11-24.md).

## Inputs and authorization limits

The clean executing platform checkout is `.worktrees/task9-platform-runtime-compat`
at `4ce5fbb646bde30dcd961b871c94f3ec13851356`. Its production proxy/firewall inputs
are unchanged from reviewed build source `a9c3ff5c79e7d3525bed0b5968ab1d8be6b2cc23`.
The worker checkout is `.worktrees/task9-worker-runtime-compat` at
`423d4e84985eb535caa66c7522c4191c6dbccad6`.

Use `scripts/fixtures/codex-conversation/packaged-v1.1-runtime-compat-pins.json`
from that platform checkout, SHA-256
`14c5a784a1f6d8c944f25570f1b0dda741831178348ad7052ecb7301529d2f0c`.
The historical profile remains frozen. The compatibility profile binds:

| Source | Frozen revision |
| --- | --- |
| Contracts release | `f1c8621810c8c121c1aafc8e5a342d6626c4b843` |
| Room gateway | `673294e66fed2b6e98d73e08cfe4a23a0e5e4d48` |
| Mediator | `48a72bcd6a8c668004e10fe2ae3cd01cdaf9361c` |
| UI | `29a940012adfeb796f59c5b89b00cab7a4d0df68` |
| Memory | `7b4651839d1fbb41b426f80ca34712669da667f1` |
| Worker | `423d4e84985eb535caa66c7522c4191c6dbccad6` |

The [exact eleven-image override](../../../docs/evidence/task9-corrected-stack-images-2026-11-25.json)
is the complete image input for this review. Relative to the prior activation,
only the worker and the two services sharing the corrected proxy image change.
Worker image: `sha256:1ac229b25167845b4d7cec217304f3064b02d65d60c53f35b07c5ae3e3683b3b`.
Proxy and namespace-owner image:
`sha256:54dc5c7d649e486bff7f5f8821050b800ae5cb454cd8496a9f93ce0047d07cf1`.
Use the installed Compose implementation with the canonical source fixes for
list-form host aliases and mediator DNS on the actual namespace owner. Do not
reuse the earlier temporary Compose compatibility shim.

For this provider-free attempt, also apply the [readiness-network override](../../../docs/evidence/task9-readiness-network-2026-11-25.json).
It replaces the Codex provider network with a fresh dedicated network named
`thought-khoral-codex-readiness-provider-20261125`, configured `internal: true`.
The other Codex network is already internal. The previous provider network is
preserved. This intentionally removes external provider connectivity while
retaining exact service images, local proxy health and firewall policy bytes.
It is a reviewed operational configuration change in addition to the three
image substitutions. Provider connectivity is not an acceptance claim of this
attempt. The mediator has automatic claim/recovery loops and no existing
read-only switch; egress isolation, current-zero work checks and an exclusive
operator window are therefore required, rather than assuming GET-only probes
disable automatic dispatch.

Reuse already provisioned private provider, invocation and catalog-bridge
credentials and the existing engine-native worker-state volume. No new OpenAI
key or host config/session import is required. Default settings remain
`gpt-6.1-sol` / `medium`. Limit admission to that model, with its six advertised
efforts `low`, `medium`, `high`, `xhigh`, `max`, `ultra`; this changes the original
medium-only admission configuration to match catalog discovery, without claiming
account/provider availability. Refresh admission expiry once at startup to UTC
now plus 60 minutes and record the absolute value privately. Keep existing
five-second UI readiness and worker tool/sandbox/egress policies unchanged.

No migrations, volume replacement, source merge/push, image publication,
provider requests, tool probes or Task 9 acceptance are authorized by startup.
Do not run `smoke-codex-conversation.mjs --live` or send room/thread/turn requests.
Existing credentials being mounted does not authorize their use for inference.

## Task 1: Bind and validate the private startup packet

**Files:** Read the profile and image override above; create an owner-only private
operator packet, environment and rendered Compose evidence outside Git. Public
results belong in a dated startup report and sanitized receipt, created only
after execution. Runtime source files remain unchanged.

- [ ] Verify clean source HEADs, profile hash, all eleven locally available image
  IDs and the existing database container/volume identity. Stop on any mismatch;
  no builds or pulls are part of this approval.
- [ ] Immediately before startup, read-only queries must show no dispatchable or
  in-flight Codex tasks in PostgreSQL and no pending mediator/worker recovery
  records that could invoke a turn. Inspect retained stores privately without
  editing or deleting them. Stop if any pending work is found or cannot be
  classified; maintenance-time emptiness is insufficient.
- [ ] Establish an exclusive operator window: no other local browser or client
  may submit room actions during this attempt. There is no application admission
  switch that preserves catalog reads. Recheck zero task allocations at the end;
  any unexpected task invalidates the attempt and triggers shutdown.
- [ ] Copy the prepared compatibility configuration into a fresh owner-only run
  directory; bind the exact profile, executing platform HEAD and image override.
  Reset activation/provider/tool approval fields before populating the newly
  approved startup scope. Provider/tool permissions must remain false.
- [ ] Refresh only bounded admission expiry and later fixture-human login tokens.
  Validate separated credentials with `python3 scripts/check-codex-inputs.py`
  in the platform checkout using the private environment. Do not print values.
- [ ] Run `node scripts/check-codex-schema.mjs thought-khoral_thought-khoral-postgres_1`;
  require `conversationSchemaReady: true`. Record the currently running seven base
  services and stopped mediator/Codex containers before making any changes.
- [ ] Render the base Compose file, Codex override, exact-image and readiness-network overrides with
  the private environment. Verify all bindings, DNS aliases, preserved external
  database/state volumes and ports. Retain the potentially sensitive render
  privately; do not publish environment expansions.

## Task 2: Start and observe without model calls

- [ ] Before starting Codex processes, create only the fresh reviewed readiness
  network through Compose/Podman and inspect it: require `Internal=true`, no
  existing containers attached, and the exact dedicated name. Stop on conflict;
  never repurpose a pre-existing network. Start only the namespace owner first,
  then inspect its attachments: both networks must be internal and no external
  provider network may remain attached. If either check fails, stop it before
  proxy/worker/mediator startup. Verify actual namespace interfaces/routes and
  absence of host networking, published ports or forwarding through another
  namespace. Recheck the same attachments after full Compose startup; metadata
  alone is insufficient. Keep this isolation throughout observation.
- [ ] Start the reviewed Compose project with the four files above using
  `up --no-build -d` and pull disabled. Preserve the existing project identity and
  external volumes. Never use `down -v`, automatic reinitialization or replacement
  database creation. Base containers may only change if rendered inputs require it.
- [ ] Require actual gateway, mediator, proxy, namespace-owner and worker health;
  verify private mediator/worker DNS from their real namespaces. Observe at least
  eleven minutes, bounded by fifteen minutes for this readiness attempt, to cover
  the reproduced ten-minute watchdog failure window. Record restarts/exits and
  sanitized failure causes; the earlier mediator exit is still unclassified.
- [ ] Refresh PKCE authentication for the two existing local fixture humans.
  Perform only authorized catalog/default GETs through the room gateway; require
  HTTP 200, the configured model/default and the six normalized efforts. Confirm
  no conversation/task/turn allocation was requested and no provider call occurred.
  These reads and health checks are the permitted startup probes.
- [ ] On failed readiness, isolation or unexpected restart, stop the Codex
  namespace and its dependent proxy/worker, retain diagnostics and keep the base
  service availability restored. If fail-stop itself fails, explicitly stop the
  dependent containers before declaring the attempt over. Never broaden policy
  or retry changed runtime inputs under this approval.
- [ ] If readiness passes, retain the local stack only within the recorded
  admission window with both Codex networks internal. Record the expiry; no
  renewal, network reconnection or model turn is implied. This approval cannot
  convert the attempt to provider-capable connectivity.
  Publish a sanitized local report with exact identities, observations and open
  gates. Leave provider and aggregate Task 9 acceptance false.

## Subsequent gates

Source integration/publication, rendered-browser proof, and provider/live
conversation acceptance each retain their existing separate review scope.
Successful startup would close only the corrected-stack readiness attempt;
it would not establish model availability or accept Task 9. No new product
features, guided directories or memory integration are included.
