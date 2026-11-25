# Compatibility source integration execution — 2026-11-25

Authority: explicit maintainer approval of the
[reviewed three-repository plan](task9-compatibility-integration-proposal-2026-11-25.md).
Integrate and publish the reviewed workspace, worker and platform source using
fast-forwards. Preserve frozen artifacts, images, profiles and evidence; keep
activation/provider/tool permissions false and all existing state intact.

## Approved source bindings

| Repository | Expected canonical and origin main | Approved source |
| --- | --- | --- |
| Workspace | `12a79911a09db0a47119bda3a03655f34a2cc39d` | `bddd99f66b73c6a4d4795794b2e0b46ece4e0ee9`, followed only by this approval/execution record and approved status reconciliation |
| Worker | `ae12605c75c33a5d6fedb5e4cc1ac0c30f93a5d8` | `423d4e84985eb535caa66c7522c4191c6dbccad6` |
| Platform | `ebc654e9ab96b72a614a344cee258d428b334dfd` | `60ec83c06b1e4bbffcd5bdd69aee6575608e5e3a` |

Record the actual clean workspace approval commit and refreshed origin refs in
the private operator packet before any merge. Reject remote drift, dirty trees,
unexpected source additions or non-fast-forward ancestry. Publish the workspace
companion first, then verify each child fast-forward and quality gates before
its source push. Record actual worker CI URLs/status without inferring success.

The last accepted runtime evidence remains the provider-isolated 662.743-second
check. This operation does not restart/recreate containers, renew admission,
publish registry images/tags/releases, migrate data, browse the UI or make
model/tool/provider calls. Branches/worktrees and private recovery records are
preserved for later acceptance.

## Published source results

All three approved source updates are integrated and pushed. The workspace
companion was published first at `5e0aac736bdc2dd621be168de542d606567259e3`.
Worker main is `423d4e84985eb535caa66c7522c4191c6dbccad6`; platform main is
`60ec83c06b1e4bbffcd5bdd69aee6575608e5e3a`. Each fast-forward produced its exact
approved source ID and tracking origin matched after the acknowledged push.
The root approval/evidence/status reconciliation follows as documentation-only
commits under the same approval; its final clean tip is recorded separately.

Merged-tree validation passed 50 worker tests, formatting, warnings-denied
locked/offline Clippy, contract/legal/documentation/catalog checks, 54 platform
guards and five Compose tests. The integrated workspace had 1,506 checked
Markdown links and no broken links; root hierarchy, references, identity and
negative regressions pass. Frozen profile hashes and production image inputs
remain byte-identical. Worktrees/branches and unrelated untracked files are kept.

## Actual CI observation

Worker CI for the published `423d4e8` source is **passed (four native runtime jobs, both package/capture jobs and documentation)** at the recorded
snapshot. Actual workflows:

- [Provider-free runtime](https://github.com/thoughtkhoral/thought-khoral-codex-agent/actions/runs/45673007315)
- [Documentation/specification checks](https://github.com/thoughtkhoral/thought-khoral-codex-agent/actions/runs/45673007526)

The [sanitized publication receipt](../../../docs/evidence/task9-compatibility-integration-2026-11-25.json)
records each run/job status and its observation time. Pending jobs are not native
acceptance. Existing CI produces bounded GitHub Actions evidence, not registry
image publication. Platform/root have no tracked CI workflow.

## Documentation and runtime scope

Current root specifications and derived workspace/project status now report
actual canonical source publication. Older local/unmerged descriptions, including
dated child checkpoint notes, retain their historical scope and are superseded
by this source-publication checkpoint. Historical test/image/runner source IDs
are preserved, including actual timed-readiness platform source `f51ec3e`.

This operation did not activate/recreate containers, renew admission, migrate
existing data, change tags/releases or call models/tools/providers. The last
accepted runtime checkpoint left Codex/mediator off and seven base services
available. Browser, provider/live and aggregate Task 9 acceptance remain open.

A final read-only engine check confirms exactly seven healthy base services,
with all seven IDs matching the accepted readiness receipt and no running
Codex/mediator. Independent review found no actionable reconciliation issue.
The final documentation check covers 1,523 Markdown links with zero broken links;
hierarchy, repository references, identity and patch-format checks pass.
