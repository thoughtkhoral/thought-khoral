# ThoughtKhoral usage scenarios

## Status

Draft illustrative scenarios for documentation and evaluation. They exercise behavior in approved specifications; the people, room content, and sample outputs are examples, not user research or new acceptance criteria. For current and deferred boundaries, see the [product vision](product-vision.md), [solution architecture in the specification index](../README.md#current-root-specifications), and [roadmap](../../../docs/roadmap.md).

## Scenario 1: Turn a room discussion into an approved decision

**User goal:** Two human participants agree on a release approach and preserve the approved choice separately from ordinary chat.

1. Alice and Bob enter the same room explicitly and discuss the release approach in room-wide messages.
2. Alice enters `/decisions` and selects Create. She writes a draft decision such as “Publish the beta to the pilot group first.” The command itself is a local UI action, not a chat message.
3. A human reviews the draft and chooses Confirm, Edit, or Dismiss. A confirmed decision appears in active collective memory; an unconfirmed draft does not.
4. If a human later deletes the current decision, the row disappears from active context while the immutable deletion event remains in room history.

**Observable result:** The transcript and decision card show the governed transition; only a human-approved decision becomes normative room context. Typing `Decision:` in chat is ordinary text and creates no draft. See [decision 008](../decisions/008-slash-decisions-and-facilitator-boundary.md) and the [UI workflow](../../../thought-khoral-workspace-ui/README.md#decision-workflow).

## Scenario 2: Address a subset of participants

**User goal:** Alice sends a message to known participants without making it a room-wide message.

1. Alice chooses known roster mentions in the composer and selects **Mentioned participants only**.
2. The room gateway resolves the audience at send time, includes Alice, and persists that audience with the message.
3. The selected recipients and Alice see the message live and on replay. Other participants do not see its content, though the global event sequence retains its place.

**Observable result:** The delivered mention and targeted-delivery label appear in the transcript. An agent context packet excludes the message unless both the invoking human and that agent are authorized to see it. `@allagents` also remains visible to all humans for supervision. See [message delivery design](../how/message-mentions-and-delivery.md) and [agent context decision](../decisions/007-a2a-agent-gateway-foundation.md).

## Scenario 3: Extract explicit action items with the in-process agent

**User goal:** Alice turns explicitly formatted room text into a visible task result.

1. Alice sends a room-wide message that directly mentions the registered `@action-items` agent and includes a line such as `- Prepare release notes | owner: Alice | due: Friday`.
2. The gateway records the message and one task. Room participants see queued, running, and terminal lifecycle events linked to Alice and the source message.
3. The deterministic result contains only action items expressed in the accepted line grammar. It does not infer an owner or due value absent from the message.

**Observable result:** A room-visible task card contains structured items and provenance. A targeted message, an alias mention, or an agent-originated message does not start this work. This path has no model, tools, external runtime, or authority to update decisions. See the [task participation specification](agent-task-participation.md) and [decision 006](../decisions/006-agent-task-dispatch.md).

## Scenario 4: Ask the local A2A reference agent for a cited result

**User goal:** Bob asks a controlled agent to summarize authorized room context or extract explicit action items and can inspect its sources.

1. Bob explicitly starts `summarize-context` or `extract-action-items` for the one pinned local reference agent.
2. The room gateway creates the task and supplies a time-limited packet containing ordered history visible to both Bob and the agent, active decisions, source identifiers, and a context revision.
3. The agent gateway invokes the selected A2A skill and submits validated progress and a terminal result. The gateway persists normalized events before the UI shows them.
4. Bob sees task progress and a result with source citations. If an optional external handoff is returned, the UI presents its instruction and HTTPS link for Bob to choose; it does not open or embed that experience.

**Observable result:** Hidden targeted messages are absent from the packet, and the agent cannot change active decisions or read the room database. This is a deterministic local reference integration, not arbitrary remote-agent admission or model-backed reasoning. See the [agent gateway specification](../../../thought-khoral-agent-gateway/.ai/specs/what/a2a-agent-gateway-foundation.md) and [implementation flow](../../../thought-khoral-agent-gateway/.ai/specs/how/a2a-agent-gateway-foundation.md#invocation-and-context-flow).

## Scenario 5: Inspect the memory proof as a developer

**User goal:** A developer checks that committed room events can be ingested into room-scoped provenance without changing active room context.

The room gateway sends committed events to the memory engine through its private authenticated ingestion boundary. The proof builds an in-memory graph partitioned by room and retains source-event provenance. The developer verifies ingestion and lineage through the memory-engine verification procedure. The UI's active collective-memory view still contains only gateway-active human-approved decisions; this proof does not create a Cognee draft or durable graph. See the [memory-engine status](../../../thought-khoral-memory-engine/README.md) and [POC specification](../../../thought-khoral-memory-engine/.ai/specs/what/poc-room-scoped-memory.md).

## Scenario coverage and research gap

These scenarios cover observable local behavior and its limits. They do not establish which audience has the highest-priority problem, how often the workflows occur, what scale is required, or whether the experience improves outcomes compared with current tools. Product-owner interviews and observed trials are needed before turning these examples into customer claims or quantitative success criteria.
