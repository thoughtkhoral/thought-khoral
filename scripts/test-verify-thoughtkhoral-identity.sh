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

review_failures=0

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

printf 'PASS: ThoughtKhoral stale-identity validator regression checks\n'
