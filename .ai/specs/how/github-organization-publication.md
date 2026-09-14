# GitHub organization publication

## Status

Approved

## Governing specifications

- [Open-source organization documentation](../what/open-source-documentation.md)
- [Issue-first contribution and change management](../decisions/004-contribution-and-change-management.md)
- [Workspace governance](../decisions/001-workspace-governance.md)

## Organization repository

`thoughtkhoral/.github` owns organization profile content and shared GitHub
community defaults. Its `profile/README.md` remains a concise landing page and
links to `thought-khoral` for the maintained project overview and repository map.
It does not own product architecture, runtime specifications, contract
definitions, or cross-project generated reports.

## Content ownership

- Organization policies and templates: `.github`.
- Product specifications and repository catalog: `thought-khoral`.
- Protocol and schema documentation: `thought-khoral-contracts`.
- Runtime, UI, and platform operation: their respective repositories.
- Release notes: the repository that releases the artifact, with cross-project
  links maintained by `thought-khoral`.

## Publication rules

Every public repository has a README that states its purpose, status,
prerequisites, verification path, compatibility boundary, and specification
index. Cross-repository links use stable organization URLs. The product catalog
is the source of truth for repository purpose and lifecycle status; the public
map is a presentation of that metadata.

Shared workflows may validate Markdown links, repository-catalog entries,
required public files, and generated-content markers. They must not silently
change specifications or implementation code.

## Verification

Before a repository is made public or changes lifecycle status, maintainers
verify its README, issue routing, security reporting path, local specification
index, links to the product catalog, and applicable build/test commands.
