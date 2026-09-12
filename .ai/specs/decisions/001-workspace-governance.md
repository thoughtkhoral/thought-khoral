# 001 — Workspace governance and specification hierarchy

## Status

Accepted

## Decision

The ThoughtKhoral workspace root is the governance repository for cross-solution specifications and shared operating rules. Runtime projects live directly beneath the root, are independently versioned, and are not part of a monorepo.

The root and every project use a Markdown-only specification hierarchy:

```text
.ai/specs/
  what/
  how/
  decisions/
```

Specifications are the source of truth for code generation, code modification, and project documentation. They must be updated and approved before any applicable code is created or changed.

Project specifications inherit root requirements. A project may override a parent requirement only through an approved record in its `.ai/specs/decisions/` directory. The record must identify the source specification, rule being overridden, replacement rule, rationale, affected scope, approval status, and consequences.

`thought-khoral-contracts` is the compatibility authority for cross-project interfaces. It owns versioned, language-neutral JSON Schema, normative protocol documentation, and compatibility fixtures; it does not become a shared runtime library.

## Consequences

- Solution-wide intent stays versioned without forcing a shared dependency graph or release train.
- Each project has clear local ownership while remaining traceable to parent requirements.
- Changes take longer to begin because an approved specification update is mandatory; the benefit is an auditable rationale and predictable code-generation context.
- Cross-project changes require coordinated contract and specification updates before implementation begins.
