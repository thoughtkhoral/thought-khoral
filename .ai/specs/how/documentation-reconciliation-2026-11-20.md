# Documentation reconciliation — 2026-11-20

Authority: the maintainer requested updated specifications followed by derived
documentation, explicitly including the current workspace. This continues the
approved [documentation What](../what/open-source-documentation.md),
[publication How](github-organization-publication.md) and
[workspace governance](../decisions/001-workspace-governance.md).

## Scope and order

1. Audit actual checkout identities and accepted execution evidence.
2. Reconcile [workspace authority](workspace-state.md), root coordination,
   component indexes/owning Hows and catalog before editing derived pages.
3. Refresh root/workspace/project guides, component READMEs/operator/status
   pages and organization profile from those specifications.
4. Verify canonical/worktree links, hierarchy/reference/identity, worker
   documentation checks and whitespace; review the exact Markdown/metadata diff.

No runtime/vendor/dependency change, release, merge, activation or provider call
is authorized. Preserve frozen inputs and exact source snapshots before advancing
documentation-only HEADs. Lifecycle values and deferred product boundaries remain
unchanged. Retain historical evidence/anchors; never reattribute a test result to
new documentation or an unexecuted packaged/browser/live gate.

## Source-to-document map

| Source reconciled first | Derived pages |
| --- | --- |
| Root workspace-state/coordination/documentation/publication Hows and catalog | README, workspace guide, project/status/architecture, compatibility, roadmap, repository map, preparation/resumption context |
| Contracts conversation/release/correction Hows and publication evidence | Canonical/release-branch READMEs and protocol context distinguishing release from candidate |
| Broker/UI released-consumption Hows and conversation Hows/indexes | Canonical/prepared READMEs and current import/test applicability |
| Platform profile/acceptance/local-service Hows/index | Canonical/prepared README and operator/verification instructions with checkout-specific command availability |
| Worker current What/How/index and native/package evidence | README, docs index/status, runtime/adapter/architecture/acceptance entrypoints |
| Agent gateway mediation How/index | README and mediation verification scope |
| Memory POC How/index | README, ingestion/proof context without promoting deferred work |
| Root publication How governing organization profile | Organization profile/current state and entrypoint README |

This maintenance creates no generator or runtime automation. Scratch state under
`.superpowers` and unrelated untracked metadata remain outside scope; do not read
tokens or copy private state into maintained documents.

## Reconciliation findings and verification

Current summaries now describe published v1.1 separately from historical
candidate locks, and verified local released-consumer/profile sources separately
from unmerged canonical runtimes. Canonical indexes expose branch-applicable
approved Hows; READMEs/operator pages state which commands/imports are actually
available in their checkout. The current workspace guide records the source map
needed when documentation-only HEADs advance. Historical checkpoints retain
their dates, immutable artifacts and explicit preserved anchors.

The change-scope audit covers 13 checkouts and 75 unique files: Markdown,
the catalog's purpose text and two byte-identical public evidence copies.
Runtime, dependencies, vendor payloads, legal files, profile/image pins and
source fixtures are unchanged. All six exact detached source inputs remain
clean. Untracked contracts metadata and organization Python-cache files were
preserved outside this change set.

Validation: 1,122 canonical Markdown links in 182 files and 406 prepared-source
links passed; all 39 inspected changed-document fragment links resolve,
including preserved historical anchors. Root hierarchy/reference/identity,
reference/identity behavioral regressions, four organization link-checker tests
and whitespace checks passed. The worker's required host suite passed 46 tests,
formatting and denied-warning clippy; 144 artifact pins, 478 retained legal files,
its catalog policy and 152 local documentation links verified. These are
separately attributed local checks; no new native CI, registry publication,
packaged/browser/provider run or production acceptance is claimed.

Independent review found three residual multiline worker release/tag assertions;
they were reconciled with the published artifact in README and architecture.
Final review found no remaining actionable current-state contradiction. Other
component runtime suites were not repeated for prose-only changes; their
retained counts remain tied to the frozen implementation inputs.

## Documentation-contract followup

The maintainer explicitly requested updates to documentation specifications
themselves at workspace and individual-project level. The root documentation
What now requires a current workspace guide, a current documentation What and
a source-mapped project index for all seven components. Each component contract
defines its maintained pages, checkout applicability and current acceptance
criteria; superseded worker scaffold-only and agent-gateway deterministic-only
documentation wording is replaced without expanding runtime authority.

These twelve documentation-What copies (root, seven canonical projects and four
prepared copies) are updated before deriving project `docs/README.md` indexes,
README navigation and the workspace documentation map. Frozen sources, profile
and published artifacts remain unchanged; this is a documentation-only followup.
