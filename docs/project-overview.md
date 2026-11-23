# ThoughtKhoral: project overview

> **Documentation draft.** This overview is derived from the [approved root specifications](../.ai/specs/README.md), the draft [product vision](../.ai/specs/what/product-vision.md), and the [capability roadmap](roadmap.md). The intended audience and benefits still need product-owner and user validation.

## What the project is for

ThoughtKhoral explores a shared workspace where people and known agents can work in the same room while people control the room's authoritative decisions. Conversation, agent tasks, and decisions have different roles: messages capture discussion, task cards show requested work and its sources, and human actions determine which decisions become active room context.

That separation matters when a team needs to return to a discussion and understand what was agreed, where an agent result came from, and which information was visible to whom. It is a product intent, not a measured claim of improved productivity or decision quality.

## What you can explore today

The local MVP supports an authenticated room with multiple human participants, ordered room events and replay, mentions with room-wide or targeted delivery, and a human `/decisions` workflow. A person can create a draft, then a human can confirm, edit, or dismiss it. A human can also delete the current decision row while preserving its audit event. Active collective memory shows the decisions the gateway has made active.

Two deterministic agent paths demonstrate bounded participation:

- Mentioning `@action-items` in a room-wide message starts the in-process Action Items Agent. It extracts only explicitly formatted items.
- A human can explicitly invoke either `summarize-context` or `extract-action-items` on one pinned local A2A reference agent. The room shows persisted progress and a source-cited result. The agent receives only context authorized for both the requester and agent.

These agents do not run a model, use arbitrary tools, or gain authority to change decisions. The incubating memory engine separately proves private ingestion and room-scoped, in-memory provenance. It does not yet create memory-derived drafts or provide durable collective-memory storage. See the [usage examples](usage-examples.md), [architecture guide](architecture.md), and [roadmap](roadmap.md) for the boundaries of each capability.

An additional, independent Codex conversation POC lets a human explicitly
address Codex using authorized room-wide history, with shared continuation and
fresh-session controls. The worker and composed provider-free checks are
implemented. Native worker tests passed on AMD64/ARM64 with Rust 1.85.0/1.93.1;
both package-policy captures passed using the pinned Rust 1.93.1 builder. Full
Codex room-stack, rendered-browser and live-provider
verification remain open. V1.1 is published, and released consumers plus an
exact packaged profile are integrated and pushed to canonical mains. Nine
production images are built; Task C still needs actual operator configuration
and its preflight. The [workspace guide](workspace-status.md) identifies which checkout
contains each runtime and preserves the exact acceptance sources.
Codex does not connect to room storage or use the memory-engine proof. See the
[cross-project Codex status guide](codex-conversation-status.md) for its current
evidence and remaining gates.

## How the project is organized

The product consists of independently versioned repositories. This repository owns cross-project specifications, governance, and the [repository map](repository-map.md). The contracts repository owns the room protocol; the workspace UI renders the experience; the room gateway authorizes and persists room events; the memory and agent gateways own their mediated integration proofs; and the platform composes the local environment. The [compatibility matrix](compatibility-matrix.md) records the current local interface boundary.

## Where the project may go

The approved design direction considers richer room-derived memory, separately admitted external agents, more efficient context delivery, and a production platform. Each needs its own design and approval before it is an implementation commitment. Current Compose operation and Kubernetes manifest validation do not constitute a production deployment. The [architecture guide](architecture.md#possible-future-boundaries) distinguishes these options from the current system.

## Start exploring

Use the [local platform setup](https://github.com/thoughtkhoral/thought-khoral-platform/blob/main/README.md#start-and-verify) to run the development stack. Then follow the [usage examples](usage-examples.md) to enter a room, create a governed decision, and request a bounded agent task. To contribute, start with an issue in the repository that owns the behavior; the [contribution guide](https://github.com/thoughtkhoral/.github/blob/main/CONTRIBUTING.md) describes the issue-first workflow.
