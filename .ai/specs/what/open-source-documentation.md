# Open-source organization documentation

## Status

Approved

## Purpose

Provide a durable public documentation structure for the ThoughtKhoral GitHub
organization and its independently versioned repositories. Documentation must
help a visitor understand the product, select the correct repository, assess
project maturity, run the MVP, and contribute through the issue-first workflow.

## Scope

The documentation system has three levels:

1. The organization profile explains the project at a glance and links to the
   product home.
2. The `thought-khoral` repository owns the project overview, repository map,
   compatibility matrix, roadmap, and cross-project specifications.
3. Each component repository owns its setup, interfaces, operational behavior,
   tests, status, and component-specific contribution context.

The `.github` repository supplies shared contribution, security, support,
issue-template, pull-request-template, and community-health defaults.

## Acceptance criteria

1. The organization profile links to the product home and the repository map.
2. The product home identifies every organization repository, its purpose,
   lifecycle status, entrypoint, and dependency direction.
3. Status values use the controlled vocabulary defined by the project catalog.
4. The contracts, gateway, UI, and platform repositories each provide a public
   README with prerequisites, verification commands, compatibility boundaries,
   and links to local specifications.
5. Specification-only repositories state that no runtime implementation is
   currently authorized.
6. Public contributors are directed to repository issue forms and the
   issue-first change-management decision.
7. Documentation links are checked in CI and generated content is clearly
   identified as derived from approved specifications.

## Explicit exclusions

This specification does not create a separate documentation website, replace
component specifications with prose, or permit generated documentation to
override an approved What, How, or Decision record.
