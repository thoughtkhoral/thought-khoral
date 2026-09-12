# Agent roadmap for ThoughtKhoral specifications

## Purpose

Use this document before proposing, creating, or modifying code or project documentation in the ThoughtKhoral workspace. Specifications are the authoritative input to implementation. Code, generated artifacts, tests, and supporting documentation must follow an approved specification update; they must not establish product or architectural intent independently.

This is an operating guide for agents. It complements the solution architecture in [../what/n2n-solution-architecture.md](../what/n2n-solution-architecture.md) and the workspace-governance decision in [../decisions/001-workspace-governance.md](../decisions/001-workspace-governance.md).

## Specification hierarchy

Every scope level has this Markdown-only structure:

```text
.ai/specs/
  what/
  how/
  decisions/
```

The workspace-root hierarchy defines cross-solution intent and rules. Each direct-child project has its own hierarchy for project-local intent and implementation. A project inherits root rules unless an accepted project decision explicitly overrides one.

## Read before acting

Before changing anything, an agent must identify the narrowest affected project and read, in this order:

1. The root `.ai/specs/README.md`.
2. Relevant root `what/` documents.
3. Relevant root `how/` documents.
4. Relevant root `decisions/` records.
5. The target project's `.ai/specs/README.md` and all local documents that govern the change.
6. Any contract specification and decision records named by those documents.

If the project does not yet exist, read the root specifications and create its local specification hierarchy before creating any runtime code.

When documents disagree, resolve authority in this order: an accepted decision record, a more specific applicable What or How specification, then a broader parent specification. Do not silently choose an interpretation. Record a decision when the ambiguity changes an interface, security boundary, operational behavior, or cross-project responsibility.

## Choose the document type

| Change question | Update first | Use it for |
| --- | --- | --- |
| What outcome, user behavior, scope, or acceptance criterion is required? | `what/` | Product/capability intent and observable success. |
| How should an approved outcome be built, integrated, operated, or verified? | `how/` | Design, interfaces, data flow, constraints, test strategy, and rollout. |
| Why select one durable option over another, or why depart from a parent rule? | `decisions/` | Accepted choices, trade-offs, consequences, and explicit overrides. |

One change often requires more than one document. Use this sequence whenever a durable choice is involved:

```text
Decision → What → How → contract/schema → code → tests and supporting documentation
```

For a localized implementation that introduces no new durable choice, update the governing What and How documents first, then implement. For a documentation-only correction, update the affected specification directly and preserve its existing authority and links.

## Lifecycle by change type

### New capability

1. Locate the owning project and parent requirements.
2. Add or update a What specification with purpose, scope, exclusions, and acceptance criteria.
3. Add a decision record if selecting among consequential alternatives.
4. Add or update a How specification with boundaries, interfaces, data handling, failure behavior, and verification plan.
5. Obtain the required human approval under the active development workflow.
6. Implement only what the approved documents require.
7. Update tests and supporting documentation, then verify every acceptance criterion.

### Code modification or defect fix

1. Read the specifications governing the affected behavior.
2. Update What when user-visible behavior, scope, or acceptance criteria change.
3. Update How when the implementation design, interface, data model, error behavior, or verification route changes.
4. Add a decision record when the fix establishes a durable policy or changes a previously accepted trade-off.
5. Obtain approval for the spec update before changing code, including for urgent fixes.
6. Implement, test, and link the result back to the governing documents.

### Cross-project change

1. Update the root What or How document that owns the shared rule.
2. Update `thought-khoral-contracts` first when an event, JSON-RPC method, error, schema, or compatibility rule changes.
3. Record a root decision when the change alters ownership, security boundaries, compatibility, or rollout policy.
4. Update each affected project’s local What and How specifications before changing that project’s code.
5. Implement consumers only against a released or otherwise explicitly pinned contract version.
6. Verify contract compatibility fixtures and every affected project’s integration tests.

### Project-level override

1. Do not edit or weaken the parent document to suit one project.
2. Create an accepted local decision record naming the parent document and exact rule being overridden.
3. State the replacement rule, rationale, affected scope, approval status, and consequences.
4. Update the project-local What and How documents to reference the decision.
5. Implement only within the recorded scope. Revisit the decision if the exception expands.

## Minimum Markdown shape

Use descriptive lowercase, hyphenated filenames. Prefix decision records with a zero-padded sequence number, for example `002-contract-versioning.md`.

### What

```markdown
# Capability name

## Status

Draft | Approved | Superseded

## Purpose

## Scope

## Exclusions

## Acceptance criteria

1. Observable result.
```

### How

```markdown
# Capability name — implementation design

## Status

Draft | Approved | Superseded

## Governing specifications

- Governing What document: relative path to the approved What specification.
- Governing decision: relative path to the accepted decision record, when applicable.

## Components and responsibilities

## Interfaces and data flow

## Failure and security behavior

## Verification
```

### Decision

```markdown
# 000 — Decision title

## Status

Proposed | Accepted | Superseded

## Context

## Decision

## Alternatives considered

## Consequences

## Overrides

State `None`, or name the parent document, rule, replacement, and affected scope.
```

Do not leave template headings empty. Omit a heading only when it cannot apply, and say why in the document.

## Agent pre-implementation checklist

- [ ] I read the applicable root and project-local spec indexes and governing documents.
- [ ] I identified whether this change belongs in What, How, Decisions, or more than one.
- [ ] I updated the governing specifications before proposing code changes.
- [ ] I created or updated a decision record for any durable choice or parent override.
- [ ] I linked related specifications using relative Markdown links.
- [ ] I confirmed the proposed implementation does not exceed the approved scope.
- [ ] I identified the acceptance criteria and verification commands that will prove the change.

## Agent completion checklist

- [ ] The implementation matches the approved What and How specifications.
- [ ] Tests demonstrate each applicable acceptance criterion.
- [ ] Cross-project changes use the documented contract version and compatibility fixtures.
- [ ] New or changed decision records describe consequences and, where relevant, the superseded decision.
- [ ] Relative links resolve from the document that contains them.
- [ ] The project’s `.ai/specs/README.md` indexes every active local specification.
- [ ] No code or generated artifact is presented as the authoritative rationale for a change.

## Maintaining a large specification set

When many specifications exist, do not read every file. Start from the root and project indexes, then follow only links relevant to the requested behavior, interface, component, or decision. Keep each index current with active documents grouped by `what`, `how`, and `decisions`; mark superseded documents rather than deleting their historical rationale.

When a specification becomes too broad to govern a single coherent change, split it by capability or bounded interface and link the replacements from the original document. Preserve decision records and historical traceability. Do not create duplicate specifications for the same authority: amend the authoritative document or explicitly supersede it.
