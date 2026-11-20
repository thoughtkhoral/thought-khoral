# Current workspace state

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
