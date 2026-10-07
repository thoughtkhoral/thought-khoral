# Codex room participation — contribution issue brief

## Status

Published and accepted by the project maintainer on 2026-10-05.
Root Decision 004 requires accepted issue/spec links before contribution execution.
Source: [room requirements](../what/codex-chat-agent.md),
[solution design](codex-chat-agent.md), and
[implementation plan](codex-room-conversations-implementation-plan.md).

## Owning feature issue

Repository: thoughtkhoral/thought-khoral-codex-agent.
Title: Add an explicitly addressed Codex room participant with authorized history.

Requested outcome: humans in one room can address Codex, continue the same shared
room thread, and ask about prior public room discussion. A new native thread
retains authorized room context. The independent worker owns Codex/native state;
the room gateway owns authorization, context, task commits, and public replies.

Acceptance: the root What criteria and provider-free/live gates in the written
plan. Exclusions: future guidance bundles, private sessions, autonomous responses,
production admission, and arbitrary agents.

## Linked contribution scopes

- Contracts: publish independent conversation API/schema/fixtures and immutable pin.
- Room gateway: atomic reservation, authorized context, profile routes and reply commit.
- Agent gateway: pinned Codex registration/dispatch, bounded queries and recovery.
- Workspace UI: explicit addressing, shared-session controls, settings/telemetry.
- Platform: opt-in worker, secrets/state, restricted provider egress, smoke evidence.

Each owning maintainer records acceptance and links the governing local What/How
plus root plan. Record actual issue URLs in execution review; the maintainer approved the coordinated specifications and plan on 2026-10-05.

## Accepted issue links

- [thought-khoral-codex-agent](https://github.com/thoughtkhoral/thought-khoral-codex-agent/issues/1)
- [thought-khoral-contracts](https://github.com/thoughtkhoral/thought-khoral-contracts/issues/1)
- [thought-khoral-room-gateway](https://github.com/thoughtkhoral/thought-khoral-room-gateway/issues/1)
- [thought-khoral-agent-gateway](https://github.com/thoughtkhoral/thought-khoral-agent-gateway/issues/1)
- [thought-khoral-workspace-ui](https://github.com/thoughtkhoral/thought-khoral-workspace-ui/issues/1)
- [thought-khoral-platform](https://github.com/thoughtkhoral/thought-khoral-platform/issues/1)
