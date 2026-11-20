# Task 9 released consumers and packaged profile preparation

> Current checkout guidance: the [workspace guide](workspace-status.md) records
> documentation-only followups and preserved clean runtime snapshots. Frozen
> implementation/artifact identities below remain unchanged when branch HEADs
> advance for documentation; earlier pending-state sections are historical.

Status: locally implemented and reviewed on 2026-11-20 under the maintainer's
“proceed” after [v1.1 publication](task9-release-preparation-2026-11-20.md).
The [approved acceptance procedure](../.ai/specs/how/task9-packaged-acceptance-2026-11-20.md)
governs the remaining packaged/browser/live gates. No application stack or
provider was activated by this work.

## Exact local sources

| Owner | Isolated branch | Verified implementation commit |
| --- | --- | --- |
| Broker | `codex/task9-broker-release-20261120` | `673294e66fed2b6e98d73e08cfe4a23a0e5e4d48` |
| UI | `codex/task9-ui-release-20261120` | `29a940012adfeb796f59c5b89b00cab7a4d0df68` |
| Platform | `codex/task9-packaged-profile-20261120` | `996e1887234b8958a315279aa3d5aa194a7fad52` |

Local worktrees are `.worktrees/task9-broker-release`,
`.worktrees/task9-ui-release` and `.worktrees/task9-packaged-profile`.
Each owning specification was committed before code. Independent review found
no actionable issue in the consumers, root identity exceptions or profile.
These three branches remain unpushed and unmerged; canonical mains retain their
previous consumers/runner. The published contracts tag is unchanged.

## Consumer transition

Both consumers vendor the exact 156-file published v1.1 payload and lock
`b7f3ad928c5c17be7e936da4959b7e7e8555bb4ed3602fa62f71a8721f042d8f`
in `contracts/agent-conversation-v1.1/`. Production resolved-settings schema
imports now use that released directory. Historical v1.0/candidate vendors,
dependency locks, retained fixture sources and wire behavior are unchanged.
Broker integrity tests and UI pretest/prebuild checks validate exact provenance,
file/directory sets and hashes, rejecting tampering, extra/missing entries and
symlinks. Root identity regressions allow only four exact new ordinary-event
wire fields and one retained synthetic authentication-constructor line.

Broker full serial suite: **160 passed**, one intentional external-agent ignore,
with an isolated migrated PostgreSQL fixture removed afterward. UI: **193
passed**, one intentional composed-test skip, TypeScript and production build
passed; the existing Vite chunk-size advisory remains. RED/GREEN evidence covers
missing release artifacts, empty-directory refusal and narrow identity rules.

## Prepared acceptance profile and actual image

The platform profile is
`scripts/fixtures/codex-conversation/packaged-v1.1-pins.json`, SHA-256
`7106f7e41a6bc13feab8a0b51fccde9b47fefca2d63980d551ed929eac1c1a71`.
It binds six exact source commits, released contract provenance, CLI/proof/lock
hashes and local immutable Linux ARM64 image
`sha256:2dd78cdf5eddb9ca271611998ea44fe6d6cfde6cfca8ba7d1d6c8858240b540d`.
The unchanged production Containerfile was built from worker `3f0318b`, final
Cargo lock `1c70ff10992b000c93232155ca0032cab9b7a6c27a13ca4ac46eba862e864a34`,
one Cargo job, and measured source/lock labels. The image is local, not a registry
publication or a claim of another platform architecture's acceptance.

All ten actual package/startup probes passed. The actual CLI recaptured the
committed ARM64 proof byte-for-byte: 44 model/effort cases across eight models,
resume and six unsolicited-tool refusals, without provider inference. The new
profile's image/label/package/CLI/proof checks also passed against an actual
network-none container running only sleep; its owned container was removed.
This probe reproduced Podman's bare-versus-prefixed image-ID format; a failing
regression preceded exact full-digest normalization. Tags and partial IDs remain
refused. The first failed probe is not counted as acceptance.

All **46** profile/retained tests pass: seven new profile tests, 13 historical
live guards and 26 candidate-pin tests. Synthetic CLI integration covers both
selected and historical positive preflight through the terminal gate and early
packet mismatch refusal without engine contact/output. A final read-only check
also validated the actual platform and all six clean source checkouts, including
a detached contracts worktree at frozen release source `f1c8621`.

The platform source retains
`docs/evidence/task9-packaged-profile-2026-11-20.json`. Raw synthetic logs,
byte-identical proof and actual-image/source observations remain under
`/private/tmp/thoughtkhoral-task9-consumers-20261120/`. No private credentials,
provider keys, human tokens or native sessions are committed.

## Remaining gates

The operator example keeps approvals false and its platform revision deliberately
invalid until replaced with the actual clean executing commit. Existing private
packet/path/loopback/distinct-human/interactive guards remain. The new live CLI
requires explicit `--acceptance-profile packaged-v1.1`; historical modes retain
their original pins and candidate-plus-live refusal.

Source publication/integration of the three prepared branches, assembled packaged
stack/private-DNS/readiness, configured operator credentials, real-browser checks
and separately authorized provider/tool/egress execution remain. No service
activation or whole Task 9 acceptance follows from these component, package and
synthetic preflight results. All owned database/package/probe containers were
removed; the existing external application database volume was not used.
