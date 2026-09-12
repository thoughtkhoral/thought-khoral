#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
scan_root=${1:-$repo_root}
scan_root=$(cd "$scan_root" && pwd)
legacy_id='n''2n'
legacy_display='n:'n
legacy_upper='N''2N'
legacy_display_upper='N:'N
match_id='__legacy__'
match_upper='__legacy_upper__'
match_display='__legacy_display__'
wire_value="$match_id.room.v1"
wire_path="$legacy_id.room.v1"
failures=0

fail_scan() {
  printf 'FAIL: ThoughtKhoral identity scan could not run: %s\n' "$1" >&2
  exit 2
}

is_historical_map_line() {
  local path=$1
  local content=$2

  case "$path" in
    thought-khoral-contracts/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-room-gateway/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-workspace-ui/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-memory-engine/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-agent-gateway/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-platform/.ai/specs/decisions/002-thoughtkhoral-identity.md)
      [[ "$content" == *"renamed exactly from \`$match_id-"*" to \`thought-khoral-"* ]]
      return
      ;;
    scripts/verify-spec-hierarchy.sh)
      case "$content" in
        "  $match_id-contracts" | \
          "  $match_id-room-gateway" | \
          "  $match_id-workspace-ui" | \
          "  $match_id-memory-engine" | \
          "  $match_id-agent-gateway" | \
          "  $match_id-platform")
          return 0
          ;;
      esac
      ;;
  esac

  return 1
}

is_compatibility_document() {
  local path=$1

  case "$path" in
    .ai/specs/README.md | \
      .ai/specs/decisions/003-thoughtkhoral-product-identity.md | \
      .ai/specs/how/"$legacy_id"-mvp-foundation-implementation-plan.md | \
      .ai/specs/how/spec-authoring-roadmap.md | \
      .ai/specs/how/thoughtkhoral-identity-migration.md | \
      .ai/specs/how/thoughtkhoral-identity-migration-implementation-plan.md | \
      .ai/specs/what/thoughtkhoral-product-identity.md | \
      thought-khoral-contracts/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-contracts/.ai/specs/README.md | \
      thought-khoral-contracts/.ai/specs/how/implementation.md | \
      thought-khoral-contracts/.ai/specs/what/mvp-contracts.md | \
      thought-khoral-contracts/protocol.md | \
      thought-khoral-room-gateway/.ai/specs/decisions/001-runtime-security-and-publication.md | \
      thought-khoral-room-gateway/.ai/specs/decisions/002-browser-session-authentication.md | \
      thought-khoral-room-gateway/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-room-gateway/.ai/specs/how/implementation.md | \
      thought-khoral-room-gateway/.ai/specs/what/mvp-room.md | \
      thought-khoral-room-gateway/README.md | \
      thought-khoral-workspace-ui/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-workspace-ui/.ai/specs/how/implementation.md | \
      thought-khoral-workspace-ui/.ai/specs/what/mvp-ui.md | \
      thought-khoral-memory-engine/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-memory-engine/.ai/specs/how/specification-only.md | \
      thought-khoral-memory-engine/.ai/specs/what/deferred-memory-engine.md | \
      thought-khoral-agent-gateway/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-agent-gateway/.ai/specs/how/specification-only.md | \
      thought-khoral-agent-gateway/.ai/specs/what/deferred-agent-gateway.md | \
      thought-khoral-platform/.ai/specs/README.md | \
      thought-khoral-platform/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-platform/.ai/specs/how/implementation.md | \
      thought-khoral-platform/.ai/specs/what/local-mvp.md | \
      thought-khoral-platform/README.md)
      return 0
      ;;
  esac

  return 1
}

is_documented_compatibility_line() {
  local path=$1
  local content=$2

  is_compatibility_document "$path" || return 1

  if [[ "$path" == thought-khoral-platform/README.md ]]; then
    case "$content" in
      'the pre-migration external volume `__legacy___postgres-data`, so the identity rename' | \
        '| Identity | Password | Retained `__legacy___role` claim |' | \
        '`__legacy__.room.v1` protocol, PostgreSQL database and role `__legacy__`, physical' | \
        '`__legacy___postgres-data` volume, development-only persisted credential values' | \
        '`__legacy__-dev-only` and `__legacy__-admin-dev-only`, and `__legacy___role` OIDC claim remain')
        return 0
        ;;
    esac
    return 1
  fi

  if [[ "$path" == thought-khoral-room-gateway/README.md ]]; then
    case "$content" in
      'Legacy `__legacy_upper___*` configuration aliases are intentionally not accepted: a missed' | \
        'The vendored `__legacy__.room.v1` contract, its immutable `__legacy__-room-v1.0.2` release' | \
        'tag, JSON Schema identifiers, the existing `__legacy___role` JWT claim, and the')
        return 0
        ;;
    esac
    return 1
  fi

  case "$content" in
    *'`__legacy__.room.v1` wire '* | \
      *'`__legacy__.room.v1` wire-'* | \
      *'`__legacy__.room.v1` protocol'* | \
      *'`__legacy__.room.v1` JSON-RPC'* | \
      *'`__legacy__.room.v1` schema'* | \
      *'`__legacy__.room.v1` fixture'* | \
      *'`__legacy__.room.v1` interface'* | \
      *'`__legacy__.room.v1` event'* | \
      *'`__legacy__.room.v1` contract'* | \
      *'`__legacy__.room.v1` message'* | \
      *'`__legacy__.room.v1` patch'* | \
      *'`__legacy__.room.v1` values'* | \
      *'`__legacy__.room.v1` through '* | \
      *'`__legacy__.room.v1` for '* | \
      *'`__legacy__.room.v1` remains '* | \
      *'`__legacy__.room.v1` without '* | \
      *'`__legacy__.room.v1` and its schema identifiers'* | \
      *'enumerated `__legacy__.room.v1`, `__legacy___role`, and database compatibility values'* | \
      *'does not define `__legacy__.room.v1`, implement gateway event semantics'* | \
      *'`__legacy__.room.v1`. The probe succeeds only '* | \
      *'`__legacy__.room.v1` are rejected before Podman parsing'* | \
      *'preserve `__legacy__.room.v1`, and state that databases and persisted values are excluded'* | \
      *'documents `__legacy__.room.v1` as a retained compatibility value'* | \
      *'Retain `__legacy__.room.v1`, vendored historical archive names only where required by the lock'* | \
      *'exact retained `__legacy__.room.v1` and persisted-data exceptions'* | \
      *'interfaces from `__legacy__.room.v1`, and explicit exclusions'* | \
      *'`contractVersion` equal to `__legacy__.room.v1`'* | \
      *'normalized `__legacy__.room.v1` persisted-event shape'* | \
      *'authenticated `__legacy__.room.v1` room events'* | \
      *'`__legacy__.room.v1` JSON Schema artifacts, normative protocol documentation, and compatibility fixtures'* | \
      *'Schemas define the `__legacy__.room.v1` envelopes, JSON-RPC requests, and room events'* | \
      *'`contractVersion: "__legacy__.room.v1"`'* | \
      *'contracts/__legacy__.room.v1/'* | \
      *"rg -n '__legacy__\\.room\\.v1'"*)
      return 0
      ;;
  esac

  case "$content" in
    *'`__legacy___role` claim'* | \
      *'`__legacy___role` JWT claim'* | \
      *'`__legacy___role` OIDC claim'* | \
      *'`__legacy___role` identity claim'* | \
      *'`__legacy___role` metadata key'* | \
      *'`__legacy___role` equal '* | \
      *'`__legacy___role` validation'* | \
      *'`__legacy___role` authentication'* | \
      *'Map `__legacy___role` only to `human` or `agent`'* | \
      *'OIDC claim `__legacy___role`'* | \
      *'Legacy `__legacy_upper___*` configuration aliases'* | \
      *'`__legacy_upper___*` aliases are not accepted'* | \
      *'Legacy `__legacy_upper___*` aliases are not read because a missed'* | \
      *'legacy `__legacy___*` Compose service'* | \
      *'an `__legacy___role` metadata key'* | \
      *'every __legacy_upper__ occurrence'* | \
      *'active __legacy_upper__ labels'*)
      return 0
      ;;
  esac

  case "$content" in
    *'database and role `__legacy__`'* | \
      *'database and role remain `__legacy__`'* | \
      *'database and role identifiers'*'`__legacy__`'* | \
      *'volume `__legacy___postgres-data`'* | \
      *'`__legacy___postgres-data` volume'* | \
      *'volume remains `__legacy___postgres-data`'* | \
      *'`__legacy___postgres-data`, development-only persisted credential values'* | \
      *'`__legacy__-dev-only` and `__legacy__-admin-dev-only`, and OIDC claim'* | \
      *'remain `__legacy__-dev-only`. Existing database contents'* | \
      *'`__legacy__-admin-dev-only` because an existing imported realm stores that credential'* | \
      *'`postgres://__legacy__:__legacy__@'* | \
      *'postgres://__legacy__:__legacy__@'* | \
      *'`__legacy__-room-v1.'* | \
      *'`__legacy__-room-v1.*`'* | \
      'git tag __legacy__-room-v1.0.0' | \
      *'__legacy__-mvp-foundation-implementation-plan.md'* | \
      *'__legacy__-solution-architecture.md'*)
      return 0
      ;;
  esac

  case "$path:$content" in
    '.ai/specs/decisions/003-thoughtkhoral-product-identity.md:The __legacy_display__ Human-to-Agent Collaborative Workspace is named **ThoughtKhoral** in display text, documentation, public communication, Rust types, and other PascalCase human-facing contexts. Its canonical machine and package identifier is `thought-khoral`.' | \
      '.ai/specs/decisions/003-thoughtkhoral-product-identity.md:ThoughtKhoral is the public, commercial, internal, and open-source product identity. `__legacy__` remains only as a documented temporary migration alias; no new source, specification, runtime, package, container, or deployment identifier may introduce it.' | \
      '.ai/specs/decisions/003-thoughtkhoral-product-identity.md:ThoughtKhoral expresses a receptacle space for multi-voice collaborative thought while avoiding the broad, overloaded __legacy_display__/__legacy_upper__ name. It gives the product one consistent public and technical identity.' | \
      '.ai/specs/decisions/003-thoughtkhoral-product-identity.md:- Retain __legacy_display__ as the technical identifier while using ThoughtKhoral only in prose.' | \
      '.ai/specs/decisions/003-thoughtkhoral-product-identity.md:- Keep ThoughtKhoral provisional while continuing __legacy_display__ development.' | \
      '.ai/specs/what/thoughtkhoral-product-identity.md:2. The rename plan maps every current active __legacy_upper__ identifier to its destination or explicitly preserves it for wire compatibility.' | \
      '.ai/specs/what/thoughtkhoral-product-identity.md:3. No new implementation adds an `__legacy__` identifier except documented compatibility paths.' | \
      '.ai/specs/how/thoughtkhoral-identity-migration.md:| `__legacy_display__` / `__legacy_upper__` display text | `ThoughtKhoral` | Rename. |' | \
      '.ai/specs/how/thoughtkhoral-identity-migration.md:| `__legacy__-*` project directories | `thought-khoral-*` | Rename after each child project’s local specification update. |' | \
      '.ai/specs/how/thoughtkhoral-identity-migration.md:| `__legacy___` database tables/records | Retain | No data migration in this pass. |' | \
      '.ai/specs/how/thoughtkhoral-identity-migration.md:4. Search all source and documentation for stale active __legacy_upper__ identifiers; classify every remaining occurrence as historical or wire compatibility.' | \
      '.ai/specs/how/thoughtkhoral-identity-migration.md:Do not place compatibility credentials, redirects, or migration mappings in URLs or logs. A missed runtime identifier must fail at build/deployment validation rather than silently selecting an __legacy_upper__ resource. Do not rename database or contract fields opportunistically.' | \
      '.ai/specs/how/thoughtkhoral-identity-migration-implementation-plan.md:- No new `__legacy__` identifiers except explicitly documented historical or `__legacy__.room.v1` wire-compatible values.' | \
      '.ai/specs/how/thoughtkhoral-identity-migration-implementation-plan.md:- Rename: six `__legacy__-*` project directories to the corresponding `thought-khoral-*` names.' | \
      '.ai/specs/how/thoughtkhoral-identity-migration-implementation-plan.md:Extend `scripts/verify-spec-hierarchy.sh` to require the six `thought-khoral-*` directories and reject active root Git tracking below them. It must initially fail because the directories retain their __legacy_upper__ names.' | \
      '.ai/specs/how/thoughtkhoral-identity-migration-implementation-plan.md:Replace every `/__legacy__-*` direct-child entry with its `/thought-khoral-*` equivalent. Run `bash scripts/verify-spec-hierarchy.sh` and `git ls-files thought-khoral-contracts thought-khoral-room-gateway thought-khoral-workspace-ui thought-khoral-platform`.' | \
      '.ai/specs/how/thoughtkhoral-identity-migration-implementation-plan.md:Run: `cargo fmt --check && cargo clippy --all-targets -- -D warnings && cargo test --all-targets && rg -n '\''__legacy__'\'' --glob '\''!contracts/**'\'' --glob '\''!migrations/**'\''`' | \
      '.ai/specs/how/thoughtkhoral-identity-migration-implementation-plan.md:Expected: FAIL on legacy __legacy_display__ title/copy.' | \
      '.ai/specs/how/thoughtkhoral-identity-migration-implementation-plan.md:Run: `npm test && npm run test:preview && npm run build && rg -n '\''__legacy_display__|__legacy__'\'' src index.html package.json`' | \
      '.ai/specs/how/thoughtkhoral-identity-migration-implementation-plan.md:Extend `scripts/smoke.sh` to reject legacy `__legacy___` Compose service/container names and require the expected ThoughtKhoral UI page title after login. Extend `scripts/validate-kube.sh` to reject active __legacy_upper__ labels outside documented v1/data compatibility annotations.' | \
      '.ai/specs/how/thoughtkhoral-identity-migration-implementation-plan.md:Create root `scripts/verify-thoughtkhoral-identity.sh`. It must fail on every `__legacy__` match unless its path is in an allowlist containing only contract fixtures/schemas, gateway contract lock/archive references, migration files, and the historical rename-map table.' | \
      '.ai/specs/how/thoughtkhoral-identity-migration-implementation-plan.md:Expected: PASS; browser displays ThoughtKhoral and all remaining __legacy_upper__ references are deliberate exceptions.' | \
      'thought-khoral-platform/.ai/specs/how/implementation.md:`__legacy___postgres-data`, and existing PostgreSQL and Keycloak database passwords')
      return 0
      ;;
  esac

  return 1
}

is_contract_artifact_line() {
  local path=$1
  local content=$2
  local contract_path=$path
  local archived=false

  case "$path" in
    thought-khoral-room-gateway/contracts/"$wire_path"/*)
      contract_path="thought-khoral-contracts/${path#thought-khoral-room-gateway/contracts/$wire_path/}"
      archived=true
      ;;
  esac

  case "$contract_path" in
    thought-khoral-contracts/fixtures/invalid/bad-version.json)
      [[ "$content" == *'"contractVersion"'*':'*'"__legacy__.room.v2"'* ]]
      return
      ;;
    thought-khoral-contracts/fixtures/invalid/empty-access-token.json | \
      thought-khoral-contracts/fixtures/invalid/invalid-action.json | \
      thought-khoral-contracts/fixtures/invalid/missing-request-id.json | \
      thought-khoral-contracts/fixtures/valid/chat-send.json | \
      thought-khoral-contracts/fixtures/valid/decision-edit.json | \
      thought-khoral-contracts/fixtures/valid/decision-propose.json | \
      thought-khoral-contracts/fixtures/valid/join.json | \
      thought-khoral-contracts/fixtures/valid/session-authenticate.json)
      [[ "$content" == *'"contractVersion"'*':'*"\"$wire_value\""* ]]
      return
      ;;
    thought-khoral-contracts/schemas/envelope.schema.json | \
      thought-khoral-contracts/schemas/room-event.schema.json | \
      thought-khoral-contracts/schemas/rpc.schema.json)
      case "$content" in
        *'"$id": "https://__legacy__.redhat.com/schemas/__legacy__.room.v1/'* | \
          *'"$ref": "https://__legacy__.redhat.com/schemas/__legacy__.room.v1/'* | \
          *'"contractVersion": { "const": "__legacy__.room.v1" }'*)
          return 0
          ;;
        *'"title": "__legacy_display__ room v1 '*)
          [[ "$archived" == true ]]
          return
          ;;
      esac
      return 1
      ;;
    thought-khoral-contracts/package.json | thought-khoral-contracts/package-lock.json)
      [[ "$archived" == true && "$content" == *'"name": "@__legacy__/contracts"'* ]]
      return
      ;;
    thought-khoral-contracts/protocol.md | \
      thought-khoral-contracts/.ai/specs/README.md | \
      thought-khoral-contracts/.ai/specs/how/implementation.md | \
      thought-khoral-contracts/.ai/specs/what/mvp-contracts.md)
      if [[ "$archived" == true ]]; then
        case "$contract_path:$content" in
          'thought-khoral-contracts/protocol.md:# __legacy_display__ room protocol v1' | \
            'thought-khoral-contracts/.ai/specs/README.md:# __legacy_display__ contracts specifications' | \
            'thought-khoral-contracts/.ai/specs/README.md:Parent requirements in the __legacy_display__ root `.ai/specs/` apply here. This project may diverge only through an accepted local decision record that identifies the overridden parent rule and its consequences.')
            return 0
            ;;
        esac
      fi
      is_documented_compatibility_line "$contract_path" "$content"
      return
      ;;
  esac

  return 1
}

is_gateway_source_line() {
  local path=$1
  local content=$2

  case "$path" in
    thought-khoral-room-gateway/contracts/lock.json)
      case "$content" in
        '  "contract": "__legacy__.room.v1",' | \
          '  "source": "../__legacy__-contracts",' | \
          '  "tag": "__legacy__-room-v1.0.2",')
          return 0
          ;;
      esac
      ;;
    thought-khoral-room-gateway/src/auth.rs | thought-khoral-room-gateway/tests/support/mod.rs)
      [[ "$content" == *'#[serde(rename = "__legacy___role")]'* || \
        "$content" == *'"contractVersion": "__legacy__.room.v1",'* ]]
      return
      ;;
    thought-khoral-room-gateway/src/config.rs)
      case "$content" in
        *'Some("postgres://database.test/__legacy__")'* | \
          *'"__legacy_upper___ALLOWED_ORIGINS"'* | \
          *'"__legacy_upper___OIDC_ISSUER"'* | \
          *'"__legacy_upper___OIDC_AUDIENCE"'* | \
          *'"__legacy_upper___OIDC_JWKS"'*)
          return 0
          ;;
      esac
      ;;
    thought-khoral-room-gateway/src/protocol.rs)
      case "$content" in
        *'include_str!("../contracts/__legacy__.room.v1/'* | \
          *'"https://__legacy__.redhat.com/schemas/__legacy__.room.v1/'* | \
          *'"the pinned __legacy__.room.v1 '* | \
          *'"contractVersion": "__legacy__.room.v1"'* | \
          *'version != "__legacy__.room.v1"'*)
          return 0
          ;;
      esac
      ;;
    thought-khoral-room-gateway/src/store.rs)
      [[ "$content" == *'"contractVersion": "__legacy__.room.v1",'* ]]
      return
      ;;
    thought-khoral-room-gateway/tests/protocol_test.rs)
      [[ "$content" == *'include_str!("../contracts/__legacy__.room.v1/fixtures/'* ]]
      return
      ;;
    thought-khoral-room-gateway/tests/authorization_test.rs)
      [[ "$content" == '// This fails if an unsupported __legacy___role is defaulted or admitted as a participant.' ]]
      return
      ;;
  esac

  return 1
}

is_ui_source_line() {
  local path=$1
  local content=$2

  case "$path" in
    thought-khoral-workspace-ui/src/api.tsx)
      [[ "$content" == "export const CONTRACT_VERSION = '$wire_value' as const;" ]]
      return
      ;;
    thought-khoral-workspace-ui/src/features/decisions/DecisionCard.test.tsx)
      [[ "$content" == *"contractVersion: '$wire_value'"* ]]
      return
      ;;
  esac

  return 1
}

is_platform_config_line() {
  local path=$1
  local content=$2

  case "$path" in
    thought-khoral-platform/compose.yaml)
      case "$content" in
        '      POSTGRES_DB: __legacy__' | \
          '      POSTGRES_PASSWORD: __legacy__-dev-only' | \
          '      POSTGRES_USER: __legacy__' | \
          '      test: ["CMD-SHELL", "pg_isready -U __legacy__ -d __legacy__"]' | \
          '      KC_BOOTSTRAP_ADMIN_PASSWORD: __legacy__-admin-dev-only' | \
          '      KC_DB_PASSWORD: __legacy__-dev-only' | \
          '      KC_DB_USERNAME: __legacy__' | \
          '      DATABASE_URL: postgres://__legacy__:__legacy__-dev-only@thought-khoral-postgres:5432/__legacy__' | \
          '    name: __legacy___postgres-data')
          return 0
          ;;
      esac
      ;;
    thought-khoral-platform/kube/gateway.yaml)
      [[ "$content" == '              value: postgres://__legacy__:__legacy__-dev-only@thought-khoral-postgres:5432/__legacy__' ]]
      return
      ;;
    thought-khoral-platform/kube/keycloak.yaml)
      case "$content" in
        '              value: __legacy__-admin-dev-only' | \
          '              value: __legacy__' | \
          '              value: __legacy__-dev-only')
          return 0
          ;;
      esac
      ;;
    thought-khoral-platform/kube/postgres.yaml)
      case "$content" in
        '              value: __legacy__' | \
          '              value: __legacy__-dev-only' | \
          '              command: [pg_isready, -U, __legacy__, -d, __legacy__]')
          return 0
          ;;
      esac
      ;;
    thought-khoral-platform/keycloak/thought-khoral-dev-realm.json)
      case "$content" in
        *'"user.attribute": "__legacy___role"'* | \
          *'"claim.name": "__legacy___role"'* | \
          *'"__legacy___role": ['*)
          return 0
          ;;
      esac
      ;;
    thought-khoral-platform/ui/thought-khoral-bootstrap.js)
      [[ "$content" == *"claims.__legacy___role === 'agent'"* ]]
      return
      ;;
    thought-khoral-platform/scripts/browser-smoke.mjs)
      [[ "$content" == *"contractVersion: '$wire_value'"* ]]
      return
      ;;
  esac

  return 1
}

is_platform_validator_line() {
  local path=$1
  local content=$2

  case "$path" in
    thought-khoral-platform/scripts/smoke.sh)
      case "$content" in
        *'pg_isready -U __legacy__ -d __legacy__' | \
          *"grep -q 'name: __legacy___postgres-data'"* | \
          *"external __legacy___postgres-data compatibility volume"* | \
          *"grep -q 'POSTGRES_PASSWORD: __legacy__-dev-only'"* | \
          *"grep -q 'KC_DB_PASSWORD: __legacy__-dev-only'"* | \
          *"grep -q 'KC_BOOTSTRAP_ADMIN_PASSWORD: __legacy__-admin-dev-only'"* | \
          *"grep -q 'DATABASE_URL: postgres://__legacy__:__legacy__-dev-only@thought-khoral-postgres:5432/__legacy__'"* | \
          *'unexpected___legacy__='* | *'"$unexpected___legacy__"'* | \
          *"grep -Ei '__legacy__[_-]'"* | \
          *"grep -Ev '^[[:space:]]+(KC_BOOTSTRAP_ADMIN_PASSWORD: __legacy__-admin-dev-only|KC_DB_PASSWORD: __legacy__-dev-only|POSTGRES_PASSWORD: __legacy__-dev-only|DATABASE_URL: postgres://__legacy__:__legacy__-dev-only@thought-khoral-postgres:5432/__legacy__|name: __legacy___postgres-data)$'"* | \
          *'active legacy __legacy_upper__ identifier'* | \
          *'label=io.podman.compose.project=__legacy__'* | \
          *'legacy __legacy_upper__ Compose containers are present'*)
          return 0
          ;;
      esac
      ;;
    thought-khoral-platform/scripts/validate-kube.sh)
      case "$content" in
        *'index(lower, "__legacy__")'* | \
          *'value:[[:space:]]+(__legacy__\.room\.v1|__legacy___role)'* | \
          *'value:[[:space:]]+__legacy__[[:space:]]*'* | \
          *'value:[[:space:]]+__legacy__-admin-dev-only'* | \
          *'value:[[:space:]]+__legacy__-dev-only'* | \
          *'postgres:\/\/__legacy__:__legacy__-dev-only@thought-khoral-postgres:5432\/__legacy__'* | \
          *'pg_isready, -U, __legacy__, -d, __legacy__'* | \
          *'active legacy __legacy_upper__ Kubernetes identifiers'*)
          return 0
          ;;
      esac
      ;;
    thought-khoral-platform/scripts/test-validate-kube.sh)
      case "$content" in
        "  '    app.kubernetes.io/name: __legacy__-gateway'" | \
          "assert_rejected 'an active legacy __legacy___role label key' "* | \
          "  '    __legacy___role: active-legacy-label'" | \
          "  '    app.kubernetes.io/name: __legacy__-gateway-__legacy__.room.v1'")
          return 0
          ;;
      esac
      ;;
  esac

  return 1
}

is_contract_test_line() {
  local path=$1
  local content=$2

  if [[ "$path" == thought-khoral-contracts/test/validate-fixtures.mjs ]]; then
    case "$content" in
      *'/`__legacy__\.room\.v1` remains a retained compatibility wire value/'* | \
        *'protocol documentation must identify __legacy__.room.v1 as a retained compatibility wire value'*)
        return 0
        ;;
    esac
  fi

  return 1
}

is_allowed_match() {
  local path=$1
  local content=$2

  is_historical_map_line "$path" "$content" || \
    is_documented_compatibility_line "$path" "$content" || \
    is_contract_artifact_line "$path" "$content" || \
    is_contract_test_line "$path" "$content" || \
    is_gateway_source_line "$path" "$content" || \
    is_ui_source_line "$path" "$content" || \
    is_platform_config_line "$path" "$content" || \
    is_platform_validator_line "$path" "$content"
}

command -v rg >/dev/null 2>&1 || fail_scan 'ripgrep (rg) is unavailable'

scan_output=
if scan_output=$(rg --line-number --with-filename --no-heading --ignore-case --hidden --no-ignore \
  --glob '!**/.git/**' \
  --glob '!**/node_modules/**' \
  --glob '!**/target/**' \
  --glob '!**/dist/**' \
  --glob '!**/coverage/**' \
  --glob '!**/.superpowers/**' \
  --glob '!**/.DS_Store' \
  "$legacy_id|$legacy_display" "$scan_root"); then
  scan_status=0
else
  scan_status=$?
fi

if (( scan_status > 1 )); then
  fail_scan "ripgrep exited with status $scan_status"
fi

while IFS= read -r match; do
  [[ -n "$match" ]] || continue
  relative=${match#"$scan_root"/}
  path=${relative%%:*}
  remainder=${relative#*:}
  line_number=${remainder%%:*}
  content=${remainder#*:}
  normalized_content=${content//$legacy_id/$match_id}
  normalized_content=${normalized_content//$legacy_upper/$match_upper}
  normalized_content=${normalized_content//$legacy_display/$match_display}
  normalized_content=${normalized_content//$legacy_display_upper/$match_display}

  if ! is_allowed_match "$path" "$normalized_content"; then
    printf 'FAIL: stale legacy identity: %s:%s:%s\n' "$path" "$line_number" "$content" >&2
    failures=$((failures + 1))
  fi
done <<<"$scan_output"

if (( failures > 0 )); then
  printf 'FAIL: found %d unapproved legacy identity occurrence(s)\n' "$failures" >&2
  exit 1
fi

printf 'PASS: ThoughtKhoral is the active product identity; retained legacy values are exact compatibility evidence\n'
