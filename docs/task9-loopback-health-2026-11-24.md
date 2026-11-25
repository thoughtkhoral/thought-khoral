# Task 9 loopback health correction — 2026-11-24

Subsequent source checkpoint — 2026-11-25: the approved
[worker/platform/workspace source integration](task9-compatibility-integration-2026-11-25.md)
is published. Earlier local/unmerged or approval-pending descriptions below
retain their dated scope; historical evidence/source identities are unchanged.

Subsequent checkpoint — 2026-11-25: the separately approved
[existing database upgrade](task9-database-upgrade-2026-11-25.md) is complete.
Database-pending observations below describe the dated checkpoint. Codex remains
off. Subsequent [corrected-stack startup subchecks](task9-corrected-startup-2026-11-25.md)
passed on internal-only networks; the timed gate remains open and a fresh window
requires separate approval.

The approved local firewall correction resolves the reproduced TCP teardown
defect. The original policy leaves three health-check clients in LAST_ACK; the
corrected policy leaves zero. The exact new image passed 660.005 seconds of
watchdog observation and proxy-loss fail-stop. Source changes remain on local branches.

Authority: [approved amendment](../.ai/specs/how/task9-loopback-health-policy-amendment-2026-11-23.md)
and [execution record](../.ai/specs/how/task9-loopback-health-execution-2026-11-24.md).
This follows the [worker/platform compatibility correction](task9-runtime-compatibility-2026-11-23.md).
The [sanitized verification manifest](evidence/task9-loopback-health-2026-11-24.json)
records exact inputs, checks and remaining gates.

## What changed

The firewall now permits one narrowly defined kernel-generated reply ACK:

- IPv4 loopback, source and destination 127.0.0.1;
- no full owning socket; already tracked ESTABLISHED reply direction;
- original destination 127.0.0.1:3128;
- total packet length 52, IP header 20 and TCP header 32, flags exactly ACK
  and reserved bits zero, leaving no room for payload.

Other header forms, INVALID/UNTRACKED/NEW traffic, additional ports/destinations
and application-owned sockets gain no permission. IPv6 policy, UID controls,
one-second health timeout and whole-policy watchdog remain unchanged.

## Verification and exact package

Real-kernel counter-only diagnosis identified the approved predicate before any
allow rule was added. Six rejected socketless ACKs matched that predicate;
INVALID/UNTRACKED/original-direction counters remained zero. The regression
failed before the fix and passes after it. Nine raw-packet cases show that only
the exact empty ACK matches the header predicate; payload, same-length disguised
payload, IP/TCP option/length, PSH and reserved-bit variants do not match. These
counter-only probes use refused port 3130; actual health teardown separately
proves the allow rule. Actual packaged-image
tests verify installed policy bytes without a mounted override.

The retained full kernel suite passes IPv4/IPv6, direct-provider/DNS denials,
controlled local verified TLS, proxy loss/readiness expiry and policy-tamper
fail-stop. Fifty-four profile/historical/schema/compatibility tests, five Compose
tests, one input and one startup test pass. Missing temporary historical inputs
were restored at their exact commits, preserving previous partial directories
and matching the original candidate archive/lock hashes.

| Input | Verified identity |
| --- | --- |
| Clean implementation source | `a9c3ff5c79e7d3525bed0b5968ab1d8be6b2cc23` |
| Reviewed platform/specification/documentation HEAD | `78b3e178eacb087c46f4ecd5c4d24118aaceab07` |
| ARM64 proxy/namespace-owner image | `sha256:54dc5c7d649e486bff7f5f8821050b800ae5cb454cd8496a9f93ce0047d07cf1` |
| Installed policy SHA-256 | `023203915acb11fe9b66183bc65426e52783fa934a89f252c15be5a147ae01dc` |

The first actual-watchdog run observed 660.003 seconds with the corrected policy
on the unchanged base image; intentional proxy loss then stopped the namespace
and dependent. A separate 660.005-second observation of the exact immutable new
image passes; proxy loss then stops its namespace and dependent. All owned
containers are removed. These are bounded provider-free fixtures, not packaged-stack or
production acceptance. No public-provider/model request was made.

The original and compatibility profile bytes, worker image and public contract
remain unchanged. New source/image identities are prepared for future operator
review. Existing database upgrades, source publication/merge, changed-input
activation, rendered-browser and provider/live acceptance retain their gates.
The [existing-database upgrade proposal](../.ai/specs/how/task9-existing-database-upgrade-proposal-2026-11-23.md)
is the next data-maintenance review; no existing-data upgrade has been applied.

All owned loopback-test containers are removed. Seven base services remain
running, UI HTTP is 200 and the existing external database volume is preserved.
Workspace/project links, specification hierarchy, repository references,
identity validation and whitespace checks pass. Independent review found no
remaining actionable issue. The private image-override draft retains the frozen
compatibility worker and changes the two proxy/namespace images; it enables no
activation or provider approval flag.
