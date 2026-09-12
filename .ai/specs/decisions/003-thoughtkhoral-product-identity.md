# 003 — ThoughtKhoral product identity

## Status

Accepted

## Decision

The N:N Human-to-Agent Collaborative Workspace is named **ThoughtKhoral** in display text, documentation, public communication, Rust types, and other PascalCase human-facing contexts. Its canonical machine and package identifier is `thought-khoral`.

ThoughtKhoral is the public, commercial, internal, and open-source product identity. `n2n` remains only as a documented temporary migration alias; no new source, specification, runtime, package, container, or deployment identifier may introduce it.

Child projects adopt these direct-child names:

- `thought-khoral-contracts`
- `thought-khoral-workspace-ui`
- `thought-khoral-room-gateway`
- `thought-khoral-memory-engine`
- `thought-khoral-agent-gateway`
- `thought-khoral-platform`

The existing `n2n.room.v1` protocol stays wire-compatible through this identity migration. A `thought-khoral.room.v2` protocol requires a separate approved contract, release, compatibility plan, and migration test.

## Rationale

ThoughtKhoral expresses a receptacle space for multi-voice collaborative thought while avoiding the broad, overloaded N:N/N2N name. It gives the product one consistent public and technical identity.

## Alternatives considered

- Retain N:N as the technical identifier while using ThoughtKhoral only in prose.
- Keep ThoughtKhoral provisional while continuing N:N development.

## Consequences

- A staged rename is required across specifications, repository identities, runtime identifiers, and user-facing copy.
- Trademark, domain, social-handle, and registry clearance remains required before public launch; accepting this decision is not legal clearance.
- Existing database tables, persisted event fields, and wire payload fields are not renamed in this pass. Any such change requires a dedicated data-migration decision.
