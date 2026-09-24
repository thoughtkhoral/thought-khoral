# Message mentions and delivery

## Status

Implemented retained-v1 behavior across contracts, room gateway, and workspace UI.

## Governing specifications

- Solution architecture, linked from the [root specification index](../README.md)
- [Initial room agent task dispatch](../decisions/006-agent-task-dispatch.md)
- [Contracts What](https://github.com/thoughtkhoral/thought-khoral-contracts/blob/main/.ai/specs/what/mvp-contracts.md) and [How](https://github.com/thoughtkhoral/thought-khoral-contracts/blob/main/.ai/specs/how/implementation.md)
- [Room gateway What](https://github.com/thoughtkhoral/thought-khoral-room-gateway/blob/main/.ai/specs/what/mvp-room.md) and [How](https://github.com/thoughtkhoral/thought-khoral-room-gateway/blob/main/.ai/specs/how/implementation.md)
- [Workspace UI What](https://github.com/thoughtkhoral/thought-khoral-workspace-ui/blob/main/.ai/specs/what/mvp-ui.md) and [How](https://github.com/thoughtkhoral/thought-khoral-workspace-ui/blob/main/.ai/specs/how/implementation.md)

## Cross-project behavior

`chat.send` accepts optional typed `mentions` and `delivery`. Omitted delivery
means `room`; `mentioned` requires at least one target. The retained
`n2n.room.v1` contract owns the field shapes and compatibility fixtures. The
UI resolves selected roster entries to canonical participant tokens, offers
the fixed aliases, and prevents a send with unresolved or excessive targets.
The gateway performs the authoritative checks even when a client bypasses the
UI.

The gateway validates direct targets against the current room roster and
canonical token before writing a message. It rejects unknown, stale,
duplicate, or noncanonical targets for both room-wide and mentioned delivery.
For mentioned delivery it expands `@allhumans` to humans and `@allagents` to
agents plus all humans for supervision, includes the sender, and persists the
sorted resolved `audienceIds` with `message.created`. Room-wide messages retain
an empty audience list and remain visible to all room participants.

Every live broadcast, reconnect replay, and task context packet applies the
same persisted audience. An unauthorized participant receives no hidden
message, while room sequence numbers and replay cursors still advance over
hidden events. A room-wide direct mention of the registered Action Items Agent
may trigger its governed task under Decision 006; a mentioned-only message,
alias, or agent-originated message does not.

## Verification

Contract fixtures cover target shape, uniqueness, limit, and delivery values.
Gateway tests cover canonical roster tokens, alias expansion, rejection before
persistence, live delivery, replay across hidden sequence gaps, and task
context filtering. UI tests cover autocomplete, unresolved targets, the
mentioned-only control, and accessible transcript rendering.
