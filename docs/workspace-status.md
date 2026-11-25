# Current ThoughtKhoral workspace

Updated 2026-11-25 from the [workspace-state specification](../.ai/specs/how/workspace-state.md)
and [coordinated acceptance record](../.ai/specs/how/codex-room-conversations-implementation-plan.md).
This is the starting point for resuming work in this checkout. It separates
published artifacts, canonical runtime sources and verified local branches.

The approved [compatibility source integration](task9-compatibility-integration-2026-11-25.md)
is published: worker main `423d4e8`, platform main `60ec83c` and the companion
workspace records. All three paths were fast-forwards, merged-tree checks pass
and immutable profile/image bytes are unchanged. Worker CI is passed (four native runtime jobs, both package/capture jobs and documentation) at the
recorded snapshot. Browser/provider/live and Task 9 acceptance remain open.

The accepted [provider-isolated readiness run](task9-readiness-renewal-2026-11-25.md)
retains its original executing source: 662.743 seconds, 22 samples and no model
calls. It ended with Codex/mediator off and seven base services healthy; source
publication did not reactivate them. Older local/unmerged checkpoint text in
this workspace and dated child documents is superseded by the source record.

## What is complete

- Conversation **v1.1.0 is published** at `f1c8621`. Recorded 2026-11-20 TAR,
  release lock, sidecar and all 156 payload files match the reviewed hashes.
  The published source includes the approved fast-uri 3.1.9 correction.
- Released-defaults broker/UI consumers are **integrated and pushed to main**.
  Broker source `673294e` passed 160 tests with one intentional external-agent
  ignore; UI `29a9400` passed 193 tests with one composed skip plus typecheck/build.
- Platform profile `996e188` fixes the exact released contract, six source
  inputs and verified local ARM64 image. Its 46 new/retained guards pass. Actual
  package/startup probes, byte-identical native capture and credential-free
  image/source preflight passed, with owned containers removed. Its runner/profile
  is now integrated and pushed to platform main.

Retained 2026-11-23 integration verification passed contracts, 160 broker tests (one intentional
external-agent ignore), 193 UI tests (one intentional composed skip), UI
TypeScript/build and all 46 profile/guard tests. Ten actual package/startup probes
pass; native policy recapture matches the retained ARM64 proof byte-for-byte.
Independent review found no actionable integration blocker. These results do
not close assembled-stack, browser or live-provider acceptance.

See the [release report](task9-release-preparation-2026-11-20.md) and
[profile-preparation report](task9-packaged-profile-preparation-2026-11-20.md)
for immutable source, image, proof, profile and artifact identities. Counts are
retained results from those exact inputs. The [2026-11-23 integration procedure](../.ai/specs/how/task9-integration-2026-11-23.md)
records the earlier released-consumer integration; the
[2026-11-25 compatibility execution](../.ai/specs/how/task9-compatibility-integration-execution-2026-11-25.md)
records the current source publication.
The [integration/preflight report](task9-integration-preflight-2026-11-23.md)
records nine successful production image builds, actual image/source verification
and cleanup. Its latest checkpoint also records reuse of existing shell Codex
authentication and five passing real-input/state/Compose checks. The earlier
missing-configuration state was resolved. Later authorized startup partially
failed: seven services remain running, Codex is disabled and the mediator is
stopped. P1 failed and browser B1 is unavailable. The
[activation report](task9-activation-2026-11-23.md) records actual observations and
the proposed compatibility correction; it supersedes the earlier startup gate.

## Which checkout contains what

| Location | Runtime content |
| --- | --- |
| Root | Governance, current specs/docs and cross-project evidence; no embedded runtime |
| Canonical contracts main | Release tooling/evidence integrated at `7e1555f`; published tag remains frozen at `f1c8621` |
| Canonical broker main | Released imports integrated at `ad4d025`; acceptance source remains `673294e` |
| Canonical UI main | Released imports integrated at `3dc3ec7`; acceptance source remains `29a9400` |
| Canonical worker main | Compatibility adapter integrated/pushed at `423d4e8`; immutable worker image/source remain paired |
| Canonical platform main | Compatibility networking/schema/profile/firewall integrated/pushed at `60ec83c`; packet measures the actual clean executing commit |
| `.worktrees/task9-worker-runtime-compat` | Preserved exact worker acceptance source `423d4e8` |
| `.worktrees/task9-platform-runtime-compat` | Preserved published candidate `60ec83c`; actual timed-readiness runner was `f51ec3e` |
| `.worktrees/task9-broker-release` | Retained integrated branch; Markdown reconciliation preserves runtime bytes |
| `.worktrees/task9-ui-release` | Retained integrated branch; Markdown reconciliation preserves runtime bytes |
| `.worktrees/task9-packaged-profile` | Retained integrated profile/runner branch at `ebc654e` |
| `.worktrees/task9-contract-release` | Retained integrated release/evidence branch; tag `f1c8621` is unchanged |

All projects remain independently versioned. The earlier four integration commits and later worker/platform compatibility
candidates are pushed to their owning mains; prepared branches are preserved. Lifecycle/maturity and
published artifacts are unchanged. Older “unpushed/unmerged” wording is historical.

## Preserve exact preflight sources

The profile requires exact clean component commits. Documentation HEADs can
advance without changing those inputs. Before this refresh, clean detached
copies were retained and mapped in:

`/private/tmp/thoughtkhoral-task9-doc-refresh-sources-20261120/source-paths.json`

| Variable | Preserved source location |
| --- | --- |
| `TASK9_CONTRACTS_REPO` | `/private/tmp/thoughtkhoral-task9-contract-source-20261120` |
| `TASK9_BROKER_REPO` | `/private/tmp/thoughtkhoral-task9-doc-refresh-sources-20261120/thought-khoral-room-gateway` |
| `TASK9_UI_REPO` | `/private/tmp/thoughtkhoral-task9-doc-refresh-sources-20261120/thought-khoral-workspace-ui` |
| `TASK9_WORKER_REPO` | `/private/tmp/thoughtkhoral-task9-doc-refresh-sources-20261120/thought-khoral-codex-agent` |
| `TASK9_MEDIATOR_REPO` | `/private/tmp/thoughtkhoral-task9-doc-refresh-sources-20261120/thought-khoral-agent-gateway` |
| `TASK9_MEMORY_REPO` | `/private/tmp/thoughtkhoral-task9-doc-refresh-sources-20261120/thought-khoral-memory-engine` |

These temporary locations are local convenience, not durable published
artifacts. Recreate clean checkouts at the profile's immutable commits if needed.
Path overrides never change trusted revisions. The platform packet names the
actual clean executing platform HEAD; it is deliberately not self-pinned inside
the profile. Canonical platform main now supports explicit packaged-v1.1 profile
selection; component source overrides must still select the frozen inputs above.
For the separate `packaged-v1.1-runtime-compat` profile, keep the five unchanged
source pins and select worker `423d4e8`, available in its preserved compatibility
worktree. Platform main now contains both explicitly named profiles. Do not
replace historical proof source IDs with the current documentation/main HEAD.

## Next work and limits

Compatibility, firewall and existing-database prerequisites now have component
and provider-isolated timed readiness evidence. The [latest report](task9-readiness-renewal-2026-11-25.md)
records verified images, mounts, namespaces, private DNS, two-human reads,
continuous health/isolation sampling and final shutdown. Earlier partial attempts
remain historical evidence and were not relabeled as successes.

Worker/platform corrections and their root companion are integrated and pushed.
Worker CI is passed (four native runtime jobs, both package/capture jobs and documentation) at the recorded snapshot; consult the
[publication record](task9-compatibility-integration-2026-11-25.md) for actual run
links and results. Rendered-browser and separately approved provider/live
verification are the remaining acceptance work. No new API key is needed, and
source publication does not authorize reactivation. The UI's last verified base
address remains [localhost:8082](http://localhost:8082).

Memory remains an incubating in-memory/provenance proof, separate from Codex;
Cognee, durable memory, guided directories and open remote admission remain
deferred. Full Task 9, registry-image and production acceptance remain open.

## Project documentation

The [workspace documentation requirements](../.ai/specs/what/open-source-documentation.md)
require each project to maintain its own current documentation contract and a
derived documentation index. These links address canonical checkouts; prepared
branches have the same local paths with their own checkout applicability.

| Project | Documentation specification | Maintained documentation |
| --- | --- | --- |
| Contracts | [Documentation contract](https://github.com/thoughtkhoral/thought-khoral-contracts/blob/main/.ai/specs/what/public-documentation.md) | [Project index](https://github.com/thoughtkhoral/thought-khoral-contracts/blob/main/docs/README.md) |
| Room gateway | [Documentation contract](https://github.com/thoughtkhoral/thought-khoral-room-gateway/blob/main/.ai/specs/what/public-documentation.md) | [Project index](https://github.com/thoughtkhoral/thought-khoral-room-gateway/blob/main/docs/README.md) |
| Workspace UI | [Documentation contract](https://github.com/thoughtkhoral/thought-khoral-workspace-ui/blob/main/.ai/specs/what/public-documentation.md) | [Project index](https://github.com/thoughtkhoral/thought-khoral-workspace-ui/blob/main/docs/README.md) |
| Platform | [Documentation contract](https://github.com/thoughtkhoral/thought-khoral-platform/blob/main/.ai/specs/what/public-documentation.md) | [Project index](https://github.com/thoughtkhoral/thought-khoral-platform/blob/main/docs/README.md) |
| Codex worker | [Documentation contract](https://github.com/thoughtkhoral/thought-khoral-codex-agent/blob/main/.ai/specs/what/public-documentation.md) | [Project index](https://github.com/thoughtkhoral/thought-khoral-codex-agent/blob/main/docs/README.md) |
| Agent gateway | [Documentation contract](https://github.com/thoughtkhoral/thought-khoral-agent-gateway/blob/main/.ai/specs/what/public-documentation.md) | [Project index](https://github.com/thoughtkhoral/thought-khoral-agent-gateway/blob/main/docs/README.md) |
| Memory engine | [Documentation contract](https://github.com/thoughtkhoral/thought-khoral-memory-engine/blob/main/.ai/specs/what/public-documentation.md) | [Project index](https://github.com/thoughtkhoral/thought-khoral-memory-engine/blob/main/docs/README.md) |

Update the contracts first, then their page/source maps and README navigation.
The current worker contract covers its implemented runtime, and the agent
gateway contract covers both deterministic reference tasks and opt-in Codex
mediation. These documentation requirements do not expand runtime authority.

## Maintaining this view

Update the applicable specs and accepted evidence first, then derive this guide
and the component pages. The [documentation reconciliation](../.ai/specs/how/documentation-reconciliation-2026-11-20.md)
records coverage and validation. Current tooling checks authored Markdown,
source links, hierarchy and identity; it does not generate prose or rewrite
specifications. Historical evidence and original anchors are retained.
