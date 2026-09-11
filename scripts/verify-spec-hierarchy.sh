#!/usr/bin/env bash

set -u

workspace_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
root_readme="$workspace_root/.ai/specs/README.md"
projects=(
  n2n-contracts
  n2n-room-gateway
  n2n-workspace-ui
  n2n-platform
)
failed=0

for project in "${projects[@]}"; do
  specs_dir="$workspace_root/$project/.ai/specs"

  for directory in what how decisions; do
    if [[ ! -d "$specs_dir/$directory" ]]; then
      printf '%s: missing specification directory %s\n' "$project" ".ai/specs/$directory" >&2
      failed=1
    fi
  done

  readme="$specs_dir/README.md"
  if [[ ! -f "$readme" ]]; then
    printf '%s: missing specification README .ai/specs/README.md\n' "$project" >&2
    failed=1
  else
    parent_link_found=0
    while IFS= read -r target; do
      target_path=${target%% *}
      target_directory=$(cd "$(dirname "$readme")/$(dirname "$target_path")" 2>/dev/null && pwd -P) || continue
      if [[ "$target_directory/$(basename "$target_path")" == "$root_readme" ]]; then
        parent_link_found=1
        break
      fi
    done < <(sed -nE 's/.*\]\(([^ )]+)( [^)]*)?\).*/\1/p' "$readme")

    if [[ "$parent_link_found" -eq 0 ]]; then
    printf '%s: local specification README must link to the root .ai/specs/README.md\n' "$project" >&2
    failed=1
    fi
  fi
done

exit "$failed"
