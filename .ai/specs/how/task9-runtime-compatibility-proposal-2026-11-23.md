# Task 9 packaged runtime compatibility correction

Status: **approved for bounded local implementation and verification**. The
maintainer answered “approved” on 2026-11-23 after reviewing this proposal.
Approval permits the local corrections, provider-free verification and package
preparation below. Source/image publication, changed-input activation, existing
database upgrades and provider/tool calls retain their separate gates.
It makes the correction concrete after authorized activation exposed failures
not covered by component/package-policy tests.

Governing sources: [Task 9 procedure](task9-packaged-acceptance-2026-11-20.md),
[integration execution record](task9-integration-2026-11-23.md), the worker's
[approved runtime How](https://github.com/thoughtkhoral/thought-khoral-codex-agent/blob/main/.ai/specs/how/codex-chat-agent.md)
and [agent instructions](https://github.com/thoughtkhoral/thought-khoral-codex-agent/blob/main/AGENTS.md).

## Observed failure and bounded objective

The exact packaged worker returns `runtime_unavailable` for authenticated model
catalog requests. A network-none fixture using the same immutable worker image,
provider configuration, fixed controls, working directory and native state
successfully initializes CLI 0.160.0 and obtains its model list without any
thread/start or turn/start request. Both responses validate against the pinned
schemas. Its stdout also contains these ordinary startup notifications:

- `configWarning`, reporting that Codex will use its bundled bubblewrap because
  the executable is absent from PATH;
- `remoteControl/status/changed`, with status `disabled`.

Both carry `emittedAtMs`, explicitly defined by the pinned `ServerNotification`
schema. The worker's closed `app_server.rs::envelope` omits that field and returns
`runtime_unavailable`. Its conversation notification loop also has no explicit
disposition for either observed startup notification. Native CLI capture tests
previously verified tool policy but did not prove real adapter catalog success.

The objective is real provider-free native initialization/catalog compatibility,
while retaining strict envelope validation and all authority/tool/egress limits.
This is an internal native-protocol correction; public room/conversation
contracts, API routes, credential separation and model defaults do not change.

## Proposed worker correction

Before implementation, place the approved requirements below in the owning
worker How and link this approval/checkpoint. No product What expansion is needed.

1. Accept the pinned optional `emittedAtMs` metadata only on server-notification
   envelopes. Validate its pinned integer type and existing bounded JSON limits;
   do not coerce strings/fractions or accept arbitrary extra keys. The metadata
   must not affect room order, context authority, settings or receipt identity.
2. Add explicit, schema-validated handling for the two observed startup
   notification types. Keep bounded diagnostics private and credential-filtered;
   do not put warning text, paths or remote installation identifiers into rooms.
   Review the observed bundled-bubblewrap fallback against the unchanged package
   and tool-policy evidence. Do not silently suppress warnings about unsupported
   security controls. A remote-control state other than disabled is outside this
   correction and must fail closed.
3. Apply that handling consistently during catalog discovery and turn lifecycle
   processing. Unknown notifications, client/tool requests, malformed metadata,
   unexpected identity changes and unsupported controls remain rejected.
4. Keep CLI 0.160.0, fixed tool controls/catalog, no tools, read-only workspace,
   service-owned native home, API authentication, limits, receipts and recovery
   semantics unchanged. Do not import host config or sessions.

### Required evidence

- A failing regression for the real timestamped notification sequence before
  the correction, followed by a passing sequence after it. Include negative
  timestamp/extra-field, malformed notification and non-disabled remote-control
  cases, retaining existing unknown-method/tool-request refusals.
- An actual CLI initialize/model-list test through the worker adapter in an
  isolated network-none production-image fixture. A fake protocol or direct CLI
  test alone cannot pass this regression. No model turn or provider inference.
- Existing worker `cargo test --locked`, fmt, clippy, contract-pin, legal/catalog
  and documentation checks. Build a new immutable ARM64 production image from
  its clean final source and repeat actual package/startup and native-policy
  checks. Attribute earlier AMD64/MSRV CI evidence only to its tested source.

## Proposed platform correction and remaining investigation

The authorized run required two private deployment adaptations. Make their
approved intent reproducible in the owning platform How before implementing:

1. Express the existing proxy hostname to `127.0.0.1` extra-host mapping in list
   syntax supported by installed Compose. Test actual generated Podman argv;
   `config --services` did not catch malformed `--add-host` output. Keep the
   target and networking restrictions unchanged.
2. Declare `thought-khoral-agent-gateway` as a DNS alias of its actual network/PID
   namespace owner on the existing agent-internal network. A container sharing
   that namespace does not independently supply the required DNS entry. Test
   actual broker-to-mediator private-DNS and authenticated catalog access. Add no
   network, routable service, port or admission authority.
3. Diagnose the unexpected Codex namespace-watchdog shutdown separately in an
   owned provider-free fixture. Owner exit stopped proxy and worker as designed;
   the triggering policy/proxy condition is not established. Current container
   states show no OOM flag and kernel OOM entries predate this attempt. Do not
   claim OOM as the cause, relax timeouts/policy checks, or bypass fail-stop to
   obtain acceptance. If fixing it requires a security-design change, prepare a
   separate concrete amendment before changing that behavior.
4. Investigate the mediator's separate later exit 1 without attributing it to
   the Codex watchdog. Preserve fail-closed admission and record its cause and
   readiness independently before restarting changed inputs.
5. Compare actual worker-advertised reasoning options with the mediator's
   admission set. The current operator policy is medium-only while the pinned
   catalog offers more options. Treat any mismatch as a distinct configuration
   issue after native adapter discovery works; retain `gpt-6.1-sol`/`medium` as
   defaults and do not infer live model/account availability.
6. Establish the existing volume's actual schema before upgrade: it has earlier
   room/task tables, lacks conversation tables, and its migration ledger is
   empty. Image `/docker-entrypoint-initdb.d` scripts do not upgrade an initialized
   volume. Prepare an owner-only backup, restore it into an isolated private
   database and validate the already approved 0006/0007 migrations and retained
   data/constraints there. Do not rerun all earlier migrations blindly, delete
   the external volume or apply an unreviewed upgrade to existing data. Present
   the concrete verified upgrade for separate approval before applying it to
   the existing volume. Include actual schema readiness in package preflight.

## New acceptance inputs and gates

Do not retarget published contracts, the current frozen profile, worker image or
historical fake/candidate/live inputs. After local correction/review, prepare a
separately named `packaged-v1.1-runtime-compat` profile with the new exact worker
source/image and actual clean platform runner. Preserve all other compatible
frozen component commits unless evidence justifies a separately reviewed change.
Review the new profile and package evidence before activation against it.

Approval of this proposal permits only the bounded local implementation,
provider-free tests, package preparation and watchdog investigation described
above. Source/image publication, activation of changed inputs and provider/tool
calls retain their existing separate gates. Keep the current live Codex side
disabled until its readiness/isolation prerequisites are established. Record
each missing gate explicitly; this proposal does not accept P1–C1 or Task 9.
