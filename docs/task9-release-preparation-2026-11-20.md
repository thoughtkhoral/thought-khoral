# Task 9 local release preparation — 2026-11-20

> Integration update — 2026-11-23: contracts release tooling/evidence, released
> broker/UI consumers and the packaged profile are integrated and pushed to main.
> The [workspace guide](workspace-status.md) records current commits and preflight.
> Pending integration/adoption descriptions below are historical; the published
> tag, artifacts and frozen acceptance inputs remain unchanged.

> Current checkout guidance: the [workspace guide](workspace-status.md) records
> documentation-only followups and preserved clean runtime snapshots. Frozen
> implementation/artifact identities below remain unchanged when branch HEADs
> advance for documentation; earlier pending-state sections are historical.

Authority: [approved acceptance procedure](../.ai/specs/how/task9-packaged-acceptance-2026-11-20.md)
and the owning platform execution plan. This report is local implementation
evidence, not contract publication or Task 9 acceptance.

## Published and verified — latest checkpoint

The maintainer authorized publication with “proceed”. The contracts source
branch is pushed; annotated tag `thought-khoral-agent-conversation-v1.1.0`
resolves to reviewed source `f1c8621810c8c121c1aafc8e5a342d6626c4b843`.
[GitHub release 452810808](https://github.com/thoughtkhoral/thought-khoral-contracts/releases/tag/thought-khoral-agent-conversation-v1.1.0)
was published at `2026-11-20T14:44:18Z` with the reviewed TAR, lock and sidecar.
Fresh downloads match every reviewed asset digest and all 156 payload hashes;
the verifier from the downloaded archive passes using the external lock anchor.
The exact asset hashes in the corrected-input table below remain authoritative.

The owning contracts source branch retains
`docs/evidence/conversation-v1.1-publication-2026-11-20.json`, including annotated
tag object `b63c96c74b35db1b20a914fc1520d7cc379028db`, peeled source, release
ID, asset IDs/download URLs/digests and byte-verification results. A local copy
is `/private/tmp/thoughtkhoral-task9-v1.1-corrected-20261120/publication.json`.
GitHub's `target_commitish` metadata does not supersede the independently
verified existing tag target. The verifier's `publication: not-performed`
means verification itself performs no publication; this separate record
establishes that the release is now published.

This closes contract artifact publication and supersedes earlier pending
publication statements below. Contracts `main` is unmerged. Broker/UI still
retain their historical candidate pins; released consumer adoption and the new
packaged live acceptance profile remain next. No service activation, container
start or provider call occurred.

## Latest checkpoint: approved correction verified

The maintainer approved the exact fast-uri 3.1.9 correction. Its owning approval
commit `a5c359f` precedes implementation source
`f1c8621810c8c121c1aafc8e5a342d6626c4b843` on the same isolated contracts
branch. Worktree and extracted-archive full suites pass, and both online audits
report zero vulnerabilities. Independent review confirmed the three-field
lock change, unchanged dependency declarations/license bytes and unchanged
consumer payload, with no actionable issue.

Two preparations from the clean committed source are byte-identical:

| Corrected publication input | SHA-256 |
| --- | --- |
| `thought-khoral-agent-conversation-v1.1.0.tar` | `b0370e43627ce6044852df75bfbc4b749d904aa9cedcfc558c61bb4e07dc95ff` |
| `lock.json` | `b7f3ad928c5c17be7e936da4959b7e7e8555bb4ed3602fa62f71a8721f042d8f` |
| Source `package-lock.json` | `26b7382546939bc1a5e371ecb99f1655b617f381eea27b72d9400fc3c49ff585` |

All 156 candidate payload hashes and 135 retained v1.0 schema/fixture hashes
remain unchanged. The corrected artifacts, proposed release notes and machine
review manifest are under
`/private/tmp/thoughtkhoral-task9-v1.1-corrected-20261120/`. Publication review
should name frozen source `f1c8621`, intended tag
`thought-khoral-agent-conversation-v1.1.0`, and these asset hashes. Later evidence
commits do not replace the frozen artifact source. Publication has not occurred.
The old 3.1.8 diagnostic artifacts remain retained and blocked.

This supersedes the pending-dependency statements in the historical preparation
checkpoint below. The canonical contracts `main` still has its original lock;
the verified correction is on the isolated release branch. Source/tag/release
publication and verified consumer transition remain prerequisites to the new
live profile. No services or provider calls were started.

## Implemented

The contracts worktree `.worktrees/task9-contract-release` on branch
`codex/task9-contract-release-20261120` contains specification-first commits
`f635758`, `57182d5`, `9ca6893` and implementation
`65bdc00a391e49296a233eec5368c266f8d9deb3`. All remain local and unpushed;
the canonical contracts `main` and its unrelated `.DS_Store` are unchanged.

The separate release preparer builds the full source TAR and a closed release
lock/vendor payload, explicitly reporting `publication: not-performed`. It
checks the 156-file approved candidate payload and all 135 retained v1.0
schema/fixture files against independently extracted, code-anchored hashes.
Candidate behavior and existing immutable artifacts are unchanged.

The baseline candidate suite's Git blob inspection failed with ENOBUFS for its
1,050,802-byte negative context fixture. A controlled probe reproduced the
default 1 MiB failure and 2 MiB success. The test now uses that bounded larger
buffer without changing the fixture or runtime limits.

## Verification and diagnostic artifacts

Full tests pass in the implementation worktree and independently from the
extracted archive: retained room validation, 125 conversation fixtures,
16 defaults fixtures, six candidate integrity tests and five release tests.
Release tests cover deterministic builds, independent extraction/hash checks,
dirty/non-HEAD source, committed payload drift, archive/vendor/metadata
tampering, symlinks, missing/extra files and external anchors. They create
self-contained Git snapshots and need no upstream Git history. Independent
review reproduced the full suite and pin provenance, with no actionable finding.

Two archives and locks built from `65bdc00` are byte-identical. Diagnostic
inputs are retained under `/private/tmp/thoughtkhoral-task9-v1.1-20261120/`:

| Item | SHA-256 |
| --- | --- |
| Intended v1.1 TAR | `1a6afb6204ccfa94d73e5875b19328fa65eb41fe43233b9d0f58ed75f21e83bd` |
| Release lock | `f9fa6a2939be0f9d53f46dd8905ff1f5ebe395ff2aa2bce01504a85e80ea1a0f` |

These are **blocked diagnostic artifacts**, not approved publication inputs.
The online audit failed both in the source worktree and extracted archive:
development dependency `fast-uri 3.1.8` has one moderate vulnerable-package
finding spanning two moderate and two low advisories. An offline install's
zero-vulnerability message does not supersede this online result.

## Concrete correction awaiting approval

The contracts worktree's
`.ai/specs/how/fast-uri-319-correction-proposal.md` proposes only the existing
transitive dependency's compatible 3.1.9 patch. The exact complete candidate
lock SHA-256 is
`26b7382546939bc1a5e371ecb99f1655b617f381eea27b72d9400fc3c49ff585`.
An isolated candidate at
`/private/tmp/thoughtkhoral-task9-fast-uri-319-ji73184x/contracts` passes the
same full suite and the online audit with zero vulnerabilities. Only three
lock fields differ: fast-uri version, resolved URL and integrity. Dependency
declarations, all other packages and the BSD-3-Clause license bytes match.

The approved release scope explicitly excludes dependency changes, so the
canonical lock and release worktree lock remain unchanged pending that bounded
exception. After approval: commit its accepted specification, apply the exact
tested lock, rerun worktree/extracted tests and online audit, and regenerate the
review package. Only then request publication approval against concrete clean
inputs. Released consumer pins and the new live acceptance profile follow
verified publication. No tag/release, push, service activation, browser session,
provider call or container start occurred during this work.
