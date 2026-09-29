# ThoughtKhoral product vision and intent

## Status

Draft synthesis for documentation. The approved solution architecture and decisions listed in the [specification index](../README.md#current-root-specifications) remain authoritative. The audience and outcome hypotheses below need product-owner validation before they become product commitments.

## Vision

ThoughtKhoral aims to make a shared conversation between people and role-specific agents useful as a governed record of work. Participants can discuss work in a room, ask a known agent to perform a bounded task, inspect where its result came from, and decide explicitly which proposed decisions become authoritative room context. The human decision boundary is the defining product rule: an agent result or derived fact can inform a decision but cannot activate or revise one.

The intended progression is from a locally controlled, auditable room toward richer room memory and separately admitted agents. Each new capability must preserve room authorization, provenance, and human authority. This is a direction, not a release promise; see the [architecture evolution brief](../how/architecture-evolution.md) and [capability roadmap](../../../docs/roadmap.md).

## Problem and intended outcome

The project addresses a common collaboration problem: conversation, task output, and decisions can become difficult to separate or trace. The current design gives each a distinct place: ordered room events preserve what happened, agent-task events show requested work and cited results, and human transitions determine active decisions. These are design claims supported by the [governed room specification](../../../thought-khoral-room-gateway/.ai/specs/what/mvp-room.md) and [A2A foundation specification](../../../thought-khoral-agent-gateway/.ai/specs/what/a2a-agent-gateway-foundation.md); user benefit and demand have not yet been measured.

## Audience hypotheses

The specifications describe roles and permissions, not validated customer personas. These audience descriptions are proposed framing for examples and should be tested with users:

| Audience | Job in the room | Current support |
| --- | --- | --- |
| Human participant | Discuss work, address participants, request an allowed agent skill, and review results. | Authenticated room, message delivery, and local deterministic tasks. |
| Human decision owner | Create and review draft decisions, confirm or edit authoritative context, dismiss drafts, and delete current rows while retaining audit history. | Human `/decisions` and governed transitions. There is no distinct decision-owner role in the MVP contract. |
| Agent developer or platform operator | Integrate a controlled agent or inspect the room, task, and deployment boundaries. | One pinned deterministic A2A reference agent and local platform; open third-party admission is deferred. |

## Product principles

1. **Human authority:** Only a human transition makes a decision active; deletion retains an immutable audit event. See [decision 008](../decisions/008-slash-decisions-and-facilitator-boundary.md).
2. **Visible provenance:** Room events are ordered and replayable; controlled agent results cite sources in the authorized context packet. See [decision 007](../decisions/007-a2a-agent-gateway-foundation.md).
3. **Scoped disclosure:** Room delivery and agent context use the persisted audience and current authorization rules. A targeted message outside an actor's audience is excluded from its replay and context. See [message delivery](../how/message-mentions-and-delivery.md).
4. **Separate authority from execution:** The room gateway owns authorization, persistence, delivery, and active decisions. Agent and memory services receive mediated inputs and have no direct room database or decision-transition authority.
5. **Incremental interoperability:** The local A2A reference integration demonstrates the boundary. Remote agents, MCP, and production identity require their own approved specifications.

## Current proof and limits

The implemented local MVP includes explicit room entry, authenticated real-time messaging, authorized replay, mentions and targeted delivery, a human `/decisions` workflow, an in-process deterministic Action Items Agent, and a pinned deterministic A2A reference agent with `summarize-context` and `extract-action-items`. The memory engine has an incubating in-memory graph and mediated-ingestion proof. It does not run Cognee, persist derived memory durably, or create live memory-derived decision drafts. The local Compose stack is a development environment, not a production distribution. See [roadmap status](../../../docs/roadmap.md), [memory-engine status](../../../thought-khoral-memory-engine/README.md), and [platform status](../../../thought-khoral-platform/README.md).

## Evidence needed to validate the vision

Before publishing claims about market fit or productivity, product owners should identify the priority audience and workflow, observe users completing the [usage scenarios](usage-scenarios.md), and record baseline and target measures. Candidate measures are whether participants can reconstruct why a decision is active, find the source of an agent result, and recognize when a targeted message was withheld. No adoption, time-saving, accuracy, or reliability target is established by the current specifications.

## Exclusions

This brief does not authorize new runtime behavior, assign a new contract role, claim model-backed reasoning, or promise remote agent admission, project/topic memory, or production deployment.
