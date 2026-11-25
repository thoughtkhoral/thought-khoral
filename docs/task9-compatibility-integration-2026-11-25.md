# Compatibility source integration — 2026-11-25

The reviewed worker, platform and companion workspace sources are integrated and
pushed to canonical mains. All updates were fast-forwards, and the merged-tree
checks passed. Worker CI is **passed (four native runtime jobs, both package/capture jobs and documentation)** at the recorded snapshot.

| Repository | Published source |
| --- | --- |
| Worker | `423d4e84985eb535caa66c7522c4191c6dbccad6` |
| Platform | `60ec83c06b1e4bbffcd5bdd69aee6575608e5e3a` |
| Workspace | Initial companion `5e0aac736bdc2dd621be168de542d606567259e3`, followed by approved status/evidence-only reconciliation |

The [approved plan](../.ai/specs/how/task9-compatibility-integration-proposal-2026-11-25.md),
[execution record](../.ai/specs/how/task9-compatibility-integration-execution-2026-11-25.md)
and [publication receipt](evidence/task9-compatibility-integration-2026-11-25.json)
retain exact source and CI observations. Branches/worktrees are preserved for
frozen-source verification; older local-only checkpoint descriptions remain
historical.

Fresh checks on the actual merged trees passed: **50 worker tests, 54 platform
guards and five Compose tests**, worker formatting/Clippy/provenance/catalog
checks, and workspace documentation/identity checks. Profile and image bytes
are unchanged; historical build and test source IDs were not substituted.

Live CI links for the published worker source:

- [Provider-free native runtime/package jobs](https://github.com/thoughtkhoral/thought-khoral-codex-agent/actions/runs/45673007315)
- [Documentation/specification checks](https://github.com/thoughtkhoral/thought-khoral-codex-agent/actions/runs/45673007526)

This was source publication, with no stack startup, admission renewal, registry
image/release publication, migration or model/provider/tool call. The prior
[provider-isolated timed readiness](task9-readiness-renewal-2026-11-25.md) remains
accepted within its scope. Rendered-browser, provider/live and aggregate Task 9
acceptance remain open.

Final read-only verification found the same seven healthy base container IDs as
the accepted readiness run, with Codex/mediator off. Independent reconciliation
review and all documentation/governance checks pass, including 1,523 Markdown
links with none broken.
