# Compatibility source integration proposal — 2026-11-25

**Status:** Approved by the maintainer with “approved” after review of this exact
three-repository integration/publication scope. The
[execution record](task9-compatibility-integration-execution-2026-11-25.md) tracks
actual results; approval alone does not establish publication or CI success.

**Goal:** Integrate the verified worker/platform corrections and their companion
workspace records into the three canonical mains without changing the stack.

**Architecture:** Fast-forward existing independently versioned repositories.
Keep immutable contract/profile/image identities and retained evidence intact;
reconcile current status separately from historical source identities.

**Specs:** [Approved compatibility scope](task9-runtime-compatibility-proposal-2026-11-23.md),
[firewall execution](task9-loopback-health-execution-2026-11-24.md) and
[passed timed readiness](task9-readiness-renewal-execution-2026-11-25.md).
Their separate source integration/publication gate is the approval sought here.

## Exact reviewed source bundle

Fresh `git fetch origin` succeeded for all three repositories. Published
`origin/main` still equals local canonical main; every main is an ancestor of
its candidate and all involved worktrees were clean during review.

| Repository | Canonical and fetched main | Reviewed candidate |
| --- | --- | --- |
| Worker | `ae12605c75c33a5d6fedb5e4cc1ac0c30f93a5d8` | `423d4e84985eb535caa66c7522c4191c6dbccad6` on `task9-worker-runtime-compat` |
| Platform | `ebc654e9ab96b72a614a344cee258d428b334dfd` | `60ec83c06b1e4bbffcd5bdd69aee6575608e5e3a` on `task9-platform-runtime-compat` |
| Workspace | `12a79911a09db0a47119bda3a03655f34a2cc39d` | Reviewed checkpoint `d009b9ddbf5004ea1f7c2b50dad787f20eff006d` on `task9-runtime-compat-record`, plus this review/proposal and navigation |

The root companion is necessary: child documentation links the new root reports,
and the root identity validator adds the exact new synthetic fixture path while
retaining exact-line matching and negative coverage. It contains specifications,
sanitized receipts and derived status, rather than private operator inputs.
Before integration, record the actual clean workspace tip containing this
proposal and its approval record. Reject additions outside the reviewed source
bundle and these documentation-only review/approval records.

Worker runtime change: accept only the pinned native startup notifications and
their permitted timestamp metadata. Platform runtime changes: reproducible
loopback host/DNS bindings, actual read-only schema readiness, a separate exact
compatibility profile, and the narrow empty socketless ACK exception. UID rules,
timeouts, whole-policy guard, fail-stop behavior and original profile stay fixed.

The historical profile SHA-256 remains
`7106f7e41a6bc13feab8a0b51fccde9b47fefca2d63980d551ed929eac1c1a71`;
the compatibility profile remains
`14c5a784a1f6d8c944f25570f1b0dda741831178348ad7052ecb7301529d2f0c`.
Worker image remains
`sha256:1ac229b25167845b4d7cec217304f3064b02d65d60c53f35b07c5ae3e3683b3b`;
proxy/namespace image remains
`sha256:54dc5c7d649e486bff7f5f8821050b800ae5cb454cd8496a9f93ce0047d07cf1`.
The latter's build source stays `a9c3ff5c79e7d3525bed0b5968ab1d8be6b2cc23`;
later platform documentation commits are not substituted as image provenance.

## Review and fresh verification

Independent worker/platform and root-companion reviews found no actionable
correctness, security, integration, provenance or privacy issue. Fresh checks
passed: 50 worker tests; formatting and warnings-denied locked/offline Clippy;
contract, legal, documentation and tool-catalog checks; 54 platform guards;
five Compose tests; workspace/platform documentation links; specification
hierarchy, references and product identity, including negative regressions.

The [review receipt](../../../docs/evidence/task9-compatibility-integration-review-2026-11-25.json)
records exact reviewed heads and checks. The retained 662.743-second/22-sample
readiness run is separate evidence; it was not rerun or relabeled as provider
acceptance during source review.

Pushing the worker triggers its existing provider-free native runtime matrix and
package/capture jobs, including bounded GitHub Actions evidence uploads. Review
found no registry-image publication or deployment workflow. Platform and root
have no tracked CI workflow. These facts do not imply future CI results.

## Execution after approval

1. Record approval in the root execution record before any merge or push. Bind
   exact clean candidate heads and fetched main refs in a private operator packet;
   keep activation, provider and tool permissions false.
2. Refresh all three origins again. Require the recorded main refs, ancestry,
   clean canonical/candidate trees and frozen byte hashes. If a remote advanced,
   a tree is dirty or protection rejects the operation, preserve all work and
   report the precise mismatch; never force-push or bypass branch protection.
3. Fast-forward the root companion first from the root checkout, using
   `git switch main` then `git merge --ff-only task9-runtime-compat-record`.
   Verify root governance checks and push with `git push origin main`.
4. In `thought-khoral-codex-agent`, require canonical `main`, then run
   `git merge --ff-only task9-worker-runtime-compat`. In
   `thought-khoral-platform`, require canonical `main`, then run
   `git merge --ff-only task9-platform-runtime-compat`. Verify exact resulting
   IDs and unchanged source/profile/image bytes. Recheck the candidate quality
   gates on the merged trees, then push each with `git push origin main`.
5. Observe the worker's actual CI runs and record URLs/outcomes. Report pending
   or failed jobs explicitly; do not infer native/compiler acceptance from the
   local suite. Any runtime correction requires its own reviewed source change.
6. Update root current specs first, then derive workspace/project status with
   actual integrated IDs and source-publication results. A documentation-only
   follow-up may be committed on the preserved root record branch, fast-forwarded
   to root main and pushed under this same approval. Preserve historical inputs
   and receipts; do not rewrite dated source identities.

Keep the source branches/worktrees available for frozen-source verification and
later acceptance; do not delete them. Preserve unrelated organization/contracts
untracked files. If any repository update fails, record partial integration
accurately and leave successful fast-forwards intact; no history rewrite.

This scope authorizes source integration/publication only. It does not authorize
container startup/recreation, admission renewal, registry-image publication,
release/tag changes, migrations, browser actions, model/tool/provider calls or
aggregate Task 9 acceptance. Contracts, broker, mediator, UI and memory runtime
sources remain unchanged. The existing base stack and private state remain as-is.
