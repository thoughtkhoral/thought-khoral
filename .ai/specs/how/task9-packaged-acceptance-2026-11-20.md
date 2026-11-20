# Task 9 packaged room-stack acceptance procedure

Status: approved for local implementation on 2026-11-20 by the maintainer's
“approve”, after review of this procedure and the owning platform plan.
Publication, service activation and provider calls retain their separate gates.
This document records no packaged/browser/live acceptance result.

## Authority and purpose

Continue [Task 9](codex-room-conversations-implementation-plan.md#task-9--verify-end-to-end-history-restart-isolation-and-release-evidence)
under the existing [Codex What](../what/codex-chat-agent.md),
[runtime How](codex-chat-agent.md), [Decision 009](../decisions/009-codex-chat-agent.md)
and accepted component issues already linked in the coordinated plan. Root owns
cross-project evidence; platform owns the executable verification procedure.
The [owning platform amendment](https://github.com/thoughtkhoral/thought-khoral-platform/blob/main/.ai/specs/how/task9-packaged-acceptance-2026-11-20.md)
defines the proposed runner changes and execution checklist.

The deliverable is evidence from the actual packaged room stack, real browser
and Keycloak, followed by separately authorized provider verification. Existing
synthetic, native-worker and default-stack evidence retain their exact scope.
Memory integration, guided directories, remote agents and production deployment
remain outside milestone one. No product What or wire behavior changes here.

## Observed source baseline

These full commits were read from the local checkouts on 2026-11-20. Remote
heads were not fetched. The table identifies preparation inputs, not a claim
that these revisions have passed packaged acceptance. All tracked trees were
clean before this preparation; contracts has an unrelated untracked
`.DS_Store`, which remains excluded from artifacts and commits.

| Owner | Preparation commit |
| --- | --- |
| Root | `c3c665577c9507ef3b9f6395873b153370b7a102` |
| Contracts | `205b453ddb83ce085888350a8ba09e9b85f4d9ec` |
| Room gateway | `248f059c85624bd028ccbab415758aaf3f972f4c` |
| Agent gateway | `48a72bcd6a8c668004e10fe2ae3cd01cdaf9361c` |
| Codex worker | `3f0318b40af8d5c9c47cc43e975b3db4836df983` |
| Workspace UI | `2cfb8c171b827a9ac75cd17ab74cff13f7a11639` |
| Platform | `fbd2d525e62a7d5e58948f91570095c6821667d4` |
| Memory engine | `7b4651839d1fbb41b426f80ca34712669da667f1` |

Implementation/release work produces new commits. Freeze those actual final
commits in a new acceptance profile before a packaged run; never substitute
`main`, an operator-selected arbitrary revision, or this preparation table for
that reviewed profile. Include memory/reference-agent inputs because they are
part of the composed stack, without claiming Codex memory integration.

## Reusable worker evidence and image availability

The worker's [retained native evidence](https://github.com/thoughtkhoral/thought-khoral-codex-agent/blob/main/docs/evidence/linux-worker-acceptance-44599536091.json)
records tested runtime source `9bcdbde61b59b99ad1e47d5fbb8644adf1e77c18`,
CLI `0.160.0`, Rust 1.93.1 production builds, and final Cargo lock SHA-256
`1c70ff10992b000c93232155ca0032cab9b7a6c27a13ca4ac46eba862e864a34`.
Four native Rust/architecture test cells and two package jobs passed.

| Platform | Recorded CI worker image ID | Exact native proof SHA-256 |
| --- | --- | --- |
| `linux/arm64` | `sha256:205fe386a36a4de66a2e08bc2b104b5897ffba20a8c0274b1c36b681dbb882ee` | `91ab6c55e22236a578b494f071bbd82ce867a2e9aae4010526b7319165344169` |
| `linux/amd64` | `sha256:412bb4a7d3c95470f2ea36190ebfc752287275bbb17eeb5c7da511f7eb9d1434` | `db8557b9f852583002397827c28e8f76078f02d4aabbfad2aecfe6617ab20c58` |

These are CI-local image IDs, not published registry references or promises of
local availability. If an image cannot be recovered with verified identity,
build the worker-owned production Containerfile from the selected clean source,
record the new image ID and architecture, and rerun actual package admission and
tool-policy capture. A rebuild need not reproduce a prior image ID. A later
documentation-only commit does not make a new image implicitly accepted.

Run the packaged platform first on native `linux/arm64`, matching the original
platform/proxy composition target. AMD64 worker acceptance alone does not close
AMD64 platform/proxy acceptance. Record host, engine and image architectures;
emulated runs receive a separate evidence classification.

## Prerequisites in dependency order

1. **Review this amendment and its owning platform procedure.** Approval permits
   local harness implementation and provider-free checks. Contract publication,
   service activation and provider calls retain their explicit later gates.
2. **Prepare the v1.1 contract release and consumer transition.** The reviewed
   defaults candidate is source `1ea828f28725ddaaefa21d083473f9abbd777975`,
   candidate archive SHA-256
   `fab59a486f6498b843467202debcb0768403bd57ba7dda41be2a01e5f23fdda8`,
   and candidate lock SHA-256
   `7914d32eae2487879a68405b5095a6b9aa91355f87529c43f4055844821902a9`.
   These identify an unreleased candidate, not release provenance. Prepare and
   review the immutable `thought-khoral-agent-conversation-v1.1.0` release inputs
   under the contracts owner's How before requesting publication. The existing
   builder emits candidate metadata only; relabeling its lock is insufficient.
   Preserve all published v1.0 schema/fixture bytes. Compare the release payload
   to the reviewed additive candidate, explain every difference, and verify
   downloaded release bytes after publication. Broker/UI must adopt the actual
   release provenance through separately reviewed owning specifications and
   consumer verification. Worker/mediator may retain compatible published v1.0
   pins. Until this transition completes, current defaults clients have only
   their existing synthetic-candidate acceptance.
3. **Prepare and verify a new exact acceptance profile.** Retain historical
   default fake/live pins and candidate guards. Add a separately selected
   packaged-v1.1 profile only after release and consumer inputs exist. The
   profile fixes full component commits, contract archive/lock hashes, image
   identity, CLI and architecture. An operator packet must match it exactly.
4. **Preflight the environment without activation.** Verify configured secret
   paths and ownership through the existing wrapper without printing values;
   verify state directories, free ports, available engine resources, package
   admission, browser automation access and resolved Compose configuration.
   Preserve the existing external database volume. Build images serially, with
   one Cargo build job, following the recorded resource-exhaustion correction.
5. **Activate only the reviewed stack after explicit activation approval.**
   Verify readiness/private DNS and actual image/source identities. Before
   provider calls, exercise the browser cases that need no model turn. Then
   perform the separately authorized live cases and retain partial failures.

Valid alternative: verify the original published-v1.0 stack using its exact old
reviewed source/image set. Classify that as historical-v1.0 acceptance; it cannot
close current defaults/F1 or final-lock packaged acceptance. The recommended
path above covers the current intended integration without expanding the local
candidate exception to provider use.

## Acceptance matrix

Each row has an independent result: `passed`, `failed`, `not-run`, or
`unavailable`. Only rows with complete supporting evidence may pass.

| ID | Required observation | Required evidence |
| --- | --- | --- |
| P1 | Actual opt-in Compose services ready; broker/mediator catalog path resolves over private DNS; no direct worker room-storage access | Resolved redacted configuration, service/image IDs, health and authenticated catalog/defaults projections |
| B1 | Real browser Keycloak PKCE login, callback, explicit room entry and reload | Browser/version, redacted screenshots, room/event correlation, no tokens in URLs or retained artifacts |
| B2 | Ordinary public messages and targeted messages do not invoke Codex; explicit room-wide selection/mention does; targeted Codex delivery is refused | Two human browser sessions, event/task counts, request types and public safe outcomes |
| B3 | Shared continuation and explicit New disclosure, prompt preservation on busy/stale failure, one assistant bubble per reply | Real DOM observations correlated to task/reply IDs; browser reload and second-human continuation |
| B4 | Visible initial/default pair, restored shared pair and New defaults; controls match actual admitted capabilities | Displayed/submitted/accepted/effective pair comparison and real DOM controls for the deployed admission. Retain the four-capability synthetic matrix as separate evidence; additional browser variants require an existing supported configuration or a separately approved test design |
| L1 | Public baseline/correction and intervening delta delivered; targeted canary and cross-room context excluded | Authorized packet/source IDs and native input inspection, plus reply checks; absence from answer alone is insufficient |
| L2 | Worker restart resumes same native thread; explicit New uses distinct thread with authorized baseline | Private receipt inspection and task/conversation/generation/thread correlation; no forgetting requirement |
| L3 | Model/effort change confirmed, shared settings restored, no automatic model fallback, usage fresh or explicitly unavailable | Runtime-confirmed settings and latest-task telemetry; generic failures remain account-access unclassified |
| I1 | No shell/file/MCP/external-tool execution, arbitrary destination access or provider-key disclosure | Actual native request/tool-policy evidence and proxy/kernel audit; refusal prose alone is insufficient |
| I2 | Namespace owner/proxy/policy loss terminates dependents; recovery recreates owner and dependents; cold bootstrap rejects stale admission | Controlled loss evidence, process/container state, expiry checks and post-recovery readiness |
| R1 | Retained deterministic behavior, contract compatibility and applicable component suites pass at selected sources | Exact commands, exit codes, source/image/contract identities and review findings |
| C1 | Owned test containers/processes removed; existing database volume retained; no private data committed | Before/after owned-resource inventory, cleanup result and reviewed Git diff |

Unavailable second-model access must be recorded as missing coverage, never a
pass. Generic task errors cannot establish account-specific denial. Retain the
known synthetic denial test separately and leave the corresponding live claim
open unless runtime evidence establishes it. Browser cases requiring turns
belong to provider-authorized execution. Existing `browser-smoke.mjs` uses Node
HTTP/WebSocket; jsdom and that script do not satisfy B1–B4.

## Evidence and acceptance decision

Use a private run directory outside all Git worktrees for operator packets,
tokens, native sessions/receipts, raw logs and browser captures. Existing private
path, owner-mode, distinct-human, exact-loopback and exclusive-new-output guards
remain mandatory. Sanitize HAR/network captures before retaining or sharing;
they can contain Authorization headers, cookies and room content.

The committed public summary names the acceptance-profile file hash, full
source commits, contract tag/commit/archive/lock hashes, actual image IDs,
architecture, CLI version/hash, start/end UTC times, scenario IDs/results,
command exit codes, redacted evidence digests, cleanup outcome and reviewer.
Keep fake-native, actual-package synthetic, real-browser, and live-provider
results separately classified. Store raw evidence access/retention details in
the private run manifest, not credentials or private content in Git.

Mark Task 9 accepted only after its original checklist, P1–C1 and the final
cross-project review are satisfied. A failed isolation check disables Codex and
blocks live/release acceptance. Infrastructure failure, inaccessible browser,
unavailable image, or missing release artifact is a failed/missing prerequisite,
not an isolation refusal or successful scenario. Commit reviewed, sanitized
evidence before requesting product release/deployment approval. This procedure
does not authorize image publication or production deployment.

## Preparation verification — 2026-11-20

The documentation-only preparation passed the existing organization link check
(1,016 links in 172 Markdown files, zero broken), root specification hierarchy,
repository-reference and identity gates, and whitespace checks. All 13 existing
platform live-run guard tests passed without an engine or provider run. A
read-only comparison verified every preparation commit, both CI image/proof
pairs and the two platform file fingerprints against local source/evidence.
Self-review retained the deployed capability scope for browser acceptance;
the existing four-capability synthetic matrix remains separately attributed.

These results validate the prepared documents and unchanged guard behavior.
They do not implement the new profile, approve the amendment, publish v1.1,
start the stack, or close Task 9. No runtime source or contract artifact changed.
