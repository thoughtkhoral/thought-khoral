# ThoughtKhoral identity migration — implementation design

## Status

Approved design; implementation planning has not started.

## Governing specifications

- [Product identity](../what/thoughtkhoral-product-identity.md)
- [Decision 003](../decisions/003-thoughtkhoral-product-identity.md)

## Rename map

| Current identifier | Destination | Treatment |
| --- | --- | --- |
| `N:N` / `N2N` display text | `ThoughtKhoral` | Rename. |
| `n2n-*` project directories | `thought-khoral-*` | Rename after each child project’s local specification update. |
| `n2n-room-v1.*` release tags | Retain | Historical immutable releases. |
| `n2n.room.v1` JSON-RPC value | Retain | Wire-compatible until separately approved v2. |
| `n2n_` database tables/records | Retain | No data migration in this pass. |
| new packages, crates, binaries, images, services, labels | `thought-khoral` | Rename. |

## Ordered execution

1. Update root and child specifications and record the applicable project-level rename decisions.
2. Rename root and child repository directories, Git remotes, package metadata, crate/binary names, images, Compose services, Kubernetes names/labels, environment-variable namespaces, and UI copy.
3. Keep explicit aliases only where required for the existing wire contract or a repository-host redirect.
4. Search all source and documentation for stale active N2N identifiers; classify every remaining occurrence as historical or wire compatibility.
5. Run contracts, gateway, UI, and platform validation, including the local browser governed-room flow.

## Security and failure behavior

Do not place compatibility credentials, redirects, or migration mappings in URLs or logs. A missed runtime identifier must fail at build/deployment validation rather than silently selecting an N2N resource. Do not rename database or contract fields opportunistically.

## Verification

- Every child repository’s local specs link to decision 003 before its identifier change.
- Repository/package/image/Compose/Kubernetes names use `thought-khoral` after migration.
- `n2n.room.v1` fixtures and gateway validation remain compatible.
- The local browser login, chat, facilitator proposal, and human decision transition work under ThoughtKhoral branding.
