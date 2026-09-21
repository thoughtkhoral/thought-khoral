# Room agent task participation

## Status

Approved

## Purpose

Let a human start a small, observable unit of agent work from the existing room conversation by directly mentioning a known executable agent.

## Scope

- Register a room-visible Action Items Agent addressed as `@action-items`.
- Let any authenticated human invoke it through a room-wide message.
- Persist and replay queued, running, succeeded, and failed task lifecycle events linked to the source message and requester.
- Render one room-visible task card with structured action-item results.

## Exclusions

No model provider, tool access, external runtime, A2A/MCP integration, agent-to-agent invocation, task cancellation, retry UI, task history, or automatic decision/context update is included.

## Acceptance criteria

1. A human can select the Action Items Agent through existing mention UX and send a room-wide invocation.
2. The accepted message creates exactly one durable, replayable task with visible lifecycle state and provenance to its source message.
3. The deterministic result contains only explicitly formatted action items; owner and due values are never inferred.
4. Retries of the same chat request do not create duplicate tasks.
5. Agent-originated messages and alias mentions do not invoke work.
