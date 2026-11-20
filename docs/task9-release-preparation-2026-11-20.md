# Task 9 local release preparation — 2026-11-20

Authority: [approved acceptance procedure](../.ai/specs/how/task9-packaged-acceptance-2026-11-20.md)
and the owning platform execution plan. This report is local implementation
evidence, not contract publication or Task 9 acceptance.

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
