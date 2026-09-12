#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
scan_root=${1:-$repo_root}
scan_root=$(cd "$scan_root" && pwd)
legacy_id='n''2n'
legacy_display='n:'n
failures=0

is_allowlisted_artifact() {
  local path=$1

  case "$path" in
    .ai/specs/how/thoughtkhoral-identity-migration.md | \
      .ai/specs/how/thoughtkhoral-identity-migration-implementation-plan.md | \
      .ai/specs/decisions/003-thoughtkhoral-product-identity.md | \
      .ai/specs/what/thoughtkhoral-product-identity.md)
      return 0
      ;;
    thought-khoral-contracts/schemas/envelope.schema.json | \
      thought-khoral-contracts/schemas/room-event.schema.json | \
      thought-khoral-contracts/schemas/rpc.schema.json | \
      thought-khoral-contracts/fixtures/invalid/bad-version.json | \
      thought-khoral-contracts/fixtures/invalid/empty-access-token.json | \
      thought-khoral-contracts/fixtures/invalid/invalid-action.json | \
      thought-khoral-contracts/fixtures/invalid/missing-request-id.json | \
      thought-khoral-contracts/fixtures/valid/chat-send.json | \
      thought-khoral-contracts/fixtures/valid/decision-edit.json | \
      thought-khoral-contracts/fixtures/valid/decision-propose.json | \
      thought-khoral-contracts/fixtures/valid/join.json | \
      thought-khoral-contracts/fixtures/valid/session-authenticate.json)
      return 0
      ;;
    thought-khoral-room-gateway/contracts/lock.json | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/.ai/specs/README.md | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/.ai/specs/decisions/README.md | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/.ai/specs/how/implementation.md | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/.ai/specs/what/mvp-contracts.md | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/.gitignore | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/fixtures/invalid/bad-version.json | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/fixtures/invalid/empty-access-token.json | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/fixtures/invalid/invalid-action.json | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/fixtures/invalid/missing-request-id.json | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/fixtures/valid/chat-send.json | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/fixtures/valid/decision-edit.json | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/fixtures/valid/decision-propose.json | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/fixtures/valid/join.json | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/fixtures/valid/session-authenticate.json | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/package-lock.json | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/package.json | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/protocol.md | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/schemas/envelope.schema.json | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/schemas/room-event.schema.json | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/schemas/rpc.schema.json | \
      thought-khoral-room-gateway/contracts/"$legacy_id".room.v1/test/validate-fixtures.mjs | \
      thought-khoral-room-gateway/migrations/0001_room_events.sql | \
      thought-khoral-room-gateway/migrations/0002_room_events_append_only.sql | \
      thought-khoral-room-gateway/migrations/0003_governed_requests.sql)
      return 0
      ;;
  esac

  return 1
}

is_compatibility_context_path() {
  local path=$1

  case "$path" in
    .ai/specs/README.md | \
      .ai/specs/how/"$legacy_id"-mvp-foundation-implementation-plan.md | \
      .ai/specs/how/spec-authoring-roadmap.md | \
      thought-khoral-contracts/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-contracts/.ai/specs/how/implementation.md | \
      thought-khoral-contracts/.ai/specs/what/mvp-contracts.md | \
      thought-khoral-contracts/protocol.md | \
      thought-khoral-contracts/test/validate-fixtures.mjs | \
      thought-khoral-room-gateway/.ai/specs/decisions/001-runtime-security-and-publication.md | \
      thought-khoral-room-gateway/.ai/specs/decisions/002-browser-session-authentication.md | \
      thought-khoral-room-gateway/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-room-gateway/.ai/specs/how/implementation.md | \
      thought-khoral-room-gateway/.ai/specs/what/mvp-room.md | \
      thought-khoral-room-gateway/README.md | \
      thought-khoral-room-gateway/src/auth.rs | \
      thought-khoral-room-gateway/src/config.rs | \
      thought-khoral-room-gateway/src/protocol.rs | \
      thought-khoral-room-gateway/src/store.rs | \
      thought-khoral-room-gateway/tests/authorization_test.rs | \
      thought-khoral-room-gateway/tests/protocol_test.rs | \
      thought-khoral-room-gateway/tests/support/mod.rs | \
      thought-khoral-workspace-ui/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-workspace-ui/.ai/specs/how/implementation.md | \
      thought-khoral-workspace-ui/.ai/specs/what/mvp-ui.md | \
      thought-khoral-workspace-ui/src/api.tsx | \
      thought-khoral-workspace-ui/src/features/decisions/DecisionCard.test.tsx | \
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
      thought-khoral-platform/README.md | \
      thought-khoral-platform/compose.yaml | \
      thought-khoral-platform/keycloak/thought-khoral-dev-realm.json | \
      thought-khoral-platform/kube/gateway.yaml | \
      thought-khoral-platform/kube/keycloak.yaml | \
      thought-khoral-platform/kube/postgres.yaml | \
      thought-khoral-platform/scripts/browser-smoke.mjs | \
      thought-khoral-platform/ui/thought-khoral-bootstrap.js)
      return 0
      ;;
  esac

  return 1
}

is_exact_historical_map() {
  local path=$1
  local content=$2

  case "$path" in
    thought-khoral-contracts/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-room-gateway/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-workspace-ui/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-memory-engine/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-agent-gateway/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-platform/.ai/specs/decisions/002-thoughtkhoral-identity.md)
      [[ "$content" == *"renamed exactly from \`$legacy_id-"*" to \`thought-khoral-"* ]]
      return
      ;;
  esac

  if [[ "$path" == scripts/verify-spec-hierarchy.sh ]]; then
    case "$content" in
      "  $legacy_id-contracts" | \
        "  $legacy_id-room-gateway" | \
        "  $legacy_id-workspace-ui" | \
        "  $legacy_id-memory-engine" | \
        "  $legacy_id-agent-gateway" | \
        "  $legacy_id-platform")
        return 0
        ;;
    esac
  fi

  return 1
}

is_migration_validator() {
  local path=$1

  case "$path" in
    thought-khoral-platform/scripts/smoke.sh | \
      thought-khoral-platform/scripts/test-validate-kube.sh | \
      thought-khoral-platform/scripts/validate-kube.sh)
      return 0
      ;;
  esac

  return 1
}

is_exact_compatibility_match() {
  local path=$1
  local content=$2
  local lower residual wire_value role_claim schema_base old_foundation old_architecture release_tag

  is_compatibility_context_path "$path" || return 1

  lower=$(printf '%s' "$content" | tr '[:upper:]' '[:lower:]')
  residual=$lower
  wire_value="$legacy_id.room.v1"
  role_claim="${legacy_id}_role"
  schema_base="https://$legacy_id.redhat.com/schemas/"
  old_foundation="$legacy_id-mvp-foundation-implementation-plan.md"
  old_architecture="$legacy_id-solution-architecture.md"
  release_tag="$legacy_id-room-v1.0."

  residual=${residual//$wire_value/}
  residual=${residual//$role_claim/}
  residual=${residual//$schema_base/}
  residual=${residual//$old_foundation/}
  residual=${residual//$old_architecture/}
  residual=${residual//$release_tag/}
  residual=${residual//${legacy_id}-room-v1.\*/}

  case "$path" in
    .ai/specs/README.md | \
      thought-khoral-platform/README.md | \
      thought-khoral-platform/.ai/specs/README.md | \
      thought-khoral-platform/.ai/specs/decisions/002-thoughtkhoral-identity.md | \
      thought-khoral-platform/.ai/specs/how/implementation.md | \
      thought-khoral-platform/.ai/specs/what/local-mvp.md)
      residual=${residual//\`$legacy_id\`/}
      residual=${residual//${legacy_id}_postgres-data/}
      residual=${residual//${legacy_id}-admin-dev-only/}
      residual=${residual//${legacy_id}-dev-only/}
      ;;
  esac

  case "$path" in
    thought-khoral-platform/compose.yaml | \
      thought-khoral-platform/kube/gateway.yaml | \
      thought-khoral-platform/kube/keycloak.yaml | \
      thought-khoral-platform/kube/postgres.yaml)
      residual=${residual//postgres:\/\/$legacy_id:$legacy_id-dev-only@thought-khoral-postgres:5432\/$legacy_id/}
      residual=${residual//pg_isready -u $legacy_id -d $legacy_id/}
      residual=${residual//pg_isready, -u, $legacy_id, -d, $legacy_id/}
      residual=${residual//${legacy_id}_postgres-data/}
      residual=${residual//${legacy_id}-admin-dev-only/}
      residual=${residual//${legacy_id}-dev-only/}
      case "$residual" in
        "      postgres_db: $legacy_id" | \
          "      postgres_user: $legacy_id" | \
          "      kc_db_username: $legacy_id" | \
          "              value: $legacy_id")
          residual=
          ;;
      esac
      ;;
    thought-khoral-room-gateway/src/config.rs)
      residual=${residual//postgres:\/\/database.test\/$legacy_id/}
      if [[ "$residual" == *"\"$legacy_id"*"_"* ]]; then
        case "$residual" in
          *"\"${legacy_id}_allowed_origins\""* | \
            *"\"${legacy_id}_oidc_issuer\""* | \
            *"\"${legacy_id}_oidc_audience\""* | \
            *"\"${legacy_id}_oidc_jwks\""*)
            residual=
            ;;
        esac
      fi
      ;;
    thought-khoral-room-gateway/README.md)
      residual=${residual//\`${legacy_id}_\*\`/}
      ;;
    thought-khoral-room-gateway/.ai/specs/how/implementation.md)
      residual=${residual//\`${legacy_id}_\*\`/}
      residual=${residual//postgres:\/\/$legacy_id:$legacy_id@127.0.0.1:54329\/$legacy_id/}
      ;;
    thought-khoral-room-gateway/.ai/specs/decisions/002-thoughtkhoral-identity.md)
      residual=${residual//\`${legacy_id}_\*\`/}
      ;;
    thought-khoral-platform/.ai/specs/how/implementation.md | \
      thought-khoral-platform/.ai/specs/what/local-mvp.md)
      residual=${residual//active $legacy_id identity occurrence/}
      residual=${residual//every $legacy_id occurrence/}
      ;;
    thought-khoral-contracts/test/validate-fixtures.mjs)
      residual=${residual//$legacy_id\\.room\\.v1/}
      ;;
  esac

  [[ "$residual" != *"$legacy_id"* && "$residual" != *"$legacy_display"* ]]
}

while IFS= read -r match; do
  relative=${match#"$scan_root"/}
  path=${relative%%:*}
  remainder=${relative#*:}
  line_number=${remainder%%:*}
  content=${remainder#*:}

  if ! is_allowlisted_artifact "$path" && \
    ! is_exact_historical_map "$path" "$content" && \
    ! is_migration_validator "$path" && \
    ! is_exact_compatibility_match "$path" "$content"; then
    printf 'FAIL: stale legacy identity: %s:%s:%s\n' "$path" "$line_number" "$content" >&2
    failures=$((failures + 1))
  fi
done < <(
  rg --line-number --with-filename --no-heading --ignore-case --hidden --no-ignore \
    --glob '!**/.git/**' \
    --glob '!**/node_modules/**' \
    --glob '!**/target/**' \
    --glob '!**/dist/**' \
    --glob '!**/coverage/**' \
    --glob '!**/.superpowers/**' \
    --glob '!**/.DS_Store' \
    "$legacy_id|$legacy_display" "$scan_root" || true
)

if (( failures > 0 )); then
  printf 'FAIL: found %d unapproved legacy identity occurrence(s)\n' "$failures" >&2
  exit 1
fi

printf 'PASS: ThoughtKhoral is the active product identity; retained legacy values are allowlisted compatibility evidence\n'
