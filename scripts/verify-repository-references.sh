#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
scan_root=${1:-$repo_root}
scan_root=$(cd "$scan_root" && pwd)
failures=0

report() {
  printf 'FAIL: %s\n' "$1" >&2
  failures=$((failures + 1))
}

check_relative_root_links() {
  local project=$1 matches

  matches=$(rg -n --hidden \
    -g '!.git/**' \
    -g '!node_modules/**' \
    -g '!target/**' \
    -g '!dist/**' \
    '\]\((\.\./)+\.ai/' \
    "$scan_root/$project" 2>/dev/null || true)
  if [[ -n "$matches" ]]; then
    report "cross-repository relative specification links remain under $project:\n$matches"
  fi
}

for project in \
  thought-khoral-contracts \
  thought-khoral-room-gateway \
  thought-khoral-workspace-ui \
  thought-khoral-platform \
  thought-khoral-memory-engine \
  thought-khoral-agent-gateway; do
  [[ -d "$scan_root/$project" ]] || continue
  check_relative_root_links "$project"
done

lock_file="$scan_root/thought-khoral-room-gateway/contracts/lock.json"
if [[ -f "$lock_file" ]]; then
  contract_source=$(sed -nE 's/.*"source"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' "$lock_file")
  if [[ "$contract_source" != \
    'https://github.com/thoughtkhoral/thought-khoral-contracts' ]]; then
    report "gateway contract lock must identify the GitHub source repository: $lock_file"
  fi
fi

if [[ "$failures" -ne 0 ]]; then
  exit 1
fi

printf 'repository-reference checks passed\n'
