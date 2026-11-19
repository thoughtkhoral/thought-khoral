# Specification-driven maintenance audit — 2026-11-19

Status: audit of the three already-approved maintenance amendments. This record
repairs their cross-project discovery and traceability; it grants no new runtime
scope and does not retrospectively invent an approval.

Governing sources: [specification-first rule](../README.md),
[Decision 004: contribution governance](../decisions/004-contribution-and-change-management.md),
and the [coordinated conversation plan](codex-room-conversations-implementation-plan.md).

## Approval and ordering

| Amendment | Maintainer approval in this conversation | Implementation ordering |
| --- | --- | --- |
| Worker architecture-specific evidence | "approved", in response to the two concrete worker/platform amendments | The proposed How existed before approval. Its status was marked accepted before adding the canonical x86 proof, changing the verifier or changing capture options. Initial investigation/capture used disposable external test assets. |
| Platform complete build inputs | The same "approved" response | The proposed How existed before approval; acceptance was recorded before Containerfile edits. The subsequent reference-agent omission was documented before its COPY addition as the same approved existing-library build-input correction, not as a separately approved product feature. |
| Worker Rust 1.85 lock correction | "approval granted as requested", after the explicit compatibility amendment request | The exact candidate and proposed How were available before approval. Acceptance was recorded before replacing the canonical lock or refreshing its legal inventory. The earlier candidate tests modified disposable copies only. |

These approvals continue the existing accepted milestone-one issues:
[worker issue 1](https://github.com/thoughtkhoral/thought-khoral-codex-agent/issues/1)
and [platform issue 1](https://github.com/thoughtkhoral/thought-khoral-platform/issues/1).
Their original acceptance is recorded in the coordinated plan. No newly filed
issue, new remote approval, issue closure, commit, or publication is asserted.

The ordering above is evidenced by this working conversation and local files.
At the audit checkpoint the edits were uncommitted; Git history alone could
not independently prove their creation/approval order. Index and coordination repairs in this audit
occur after implementation and must not be presented as earlier approvals.

## What, How, decisions and contracts

The accepted [root Codex What](../what/codex-chat-agent.md) and existing component
What requirements remain the product authority. The worker fixes implement its
existing independent-build/release criterion and no-tools runtime boundary.
The platform correction implements its existing local composition/start
criteria. No user behavior, agent authority, interface, storage mapping or
product scope was changed; no new What behavior was required or added.

The detailed amendments reside in the independently versioned owning projects.
Paths in the following tables are relative to the named owning repository;
they identify the local accepted files, not yet-published GitHub file versions.

| Owning repository | Existing What | Accepted How amendment | Main How and discovery |
| --- | --- | --- | --- |
| `thought-khoral-codex-agent` | `.ai/specs/what/codex-chat-agent.md`, acceptance 13 and existing exclusions | `.ai/specs/how/x86-package-evidence-proposal.md` | Linked from `.ai/specs/README.md`; incorporated in `.ai/specs/how/codex-chat-agent.md`. |
| `thought-khoral-codex-agent` | Same independent-build/release requirement; existing Rust 1.85 technical floor | `.ai/specs/how/rust-185-lock-compatibility-proposal.md` | Linked from `.ai/specs/README.md`; incorporated in `.ai/specs/how/codex-chat-agent.md`. |
| `thought-khoral-platform` | `.ai/specs/what/local-mvp.md`, composition/start and sibling-source criteria | `.ai/specs/how/package-build-inputs-proposal.md` | Linked from `.ai/specs/README.md`; incorporated in `.ai/specs/how/implementation.md`. |

The `proposal` filenames are retained to preserve existing links; each file's
explicit accepted status is authoritative. No parent governance override or
new architecture decision was needed. Existing Decisions 004, 007 and 009
remain in force. No room/conversation wire contract or released artifact was
changed. The worker's private CLI-artifact lock adds an approved capture file;
it is distinct from the unchanged published conversation contract.

## Complete changed-file coverage

| Owning repository | Implementation, data or derived files | Governing amendment and verification |
| --- | --- | --- |
| Worker | `src/tool_policy.rs`, `tests/tool_policy_test.rs` | Architecture evidence: compile-target selection, exact proof/binary binding, wrong digest/proof and tamper refusal. Both host suites passed; actual package checks are separately attributed below. |
| Worker | `Containerfile` | Architecture evidence: copy both immutable proof files. Both local target packages were verified before the later Rust lock change. |
| Worker | `contracts/codex-app-server-0.160.0/tool-policy-proof-x86_64.json`, `lock.json`, `TOOL_POLICY.md` in that directory | Architecture evidence: actual-binary capture and artifact hashes; retained ARM proof, catalog, controls, release/archive/schema pins and licensing. |
| Worker | `scripts/test-native-tool-policy.py`, `scripts/test_tool_policy_resolver.py` | Architecture evidence: immutable image IDs, platform matching and retained default pins; three Python tests and byte-identical regenerated captures. |
| Worker | `Cargo.lock` | Rust 1.85 amendment: exact approved SHA-256 `1c70ff10992b000c93232155ca0032cab9b7a6c27a13ca4ac46eba862e864a34`; only explicit derive downgrade with its required additional transitive package. Direct requirements and minimum remain unchanged. |
| Worker | `docs/dependency-evidence.json`, `THIRD_PARTY_NOTICES.md` | Rust amendment: all 276 registry version/checksum entries match the lock; both final-source toolchains and legal provenance are recorded. |
| Worker | `licenses/yoke-derive-0.8.2/LICENSE`, `licenses/synstructure-0.13.2/LICENSE`; removed obsolete `licenses/yoke-derive-0.8.3/LICENSE` | Rust amendment: original texts extracted from checksum-verified crate archives; 478 retained legal files pass verification. |
| Platform | `containers/agent-gateway.Containerfile`, `containers/reference-agent.Containerfile`, `containers/ui.Containerfile` | Build-input amendment: the four missing COPY directives; actual three-image builds and default deterministic-stack smoke passed with existing checks and runtime policy retained. |
| Root and affected components | Specification indexes, governing How documents, the three accepted amendment files, this audit and the root coordination-plan checkpoint | Governance/discovery records for the same approved scope; not independent product authorization. |
| Root | `README.md`, `docs/resumption-status-2026-11-19.md` | Derived status/navigation from the accepted specifications and attributed verification results. |

The other five component repositories have no task implementation changes.
The contracts checkout's pre-existing untracked `.DS_Store` is unrelated local
metadata, not a protocol or specification change, and was left untouched.

## Evidence and open gates

- Final worker lock/source: 46 tests passed on each of actual Rust 1.85.0 and
  1.93.1 on macOS ARM64. Formatting, denied-warning clippy, artifact pins,
  legal inventory, documentation and policy checks passed. Independent review
  confirmed the lock and licensing. Linux minimum-version execution is open.
- Architecture amendment: ARM64 and cross-compiled/emulated x86_64 package
  admission checks passed and both captures were reproduced byte for byte.
  These images predate the Rust lock correction; they are not final-lock Linux
  image evidence. Native x86_64 CI remains open.
- Pinned synthetic composition: 24 synthetic turns, six recovery boundaries,
  and 12 rendered jsdom UI phases passed at the exact retained fixture source
  revisions; it does not validate an unpinned current-source or live provider
  stack by implication.
- Default deterministic platform: actual image builds and HTTP/WebSocket PKCE,
  authorized-context filtering, egress and both reference skills passed.
  Rendered-browser inspection was unavailable; no live Codex/provider run was
  performed. The containers were later removed at the maintainer's request,
  preserving the external database volume, and remain stopped.
- Task 9, the unreleased v1.1 conversation candidate, final-lock Linux images,
  native CI, live provider/tool isolation and production acceptance retain
  their existing separate gates. No historical passing image or default-stack
  result is used to close them.

The accepted component amendments retain exact image IDs, hashes, command
details and local evidence-log paths. Those logs are temporary local evidence;
they are not a claim of published or indefinitely retained CI artifacts.

## Audit corrections and verification limits

The detailed How amendments and approval records existed, but the platform
index/main How and root index/coordinated plan lacked complete discovery links.
This audit adds those links, associates existing What/issue authority with each
amendment, corrects stale running-container wording, and maps every task change.

The repository hierarchy gate checks required directories and parent links;
it does not prove semantic coverage, maintainer approval, implementation order,
or complete acceptance. This audit therefore also inspected the actual diffs,
accepted amendment contents, conversation approvals, file coverage and evidence
qualifications. Documentation/link/reference/identity and artifact/legal checks
are rerun for the corrected records. Runtime tests and containers need not be
rerun for these documentation-only repairs.

### Recorded audit results

- All 29 task files were checked against an explicit authority map: five root,
  eighteen worker and six platform files. No unmapped task change was found.
- All three accepted amendments are linked from their owning indexes and
  incorporated in their main How documents. The approved Rust lock hash is
  unchanged.
- All 111 relative Markdown links in changed records resolved locally. The
  worker documentation checker separately passed 112 local links.
- Specification hierarchy, repository-reference, identity and whitespace gates
  passed. The 144 artifact pins and 478 retained legal files also verified.
- Independent read-only review approved the repaired specification trail with
  no important findings or newly introduced scope.

The exact file-to-authority check output is retained locally at
`/private/tmp/thought-khoral-resume-2026-11-19/spec-audit-coverage.json`.
