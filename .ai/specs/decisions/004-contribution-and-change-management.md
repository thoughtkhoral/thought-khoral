# 004 — Issue-first contribution and change management

## Status

Accepted

## Context

ThoughtKhoral uses specifications as durable project memory and as the
authoritative input to implementation and generated documentation. Public
contributors need a simple entry point that does not require them to understand
the internal What/How/Decision hierarchy before reporting a problem or proposing
an outcome.

## Decision

All public change requests enter through a GitHub issue in the repository that
owns the affected behavior. Issue forms classify feature requests, defects,
documentation corrections, protocol or compatibility changes, architecture or
governance proposals, and operational problems.

Maintainers triage the issue, identify the owning repository, and decide whether
the request is accepted, needs more evidence, deferred, or closed. An accepted
issue becomes the authority for a maintainer-authored specification update.
Implementation begins only after the applicable specification is approved.

Implementation pull requests must reference the accepted issue and governing
specification. Contributors may submit a pull request when maintainers invite
implementation or when the issue and specification explicitly make the change
ready for contribution; an unlinked code or specification change is not an
accepted project contribution.

Generated documentation and project maps are updated from approved
specifications and do not establish independent product intent. Security
vulnerabilities use the private reporting process in `SECURITY.md`, not public
issues.

## Consequences

- Issues provide one public, low-context entry point for project feedback.
- Specifications retain authority and traceability without requiring casual
  contributors to edit them directly.
- Maintainers must triage issues and keep issue, specification, implementation,
  and generated-documentation links synchronized.
- Branch protection and CODEOWNERS must require specification-owner review for
  `.ai/specs`, protocol contracts, and generated project metadata.

## Overrides

None.
