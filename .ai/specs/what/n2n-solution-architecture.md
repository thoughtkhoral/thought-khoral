# ThoughtKhoral Human-to-Agent Collaborative Workspace — solution architecture

## Status

Approved design baseline; local MVP and incubating integrations are in active
development. Deferred production capabilities remain design direction only.

## Purpose

ThoughtKhoral is a real-time, shared conversational workspace in which multiple people and multiple role-specific AI agents deliberate together. It turns unstructured dialogue into a structured, validated, and auditable source of truth while keeping humans in control of authoritative room context.

## Scope

The solution is a collection of independently versioned direct-child projects, not a monorepo. The root repository holds cross-solution specifications and governance. Each project owns its own code, dependencies, CI, release lifecycle, and local specification hierarchy.

The independently versioned projects are:

| Project | Responsibility |
| --- | --- |
| `thought-khoral-contracts` | Language-neutral JSON Schema, normative protocol documentation, and compatibility fixtures. |
| `thought-khoral-workspace-ui` | Vite and PatternFly React collaborative chat canvas, Collective Memory drawer, and decision cards. |
| `thought-khoral-room-gateway` | Rust/Axum authenticated WebSocket room service, JSON-RPC validation, event dispatch, and authorization boundary. |
| `thought-khoral-memory-engine` | Cognee-RS integration, PostgreSQL/pgvector storage, temporal graph derivation, and decision proposals. |
| `thought-khoral-agent-gateway` | A2A/MCP adapters, least-privilege hydration, and hosted/remote agent isolation boundary. |
| `thought-khoral-platform` | Rootless Podman development environment, Kubernetes-manifest parity checks, and OpenShift deployment composition. |

## User experience

`thought-khoral-workspace-ui` uses Vite and the PatternFly React ecosystem, including `@patternfly/chatbot`. A room presents a multi-human/multi-agent chat stream and an expandable PatternFly Drawer showing the live Collective Memory ledger.

The UI displays draft decision cards created from conversational events. A human must explicitly Confirm, Edit, or Dismiss each proposal. No agent action alone can make a proposal authoritative.

## Event and context model

The UI and in-process room participants communicate with `thought-khoral-room-gateway` through JSON-RPC over WebSocket. A browser opens the socket unauthenticated and must send `session.authenticate` containing an OIDC access token as its first application message within a short gateway-configured timeout. Before successful authentication the gateway accepts no room method. It validates the token's issuer, audience, signature, key identifier, algorithm, expiry, and not-before time, binds the resulting identity and role to the connection, then validates authorized payloads against the `thought-khoral-contracts` schemas. It appends a normalized immutable room event to PostgreSQL and broadcasts it only to authorized room participants. The separate agent gateway uses authenticated task-scoped HTTP with the room gateway and A2A with the pinned local reference agent; that agent never joins the browser room socket or reads the room database.

The memory engine derives graph facts and draft decisions from persisted room events. It preserves provenance through source-event identifiers and timestamps. Decision lineage uses directed graph relations including `DERIVED_FROM` and `SUPERSEDES`; decision nodes carry statuses such as `active` and `superseded`. For the first Cognee integration, that memory is room-scoped: a room remains one conversation, and derived facts and drafts are partitioned by `roomId`. The gateway facilitator is the draft-proposal port; Cognee is a later implementation of that port, not a second independent proposer. A later project-with-many-topic-conversations model, with distinct project-level and topic-level memory, is an explicit non-goal of that POC; see [decision 005](../decisions/005-room-scoped-poc-memory.md).

Only a human Confirm/Edit/Dismiss transition updates active room context. An edit retains the original proposal and records the approved replacement as derived from or superseding it. The gateway is the sole mediator of active-context updates.

The first controlled external-agent integration delivers an expiring,
task-bound packet containing the full ordered room history the invoking human
and agent are authorized to view, active decisions, provenance, scope, and
expiry. It is a correctness-first baseline that later evolves to compact,
revision-based context delivery without changing authorization or provenance
semantics. Agents do not receive direct database access, filesystem access,
arbitrary shell execution, or unmediated side-effecting tools.

## Technology direction

- UI: Vite, React, PatternFly, and `@patternfly/chatbot`.
- Gateway: Rust with Tokio, Axum, and tower-http.
- Data: PostgreSQL plus pgvector for relational events, vector data, and temporal knowledge-graph records.
- Memory: Cognee-RS embedded in the `thought-khoral-memory-engine` Rust process, not in the room gateway, subject to compatibility validation during implementation planning.
- Interoperability: A2A and MCP through versioned JSON-RPC contracts and WebSocket transport where appropriate.
- Identity: Keycloak with OAuth 2.0/OIDC. Short-lived workload identity via SPIFFE/SPIRE is a production-direction capability, not an MVP prerequisite.
- Local platform: rootless Podman and Podman Compose. `podman play kube` validates Kubernetes manifests locally. Optional local-model profiles support Red Hat Granite through vLLM or InstructLab; sandbox profiles use Wasm runtimes managed by crun.
- Production platform: OpenShift-native deployment, with Serverless/Knative, Service Mesh/Istio, Strimzi, Crunchy Data PostgreSQL, and ODF evaluated as scale and operational requirements warrant.

## MVP

The first vertical slice proves ThoughtKhoral governance rather than the entire platform. It includes one local authenticated room, multiple human participants, a built-in deterministic facilitator agent, real-time message broadcast, draft-decision cards, human confirmation/edit/dismissal, active-context updates, and an auditable relational event log.

Project/topic memory hierarchy, nested conversations, remote third-party A2A/MCP agents, SPIFFE/SPIRE, local model hosting, Wasm isolation, Kafka, service mesh, and production OpenShift topology remain deferred. The approved local A2A foundation uses one deterministic reference agent behind `thought-khoral-agent-gateway`; it is not general bring-your-own-agent admission. The memory engine has an incubating room-scoped ingestion proof; Cognee extraction, durable memory storage, and production deployment remain deferred.

## Reliability and security requirements

The gateway treats all inbound data as untrusted. It validates an explicit WebSocket Origin allowlist at handshake and closes unauthenticated or authentication-timeout connections without processing room methods. It returns structured protocol errors for malformed JSON-RPC, unsupported contract versions, expired context packets, unauthorized room access, and invalid decision-state transitions. It records security/audit events without leaking room content, access tokens, session identifiers, or ticket material.

Clients use durable event cursors to replay missed normalized events in order after reconnect. Write requests use client-generated request IDs and gateway-enforced idempotency.

## Quality requirements

- Contracts provide schema-conformance and backwards-compatibility fixtures.
- The gateway has unit coverage for state transitions and integration coverage for authentication, persistence, fan-out, reconnect, and rejection paths.
- The UI has component coverage for chat, drawer, and decision workflows, plus end-to-end governed-decision coverage.
- The memory engine has deterministic provenance and lineage fixtures.
- Platform CI provides rootless Podman Compose smoke coverage and `podman play kube` manifest validation.
- Component protocol maturity, operational compatibility, and full transitive licensing must be verified against authoritative sources before dependency adoption.

## Acceptance criteria for the design baseline

1. The root workspace has a Markdown-only `.ai/specs/what`, `.ai/specs/how`, and `.ai/specs/decisions` hierarchy.
2. Each planned project is a direct child of the workspace root and is independently versioned when created.
3. Every project has the same local specification hierarchy.
4. Specifications are updated and approved before related code changes.
5. A project can override a parent specification only through an approved decision record that identifies the parent rule, override, rationale, scope, and approval status.
6. A human approval is required before a draft decision becomes active room context.
