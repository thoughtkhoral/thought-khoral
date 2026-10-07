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
  local project=$1
  if ! python3 - "$scan_root/$project" <<'CHECK_LINKS'
import os
from pathlib import Path
import re
import sys
from urllib.parse import unquote, urlsplit

project = Path(sys.argv[1]).resolve()
failures = []
for directory, directories, files in os.walk(project):
    directories[:] = [name for name in directories if name not in
                      {".git", "node_modules", "target", "dist", ".codex", "sessions"}]
    for name in files:
        if not name.endswith(".md"):
            continue
        path = Path(directory) / name
        for number, line in enumerate(path.read_text().splitlines(), 1):
            for raw in re.findall(r"\]\(([^)]+)\)", line):
                target = raw.split(">", 1)[0][1:] if raw.startswith("<") else raw.split(" ", 1)[0]
                parsed = urlsplit(target)
                if parsed.scheme or target.startswith("//") or ".ai" not in parsed.path.split("/"):
                    continue
                destination = (path.parent / unquote(parsed.path)).resolve()
                if not destination.is_relative_to(project):
                    failures.append(f"{path}:{number}: {target}")
for failure in failures:
    print(f"cross-repository relative specification link: {failure}", file=sys.stderr)
sys.exit(bool(failures))
CHECK_LINKS
  then
    report "cross-repository relative specification links remain under $project"
  fi
}

for project in \
  thought-khoral-contracts \
  thought-khoral-room-gateway \
  thought-khoral-workspace-ui \
  thought-khoral-platform \
  thought-khoral-memory-engine \
  thought-khoral-agent-gateway \
  thought-khoral-codex-agent; do
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
