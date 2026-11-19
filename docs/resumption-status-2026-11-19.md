# ThoughtKhoral resumption checks — 2026-11-19

This report records a fresh local investigation and approved follow-up against the
[approved conversation plan](../.ai/specs/how/codex-room-conversations-implementation-plan.md).
It is execution evidence, not milestone acceptance. No push, release,
or live provider call was made.

## Latest checkpoint: Linux CI implemented locally

The maintainer approved the [focused Linux acceptance How](../thought-khoral-codex-agent/.ai/specs/how/linux-worker-acceptance.md).
Specifications were committed before code: worker `5fd884e`, root `8842802`.
Worker implementation `9bcdbde` adds four native AMD64/ARM64 Rust 1.85.0/1.93.1
test cells and two dependent final-lock production-package/CLI-capture jobs,
with immutable test pins, bounded evidence and ownership-scoped cleanup.
These commits are local and unpushed, alongside the earlier maintenance commits.

All 15 offline helper tests pass. Independent review found an acceptance gap
where infrastructure failures could count as tamper refusal; tests reproduced
it before the fix. Exact worker refusal and completed non-OOM container state
are now required, with no remaining material finding in final static review.
Both actual Rust versions pass all 46 worker tests on macOS ARM64. The minimum
suite's initial process-cleanup sandbox denial cleared on an authorized rerun.
Fmt/clippy, pins/legal/catalog, documentation (120 local links), actionlint
1.7.12 and root hierarchy/reference/identity checks pass.

Next is authorized source publication and execution of all six native Linux
jobs, followed by reviewed run URLs/artifact digests. **Native Linux acceptance
remains open.** No local containers were started; no source was pushed or CI
dispatched. Packaged-stack/browser/live, contract publication and release gates
also remain open. Later sections retain the earlier investigation checkpoints;
this section supersedes their historical next-action lists.

The [specification audit](../.ai/specs/how/spec-driven-maintenance-audit-2026-11-19.md)
maps every changed implementation/data file to its accepted amendment,
existing What requirements, approval record and verification evidence. It
also records repaired root/platform discovery links and the limits of the
automated hierarchy check.

## Local commit handoff

The maintainer requested local commits with descriptive comments before any
push. Governing specifications were committed before implementation in each
affected repository. The following commits are local and have not been pushed;
this table is not a claim that their objects exist on GitHub.

| Repository | Commit purpose | Local commit |
| --- | --- | --- |
| Root governance | Specification audit and coordination | `acf49d2edb49ce63665abcfb7132f1acd1bc6bde` |
| Codex worker | Accepted specifications | `dcad1ff0472099e3c731651a93853d371838af2a` |
| Codex worker | Implementation, dependency lock and legal evidence | `429f6be81032bb1e489f1a7e61314518b1140763` |
| Platform | Accepted specifications | `af14f5ef365ae8fc2a39890873aabc04d751d7cc` |
| Platform | Container build corrections | `74ac640a903ae7a3e3a043ef5f04ef5b4b1e4254` |

The root README/report handoff is committed after these references are recorded.
Each component implementation commit includes its governing spec and existing
issue references, rationale and validation results. Fresh pre-commit worker
tests passed (46 tests, Rust 1.93.1); the unchanged approved lock's prior final
Rust 1.85 suite passed 46 tests. Offline platform source-staging/Compose/input,
specification/reference/identity, formatting, artifact/legal and documentation
checks passed. No test containers were started for this commit preparation.

## Current state after Rust 1.85 approval

The maintainer approved the additional
[Rust 1.85 correction](../thought-khoral-codex-agent/.ai/specs/how/rust-185-lock-compatibility-proposal.md).
The exact tested lock is now applied: `yoke-derive 0.8.2`, unchanged
`yoke 0.8.3`, and additional `synstructure 0.13.2`. All 276 locked registry
packages and archive checksums match the refreshed inventory; 478 retained
legal files verify. The new legal files were extracted from checksum-verified
crate archives, retaining their original bytes.

Final-source tests passed on both actual Rust 1.85.0 and 1.93.1 on macOS ARM64:
46 passed, zero failed on each. Independent review confirmed the exact approved
lock, all package/checksum entries, and original legal bytes.
Formatting, clippy with denied warnings, contract pins, legal inventory,
documentation, catalog-policy and capture-helper checks also passed.
The previously tested Linux images and default-stack smoke below belong to the
earlier dependency lock; they are not final-lock Linux verification. All eight
default-stack containers were subsequently stopped and removed at the user's
request, preserving the external database volume. No containers are started
for this compatibility correction.

## Earlier approved package corrections

The maintainer approved both bounded corrections after the initial review:

- The worker now pins a separate actual-binary x86_64 proof and selects its
  embedded and installed evidence by build architecture. Exact-byte/digest
  checks and the unchanged mandatory CI package gate remain in force. Capture
  overrides require immutable image IDs and the requested target platform.
- Platform build stages now copy the existing gateway contracts into both
  gateway and reference-agent images, and the existing UI contracts and scripts
  into the UI image. All three actual image builds and default Compose startup
  passed without bypassing the contract checks.

All 46 updated worker tests, fmt, clippy, 144 contract/runtime artifact pins,
legal inventory, documentation, catalog checks, and three capture-helper tests
passed. The updated capture harness reproduced the pinned ARM64 proof byte for
byte. Independent review found no outstanding issues after adding exact capture
image provenance. At this earlier checkpoint the worker dependency lock and all
room contracts were unchanged.

Fresh worker package admission passed for both local targets:

| Target | Image | Verification |
| --- | --- | --- |
| Linux ARM64 | `sha256:3f46c52e8615df74247590bc40e4aa3c36c33263b095e9f770625be468db3d52` | All ten actual-image startup/refusal checks passed. |
| Linux x86_64 | `sha256:586f436750780f040f896476c7ebe0e407cc05c4070e37c1d0e81dc210623072` | Actual package admission passed under CPU emulation; another architecture's proof, altered controls, and altered catalog were rejected. |

The explicit-target x86_64 capture also reproduced its committed proof exactly
using the new worker image and Python harness
`sha256:cf2dad23925ed51a00735f57606b2998aedf4705a1634cb9ae1053b5c145d5ba`.
The worker's approved amendment records exact provenance and commands.

After the package changes, the pinned provider-free composed defaults runner
passed again: 24 synthetic turns, six recovery boundaries, 12 rendered jsdom
UI lifecycle phases, four read-only defaults checks, and three settings-mutation
cases. Its retained state is
`/var/folders/70/5kxy5kys3bj0252chp3ck8900000gn/T/Task9-codex-conversation-z86Gbw`.
This runner continues to use its exact reviewed fixture revisions listed below;
it is independent of the new images' actual package-admission evidence.

The default-stack scripted smoke initially reached a fresh HTTP/WebSocket PKCE
login and room entry, then encountered token HTTP 500 errors. A retry encountered authorization
HTTP 500 errors. Keycloak was confirmed OOM-killed while concurrent image builds
shared the VM; a worker compiler was also killed. The stack was stopped without
deleting its external database volume, and subsequent builds are serialized with
one Cargo build job. At that point the default-stack smoke had not passed.
After the worker builds and composed checks finished, a default restart without
builds and an exclusive `scripts/smoke.sh` run passed, exit 0. It verified all
service readiness, kernel egress, fresh HTTP/WebSocket PKCE room entry, hidden
targeted-message exclusion, and both human-invoked A2A skills with ordered
progress and exactly one cited terminal result. The initial OOM failures remain
retained as historical failed runs; they do not invalidate this separate pass.
The eight default services were initially left running at `http://localhost:8082`, with
seven declared healthchecks healthy and the agent gateway running without a
declared healthcheck. The external database volume is intact; Codex is disabled.
Final logs are `platform-default-smoke-final.log`, `platform-final-services.log`,
and `platform-final-images.log` in the evidence directory.

Rendered-browser visual validation remains unverified. Chrome DevTools could
not access its profile connection metadata because of a permission denial,
and the in-app browser access host was unavailable. No permission or browser
security setting was changed. The default smoke uses Node HTTP/WebSocket,
and the composed UI checks use rendered jsdom; neither is a real-browser claim.

The emulated x86_64 compiler itself crashed even on version inspection. The
passing local x86_64 image was cross-compiled with the working ARM64 compiler.
Both target builds used one Cargo job and the existing checksum-pinned local
CLI release archives because the build container's GitHub TLS chain could not
be verified. Archive/schema checks were preserved and no TLS verification was
disabled. These results cannot establish native x86_64 CI acceptance.

A separately isolated Rust 1.85 candidate pins only `yoke-derive 0.8.2`, retains
`yoke 0.8.3`, and adds its `synstructure 0.13.2` dependency. It passed all 46
tests on actual Rust 1.85/macOS ARM64. The
[concrete compatibility amendment](../thought-khoral-codex-agent/.ai/specs/how/rust-185-lock-compatibility-proposal.md)
was subsequently approved and applied as recorded in the current-state section.

## Initial review checkpoint

The remaining sections preserve the initial review before the corrections were
approved or implemented. At that checkpoint no runtime code, lockfile, published
contract, service policy, or provider configuration had been changed.

## Outcome

The retained provider-free conversation integration still passes after restoring
its exact pinned temporary sources, candidate archive, and UI dependencies.
The actual ARM64 worker package and isolated network-policy checks also pass.
The default packaged stack cannot start from current sources because two
container build recipes omit files introduced by the conversation integration.
The declared Rust 1.85 worker compatibility gate also fails in a locked dependency.
The x86_64 worker CI package failure is reproduced and its missing capture
evidence has been collected outside the repository; the verifier is unchanged.

## Fresh checks

| Check | Result and boundary |
| --- | --- |
| Worker `cargo test --locked -- --test-threads=1` | Passed: 46 tests on macOS ARM64, Rust/Cargo 1.93.1. |
| Worker fmt and clippy with warnings denied | Passed. |
| Worker contract pins, dependency notices, documentation, and catalog policy | Passed: 143 pinned files, 477 legal files for 275 locked crates and Ratatui, 103 local Markdown links. |
| Retained ARM64 image `--verify-package` | Passed for image `sha256:2d8bfade27802f910cf68e832722c93b4a2acc2addb825711e1223617a4cd385`; no inference. |
| Actual image/startup tests | Passed all 10 checks, including absent/shared credentials, imported native config/auth, ownership/mode, mutable tag, wrong CLI version, and stale admission refusal. |
| Conversation runner checks | 13 live-mode/guard tests and 3 process-cleanup tests passed. |
| Defaults pin/candidate tests | All 26 passed after regenerating the exact missing candidate artifact. |
| Composed `--fake --defaults-candidate` | Passed: 24 synthetic native turns, six crash/commit boundaries, history/targeted/cross-room isolation, 12 rendered UI lifecycle phases, four read-only defaults authorization/cache checks, and three settings-mutation cases. |
| Compose/input/startup/bootstrap checks | Passed: three Compose tests, one input test, one host startup test, and bootstrap admission checks. |
| Proxy and isolated kernel checks | Four proxy tests passed; actual IPv4/IPv6/direct-provider denial, exact CONNECT with controlled verified TLS, and proxy/policy-loss shutdown passed. |
| Root specification/reference/identity checks | Passed. |
| Default Compose build/start | Failed before services started: agent-gateway image omits conversation schemas. |
| Independent UI image build | Failed in prebuild: required contract-verification script absent from image build stage. |
| Worker Rust 1.85 check | Failed in locked `yoke-derive 0.8.3`; see below. |
| Real provider, browser/Keycloak, full packaged Codex acceptance | Not run; existing gates remain open. |

The initial candidate-pin run began before archive restoration and reported two
missing-artifact failures; the subsequent complete 26-test pin suite passed.
The first composed candidate attempt collided with concurrently running cleanup
fixtures on fixed ports; its sequential rerun passed. The kernel fixture first
encountered an AMD64 base-image cache selection from the reproduction probe;
restoring its required ARM64 base resolved that environment mismatch.

## x86_64 package rejection

The latest [GitHub runtime failure](https://github.com/thoughtkhoral/thought-khoral-codex-agent/actions/runs/37699754057)
is consistent with the approved ARM64-only capture gate: the verifier embeds
only `tool-policy-proof-aarch64.json`, while the installed x86_64 CLI has a
different executable digest. A disposable image using the actual x86_64 CLI
and current evidence reproduces `runtime_unavailable`. The retained ARM64 image
passes the same check.

The pinned x86_64 release archive checksum was verified as
`306865417d4ee7a927785852910a527f41e1e159add390ac5ae3accb67d44a13`.
The executable digest is
`12eb3e81114588aca3b7998f4f19e8997b056aca08e57a7ca7c8a3ec8c652aad`.
Its actual isolated HTTP/SSE capture passed 44 model/effort cases, fresh-process
resume, empty nested tool arrays, and six unsolicited-tool refusals. The proof
differs from ARM64 only in `cliSha256`; its file digest is
`db8557b9f852583002397827c28e8f76078f02d4aabbfad2aecfe6617ab20c58`.
The x86_64 executable ran through local CPU emulation in the Linux ARM64 Podman
VM. This establishes actual-binary synthetic behavior under emulation; native
x86_64 CI package acceptance remains unproven.

The external capture is at
`/private/tmp/thought-khoral-resume-2026-11-19/x86-capture/result/tool-policy-proof-x86_64.json`.
The [bounded worker amendment](../thought-khoral-codex-agent/.ai/specs/how/x86-package-evidence-proposal.md)
proposes adding and selecting architecture-specific immutable evidence while
retaining the current checks. It awaits approval; no verifier change was made.

## Packaged-stack failures

At platform `f07065c4a17636871b3b8f01d7642b6cd0554db3`, default Compose image
preparation fails because `containers/agent-gateway.Containerfile` omits
`thought-khoral-agent-gateway/contracts/`. Six compile-time schema imports fail.
The independent UI build also fails: `containers/ui.Containerfile` omits its
`scripts/` and `contracts/` directories, so the mandatory contract prebuild
checker cannot load. The local UI build log is at
`/private/tmp/thought-khoral-resume-2026-11-19/ui-build.log`.

The [packaging correction proposal](../thought-khoral-platform/.ai/specs/how/package-build-inputs-proposal.md)
lists the three missing COPY directives and real-image validation. It awaits
approval. No app containers are running, and the existing database volume was
not started or deleted. Some local development image tags were rebuilt before
the agent-gateway build stopped.

## Minimum Rust version

The worker declares Rust 1.85. A fresh isolated-target check with actual
Rust 1.85.0 fails in `yoke-derive 0.8.3`, `src/lib.rs:202`, where
`str::from_utf8` is unavailable on that compiler. This is an actual compiler
failure despite the locked dependency metadata not declaring a newer floor.
The dependency arrives through yoke/ICU/idna and the schema/HTTP/storage graph.
No dependency was downgraded or patched, and the declared minimum was not raised.
macOS ARM64 is the tested minimum-version target; Linux minimum-version
execution remains outstanding too.

## Retained synthetic source evidence

The passing composed run used the unchanged reviewed revisions:

| Component | Revision |
| --- | --- |
| Contracts candidate | `1ea828f28725ddaaefa21d083473f9abbd777975` |
| Broker | `2e7d23b467c572819f498c3b9bf14d74a62dc821` |
| Mediator | `6c3d96b4763871b9addc9bc7223e71ee7d38abd9` |
| Worker | `b0d43ec2b5b0c8da035d4ccff754545132b978d4` |
| UI | `79e5e7310a450efea561548cd87871446c1939aa` |

Source snapshots were restored as local disposable clones in the runner's
recorded `/private/tmp/codex-conversation-final-fix/` and
`/private/tmp/codex-conversation-defaults/` locations. The rebuilt archive and
external lock exactly match their existing anchors. The passing composed state
and per-case evidence were retained at
`/var/folders/70/5kxy5kys3bj0252chp3ck8900000gn/T/Task9-codex-conversation-hTBtLx`.

## Initial investigation's next actions (historical)

Approve the bounded worker evidence and platform build-input proposals before
changing implementation, as required by the repository specification-first
rule. Apply and verify those corrections, then investigate a compatible locked
dependency set for Rust 1.85. Resume actual packaged-stack/browser acceptance
after its image builds pass. Live Codex activation and provider checks still
require their separately configured and authorized operator run.
