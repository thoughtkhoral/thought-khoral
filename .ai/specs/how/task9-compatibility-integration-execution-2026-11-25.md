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

## Progress

Approval is recorded before integration. Source publication, merged-tree checks,
CI status and final documentation reconciliation are pending execution.
