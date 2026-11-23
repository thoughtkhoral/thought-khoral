# Task 9 source integration and package preflight

Status: authorized on 2026-11-23 by the maintainer's “proceed” after the
workspace analysis identified source integration followed by Task C preflight.
This is execution of the [approved acceptance procedure](task9-packaged-acceptance-2026-11-20.md),
not a new runtime capability or approval to activate services or call providers.

## Scope and sequence

1. Integrate the reviewed contracts release, broker/UI released consumers and
   platform acceptance-profile branches into their owning canonical mains.
   Reconcile documentation conflicts while preserving reviewed runtime bytes.
2. Keep the published v1.1 tag and artifacts, historical vendors, acceptance
   profile and all six frozen source commits unchanged. Later documentation or
   integration commits are not replacements for those acceptance inputs.
3. Verify the merged components, unchanged profile/guards and actual worker
   package. Retain a read-only independent review before advancing mains.
4. Stage exact source inputs and build production images serially with one
   Cargo job. Record actual source/image identities and architecture. Preserve
   the existing external database volume and remove only owned test fixtures.
5. Complete Task C with real configured credential paths, reviewed policies,
   private state, two human identities, browser access and a concrete operator
   packet. Missing configuration remains an explicit unmet prerequisite.
6. Request the separate activation/provider approvals only against the complete
   reviewed inputs. Task D and Task 9 acceptance remain open until their own
   required evidence is recorded.

## Integration inputs

| Owner | Prepared branch | Frozen implementation |
| --- | --- | --- |
| Contracts | `codex/task9-contract-release-20261120` | `f1c8621810c8c121c1aafc8e5a342d6626c4b843` |
| Broker | `codex/task9-broker-release-20261120` | `673294e66fed2b6e98d73e08cfe4a23a0e5e4d48` |
| UI | `codex/task9-ui-release-20261120` | `29a940012adfeb796f59c5b89b00cab7a4d0df68` |
| Platform | `codex/task9-packaged-profile-20261120` | `996e1887234b8958a315279aa3d5aa194a7fad52` |

Remote fetch and GitHub branch inspection on 2026-11-23 confirm that prepared
branches are already published and canonical mains have not incorporated them.
Earlier “unpushed” descriptions are stale. Merge preparation found only Markdown
conflicts caused by the earlier canonical/feature documentation refreshes.

The profile SHA-256 remains
`7106f7e41a6bc13feab8a0b51fccde9b47fefca2d63980d551ed929eac1c1a71`.
Its clean component snapshots remain available through the source map described
in [workspace state](workspace-state.md). The operator packet must name the
actual clean executing platform commit. The worker image remains
`sha256:2dd78cdf5eddb9ca271611998ea44fe6d6cfde6cfca8ba7d1d6c8858240b540d`.

## Evidence boundaries

Fresh component tests, package probes and source/image preflight do not establish
assembled-stack, private-DNS, Keycloak/browser, provider, tool/egress or production
acceptance. Memory remains a separate incubating proof, with no Codex integration;
guided directories, Cognee, durable memory and remote admission remain deferred.
Record final commands, identities, failures, cleanup and remaining prerequisites
in the execution checkpoint before deriving current workspace documentation.
