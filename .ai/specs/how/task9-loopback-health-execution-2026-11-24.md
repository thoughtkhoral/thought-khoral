# Task 9 loopback health execution — 2026-11-24

Authority: explicit maintainer approval of the [bounded firewall amendment](task9-loopback-health-policy-amendment-2026-11-23.md).
Use the existing clean isolated platform branch; preserve canonical main and
the frozen original/compatibility profile bytes. This work adds no existing-data
upgrade, source publication, changed-input activation or provider authority.

1. Record approved local How before implementation.
2. Reproduce original-policy teardown in an owned network-none fixture. Add only
   nonterminating counter predicates while identifying rejected ACK state,
   direction and socket ownership; do not grant traffic on a hypothesis.
3. Test the approved exception only if the exact socketless ESTABLISHED reply
   predicate is confirmed. Verify zero payload and all existing connection/UID
   limits. A different predicate or unsafe representation stops the correction.
4. If eligible, implement with regression tests, real-kernel RED/GREEN, long
   health observation and fail-stop/negative-egress checks. Otherwise retain the
   diagnostic result and prepare a precise replacement amendment.
5. Independently review, update workspace/project specifications and derived
   documentation, clean owned fixtures and commit local reviewable checkpoints.

## Verified local checkpoints

- Owning platform design committed before implementation at `6c03ae5` and
  `b201479`. The original-policy regression leaves three clients in LAST_ACK;
  six counted socketless ACKs match ESTABLISHED reply direction and the strict
  zero-payload header predicate, with zero INVALID/UNTRACKED/original matches.
- Correction committed at `a9c3ff5c79e7d3525bed0b5968ab1d8be6b2cc23` on the
  isolated platform branch. It permits only IPv4 loopback 127.0.0.1 pure ACKs,
  no full owning socket, ESTABLISHED reply direction, original destination
  127.0.0.1:3128, total length 52, IHL 20 and TCP header 32 with zero reserved
  bits. Therefore no payload fits. IPv6, application-owned socket UID checks,
  initial connections, the one-second timeout and whole-policy guard are unchanged.
- Real-kernel GREEN leaves zero clients in LAST_ACK and exercises six eligible
  ACKs. Nine raw header cases match the header predicate only for the exact empty
  timestamped ACK; payloads, same-size disguised payloads, options/length variants,
  PSH and reserved bits do not match it. All raw probes use refused port 3130;
  actual health teardown separately proves the allow rule. Predicate-positive and forbidden-
  class counter deltas are mandatory assertions.
- Retained full kernel suite passes direct-provider/DNS/IPv4/IPv6 denials,
  controlled local verified TLS, proxy-loss/readiness expiry and policy-tamper
  fail-stop. No public-provider traffic or worker model turn was requested.
- Fifty-four profile/historical/schema/compatibility tests, five Compose tests,
  one input test and one startup test pass. Initially missing historical temporary
  checkouts were restored from exact local commits; partial previous directories
  were preserved privately. Rebuilt candidate archive and lock match their
  immutable hashes; no frozen metadata or canonical component source changed.
- New immutable local ARM64 proxy/namespace-owner image:
  `sha256:54dc5c7d649e486bff7f5f8821050b800ae5cb454cd8496a9f93ce0047d07cf1`.
  Built from clean `a9c3ff5` with source/policy labels. Installed policy SHA-256 is
  `023203915acb11fe9b66183bc65426e52783fa934a89f252c15be5a147ae01dc`.
  Actual packaged-image teardown/header checks pass without a policy override.
- Initial 660.003-second actual watchdog observation using the exact new policy
  file on the unchanged base image passes; proxy loss then stops namespace and
  dependent. The exact newly packaged image's separate observation passes
  660.005 seconds, then proxy loss stops namespace and dependent. Its installed
  policy hash matches source and all owned fixture containers are removed.
  This uses the clean final test harness at `4d5a445`.
- Independent review found no runtime-scope issue. Its regression-assertion
  finding was fixed and scoped rereview is clean. The
  [sanitized evidence](../../../docs/evidence/task9-loopback-health-2026-11-24.json)
  binds the final package, observations, limits and remaining gates. Workspace
  and platform specifications/documentation are updated together.
  Final clean platform/specification/documentation HEAD is
  `78b3e178eacb087c46f4ecd5c4d24118aaceab07`; every production-image input remains
  byte-identical to the clean image-building implementation source `a9c3ff5`.
- Final owned-fixture count is zero. Seven base services remain running and UI
  HTTP is 200; the existing external database volume is preserved. Root and
  isolated-project link checks, hierarchy, repository references, identity and
  whitespace pass. Final independent scoped rereview is clean. A private future-
  activation image draft preserves the frozen compatibility worker and replaces
  only its two proxy/namespace service images, with all approval flags false.

Existing database upgrades, publication/merge, changed-input activation and
provider/live acceptance remain unperformed and separately gated.

## Validation maintenance

Scanning the isolated platform under its canonical component prefix exposed a
pre-existing compatibility-test validation gap: the November 23 runtime-profile
test constructs the same exact retained JWT role-claim line already permitted
in the two older verification tests, but its new path was absent from the identity
validator. Extend only that enumerated path using the existing exact-line rule.
Add positive and adjacent-legacy-service negative regression cases before the
validator edit. Do not rename/obfuscate the wire claim or grant a whole-file or
directory exception. This is validation maintenance under the existing accepted
compatibility policy, not new runtime or firewall authority.
