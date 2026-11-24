# Task 9 runtime compatibility correction — 2026-11-23

**Later checkpoint:** the maintainer approved the firewall amendment on
2026-11-24. The [loopback correction report](task9-loopback-health-2026-11-24.md)
supersedes its approval-pending wording below; historical proof retains its
original tested source and scope.

The maintainer approved bounded local correction after the
[partial activation](task9-activation-2026-11-23.md). This report derives from the
[approved proposal](../.ai/specs/how/task9-runtime-compatibility-proposal-2026-11-23.md)
and [execution record](../.ai/specs/how/task9-runtime-compatibility-execution-2026-11-23.md).
Changes remain on isolated local branches. No existing database upgrade,
publication or changed-input stack activation has been performed.
The [sanitized verification manifest](evidence/task9-runtime-compatibility-2026-11-23.json)
binds source/image/profile identities and the exact scope of each check.

The worker correction at `423d4e84985eb535caa66c7522c4191c6dbccad6` handles
pinned timestamped startup notifications in catalog discovery and conversation
processing. It accepts only the reviewed bundled-bubblewrap warning and disabled
remote-control state, with strict schemas, integer metadata and closed fields.
Unknown notifications, malformed metadata, tool requests and unsupported security
warnings remain rejected. All 50 worker tests, fmt/clippy and required pin,
legal/catalog/documentation checks pass. Independent review found no actionable
issue and independently ran the four new test functions.

The new local ARM64 production image is
`sha256:1ac229b25167845b4d7cec217304f3064b02d65d60c53f35b07c5ae3e3683b3b`.
It was built from a clean exact archive of that worker source, with source and
unchanged Cargo-lock provenance labels. All ten package/startup probes pass.
Actual isolated native capture reproduces the retained proof byte-for-byte:
44 model/effort cases across eight models, fresh-process resume and six synthetic
unsolicited-tool refusals. This uses a network-none local synthetic provider;
it establishes no account/model availability or public-provider inference.
Real packaged adapter verification also passes: old image HTTP 503 becomes HTTP
200 with the corrected image, six normalized efforts and zero conversation/task
receipts or requested turns. All owned adapter fixtures were removed.

The separate `packaged-v1.1-runtime-compat` profile is prepared at clean platform
source `8edcca07d5ae90c1a66c2f7f8915ead7edf9f0d3`, SHA-256
`14c5a784a1f6d8c944f25570f1b0dda741831178348ad7052ecb7301529d2f0c`.
Only its identity and worker source/image differ from the preserved original
profile. Actual clean-source/image/package/read-only-clone-schema helper checks
pass, without live-mode activation or provider calls. Fifty-four combined guards
pass; the optional historical cleanup suite is obstructed by occupied port 8080.

The platform fixes preserve the loopback proxy target and add the mediator DNS
alias on its existing namespace owner. Five actual Compose-generation tests pass,
along with 46 retained profile/historical guards. A bounded read-only schema
verifier checks required columns, constraints and indexes without reading room
data or relying on the migration ledger. It rejects the current database and
accepts the migrated private copy. Independent review found no actionable issue
and reran the offline Compose/schema tests.

The owner-only database backup restores successfully to an isolated network-none
fixture. Approved migrations 0006/0007 preserve earlier table data and establish
the required constraints. An additional private restore verified an atomic
combined transaction and rollback of both migrations after forced failure. The
[existing-database upgrade proposal](../.ai/specs/how/task9-existing-database-upgrade-proposal-2026-11-23.md)
is concrete and awaits separate approval; no existing-data migration was applied.

The unchanged watchdog reproduced a stop after a one-second local proxy TCP
connect timeout; whole-policy comparison had continued to pass. Further packet
metadata/counter observations expose incomplete TCP teardown and rejected traffic.
The causal connection to the earlier timeout is not yet established. The
[bounded loopback-policy amendment](../.ai/specs/how/task9-loopback-health-policy-amendment-2026-11-23.md)
is prepared for separate approval before any security behavior changes.
Timeouts, policy and fail-stop behavior are unchanged. The original mediator log reports only `Rejected`, which can
represent token, claim, decoding or update rejection. Fresh workload-token
authentication passes a read-only nonexistent-task check; it does not establish
the earlier failure's cause. No real tasks were claimed during diagnosis.

The current base UI remains available at [localhost:8082](http://localhost:8082).
Live Codex remains disabled; Task 9, rendered-browser and separately authorized
provider/live acceptance remain open. Earlier AMD64/MSRV evidence applies only
to its original tested source.

All owned diagnostic containers and the database clone have been removed.
The private backup remains owner-only. Seven base services remain running,
UI HTTP is 200 and the existing external database volume is preserved.

The private draft operator policy retains `gpt-6.1-sol`/`medium` defaults and
proposes admitting the six effort capabilities actually advertised by the worker;
the original medium-only configuration would reject that catalog. The draft is
not activated and requires review with any future changed-input activation.
