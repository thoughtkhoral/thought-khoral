#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
validator="$repo_root/scripts/verify-thoughtkhoral-identity.sh"
fixture_root=$(mktemp -d "${TMPDIR:-/tmp}/thought-khoral-identity-test.XXXXXX")
trap 'rm -rf "$fixture_root"' EXIT
git init -q "$fixture_root"

legacy_id='n''2n'
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

printf 'PASS: ThoughtKhoral stale-identity validator regression checks\n'
