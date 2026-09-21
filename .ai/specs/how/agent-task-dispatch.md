# Room agent task dispatch — implementation design

## Status

Approved

## Governing specifications

- Governing What: [room agent task participation](../what/agent-task-participation.md)
- Governing decision: [006 — Initial room agent task dispatch](../decisions/006-agent-task-dispatch.md)

## Components and responsibilities

The contracts project defines additive lifecycle event shapes. The room gateway owns agent registration, task creation, durable state transitions, recovery, and the first deterministic executor. The workspace UI projects task events into a compact transcript card and continues to treat the gateway as the only authoritative event source.

## Interfaces and data flow

The Action Items Agent is a registered agent participant with a stable UUID, display name, and canonical mention token. A human `chat.send` with a room-wide direct mention of that agent atomically stores `message.created`, `agent.task.queued`, `agent.task.running`, and either `agent.task.succeeded` with `{ actionItems: [{ text, owner?, due? }] }` or `agent.task.failed` with a safe code.

The executor reads only the source message after removal of `@action-items`. It recognizes lines in the form `- text`, optionally followed by `| owner: value` and `| due: value`. No action lines produce a successful empty result; malformed optional fields cause a safe task failure.

## Failure and security behavior

Only a human can create a task. Alias mentions, non-room delivery, and unregistered agent mentions do not create one. Agent work has no tool, filesystem, shell, external network, or direct database access. The gateway logs only task and actor identifiers, lifecycle state, and safe failure codes. A future remote dispatcher may add durable worker claims and recovery without changing the task event contract.

## Verification

Contract fixtures validate every lifecycle shape. Gateway tests cover atomic creation, authorization, idempotency, recovery, parser behavior, replay, and safe failures. UI tests cover participant discovery and task-card projection; an end-to-end test verifies one human mention produces one visible result.
