# Task 9 activation result — 2026-11-23

Authorized startup was partially successful; **Task 9 remains open**. The UI
responds at [localhost:8082](http://localhost:8082). Seven services remain running;
the Codex namespace owner, proxy, worker and mediator are stopped. UI availability
does not establish conversation readiness. No model turn was requested.

This report derives from the [activation execution record](../.ai/specs/how/task9-integration-2026-11-23.md#authorized-activation-partial-failure--2026-11-23)
and [sanitized observations](evidence/task9-activation-2026-11-23.json).
It supersedes the earlier ready-for-activation status in the
[preflight report](task9-integration-preflight-2026-11-23.md).

| Observation | Result and implication |
| --- | --- |
| Exact-image startup | All eleven services initially ran after two private configuration adaptations: equivalent list-form loopback host mapping and mediator DNS alias on its existing namespace owner. Canonical sources, images and frozen profile are unchanged; stock startup failed. The evidence identifies the adapted effective configuration by SHA-256. |
| Authentication/readiness | Two distinct fixture humans authenticated through PKCE. All four authenticated models/defaults requests returned 503 `runtime_unavailable`; P1 failed. |
| Native adapter | A network-none fixture using the exact worker image initializes CLI 0.160.0 and lists models. Pinned-schema-valid startup notifications include `emittedAtMs`, which the worker rejects. Direct CLI success does not prove adapter success. |
| Isolation | The Codex watchdog stopped its namespace; the triggering condition is undetermined. Current OOM flags are false. The mediator subsequently stopped with exit 1 for an undetermined separate cause. Keep Codex disabled. |
| Database | Existing storage lacks conversation tables and has an empty migration ledger. No upgrade was applied. Test-room events are zero; conversation/task allocation counters cannot be queried. The external volume is preserved. |
| Browser | B1 unavailable; no rendered-browser acceptance or screenshots. Remaining Task 9 gates were not run. |

The owned diagnostic fixture was removed. Seven base services were left running;
expired admission prevents fresh Codex admission. No provider inference, model
turn, tool probe or existing-data migration was performed.

The next step is review of the [bounded compatibility proposal](../.ai/specs/how/task9-runtime-compatibility-proposal-2026-11-23.md).
It proposes local adapter/Compose/DNS corrections, provider-free shutdown
investigation, admission-policy comparison and migration testing on a private
restored backup. Approval would permit that local work; upgrading existing data,
publishing new inputs, activating changed inputs and provider/tool calls retain
their separate gates. The worker's [agent instructions](https://github.com/thoughtkhoral/thought-khoral-codex-agent/blob/main/AGENTS.md)
require applicable specification approval before runtime behavior changes.
