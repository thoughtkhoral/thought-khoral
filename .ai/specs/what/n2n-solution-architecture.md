# N:N Human-to-Agent Collaborative Workspace — solution architecture

## Status

Approved design baseline; implementation planning has not started.

## Purpose

N:N is a real-time, shared conversational workspace in which multiple people and multiple role-specific AI agents deliberate together. It turns unstructured dialogue into a structured, validated, and auditable source of truth while keeping humans in control of authoritative room context.

## Scope

The solution is a collection of independently versioned direct-child projects, not a monorepo. The root repository holds cross-solution specifications and governance. Each project owns its own code, dependencies, CI, release lifecycle, and local specification hierarchy.

The planned projects are:

| Project | Responsibility |
| --- | --- |
| `n2n-contracts` | Language-neutral JSON Schema, normative protocol documentation, and compatibility fixtures. |
| `n2n-workspace-ui` | Vite and PatternFly React collaborative chat canvas, Collective Memory drawer, and decision cards. |
| `n2n-room-gateway` | Rust/Axum authenticated WebSocket room service, JSON-RPC validation, event dispatch, and authorization boundary. |
| `n2n-memory-engine` | Cognee-RS integration, PostgreSQL/pgvector storage, temporal graph derivation, and decision proposals. |
| `n2n-agent-gateway` | A2A/MCP adapters, least-privilege hydration, and hosted/remote agent isolation boundary. |
| `n2n-platform` | Rootless Podman development environment, Kubernetes-manifest parity checks, and OpenShift deployment composition. |

## User experience

`n2n-workspace-ui` uses Vite and the PatternFly React ecosystem, including `@patternfly/chatbot`. A room presents a multi-human/multi-agent chat stream and an expandable PatternFly Drawer showing the live Collective Memory ledger.

The UI displays draft decision cards created from conversational events. A human must explicitly Confirm, Edit, or Dismiss each proposal. No agent action alone can make a proposal authoritative.

## Event and context model

The UI and agent participants communicate with `n2n-room-gateway` through authenticated JSON-RPC over WebSocket. The gateway validates each payload against the `n2n-contracts` schemas, assigns or verifies server-side identity, appends a normalized immutable room event to PostgreSQL, and broadcasts it only to authorized room participants.

The memory engine derives graph facts and draft decisions from persisted room events. It preserves provenance through source-event identifiers and timestamps. Decision lineage uses directed graph relations including `DERIVED_FROM` and `SUPERSEDES`; decision nodes carry statuses such as `active` and `superseded`.

Only a human Confirm/Edit/Dismiss transition updates active room context. An edit retains the original proposal and records the approved replacement as derived from or superseding it. The gateway is the sole mediator of active-context updates.

Agents receive an expiring, minimized room-context packet containing only the room identifier, approved active context, relevant recent messages, provenance, scope, and expiry. Agents do not receive direct database access, filesystem access, arbitrary shell execution, or unmediated side-effecting tools.

## Technology direction

- UI: Vite, React, PatternFly, and `@patternfly/chatbot`.
- Gateway: Rust with Tokio, Axum, and tower-http.
- Data: PostgreSQL plus pgvector for relational events, vector data, and temporal knowledge-graph records.
- Memory: Cognee-RS embedded in the Rust process, subject to compatibility validation during implementation planning.
- Interoperability: A2A and MCP through versioned JSON-RPC contracts and WebSocket transport where appropriate.
- Identity: Keycloak with OAuth 2.0/OIDC. Short-lived workload identity via SPIFFE/SPIRE is a production-direction capability, not an MVP prerequisite.
- Local platform: rootless Podman and Podman Compose. `podman play kube` validates Kubernetes manifests locally. Optional local-model profiles support Red Hat Granite through vLLM or InstructLab; sandbox profiles use Wasm runtimes managed by crun.
- Production platform: OpenShift-native deployment, with Serverless/Knative, Service Mesh/Istio, Strimzi, Crunchy Data PostgreSQL, and ODF evaluated as scale and operational requirements warrant.

## MVP

The first vertical slice proves N:N governance rather than the entire platform. It includes one local authenticated room, multiple human participants, a built-in deterministic facilitator agent, real-time message broadcast, draft-decision cards, human confirmation/edit/dismissal, active-context updates, and an auditable relational event log.

Embeddings, graph extraction automation, remote third-party A2A/MCP agents, SPIFFE/SPIRE, local model hosting, Wasm isolation, Kafka, service mesh, and production OpenShift topology are explicitly deferred until the governed-room path is proven.

## Reliability and security requirements

The gateway treats all inbound data as untrusted. It returns structured protocol errors for malformed JSON-RPC, unsupported contract versions, expired context packets, unauthorized room access, and invalid decision-state transitions. It records security/audit events without leaking room content.

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
