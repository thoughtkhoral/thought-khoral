# ThoughtKhoral usage examples

> **Documentation draft.** These illustrative examples are derived from the draft [usage scenarios](../.ai/specs/what/usage-scenarios.md) and the [approved specifications](../.ai/specs/README.md). Alice, Bob, and the room content are examples. These steps describe the local MVP, not a hosted service.

## Before you begin

Start the development stack using the [platform instructions](../thought-khoral-platform/README.md#start-and-verify). Open the workspace, sign in with a local development identity, and explicitly enter a valid room UUID. The platform README lists its local fixture identities and a sample room ID. A suggested room in the URL can prefill the entry control; it does not join the room for you. Have a second human enter the same room to see shared events.

## Example 1: Record a decision after discussion

Alice and Bob discuss a release plan in room-wide chat. Alice enters `/decisions`, chooses Create, and drafts a decision such as “Publish the beta to the pilot group first.” The command opens local controls; it is not posted as chat. A human then reviews the draft and selects Confirm, Edit, or Dismiss. A confirmed decision appears in active collective memory, while an unconfirmed draft does not.

If the choice is later withdrawn, a human can delete its current row. The room retains an immutable audit event for that deletion. Typing a message beginning `Decision:` does not create a draft. The [decision workflow](../thought-khoral-workspace-ui/README.md#decision-workflow) and [governance decision](../.ai/specs/decisions/008-slash-decisions-and-facilitator-boundary.md) define the exact boundary.

## Example 2: Send a message to selected participants

Alice types `@` and selects known people or agents from the room roster. She chooses **Mentioned participants only** before sending. The room gateway resolves and persists the audience, including Alice. Those recipients can see the message live and on replay; others cannot see its content. The transcript identifies the targeted delivery.

The fixed `@allhumans` and `@allagents` aliases are available. Messages to `@allagents` are also visible to all humans for supervision. An agent task receives a targeted message in its context only if both the invoking human and that agent are allowed to see it. See [message delivery](../.ai/specs/how/message-mentions-and-delivery.md).

## Example 3: Extract a clearly written action item

Alice sends a **room-wide** message that directly mentions `@action-items` and contains an explicit item, for example:

```text
@action-items
- Prepare release notes | owner: Alice | due: Friday
```

The room displays one task linked to Alice's message, with queued, running, and terminal state followed by a structured result. The deterministic agent extracts only the formatted item; it does not infer missing owners or dates. A targeted message, an alias mention, or an agent-authored message does not start this agent. It cannot update active decisions. See the [task participation specification](../.ai/specs/what/agent-task-participation.md).

## Example 4: Request a cited summary from the local reference agent

Bob explicitly selects the pinned local reference agent and starts `summarize-context`. The room gateway assembles a time-limited snapshot of ordered room history visible to both Bob and the agent, plus active decisions and source IDs. The room displays persisted task progress and a deterministic summary with citations. Bob can use those citations to inspect the sources behind the result.

The second permitted skill, `extract-action-items`, extracts explicitly formatted items and cites the source message. Neither skill uses a model or arbitrary tools. The agent cannot see hidden targeted messages, read the room database, or confirm decisions. This local reference path does not admit a user-supplied remote agent. See the [agent gateway specification](../thought-khoral-agent-gateway/.ai/specs/what/a2a-agent-gateway-foundation.md).

## Developer example: Inspect the memory proof

Committed room events can reach the memory engine through private authenticated ingestion. Its current proof builds room-scoped in-memory graph facts and provenance. A developer can follow the [memory-engine verification record](../thought-khoral-memory-engine/docs/poc-verification.md) to inspect the proof. The room's active collective-memory view still shows only human-approved active decisions. Cognee-backed extraction, durable storage, and memory-derived decision drafts remain deferred.
