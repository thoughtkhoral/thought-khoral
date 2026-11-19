# Specification-driven maintenance audit — 2026-11-19

Status: audit of the three already-approved maintenance amendments. This record
repairs their cross-project discovery and traceability; it grants no new runtime
scope and does not retrospectively invent an approval.

Governing sources: [specification-first rule](../README.md),
[Decision 004: contribution governance](../decisions/004-contribution-and-change-management.md),
and the [coordinated conversation plan](codex-room-conversations-implementation-plan.md).

Current reading: the original maintenance audit below is a historical checkpoint
from before publication/native CI. The coordinated plan's later published-native
checkpoint supersedes its local-only/open-native statements. The documentation
refresh recorded at the end reconciles current pages with approved specifications
without changing runtime requirements or promoting deferred work.

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

## Specification-to-document refresh — 2026-11-19

The maintainer requested that all documentation/specifications be current and
documentation be regenerated from specs. Under the approved
[documentation What](../what/open-source-documentation.md) and
[publication How](github-organization-publication.md), public Markdown is
maintained from approved source specifications; CI validates it and does not
generate prose or rewrite its sources. This refresh follows that model. No new
generator, runtime behavior, contract or product requirement is introduced.

Scope: root, all seven independent component repositories and the organization
profile. The organization repository's three existing workflow/checker/README
edits were initially preserved separately, then reviewed and adopted unchanged
after reproducing the coverage failure described below. Read the owning
specifications and accepted checkpoints first, reconcile factual status/index
wording, then refresh their derived READMEs, status, architecture, runtime and
operator guides where stale. Preserve dated verification snapshots, original
image/source attribution and explicit draft/future boundaries. Keep source
metadata, legal texts and versioned protocol artifacts unchanged unless their
existing checker identifies actual drift.

The current authority is the coordinated plan and owning native acceptance How:
run 44599536091 passed all six jobs at worker `9bcdbde`; evidence-only `8d233e4`
also passed all six in run 44600836229 and documentation run 44600836236. The final
lock, both target proofs and retained evidence are unchanged. This closes native
worker gates, not Task 9 room-stack/browser/live, unreleased v1.1, or production.
Default deterministic-stack smoke is separately scoped evidence. The retired
`Decision:` parser remains historical under Decision 008; memory stays an
incubating mediated-ingestion proof with Cognee/durable storage deferred.

Validation covers existing documentation checkers and any applicable prescribed
documentation generation commands, all local Markdown targets/source links,
hierarchy/reference/identity gates, whitespace and diff scope. Documentation-only
maintenance does not require starting containers or rerunning provider tests.
The resulting report identifies changed pages, governing sources, untouched
repositories and any genuine unresolved requirement/implementation mismatch.

### Refreshed source-to-document map

| Owner | Authoritative source reconciled first | Derived documentation refreshed |
| --- | --- | --- |
| Root | Spec indexes, approved runtime/publication Hows, documentation What and coordinated acceptance checkpoints | README, cross-project status, overview, architecture, repository map, compatibility matrix and roadmap |
| Codex worker | Approved public-documentation applicability, foundation/runtime authority and accepted Rust/x86/native Hows | README, contribution guide, component status, adapter, architecture, runtime and authored tool-policy provenance |
| Contracts | Conversation How and current index; immutable v1.0 release versus unreleased v1.1 | README release provenance and protocol candidate labeling |
| Room gateway | Owning conversation How/index and valid pushed commit | README and historical retained-room Task 9 report, distinguished from Codex Task 9 |
| Agent gateway | Owning mediation How/index and existing pushed-source evidence | Existing derived README already matches the boundary; current discovery/status wording reconciled in the index/How |
| Workspace UI | Conversation checkpoints and already-approved `session.authenticate` host contract | README and stale transport implementation prose |
| Platform | Accepted build-input and opt-in service Hows/index | README, operator guide and verification procedure with exact historical pins preserved |
| Memory engine | Approved plan/current Decision 008 baseline and explicitly unclosed implementation-limit checkpoint | README, mediated-ingestion guide and historical POC verification record |
| Organization profile/validation | Root documentation What/publication How and current accepted evidence | `profile/README.md`, README count and existing seventh-component checkout/checker extension |

The memory checkpoint explicitly retains unclosed proof requirements: fixture-only
extraction, duplicate/error-envelope behavior, receipt-body checking and bounded
failure handling. Documentation describes these limits without waiving approved
requirements. No draft capability was promoted or deferred runtime implemented.

Initial local validation: the organization checker extension resolved 995 links
across 170 Markdown files with zero broken links; all four checker tests passed.
The independent worker checker resolved 145 local links, and all 144 artifact
pins and 478 retained legal files passed. Hierarchy/reference/identity and
whitespace gates passed. The package builder remains Rust 1.93.1; Rust 1.85.0
coverage is the native runtime matrix, not a claimed 1.85-built release image.
Independent documentation review's compiler-scope wording issue was corrected.

### Required published documentation coverage correction

Running the original organization checker from published HEAD against the current
documentation reproduced 55 `unknown or absent organization repository` failures,
all caused by its missing Codex catalog/checkout entry. The already-existing
three-file extension adds that repository to the workflow clone list and checker
`COMPONENTS`, and changes the README count to seven. With it, the exact same
995-link set and all four existing checker tests pass. This is the existing
approved all-seven documentation requirement, not a new product capability.

The extension is included unchanged after this source checkpoint, independent
review and the failing/passing comparison. Other source/locks/schema/proof/legal
files remain unchanged; local containers stay stopped. The initial plan to leave
the extension unpublished is superseded because it would leave the published
documentation gate unable to validate current cross-project links.

### Publication and final documentation verification

The specification-first commits and derived refresh are published at root
`cbb5214`, contracts `205b453`, broker `248f059`, UI `2cfb8c1`, memory `7b46518`,
mediator `48a72bc`, platform `fbd2d52`, worker `3f0318b` and organization
`fabe4e3`. The [published organization documentation run](https://github.com/thoughtkhoral/.github/actions/runs/44604159724)
passed with all seven components present. The worker's documentation/specification
run `44604155429` also passed at the documentation-only source revision.

The scope includes 53 Markdown files and the two existing documentation-coverage
automation files. Existing runtime source, schemas, locks, proof JSON and legal
bytes are unchanged. The contracts checkout's pre-existing `.DS_Store` remains
untracked; it is not part of a task commit. No local test containers, provider
calls or release operations were used for the refresh.

After adding the durable published-run link, the final local check resolved
996 Markdown links across the same 170 files with zero broken links. Root
hierarchy/reference/identity and whitespace gates passed again. The worker's
46-test Rust suite, fmt and denied-warning clippy also passed during this
documentation task; this is separately attributed host verification.
