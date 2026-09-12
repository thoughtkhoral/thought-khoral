#!/usr/bin/env bash

set -u

workspace_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
root_readme="$workspace_root/.ai/specs/README.md"
projects=(
  thought-khoral-contracts
  thought-khoral-room-gateway
  thought-khoral-workspace-ui
  thought-khoral-memory-engine
  thought-khoral-agent-gateway
  thought-khoral-platform
)
legacy_projects=(
  n2n-contracts
  n2n-room-gateway
  n2n-workspace-ui
  n2n-memory-engine
  n2n-agent-gateway
  n2n-platform
)
failed=0

for index in "${!projects[@]}"; do
  project=${projects[$index]}
  legacy_project=${legacy_projects[$index]}

  if [[ -d "$workspace_root/$legacy_project" ]]; then
    printf '%s: legacy project directory must be renamed to %s\n' "$legacy_project" "$project" >&2
    failed=1
  elif [[ ! -d "$workspace_root/$project" ]]; then
    printf '%s: missing ThoughtKhoral project directory\n' "$project" >&2
    failed=1
  fi
done

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

  if git -C "$workspace_root" ls-files --error-unmatch "$project" >/dev/null 2>&1 ||
    [[ -n $(git -C "$workspace_root" ls-files "$project/") ]]; then
    printf '%s: child repository paths must not be tracked by root Git\n' "$project" >&2
    failed=1
  fi
done

exit "$failed"
