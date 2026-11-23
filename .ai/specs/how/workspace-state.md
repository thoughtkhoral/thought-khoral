# Current workspace state

## Current integration checkpoint — 2026-11-23

Latest activation result: the maintainer approved starting the reviewed stack
without model calls. Seven base services remain running; the mediator subsequently
stopped with exit 1, separately from the Codex namespace shutdown. Its cause is
not established. The Codex namespace
watchdog stopped its owner/proxy/worker and Codex remains disabled. Authenticated
catalog/defaults return 503 despite successful native CLI initialization/listing
in an isolated fixture: the worker rejects pinned startup-notification metadata.
P1 failed and rendered-browser coverage is unavailable. The [activation record](task9-integration-2026-11-23.md#authorized-activation-partial-failure--2026-11-23)
and sanitized evidence supersede the earlier ready/not-activated status below.
The [compatibility proposal](task9-runtime-compatibility-proposal-2026-11-23.md)
was subsequently approved for bounded local correction; isolated branches are
tracked by the [execution record](task9-runtime-compatibility-execution-2026-11-23.md).
The original frozen inputs remain unchanged. No room model turn was
requested, and the database volume is preserved.

The maintainer authorized the [planned source integration and Task C preflight](task9-integration-2026-11-23.md)
with “proceed”. The four reviewed branches are now integrated and pushed to
their component mains. Merge conflicts were limited to Markdown applicability
and status text; reviewed runtime, artifact and profile bytes are unchanged.

| Component | Integrated canonical main | Frozen acceptance implementation |
| --- | --- | --- |
| Contracts | `7e1555feab8ecb55bf57fa021dc1dc68a7b3f111` | Published release source `f1c8621810c8c121c1aafc8e5a342d6626c4b843` |
| Room gateway | `ad4d02561669ab2237f25be277e467937403cd03` | Released consumer `673294e66fed2b6e98d73e08cfe4a23a0e5e4d48` |
| UI | `3dc3ec73adf7bdd329fbf60edd317b980c7ed410` | Released consumer `29a940012adfeb796f59c5b89b00cab7a4d0df68` |
| Platform | `ebc654e9ab96b72a614a344cee258d428b334dfd` | Profile implementation `996e1887234b8958a315279aa3d5aa194a7fad52` |

Worker, mediator and memory runtime inputs remain unchanged. The six clean
component snapshots and profile remain authoritative for acceptance; canonical
documentation/integration HEADs are not substitutions. The executing platform
packet names its actual clean merge commit. The published v1.1 tag is unchanged.

Fresh verification on the reconciled trees passes contracts fixtures and
release/candidate suites, 160 broker tests with one intentional external-agent
ignore, 193 UI tests with one intentional composed skip, and 46 platform
profile/guard tests. UI TypeScript/build passes. Ten actual worker package/startup
probes pass and the actual native capture reproduces the retained ARM64 proof
byte-for-byte. Independent review found no actionable integration blocker.
Owned database/package/capture fixtures were removed; the external database
volume is preserved. These remain component/provider-free evidence.

Latest operator checkpoint: existing shell Codex API authentication and its
`gpt-6.1-sol`/`medium` setting now provision the isolated worker without a new key
or host login/config/session import. Five actual real-input/state/Compose
preflight checks pass. An engine-native state volume satisfies ownership where
macOS shared directories did not. [The execution checkpoint](task9-integration-2026-11-23.md#existing-shell-authentication-reused--2026-11-23)
and sanitized cached-auth evidence supersede the earlier missing-configuration
state. Inputs are ready for separate activation review; no stack/provider is
activated. Human login tokens and runtime readiness follow authorized startup.

Nine exact-source production images are built and the reviewed worker image is
available. Actual image/source/package preflight passed; the private packet,
operator environment and immutable Compose image override are prepared. The
[earlier execution record](task9-integration-2026-11-23.md#execution-checkpoint--2026-11-23)
and sanitized evidence retain complete image/source identities. Assembled-stack,
private-DNS, real-browser, live-provider/tool/egress and Task 9 acceptance remain
open. Activation and provider approvals have not been asserted. Memory/guidance,
registry-image publication and production deployment remain separately scoped.

## Historical reconciliation — 2026-11-20

The following retained source map and preparation results describe the earlier
checkpoint. Its local/unmerged descriptions are superseded by the integration
table above; its frozen artifact/source identities remain unchanged.

Status: reconciled on 2026-11-20 under the maintainer's request to update specs
first and derive documentation from them, including the current workspace.
This view records accepted work; it adds no product or runtime scope. The
[coordinated plan](codex-room-conversations-implementation-plan.md), component
Hows, immutable artifacts and attributed evidence govern their exact claims.

## Repository and checkout boundaries

ThoughtKhoral consists of this governance repository, seven independently
versioned components and the organization `.github` checkout. Root owns
cross-project context; components retain runtime and
documentation ownership. Catalog lifecycle/maturity values are unchanged.

| Component | Canonical runtime baseline | Additional verified source |
| --- | --- | --- |
| Contracts | `205b453`; historical candidate tooling/lock | Published v1.1 source `f1c8621810c8c121c1aafc8e5a342d6626c4b843`; release/evidence branch published |
| Room gateway | `248f059`; candidate defaults import | Released consumer `673294e66fed2b6e98d73e08cfe4a23a0e5e4d48`, local unmerged branch |
| UI | `2cfb8c1`; candidate defaults import | Released consumer `29a940012adfeb796f59c5b89b00cab7a4d0df68`, local unmerged branch |
| Platform | `26462d7`; historical runner | Profile implementation `996e1887234b8958a315279aa3d5aa194a7fad52`, local unmerged branch |
| Worker | `3f0318b40af8d5c9c47cc43e975b3db4836df983` | Native CI source `9bcdbde`, retained by `8d233e4`; verified local final-lock ARM64 image |
| Agent gateway | `48a72bcd6a8c668004e10fe2ae3cd01cdaf9361c` | Compatible published-v1.0 mediation; no new runtime changes |
| Memory engine | `7b4651839d1fbb41b426f80ca34712669da667f1` | Incubating in-memory/provenance proof; no Codex memory integration |

These are runtime-input revisions, not promises that documentation-only HEADs
equal them. The three implementation branches are
`codex/task9-broker-release-20261120`, `codex/task9-ui-release-20261120` and
`codex/task9-packaged-profile-20261120`. They remain local/unmerged. The contracts
branch `codex/task9-contract-release-20261120` and its exact release tag are
published; contracts main has not merged that source. Documentation followups
may advance these checkouts without changing frozen acceptance inputs.

## Published release and local preparation

Conversation v1.0.0 remains immutable. Additive v1.1.0 was published with explicit
authorization at `2026-11-20T14:44:18Z`, tag source `f1c8621`. TAR SHA-256 is
`b0370e43627ce6044852df75bfbc4b749d904aa9cedcfc558c61bb4e07dc95ff`;
release-lock SHA-256 is
`b7f3ad928c5c17be7e936da4959b7e7e8555bb4ed3602fa62f71a8721f042d8f`.
Fresh downloads and all 156 payload hashes verify. The published source includes
approved fast-uri 3.1.9; source/extracted tests and online audits passed. Canonical
contracts main still retains its earlier lock/tooling.

Released broker/UI consumption is implemented and reviewed locally, not pending
implementation. Publication/integration/deployment remain pending. Historical
v1.0/candidate vendors and dependency locks are unchanged. Retained component
results are 160 broker tests plus one intentional external-agent ignore, 193 UI
tests plus one composed skip, and TypeScript/build. Counts apply to the exact
local sources, not canonical mains or new documentation-only revisions.

The prepared profile SHA-256 is
`7106f7e41a6bc13feab8a0b51fccde9b47fefca2d63980d551ed929eac1c1a71`.
It fixes six component inputs and local Linux ARM64 image
`sha256:2dd78cdf5eddb9ca271611998ea44fe6d6cfde6cfca8ba7d1d6c8858240b540d`.
Ten package/startup probes, exact native capture (44 model/effort cases, eight
models, resume, six refusals), actual credential-free image/source preflight and
46 profile/historical-guard tests passed. The image is local, not registry
publication. All owned verification containers were removed without using the
external application database volume. No application stack or provider call
was activated. Packaged/private-DNS/browser/live/tool/egress and production gates
remain open; memory/guidance/remote admission remain separately scoped.

## Exact source preservation during documentation updates

Preserve source/profile/vendor/artifact bytes; do not integrate runtime changes
into mains through documentation work. Six clean component source inputs are
retained by `/private/tmp/thoughtkhoral-task9-doc-refresh-sources-20261120/source-paths.json`:
contracts uses its detached release checkout; broker/UI/worker/mediator/memory
use detached snapshots of the exact commits above. TASK9_*_REPO may point to
these paths after documentation HEADs advance. The executing platform commit
is measured separately, avoiding a self-referential profile pin.

The maintained workspace entrypoint is derived `docs/workspace-status.md`.
Current CI validates authored documentation; it does not generate prose or
rewrite specifications. The refresh includes root, all seven components,
organization profile and four Task 9 worktrees. Old evidence stays dated and
historical, with anchors preserved. Runtime scratch/token state is excluded.
