# 006 — Initial room agent task dispatch

## Status

Accepted

## Context

ThoughtKhoral rooms already support known agent participants and validated direct mentions, but a mention only controls message delivery. The product needs a small, governed way for a human to request work from an agent without prematurely adopting a model provider, tool runtime, A2A/MCP transport, or remote-agent isolation design.

## Decision

The first executable room agent is a gateway-owned deterministic Action Items Agent. A room-wide `chat.send` from a human that directly mentions the registered `@action-items` participant creates one durable task alongside the source message. The gateway persists and broadcasts queued, running, and terminal task events atomically with the source message through a pure, no-side-effect executor.

The executor receives only the committed source message after its invocation mention is removed. Its structured result contains action-item text with optional explicitly supplied owner and due fields. Agent task outputs never alter active context or decisions, and an agent message cannot invoke another agent.

The gateway exposes a narrow registered-agent and task-executor seam. A later Agent Gateway may replace the execution implementation, but it must preserve the room task/event contract and introduce its own admission, context, isolation, and tool-policy decisions.

## Alternatives considered

- Invoke a handler synchronously inside `chat.send`: rejected because slow or failed work would couple execution to the request path and provide no durable lifecycle.
- Build the full external A2A/MCP Agent Gateway first: rejected because it delays the basic conversational capability behind provider and isolation decisions that are not needed for the deterministic first task.
- Treat every agent mention as an invocation: rejected because ordinary direct messages and `@allagents` must remain delivery primitives and must not fan out work.

## Consequences

- The retained `n2n.room.v1` event schema gains additive agent-task lifecycle events and payloads.
- The room gateway adds task persistence, recovery, and a deterministic worker without granting agents database credentials, arbitrary tools, or shell access.
- The workspace projects task events as room-visible, agent-attributed cards.
- Cancellation, retry controls, task history, model-backed execution, remote agents, and agent-to-agent task invocation remain excluded.

## Overrides

None.
