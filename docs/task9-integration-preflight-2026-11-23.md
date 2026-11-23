# Task 9 integration and package preflight — 2026-11-23

**Later checkpoint:** authorized startup partially failed. Seven services remain
running; Codex is disabled and the mediator is stopped. P1 failed, browser B1 is
unavailable and no model turn was requested. The
[activation report](task9-activation-2026-11-23.md) supersedes ready/not-activated
wording below; the retained preflight evidence keeps its original scope.

Source integration is complete. All nine production images are built; the
reviewed worker image is available. Actual private-input/state/Compose preflight
now passes using existing shell Codex authentication. Inputs are ready for
separate activation review. No application stack or provider was activated,
and Task 9 is not accepted.

Derived from the [authorized integration scope and execution checkpoint](../.ai/specs/how/task9-integration-2026-11-23.md)
and [current workspace specification](../.ai/specs/how/workspace-state.md).
The [sanitized evidence manifest](evidence/task9-integration-preflight-2026-11-23.json)
retains full commits, immutable image IDs, source/Containerfile/proof/log hashes,
base-image inputs, command outcomes and explicit remaining gates.

## Integrated sources

| Owner | Pushed canonical main | Frozen acceptance source |
| --- | --- | --- |
| Contracts | `7e1555f` | Published tag source `f1c8621` |
| Room gateway | `ad4d025` | Released consumer `673294e` |
| Workspace UI | `3dc3ec7` | Released consumer `29a9400` |
| Platform | `ebc654e` | Profile implementation `996e188`; packet names actual executing `ebc654e` |

All four prepared branches and their mains contain the integration commits;
remote main identities were independently rechecked. Markdown conflicts were
reconciled without changing reviewed runtime bytes. Published artifacts,
historical vendors, six frozen component inputs and the profile hash are
unchanged. Independent agent integration and documentation reviews found no
actionable issue. The organization profile and maintained root guides now
describe integrated sources rather than pending integration.

## Verification and prepared images

| Check | Result |
| --- | --- |
| Contracts | Full room/conversation/defaults and candidate/release suites pass; canonical install matches fast-uri 3.1.9 lock. |
| Room gateway | 160 tests pass; one intentional external-agent ignore. Isolated migrated database removed. |
| Workspace UI | 193 tests pass; one intentional composed skip. TypeScript and production build pass; existing Vite chunk advisory remains. |
| Platform | All 46 profile/historical guards and five Compose/input/startup guards pass. |
| Worker package | Ten actual startup/admission probes pass without provider inference. |
| Actual native capture | 44 model/effort cases across eight models, resume and six unsolicited-tool refusals reproduce the retained ARM64 proof byte-for-byte. |
| Source/image preflight | Actual clean platform plus six exact clean component sources pass; network-none worker fixture verifies immutable image, labels, installed CLI/proof bytes and package admission. |
| Workspace documentation | 1,315 Markdown links in 190 files pass with zero broken links; specification hierarchy, repository-reference, identity and whitespace checks pass. |

PostgreSQL, Keycloak, room gateway, memory engine, reference agent, agent gateway,
agent egress, workspace UI and provider proxy production images all built from
the staged exact inputs on Linux ARM64. Rust builds used one Cargo job and
builds ran serially. Separate local preflight tags preserve existing dev tags;
the private immutable Compose override also fixes the unchanged worker image.
No registry images were published. One initial scratch-driver invocation was
rejected before building because of Podman optional-argument syntax; its failed
attempt is retained separately from the nine successful builds.

Required loopback ports were free, owned verification fixtures were removed,
zero containers were running and the existing external database volume was
preserved. The VM has six CPUs, about 2 GB RAM and no swap; full-stack resource
acceptance has not run. Native Chrome controls are accessible. DevTools/browser
host access is unavailable; no packaged browser scenario has been exercised.

## Existing authentication reused — latest checkpoint

The maintainer clarified that shell Codex is already configured. A read-only
status check confirmed saved API authentication. Its existing credential now
provisions the private worker input once; no new key, manual key entry or host
login change is needed. Host configuration and conversation history remain
outside the container. The host CLI remains 0.171.0; the worker keeps its exact
reviewed 0.160.0 runtime. The configured `gpt-6.1-sol`/`medium` pair is retained
within its approved catalog and native proof coverage.

Five actual checks pass without provider access: engine-native state ownership,
worker package/startup --check with the real private input files, mediator
recipient/state access, broker recipient-only access, and the existing wrapper's
resolved Compose configuration with exact images. The first shared-directory
probe correctly failed because macOS reported state ownership as 0:0; a dedicated
engine-native runtime-state volume preserves required per-service ownership and
passes the unchanged checks. Keep that prepared runtime volume for the later run.
Owned probe containers are removed and the external database volume is preserved.

The [cached-auth evidence](evidence/task9-cached-auth-preflight-2026-11-23.json)
records safe outcomes and the redacted configuration hash. It supersedes the
initial evidence manifest's missing-configuration status; prior evidence remains
dated and unchanged. No credential values or private host paths are published.

## Next action

The owner-only draft operator packet and immutable image override are prepared
outside Git. Activation, provider-call and tool-probe approvals remain false.
Human authentication/token files and actual running-container identity still
need the later authorized workflow. Review the complete prepared inputs and
proposed bounded admission expiry before the procedure's separate service
activation approval. Refresh the expiry if needed before startup. Provider
and tool-probe calls retain their own approval.

Assembled-stack/private-DNS, B1–B4 browser, L1–L3 provider, I1–I2 isolation and
full acceptance-run R1/C1 evidence remain open. Memory integration, guided
directories, remote admission, registry publication and production deployment
remain separately scoped. The [workspace guide](workspace-status.md) retains
the exact source overrides for resumption.
