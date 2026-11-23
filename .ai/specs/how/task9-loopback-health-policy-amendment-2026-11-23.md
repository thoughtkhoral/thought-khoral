# Task 9 loopback TCP health-policy amendment

Status: **proposed; awaiting approval**. The [approved compatibility scope](task9-runtime-compatibility-proposal-2026-11-23.md)
permits diagnosis but requires a separate amendment before a security-design
change. No firewall rule, timeout or watchdog behavior has been changed.

## Evidence and remaining uncertainty

Two owned network-none fixtures reproduced fail-stop after local proxy health
failure. The detailed run failed at health call 461 during TCP connect, after
1.000862 seconds. Load averages were 0.185/0.211/0.269 and available memory was
634088 kB. Container OOM flags were false; observed kernel OOM entries predate
this run. This does not establish the original deployed failure's exact cause.

A further unchanged-policy fixture shows substantial rejected traffic during
ordinary local health checks, with client LAST_ACK and server TIME_WAIT sockets.
A passive 120-packet metadata capture shows successful TCP handshakes and HTTP
responses followed by FIN exchanges without a corresponding final proxy ACK in
the captured outgoing stream. Only TCP flags/ports/lengths were recorded, never
request contents. One later snapshot counted 104 client LAST_ACK sockets; the
filter's reject counter reached 3400. These observations support a teardown-rule
defect; they do not prove that it caused the earlier intermittent connect timeout.
Diagnostic logging changes timing and is not timing-identical production proof.

## Proposed bounded local work

1. First make the teardown defect deterministic in an owned network-none kernel
   fixture with the original policy. Correlate the rejected packet, conntrack
   direction/state, socket ownership and before/after counters. Demonstrate the
   missing final ACK and retained LAST_ACK state without loading a provider key.
2. If that evidence confirms a socketless kernel-generated reply ACK is rejected,
   test one narrowly scoped exception: IPv4 loopback output, source/destination
   127.0.0.1, TCP pure ACK, already tracked ESTABLISHED reply direction, original
   destination port 3128, and no owning full socket. Preserve UID checks for
   application-owned sockets and every initial connection. Do not admit NEW,
   RELATED or INVALID traffic, additional destinations/ports, data-bearing
   requests, worker DNS/direct egress, or an unowned general ESTABLISHED rule.
3. Require real kernel RED/GREEN tests: affected teardown completes and LAST_ACK
   does not accumulate; repeated health connections survive the observed failure
   window; proxy loss and any firewall tamper still stop the namespace and expire
   admission. Retain negative direct-provider/DNS/other-port checks and both
   IPv4/IPv6 denials. Keep the one-second health timeout and whole-policy guard.
4. If the proposed predicate cannot be represented safely, the packet is not in
   the specified state/direction, or the change fails to resolve the proven
   defect, do not widen the rule. Record the result and prepare a new amendment.
   Do not claim the original timeout fixed unless it is independently reproduced
   and resolved with the same bounded change.
5. Record approved local How changes before implementation, independently review
   the correction and prepare new exact platform/package evidence. Preserve the
   current compatibility profile and all historical inputs; a changed platform
   runner receives a new clean source checkpoint.

Approval would permit only these local fixture tests and the conditional bounded
correction. Existing database upgrades, source/image publication, changed-input
activation, provider/tool calls and Task 9 acceptance remain separately gated.
