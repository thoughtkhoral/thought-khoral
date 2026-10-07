#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
validator="$repo_root/scripts/verify-thoughtkhoral-identity.sh"
fixture_root=$(mktemp -d "${TMPDIR:-/tmp}/thought-khoral-identity-test.XXXXXX")
trap 'rm -rf "$fixture_root"' EXIT
git init -q "$fixture_root"

legacy_id='n''2n'
legacy_upper='N''2N'
legacy_display_upper='N:'N
printf '/thought-khoral-contracts/\n' >"$fixture_root/.gitignore"
mkdir -p "$fixture_root/thought-khoral-contracts/fixtures/valid"
printf '{"contractVersion":"%s.room.v1"}\n' "$legacy_id" \
  >"$fixture_root/thought-khoral-contracts/fixtures/valid/join.json"

if ! allowed_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: the pinned v1 contract fixture must be allowed\n%s\n' "$allowed_output" >&2
  exit 1
fi

mkdir -p "$fixture_root/.worktrees/duplicate"
printf 'service=%s-room-gateway\n' "$legacy_id" \
  >"$fixture_root/.worktrees/duplicate/active.env"
if ! worktree_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: duplicate worktree contents must not enter the canonical scan\n%s\n' \
    "$worktree_output" >&2
  exit 1
fi
mkdir -p "$fixture_root/.worktrees/feature"
printf 'service=%s-room-gateway\n' "$legacy_id" \
  >"$fixture_root/.worktrees/feature/active.env"
if feature_output=$(bash "$validator" "$fixture_root/.worktrees/feature" 2>&1); then
  printf 'FAIL: an explicitly selected feature worktree was not scanned\n%s\n' \
    "$feature_output" >&2
  exit 1
fi
printf '%s\n' "$feature_output" | grep -Fq 'active.env' || {
  printf 'FAIL: feature worktree rejection did not identify active.env\n%s\n' \
    "$feature_output" >&2
  exit 1
}
rm "$fixture_root/.worktrees/feature/active.env"
printf 'gitdir: /tmp/%s-repository/.git/worktrees/feature\n' "$legacy_id" \
  >"$fixture_root/.worktrees/feature/.git"
if ! metadata_output=$(bash "$validator" "$fixture_root/.worktrees/feature" 2>&1); then
  printf 'FAIL: Git worktree metadata must not be scanned as product content\n%s\n' \
    "$metadata_output" >&2
  exit 1
fi

mkdir -p \
  "$fixture_root/docs/superpowers/plans" \
  "$fixture_root/.ai/specs/decisions" \
  "$fixture_root/thought-khoral-memory-engine/docs" \
  "$fixture_root/thought-khoral-room-gateway/.ai/specs/decisions" \
  "$fixture_root/thought-khoral-room-gateway/contracts/$legacy_id.room.v1/test" \
  "$fixture_root/thought-khoral-platform/scripts" \
  "$fixture_root/thought-khoral-contracts/test"
printf '{"contractVersion":"%s.room.v1"}\n' "$legacy_id" \
  >"$fixture_root/thought-khoral-contracts/fixtures/valid/chat-send-mentions.json"
printf 'The retained `%s.room.v1` contract gains additive chat delivery fields:\n' \
  "$legacy_id" >"$fixture_root/docs/superpowers/plans/2026-09-18-message-mentions.md"
printf '  git add contracts/%s.room.v1 src/protocol.rs\n' "$legacy_id" \
  >>"$fixture_root/docs/superpowers/plans/2026-09-18-message-mentions.md"
printf -- '- The retained `%s.room.v1` event schema gains additive events.\n' \
  "$legacy_id" >"$fixture_root/.ai/specs/decisions/006-agent-task-dispatch.md"
printf -- '- Contract: `%s.room.v1` remains unchanged.\n' "$legacy_id" \
  >"$fixture_root/thought-khoral-memory-engine/docs/poc-verification.md"
printf 'The existing `%s-room-v1.0.2` archive remains immutable.\n' "$legacy_id" \
  >"$fixture_root/thought-khoral-room-gateway/.ai/specs/decisions/003-slash-decisions-crud.md"
printf 'The vendored `%s.room.v1` contract is pinned to its authoritative commit (recorded in\n' \
  "$legacy_id" >"$fixture_root/thought-khoral-room-gateway/README.md"
printf 'The gateway vendor prefix is `contracts/%s.room.v1/`.\n' "$legacy_id" \
  >"$fixture_root/thought-khoral-room-gateway/task-9-gateway-fix-report.md"
printf '  /`%s\\.room\\.v1` remains a retained compatibility wire value/,\n' "$legacy_id" \
  >"$fixture_root/thought-khoral-room-gateway/contracts/$legacy_id.room.v1/test/validate-fixtures.mjs"
printf "      contractVersion: '%s.room.v1',\n" "$legacy_id" \
  >"$fixture_root/thought-khoral-platform/scripts/smoke-agent-gateway.mjs"
printf '  contractVersion: "%s.room.v1",\n' "$legacy_id" \
  >"$fixture_root/thought-khoral-contracts/test/validate-fixtures.mjs"
if ! current_compatibility_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: current retained-wire and historical evidence must be allowed\n%s\n' \
    "$current_compatibility_output" >&2
  exit 1
fi
mkdir -p "$fixture_root/.ai/specs/how"
printf '`%s.room.v1` contract owns the field shapes and compatibility fixtures. The\n' \
  "$legacy_id" >"$fixture_root/.ai/specs/how/message-mentions-and-delivery.md"
if ! mention_spec_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: the new spec exact retained-wire reference must be allowed\n%s\n' \
    "$mention_spec_output" >&2
  exit 1
fi
rm "$fixture_root/.ai/specs/how/message-mentions-and-delivery.md"
printf '| Contracts | Publishes the retained `%s.room.v1` JSON Schemas, protocol, and compatibility fixtures. | Contract artifacts only; no runtime library. |\n' \
  "$legacy_id" >"$fixture_root/docs/compatibility-matrix.md"
if ! matrix_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: the compatibility matrix exact wire value must be allowed\n%s\n' \
    "$matrix_output" >&2
  exit 1
fi
rm "$fixture_root/docs/compatibility-matrix.md"
rm \
  "$fixture_root/thought-khoral-contracts/fixtures/valid/chat-send-mentions.json" \
  "$fixture_root/docs/superpowers/plans/2026-09-18-message-mentions.md" \
  "$fixture_root/.ai/specs/decisions/006-agent-task-dispatch.md" \
  "$fixture_root/thought-khoral-memory-engine/docs/poc-verification.md" \
  "$fixture_root/thought-khoral-room-gateway/.ai/specs/decisions/003-slash-decisions-crud.md" \
  "$fixture_root/thought-khoral-room-gateway/README.md" \
  "$fixture_root/thought-khoral-room-gateway/task-9-gateway-fix-report.md" \
  "$fixture_root/thought-khoral-room-gateway/contracts/$legacy_id.room.v1/test/validate-fixtures.mjs" \
  "$fixture_root/thought-khoral-platform/scripts/smoke-agent-gateway.mjs" \
  "$fixture_root/thought-khoral-contracts/test/validate-fixtures.mjs"

mkdir -p \
  "$fixture_root/thought-khoral-agent-gateway/contracts/$legacy_id.room.v1/schemas" \
  "$fixture_root/thought-khoral-agent-gateway/tests" \
  "$fixture_root/thought-khoral-room-gateway/tests" \
  "$fixture_root/thought-khoral-workspace-ui/src/features/room"
printf '  "contract": "%s.room.v1",\n' "$legacy_id" \
  >"$fixture_root/thought-khoral-agent-gateway/contracts/lock.json"
printf 'The contract remains `%s.room.v1`.\n' "$legacy_id" \
  >"$fixture_root/thought-khoral-agent-gateway/contracts/README.md"
printf '  "$id": "https://%s.redhat.com/schemas/%s.room.v1/envelope.schema.json",\n' \
  "$legacy_id" "$legacy_id" \
  >"$fixture_root/thought-khoral-agent-gateway/contracts/$legacy_id.room.v1/schemas/envelope.schema.json"
printf 'root.join("%s.room.v1/schemas")\n"../contracts/%s.room.v1/schemas/envelope.schema.json"\n' \
  "$legacy_id" "$legacy_id" \
  >"$fixture_root/thought-khoral-agent-gateway/tests/dispatcher_test.rs"
printf 'contract_version: "%s.room.v1".to_owned(),\n' "$legacy_id" \
  >"$fixture_root/thought-khoral-room-gateway/tests/agent_service_test.rs"
printf "contractVersion: '%s.room.v1', roomId: 'room-id',\n" "$legacy_id" \
  >"$fixture_root/thought-khoral-workspace-ui/src/features/room/ChatStream.test.tsx"
if ! feature_compatibility_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: feature-branch pinned wire evidence must be allowed\n%s\n' \
    "$feature_compatibility_output" >&2
  exit 1
fi
rm \
  "$fixture_root/thought-khoral-agent-gateway/contracts/lock.json" \
  "$fixture_root/thought-khoral-agent-gateway/contracts/README.md" \
  "$fixture_root/thought-khoral-agent-gateway/contracts/$legacy_id.room.v1/schemas/envelope.schema.json" \
  "$fixture_root/thought-khoral-agent-gateway/tests/dispatcher_test.rs" \
  "$fixture_root/thought-khoral-room-gateway/tests/agent_service_test.rs" \
  "$fixture_root/thought-khoral-workspace-ui/src/features/room/ChatStream.test.tsx"

printf 'service=%s-room-gateway\n' "$legacy_id" >"$fixture_root/active.env"
if active_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: an active legacy machine identifier was accepted\n%s\n' "$active_output" >&2
  exit 1
fi
printf '%s\n' "$active_output" | grep -Fq 'active.env' || {
  printf 'FAIL: rejection did not identify active.env\n%s\n' "$active_output" >&2
  exit 1
}
rm "$fixture_root/active.env"

printf 'product=%s\n' "$legacy_id" >"$fixture_root/thought-khoral-contracts/README.md"
if broad_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: the contracts repository was allowed as a broad path\n%s\n' "$broad_output" >&2
  exit 1
fi
printf '%s\n' "$broad_output" | grep -Fq 'thought-khoral-contracts/README.md' || {
  printf 'FAIL: broad-path rejection did not identify the contracts README\n%s\n' "$broad_output" >&2
  exit 1
}

printf 'contract=%s.room.v1\n' "$legacy_id" >"$fixture_root/thought-khoral-contracts/README.md"
if undocumented_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: a wire token outside an enumerated compatibility file was accepted\n%s\n' \
    "$undocumented_output" >&2
  exit 1
fi
printf '%s\n' "$undocumented_output" | grep -Fq 'thought-khoral-contracts/README.md' || {
  printf 'FAIL: undocumented wire-token rejection did not identify the contracts README\n%s\n' \
    "$undocumented_output" >&2
  exit 1
}
rm "$fixture_root/thought-khoral-contracts/README.md"

# Independent consumers retain only the two immutable ordinary-message fields.
for consumer in thought-khoral-codex-agent thought-khoral-agent-gateway thought-khoral-workspace-ui; do
consumer_directory="$fixture_root/$consumer/contracts/agent-conversation-v1/fixtures/valid"
mkdir -p "$consumer_directory"
for fixture in ordinary-human-message ordinary-codex-message; do
  printf '  "contractVersion": "%s.room.v1",\n' "$legacy_id" >"$consumer_directory/$fixture.json"
done
if ! consumer_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: exact consumer compatibility fixtures must be allowed\n%s\n' "$consumer_output" >&2
  exit 1
fi
printf '  "product": "%s",\n' "$legacy_id" >>"$consumer_directory/ordinary-human-message.json"
if consumer_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: consumer fixture allowance accepted another legacy occurrence\n%s\n' "$consumer_output" >&2
  exit 1
fi
rm "$consumer_directory/ordinary-human-message.json" "$consumer_directory/ordinary-codex-message.json"

done

review_failures=0

assert_rejected_content() {
  local description=$1 path=$2 content=$3 output
  mkdir -p "$(dirname "$fixture_root/$path")"
  printf '%s\n' "$content" >"$fixture_root/$path"
  if output=$(bash "$validator" "$fixture_root" 2>&1); then
    printf 'FAIL: %s was accepted\n%s\n' "$description" "$output" >&2
    review_failures=$((review_failures + 1))
  elif ! printf '%s\n' "$output" | grep -Fq "FAIL: stale legacy identity: $path:"; then
    printf 'FAIL: %s rejection did not identify its source\n%s\n' "$description" "$output" >&2
    review_failures=$((review_failures + 1))
  fi
  rm "$fixture_root/$path"
}

# Unreleased candidate pins preserve only these exact ordinary-event wire fields.
for candidate_owner in thought-khoral-room-gateway thought-khoral-workspace-ui; do
  candidate_directory="$candidate_owner/contracts/agent-conversation-v1.1-candidate/fixtures/agent-conversation-v1/valid"
  for candidate_name in ordinary-human-message ordinary-codex-message; do
    candidate_path="$candidate_directory/$candidate_name.json"
    mkdir -p "$(dirname "$fixture_root/$candidate_path")"
    printf '  "contractVersion": "%s.room.v1",\n' "$legacy_id" >"$fixture_root/$candidate_path"
    if ! candidate_output=$(bash "$validator" "$fixture_root" 2>&1); then
      printf 'FAIL: exact candidate wire fixture was rejected\n%s\n' "$candidate_output" >&2
      exit 1
    fi
    rm "$fixture_root/$candidate_path"
    assert_rejected_content 'a legacy product beside the candidate wire field' \
      "$candidate_path" "  \"contractVersion\": \"$legacy_id.room.v1\", \"product\": \"$legacy_id\""
  done
  assert_rejected_content 'a candidate wire field in an unenumerated fixture' \
    "$candidate_directory/unapproved-message.json" "  \"contractVersion\": \"$legacy_id.room.v1\","
done

# Task9 retains the existing authentication claim, never a legacy service name.
task9_paths=(
  thought-khoral-platform/scripts/smoke-codex-conversation.mjs
  thought-khoral-platform/scripts/fixtures/codex-conversation/src/main.rs
  thought-khoral-platform/scripts/tests/codex-conversation-smoke.test.mjs
)
task9_lines=(
  "  if (!uuid(claims.sub) || claims.${legacy_id}_role !== 'human') throw new Error('live tokens must be distinct human room credentials');"
  "    ${legacy_id}_role: Option<&'static str>,"
  "  const token = sub => 'synthetic.' + Buffer.from(JSON.stringify({ sub, ${legacy_id}_role: 'human', padding: 'x'.repeat(100) })).toString('base64url') + '.synthetic';"
)
for i in 0 1 2; do
  task9_path=${task9_paths[$i]}
  mkdir -p "$(dirname "$fixture_root/$task9_path")"
  printf '%s\n' "${task9_lines[$i]}" >"$fixture_root/$task9_path"
  if ! task9_output=$(bash "$validator" "$fixture_root" 2>&1); then
    printf 'FAIL: Task9 exact retained authentication claim was rejected\n%s\n' "$task9_output" >&2
    exit 1
  fi
  rm "$fixture_root/$task9_path"
  assert_rejected_content 'a legacy service beside the Task9 authentication claim' \
    "$task9_path" "${task9_lines[$i]} // ${legacy_id}-gateway"
  assert_rejected_content 'a legacy service in the Task9 verification file' \
    "$task9_path" "service=${legacy_id}-gateway"
done
task9_path=${task9_paths[1]}
printf '            %s_role: role,\n' "$legacy_id" >"$fixture_root/$task9_path"
if ! task9_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: Task9 exact retained claim assignment was rejected\n%s\n' "$task9_output" >&2
  exit 1
fi
rm "$fixture_root/$task9_path"
assert_rejected_content 'a Task9 claim in an unenumerated file' \
  thought-khoral-platform/scripts/unapproved-task9.mjs "${task9_lines[0]}"

assert_rejected_content 'a runtime command beside documented wire compatibility' \
  .ai/specs/how/thoughtkhoral-identity-migration.md \
  "Run \`podman run $legacy_id-room-gateway\` against the \`$legacy_id.room.v1\` protocol."
assert_rejected_content 'a runtime wire-token identity beside a second allowed wire token' \
  .ai/specs/how/thoughtkhoral-identity-migration.md \
  "Run \`podman run $legacy_id.room.v1\` against the \`$legacy_id.room.v1\` protocol."
assert_rejected_content 'a live legacy heading beside documented wire compatibility' \
  thought-khoral-contracts/protocol.md \
  "# $legacy_display_upper \`$legacy_id.room.v1\` protocol"
assert_rejected_content 'a live schema title beside an allowed schema identifier' \
  thought-khoral-contracts/schemas/envelope.schema.json \
  "{\"\$id\": \"https://$legacy_id.redhat.com/schemas/$legacy_id.room.v1/envelope.schema.json\", \"title\": \"$legacy_display_upper room v1 application envelope\"}"
assert_rejected_content 'a live schema name beside an allowed schema reference' \
  thought-khoral-contracts/schemas/envelope.schema.json \
  "{\"\$ref\": \"https://$legacy_id.redhat.com/schemas/$legacy_id.room.v1/envelope.schema.json\", \"name\": \"$legacy_id-room\"}"
assert_rejected_content 'live display metadata beside an allowed contract version' \
  thought-khoral-contracts/schemas/envelope.schema.json \
  "{\"contractVersion\": { \"const\": \"$legacy_id.room.v1\" }, \"display\": \"$legacy_display_upper\"}"
assert_rejected_content 'a fixture name beside an allowed contract version' \
  thought-khoral-contracts/fixtures/valid/chat-send.json \
  "{\"contractVersion\":\"$legacy_id.room.v1\",\"name\":\"$legacy_id-room\"}"
assert_rejected_content 'an active legacy service in the new mention spec' \
  .ai/specs/how/message-mentions-and-delivery.md \
  "The \`$legacy_id.room.v1\` contract owns the field shapes and compatibility fixtures. The $legacy_id-room-gateway serves it."
assert_rejected_content 'an active legacy service in the compatibility matrix' \
  docs/compatibility-matrix.md \
  "| Contracts | Publishes the retained \`$legacy_id.room.v1\` JSON Schemas, protocol, and compatibility fixtures. | Active $legacy_id service. |"

printf '{"$id": "https://%s.redhat.com/schemas/%s.room.v1/envelope.schema.json", "$ref": "https://%s.redhat.com/schemas/%s.room.v1/room-event.schema.json", "contractVersion": { "const": "%s.room.v1" }, "title": "ThoughtKhoral room v1 envelope"}\n' \
  "$legacy_id" "$legacy_id" "$legacy_id" "$legacy_id" "$legacy_id" \
  >"$fixture_root/thought-khoral-contracts/schemas/envelope.schema.json"
if ! schema_fields_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: coexisting schema compatibility fields were rejected\n%s\n' "$schema_fields_output" >&2
  review_failures=$((review_failures + 1))
fi
rm "$fixture_root/thought-khoral-contracts/schemas/envelope.schema.json"

printf '{"name": "@%s/contracts"}\n' "$legacy_id" \
  >"$fixture_root/thought-khoral-contracts/package.json"
if package_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: active legacy package metadata in the live contracts project was accepted\n%s\n' \
    "$package_output" >&2
  review_failures=$((review_failures + 1))
fi
if ! printf '%s\n' "$package_output" | grep -Fq 'thought-khoral-contracts/package.json'; then
  printf 'FAIL: package-metadata rejection did not identify live package.json\n%s\n' \
    "$package_output" >&2
  review_failures=$((review_failures + 1))
fi
rm "$fixture_root/thought-khoral-contracts/package.json"

printf '# %s room protocol v1\n' "$legacy_display_upper" \
  >"$fixture_root/thought-khoral-contracts/protocol.md"
if heading_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: an active legacy display heading in live protocol documentation was accepted\n%s\n' \
    "$heading_output" >&2
  review_failures=$((review_failures + 1))
fi
if ! printf '%s\n' "$heading_output" | grep -Fq 'thought-khoral-contracts/protocol.md'; then
  printf 'FAIL: display-heading rejection did not identify live protocol.md\n%s\n' \
    "$heading_output" >&2
  review_failures=$((review_failures + 1))
fi
rm "$fixture_root/thought-khoral-contracts/protocol.md"

mkdir -p "$fixture_root/thought-khoral-contracts/schemas"
printf '{"title": "%s room v1 application envelope"}\n' "$legacy_display_upper" \
  >"$fixture_root/thought-khoral-contracts/schemas/envelope.schema.json"
if schema_title_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: active legacy display metadata in a live contract schema was accepted\n%s\n' \
    "$schema_title_output" >&2
  review_failures=$((review_failures + 1))
fi
if ! printf '%s\n' "$schema_title_output" | grep -Fq 'thought-khoral-contracts/schemas/envelope.schema.json'; then
  printf 'FAIL: display-metadata rejection did not identify the live schema\n%s\n' \
    "$schema_title_output" >&2
  review_failures=$((review_failures + 1))
fi
rm "$fixture_root/thought-khoral-contracts/schemas/envelope.schema.json"

mkdir -p "$fixture_root/thought-khoral-room-gateway"
printf 'image: %s.room.v1 gateway\n' "$legacy_id" \
  >"$fixture_root/thought-khoral-room-gateway/README.md"
if gateway_readme_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: a runtime image declaration in the gateway README was accepted\n%s\n' \
    "$gateway_readme_output" >&2
  review_failures=$((review_failures + 1))
fi
if ! printf '%s\n' "$gateway_readme_output" | grep -Fq 'thought-khoral-room-gateway/README.md'; then
  printf 'FAIL: image-identity rejection did not identify the gateway README\n%s\n' \
    "$gateway_readme_output" >&2
  review_failures=$((review_failures + 1))
fi
rm "$fixture_root/thought-khoral-room-gateway/README.md"

printf 'Legacy `%s_*` configuration aliases are intentionally not accepted: a missed\nThe vendored `%s.room.v1` contract, its immutable `%s-room-v1.0.2` release\ntag, JSON Schema identifiers, the existing `%s_role` JWT claim, and the\n' \
  "$legacy_upper" "$legacy_id" "$legacy_id" "$legacy_id" \
  >"$fixture_root/thought-khoral-room-gateway/README.md"

archive_root="$fixture_root/thought-khoral-room-gateway/contracts/$legacy_id.room.v1"
mkdir -p "$archive_root/schemas"
printf '{"name": "@%s/contracts"}\n' "$legacy_id" >"$archive_root/package.json"
printf '# %s room protocol v1\n' "$legacy_display_upper" >"$archive_root/protocol.md"
printf '{"title": "%s room v1 application envelope"}\n' "$legacy_display_upper" \
  >"$archive_root/schemas/envelope.schema.json"
if ! archive_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: immutable vendored contract archive identity was rejected\n%s\n' \
    "$archive_output" >&2
  review_failures=$((review_failures + 1))
fi

mkdir -p "$fixture_root/test-bin"
ln -s "$(command -v dirname)" "$fixture_root/test-bin/dirname"
if missing_rg_output=$(PATH="$fixture_root/test-bin" /bin/bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: the validator passed when ripgrep was unavailable\n%s\n' "$missing_rg_output" >&2
  review_failures=$((review_failures + 1))
fi
if printf '%s\n' "$missing_rg_output" | grep -Fq 'PASS:'; then
  printf 'FAIL: the validator printed PASS after the scanner command failed\n%s\n' \
    "$missing_rg_output" >&2
  review_failures=$((review_failures + 1))
fi

printf '#!/bin/sh\nexit 2\n' >"$fixture_root/test-bin/rg"
chmod +x "$fixture_root/test-bin/rg"
if failed_rg_output=$(PATH="$fixture_root/test-bin" /bin/bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: the validator passed when ripgrep returned status 2\n%s\n' \
    "$failed_rg_output" >&2
  review_failures=$((review_failures + 1))
fi
if printf '%s\n' "$failed_rg_output" | grep -Fq 'PASS:'; then
  printf 'FAIL: the validator printed PASS after ripgrep returned status 2\n%s\n' \
    "$failed_rg_output" >&2
  review_failures=$((review_failures + 1))
fi
rm "$fixture_root/test-bin/rg"

mkdir -p "$fixture_root/thought-khoral-platform/scripts"
printf 'podman run %s-room-gateway\n' "$legacy_id" \
  >"$fixture_root/thought-khoral-platform/scripts/smoke.sh"
if smoke_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: an active runtime name in the platform smoke validator was accepted\n%s\n' \
    "$smoke_output" >&2
  review_failures=$((review_failures + 1))
fi
if ! printf '%s\n' "$smoke_output" | grep -Fq 'thought-khoral-platform/scripts/smoke.sh'; then
  printf 'FAIL: runtime-name rejection did not identify the platform smoke validator\n%s\n' \
    "$smoke_output" >&2
  review_failures=$((review_failures + 1))
fi
rm "$fixture_root/thought-khoral-platform/scripts/smoke.sh"

printf 'image: %s.room.v1\n' "$legacy_id" >"$fixture_root/thought-khoral-platform/compose.yaml"
if compose_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: a wire value used as a Compose image identity was accepted\n%s\n' \
    "$compose_output" >&2
  review_failures=$((review_failures + 1))
fi
if ! printf '%s\n' "$compose_output" | grep -Fq 'thought-khoral-platform/compose.yaml'; then
  printf 'FAIL: image-identity rejection did not identify the Compose file\n%s\n' \
    "$compose_output" >&2
  review_failures=$((review_failures + 1))
fi
rm "$fixture_root/thought-khoral-platform/compose.yaml"

printf 'image: %s.room.v1 gateway\n' "$legacy_id" \
  >"$fixture_root/thought-khoral-platform/README.md"
if readme_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: a runtime image declaration in the platform README was accepted\n%s\n' \
    "$readme_output" >&2
  review_failures=$((review_failures + 1))
fi
if ! printf '%s\n' "$readme_output" | grep -Fq 'thought-khoral-platform/README.md'; then
  printf 'FAIL: image-identity rejection did not identify the platform README\n%s\n' \
    "$readme_output" >&2
  review_failures=$((review_failures + 1))
fi
rm "$fixture_root/thought-khoral-platform/README.md"

printf '`%s.room.v1` protocol, PostgreSQL database and role `%s`, physical\n`%s_postgres-data` volume, development-only persisted credential values\n`%s-dev-only` and `%s-admin-dev-only`, and `%s_role` OIDC claim remain\n' \
  "$legacy_id" "$legacy_id" "$legacy_id" "$legacy_id" "$legacy_id" "$legacy_id" \
  >"$fixture_root/thought-khoral-platform/README.md"
if ! declared_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: the platform README compatibility declaration was rejected\n%s\n' \
    "$declared_output" >&2
  review_failures=$((review_failures + 1))
fi

if (( review_failures > 0 )); then
  exit 1
fi

# Only the exact retained field in the two new profile projections is allowed.
profile_fixtures="$fixture_root/thought-khoral-contracts/fixtures/agent-conversation-v1/valid"
mkdir -p "$profile_fixtures"
for name in ordinary-human-message ordinary-codex-message; do
  printf '{\n  "contractVersion": "%s.room.v1",\n  "text": "Synthetic public message."\n}\n' "$legacy_id" >"$profile_fixtures/$name.json"
done
if ! profile_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: public conversation projections must retain the exact room wire field\n%s\n' "$profile_output" >&2
  exit 1
fi
printf '{\n  "contractVersion": "%s.room.v1",\n  "text": "%s"\n}\n' "$legacy_id" "$legacy_id" >"$profile_fixtures/ordinary-codex-message.json"
if bash "$validator" "$fixture_root" >/dev/null 2>&1; then
  printf 'FAIL: compatibility projection admitted a legacy text identity\n' >&2
  exit 1
fi
printf '{\n  "contractVersion": "%s.room.v1",\n  "text": "Synthetic public message."\n}\n' "$legacy_id" >"$profile_fixtures/ordinary-codex-message.json"
printf '{\n  "contractVersion": "%s.room.v1",\n  "text": "Synthetic public message."\n}\n' "$legacy_id" >"$profile_fixtures/unapproved-message.json"
if bash "$validator" "$fixture_root" >/dev/null 2>&1; then
  printf 'FAIL: a neighboring unenumerated profile fixture was admitted\n' >&2
  exit 1
fi
rm "$profile_fixtures/unapproved-message.json"

# The consumer pin has the same two immutable projections, with no wildcard exception.
gateway_profile="$fixture_root/thought-khoral-room-gateway/contracts/agent-conversation-v1/fixtures/valid"
mkdir -p "$gateway_profile"
for name in ordinary-human-message ordinary-codex-message; do
  cp "$profile_fixtures/$name.json" "$gateway_profile/$name.json"
done
if ! consumer_output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: the pinned consumer projections must retain their exact wire field\n%s\n' "$consumer_output" >&2
  exit 1
fi
printf '{\n  "contractVersion": "%s.room.v1",\n  "text": "%s"\n}\n' "$legacy_id" "$legacy_id" >"$gateway_profile/ordinary-codex-message.json"
if bash "$validator" "$fixture_root" >/dev/null 2>&1; then
  printf 'FAIL: the consumer pin admitted a legacy text identity\n' >&2
  exit 1
fi
cp "$profile_fixtures/ordinary-codex-message.json" "$gateway_profile/ordinary-codex-message.json"
cp "$profile_fixtures/ordinary-codex-message.json" "$gateway_profile/unapproved-message.json"
if bash "$validator" "$fixture_root" >/dev/null 2>&1; then
  printf 'FAIL: an unenumerated consumer profile fixture was admitted\n' >&2
  exit 1
fi
rm "$gateway_profile/unapproved-message.json"

printf 'PASS: ThoughtKhoral stale-identity validator regression checks\n'
