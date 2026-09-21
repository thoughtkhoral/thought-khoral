# 007 — A2A agent gateway foundation

## Status

Proposed — awaiting review of the written design before implementation planning.

## Context

ThoughtKhoral needs a governed path for people to bring external agents into a
room without giving those agents direct access to the room database, private
delivery history, active-context mutation, or platform credentials. The
existing deterministic Action Items Agent proves a narrow in-process task
path; it is not an external-agent admission or interoperability boundary.

The project now needs a first, local reference integration that proves
interoperable A2A task invocation, complete shared context, progress updates,
source-cited results, and human-visible task state. It must establish the
separate `thought-khoral-agent-gateway` as the mediated boundary before
admitting remote third-party agents.

## Decision

`thought-khoral-agent-gateway` becomes the sole mediator between governed
rooms and external A2A agents. Its first implementation consumes the official,
Apache-2.0-licensed `a2aproject/a2a-rs` SDK as an A2A client. The dependency
must be pinned to a reviewed release, and its license, security advisory, and
protocol-compatibility evidence must be recorded before runtime adoption.

The first admitted agent is a locally controlled deterministic A2A reference
agent. It advertises exactly two skills: `summarize-context` and
`extract-action-items`. It is not a model runtime and has no database,
filesystem, shell, or unrestricted network authority.

For this initial integration, the Room Context Broker delivers the full ordered
room history the invoking human and the registered agent are authorized to
view, plus the active-decision projection. The packet has a task binding,
room identifier, source-event identifiers, high-water event sequence,
generation time, and expiry. This correctness-first baseline will evolve to
revision-based deltas, retrieval, and compact representations; it must never
be interpreted as authority to read hidden, targeted, revoked, or otherwise
unauthorized room data.

The room gateway remains the sole authority for room authorization, event
persistence, room delivery, and active-decision transitions. The agent gateway
has no direct database access and cannot self-assert room events. It receives
only task-scoped context through a room-gateway service interface and returns
only validated, normalized task updates and result candidates through that
interface.

The first integration adopts A2A task, status-update, and artifact semantics.
ThoughtKhoral projects meaningful validated A2A updates into durable governed
room events. An external agent's own human-in-the-loop experience remains
outside ThoughtKhoral. At most, a task may expose a user-clicked external
handoff instruction and HTTPS URL; ThoughtKhoral never auto-opens or embeds
that UI and never receives its sensitive inputs.

## Consequences

- The agent gateway is no longer specification-only once an approved
  implementation plan is completed.
- The contracts, room gateway, workspace UI, agent gateway, and platform need
  coordinated additive work before the reference integration can run.
- Existing retained room-protocol values and persisted identifiers remain compatible;
  any additive contract changes require their own compatibility fixtures.
- Remote or user-supplied agent admission, MCP transport, model-backed agent
  execution, and context compaction remain out of the first implementation.

## Zero-trust requirements

- Every service-to-service request is authenticated and authorized for its
  exact task, room, requester, agent identity, and expiry.
- The registered Agent Card and endpoint are pinned locally; discovery never
  constitutes admission. Agent Card signatures are verified when used.
- Context packets are integrity-bound to their task and revision, expire, and
  are rejected if replayed, stale, or mismatched.
- All inbound A2A messages, status updates, artifacts, URLs, and callback
  configuration are untrusted input subject to schema validation, bounded
  size, rate limits, and idempotency checks.
- Workload credentials are short-lived and audience-bound. Production
  deployment upgrades the local service identity to mutual TLS and workload
  identity without changing the authorization model.

## Overrides

This decision replaces the root architecture's initial assumption that every
agent receives only relevant recent messages. The first controlled reference
integration instead receives the full *authorized* history in its expiring
context packet. The least-privilege and expiry requirements remain in force.
