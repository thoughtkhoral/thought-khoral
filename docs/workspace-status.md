# Current ThoughtKhoral workspace

Updated 2026-11-20 from the [workspace-state specification](../.ai/specs/how/workspace-state.md)
and [coordinated acceptance record](../.ai/specs/how/codex-room-conversations-implementation-plan.md).
This is the starting point for resuming work in this checkout. It separates
published artifacts, canonical runtime sources and verified local branches.

## What is complete

- Conversation **v1.1.0 is published** at `f1c8621`. Freshly downloaded TAR,
  release lock, sidecar and all 156 payload files match the reviewed hashes.
  The published source includes the approved fast-uri 3.1.9 correction.
- Released-defaults broker/UI consumers are **implemented and reviewed locally**.
  Broker source `673294e` passed 160 tests with one intentional external-agent
  ignore; UI `29a9400` passed 193 tests with one composed skip plus typecheck/build.
- Platform profile `996e188` fixes the exact released contract, six source
  inputs and verified local ARM64 image. Its 46 new/retained guards pass. Actual
  package/startup probes, byte-identical native capture and credential-free
  image/source preflight passed, with owned containers removed.

See the [release report](task9-release-preparation-2026-11-20.md) and
[profile-preparation report](task9-packaged-profile-preparation-2026-11-20.md)
for immutable source, image, proof, profile and artifact identities. Counts are
retained results from those exact inputs; this documentation refresh does not
claim new runtime execution or assembled-stack acceptance.

## Which checkout contains what

| Location | Runtime content |
| --- | --- |
| Root | Governance, current specs/docs and cross-project evidence; no embedded runtime |
| Canonical contracts main | Historical candidate tooling/lock; published release source is a separate pushed branch/tag |
| Canonical broker/UI mains | Existing candidate imports; released imports are not merged here |
| Canonical platform main | Historical runner; the new profile option is in the prepared branch |
| `.worktrees/task9-broker-release` | Released consumer implementation; documentation may have later commits than frozen `673294e` |
| `.worktrees/task9-ui-release` | Released consumer implementation; documentation may have later commits than frozen `29a9400` |
| `.worktrees/task9-packaged-profile` | Prepared profile/runner; documentation may have later commits than implementation `996e188` |
| `.worktrees/task9-contract-release` | Published release/evidence source branch; documentation followups do not retarget `f1c8621` |

All projects remain independently versioned. Documentation-only commits do not
merge prepared runtimes, republish artifacts or change lifecycle/maturity.
The three prepared consumer/platform branches remain local and unmerged.

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
the profile. Use prepared-branch verification instructions for that runner;
canonical-main commands retain their historical behavior.

## Next work and limits

Publish/integrate the reviewed prepared sources, then complete the assembled
packaged-stack, private-DNS/readiness and real-browser checks. Provider turns,
multi-human continuation/reset, runtime settings/usage and live tool/egress
verification require the separately configured and authorized operator run.
No application stack or provider has been activated by this documentation task.

Memory remains an incubating in-memory/provenance proof, separate from Codex;
Cognee, durable memory, guided directories and open remote admission remain
deferred. Full Task 9, registry-image and production acceptance remain open.

## Maintaining this view

Update the applicable specs and accepted evidence first, then derive this guide
and the component pages. The [documentation reconciliation](../.ai/specs/how/documentation-reconciliation-2026-11-20.md)
records coverage and validation. Current tooling checks authored Markdown,
source links, hierarchy and identity; it does not generate prose or rewrite
specifications. Historical evidence and original anchors are retained.
