# Task 9 source integration and package preflight

Status: authorized on 2026-11-23 by the maintainer's “proceed” after the
workspace analysis identified source integration followed by Task C preflight.
This is execution of the [approved acceptance procedure](task9-packaged-acceptance-2026-11-20.md),
not a new runtime capability or approval to activate services or call providers.

## Scope and sequence

1. Integrate the reviewed contracts release, broker/UI released consumers and
   platform acceptance-profile branches into their owning canonical mains.
   Reconcile documentation conflicts while preserving reviewed runtime bytes.
2. Keep the published v1.1 tag and artifacts, historical vendors, acceptance
   profile and all six frozen source commits unchanged. Later documentation or
   integration commits are not replacements for those acceptance inputs.
3. Verify the merged components, unchanged profile/guards and actual worker
   package. Retain a read-only independent review before advancing mains.
4. Stage exact source inputs and build production images serially with one
   Cargo job. Record actual source/image identities and architecture. Preserve
   the existing external database volume and remove only owned test fixtures.
5. Complete Task C with real configured credential paths, reviewed policies,
   private state, two human identities, browser access and a concrete operator
   packet. Missing configuration remains an explicit unmet prerequisite.
6. Request the separate activation/provider approvals only against the complete
   reviewed inputs. Task D and Task 9 acceptance remain open until their own
   required evidence is recorded.

## Integration inputs

| Owner | Prepared branch | Frozen implementation |
| --- | --- | --- |
| Contracts | `codex/task9-contract-release-20261120` | `f1c8621810c8c121c1aafc8e5a342d6626c4b843` |
| Broker | `codex/task9-broker-release-20261120` | `673294e66fed2b6e98d73e08cfe4a23a0e5e4d48` |
| UI | `codex/task9-ui-release-20261120` | `29a940012adfeb796f59c5b89b00cab7a4d0df68` |
| Platform | `codex/task9-packaged-profile-20261120` | `996e1887234b8958a315279aa3d5aa194a7fad52` |

Remote fetch and GitHub branch inspection on 2026-11-23 confirm that prepared
branches are already published and canonical mains have not incorporated them.
Earlier “unpushed” descriptions are stale. Merge preparation found only Markdown
conflicts caused by the earlier canonical/feature documentation refreshes.

The profile SHA-256 remains
`7106f7e41a6bc13feab8a0b51fccde9b47fefca2d63980d551ed929eac1c1a71`.
Its clean component snapshots remain available through the source map described
in [workspace state](workspace-state.md). The operator packet must name the
actual clean executing platform commit. The worker image remains
`sha256:2dd78cdf5eddb9ca271611998ea44fe6d6cfde6cfca8ba7d1d6c8858240b540d`.

## Evidence boundaries

Fresh component tests, package probes and source/image preflight do not establish
assembled-stack, private-DNS, Keycloak/browser, provider, tool/egress or production
acceptance. Memory remains a separate incubating proof, with no Codex integration;
guided directories, Cognee, durable memory and remote admission remain deferred.
Record final commands, identities, failures, cleanup and remaining prerequisites
in the execution checkpoint before deriving current workspace documentation.

## Execution checkpoint — 2026-11-23

All four component integrations are pushed and independently rechecked against
remote main: contracts `7e1555f`, broker `ad4d025`, UI `3dc3ec7` and platform
`ebc654e`. The reconciled changes relative to prepared branch tips are Markdown
only. The published tag still peels to `f1c8621`; profile bytes and six frozen
component sources are unchanged. The organization profile and current root
guidance reflect integration, with lifecycle/maturity unchanged.

Fresh component verification passes the full contracts fixture/release suite,
160 broker tests with one intentional external-agent ignore, 193 UI tests with
one intentional composed skip, TypeScript/build, 46 profile/historical guards
and five Compose/input/startup guards. The canonical contracts install now
matches its lock (fast-uri 3.1.9); its full suite passes after installation.
Independent agent integration and documentation reviews found no actionable
issue. These are component checks, not the assembled run's R1 acceptance.

Nine production images were built serially on native Linux ARM64 from the
staged exact source inputs and unchanged production Containerfiles. Rust builds
use one Cargo job. Separate local preflight tags preserve existing dev tags;
an immutable Compose image override is prepared privately. The existing reviewed
worker image remains fixed by the profile. Ten package/startup probes pass,
native capture reproduces all 44 model/effort cases, resume and six refusals
byte-for-byte, and actual image/package/source preflight passes in a network-none
sleep fixture. The first scratch-driver build attempt was rejected by Podman's
optional `--pull` argument parsing before building; `--pull=missing` corrected
that invocation. Its failed attempt remains separately retained and unaccepted.

The [sanitized evidence](../../../docs/evidence/task9-integration-preflight-2026-11-23.json)
records remote integration IDs, source/profile/CLI/proof identities, nine image
IDs and Containerfile/log hashes, base inputs, observed VM resources and explicit
remaining gates. Required loopback ports were free. Native Chrome accessibility
controls are available; DevTools and browser-host controllers are unavailable.
No packaged browser scenario ran. Owned verification fixtures are removed,
zero containers are running and the external database volume is preserved.

Task C remains incomplete: no actual operator environment/configuration was
provided or found in the environment or platform checkout. Three private,
distinct credential-file paths, reviewed model policies and prepared state
ownership must pass the existing wrapper's real configuration preflight.
The private operator packet is owner-only and keeps activation/provider/tool
approvals false; live human token files are not present. Human authentication,
actual running-container identity and resource/readiness evidence remain part
of the later authorized run. A configuration-path question is pending.

No application stack or provider was activated. P1–C1, Task 9 acceptance,
registry-image publication and production deployment remain open. Do not ask
for activation/provider approval until the missing preflight configuration is
concrete and reviewable under the approved procedure.

## Existing shell authentication reused — 2026-11-23

The maintainer clarified that shell Codex is already configured and no new key
or repeated manual key entry is needed. A read-only login-status check confirms
saved API authentication, and configured `gpt-6.1-sol`/`medium` is present in the
pinned worker catalog and retained native policy proof. This supersedes the
earlier request for the maintainer to supply another credential/configuration.

Existing Task C operator provisioning now uses the cached API credential once
to prepare the worker-only private credential file. No host login/configuration
or native conversation history is imported or changed. Separate internal
invocation/catalog credentials and matching broker/mediator policies are
prepared privately. The host CLI remains 0.171.0 and the packaged worker remains
the exact reviewed 0.160.0; reusing authentication does not substitute host
runtime/configuration for the verified container. No runtime code, image,
profile, published artifact or frozen source input changes.

Five actual provider-free checks pass: state ownership, worker --check/package
admission with its real private input files, mediator recipient/state access,
broker recipient-only access, and the existing host wrapper's resolved Compose
configuration with the immutable image override. Output is retained privately
with credential-value exclusion and redaction. Credential source files are
inside owner-only host directories; Compose mounts only each recipient's
declared read-only file. Packet/provider/tool approvals remain false.

The first macOS shared-directory probe reported state ownership as 0:0 inside
the worker and was correctly rejected by its unchanged UID/GID guard. An empty,
dedicated engine-native runtime-state volume preserves the required per-service
UID/GID/modes and passes the repeated checks. Keep this prepared runtime volume
for the later run; owned probe containers are removed and the external database
volume is preserved. This correction changes operator storage configuration,
not runtime authority or the production Compose source.

The [cached-auth preflight evidence](../../../docs/evidence/task9-cached-auth-preflight-2026-11-23.json)
records the successful checks, rejected shared-directory attempt, model/effort,
redacted configuration hash and approval state without credential values or
private host paths. Task C's missing operator configuration is resolved and the
inputs are ready for activation review. Refresh the proposed bounded admission
expiry if needed before startup. The existing separate service-activation gate
now applies; browser human authentication/token acquisition and actual
container/readiness/resource observations follow authorized startup. Provider
and tool execution retain their own approval. No application stack or provider
was activated, and P1–C1/Task 9 acceptance remains open.

## Authorized activation: partial failure — 2026-11-23

The maintainer answered “proceed” to the explicit question to start the reviewed
local stack without model calls. Activation is authorized; provider/tool calls
remain unauthorized. [Actual activation evidence](../../../docs/evidence/task9-activation-2026-11-23.json)
supersedes the preceding not-activated/ready-for-review status. No model turn was
requested; the dedicated test room has zero events. Conversation/task counts
cannot be queried because their tables are absent in the existing volume.

Stock startup failed because installed Compose 1.6 emitted a bare hostname for
the mapping-form loopback extra-host entry. Merging a list override also fails
in that version. A privately materialized, hash-bound effective configuration
converts only that entry to its equivalent list form, with actual dry-run
RED/GREEN Podman argv evidence. Activation still invokes the unchanged host
secret-check wrapper. A missing mediator DNS alias was then added to its actual
namespace owner on the existing agent-internal interface; no network or port
was added. The full stack was recreated with dependency health ordering intact.
These are attributed deployment adaptations, not canonical source fixes.

All eleven services initially ran, and the private mediator DNS lookup then
passed. Two distinct local fixture users authenticated with PKCE. UI HTTP is
200, room WebSocket ingress responds with its expected unauthenticated upgrade
status, and Keycloak discovery is available. Authenticated catalog/default
requests still return 503 `runtime_unavailable`; P1 is failed, not accepted.
The existing database has the earlier room/task tables but lacks the conversation
tables required by migrations 0006/0007; its migration ledger is empty. Image
init scripts do not upgrade an already initialized external volume. No schema
migration was applied during this run. Establish actual schema state and verify
the approved migrations on a private restored backup before proposing an upgrade.

A network-none diagnostic fixture using the exact image/controls/native state
successfully initializes CLI 0.160.0 and lists models. Initialize, model-list and
startup notifications validate against their pinned schemas. Normal
`configWarning` and disabled `remoteControl/status/changed` notifications carry
the pinned `emittedAtMs` metadata rejected by the worker's closed envelope. This
identifies a native-adapter compatibility blocker, not a missing authentication
credential. Runtime sources, images and the frozen profile remain unchanged.

The Codex namespace watchdog subsequently exited with its generic isolation-loss
message; proxy and worker stopped with their shared PID namespace. Current
container OOM flags are false and observed kernel OOM records predate this run.
The triggering policy/proxy condition remains undetermined. Keep the live Codex
side disabled; do not relax safeguards or claim I1/I2 acceptance. Eight base
services initially remained running; the mediator subsequently stopped with
exit 1. Its cause is not established and is not attributed to the Codex watchdog.
The final checkpoint records seven running services. The database is preserved and
the owned network-none diagnostic fixture was removed. Public readiness-file
expiry prevents fresh Codex admission after shutdown.

Rendered-browser coverage is unavailable: the isolated browser host could not
connect, and the native Chrome controller reported concurrent user changes.
No browser acceptance or screenshots are claimed; HTTP PKCE is separate evidence.
The [bounded compatibility proposal](task9-runtime-compatibility-proposal-2026-11-23.md)
is prepared for maintainer review before worker runtime changes. It covers the
native metadata/notification handling, durable Compose/DNS corrections and
separate provider-free watchdog investigation. It grants no implementation or
provider authorization until approved, and no changed package/profile is yet
prepared or activated.
