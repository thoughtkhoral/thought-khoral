# ThoughtKhoral product identity

## Status

Approved

## Purpose

Establish ThoughtKhoral as the distinctive, consistent identity for the human-to-agent collaborative workspace across public, commercial, internal, and open-source contexts.

## Scope

Use `ThoughtKhoral` in display and prose contexts. Use `thought-khoral` for repositories, packages, crates, binaries, container tags, Compose services, Kubernetes labels, environment-variable namespaces, and future protocol namespaces.

The root repository and the six planned child projects adopt the names recorded in [decision 003](../decisions/003-thoughtkhoral-product-identity.md).

## Exclusions

- Trademark registration, domain purchase, social-handle registration, and legal clearance.
- Renaming existing database tables, persisted records, event payload keys, or `n2n.room.v1` wire protocol values.
- Introducing `thought-khoral.room.v2`; it needs an independent approved specification.

## Acceptance criteria

1. Root specifications define ThoughtKhoral as the sole canonical product name and `thought-khoral` as the canonical machine identifier.
2. The rename plan maps every current active N2N identifier to its destination or explicitly preserves it for wire compatibility.
3. No new implementation adds an `n2n` identifier except documented compatibility paths.
4. All renamed runtime projects build, test, and run the browser governed-room flow from the ThoughtKhoral-named local stack.
