#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
validator="$repo_root/scripts/verify-repository-references.sh"
fixture_root=$(mktemp -d "${TMPDIR:-/tmp}/thought-khoral-references-test.XXXXXX")
trap 'rm -rf "$fixture_root"' EXIT

mkdir -p \
  "$fixture_root/thought-khoral-contracts" \
  "$fixture_root/thought-khoral-room-gateway/contracts/n2n.room.v1/.ai/specs" \
  "$fixture_root/thought-khoral-platform"

cat >"$fixture_root/thought-khoral-contracts/protocol.md" <<'EOF'
See the [root decision](https://github.com/thoughtkhoral/thought-khoral/blob/main/.ai/specs/decisions/002-browser-websocket-authentication.md).
EOF
cat >"$fixture_root/thought-khoral-room-gateway/contracts/lock.json" <<'EOF'
{"source":"https://github.com/thoughtkhoral/thought-khoral-contracts","commit":"abc"}
EOF
cat >"$fixture_root/thought-khoral-room-gateway/contracts/n2n.room.v1/.ai/specs/README.md" <<'EOF'
See the [root specification index](https://github.com/thoughtkhoral/thought-khoral/blob/main/.ai/specs/README.md).
EOF
cat >"$fixture_root/thought-khoral-platform/README.md" <<'EOF'
The source repositories are [the gateway](https://github.com/thoughtkhoral/thought-khoral-room-gateway)
and [the UI](https://github.com/thoughtkhoral/thought-khoral-workspace-ui).
EOF

if ! bash "$validator" "$fixture_root"; then
  printf 'FAIL: valid repository references were rejected\n' >&2
  exit 1
fi

printf '%s\n' 'See [the root decision](../.ai/specs/decisions/002-browser-websocket-authentication.md).' \
  >"$fixture_root/thought-khoral-contracts/protocol.md"
if output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: a relative cross-repository specification link was accepted\n%s\n' "$output" >&2
  exit 1
fi
printf '%s\n' "$output" | grep -Fq 'protocol.md' || {
  printf 'FAIL: relative-link rejection did not identify protocol.md\n%s\n' "$output" >&2
  exit 1
}

printf '%s\n' '{"source":"../n2n-contracts"}' \
  >"$fixture_root/thought-khoral-room-gateway/contracts/lock.json"
if output=$(bash "$validator" "$fixture_root" 2>&1); then
  printf 'FAIL: a relative contract source was accepted\n%s\n' "$output" >&2
  exit 1
fi
printf '%s\n' "$output" | grep -Fq 'contracts/lock.json' || {
  printf 'FAIL: contract-source rejection did not identify lock.json\n%s\n' "$output" >&2
  exit 1
}

printf 'repository-reference checks passed\n'

# Local links are permitted; only escaping specification targets are rejected.
checker=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/verify-repository-references.sh
python3 - "$checker" <<'TEST_LINKS'
from pathlib import Path
import subprocess
import sys
import tempfile

checker = Path(sys.argv[1])
with tempfile.TemporaryDirectory(prefix="thought-khoral-reference-check-") as temporary:
    root = Path(temporary)
    child = root / "thought-khoral-codex-agent"
    (child / "docs").mkdir(parents=True)
    (child / ".ai/specs").mkdir(parents=True)
    (root / ".ai/specs").mkdir(parents=True)
    (root / "thought-khoral-contracts/.ai/specs").mkdir(parents=True)
    doc = child / "docs/guide.md"
    cases = [
        ("[local](../.ai/specs/README.md)", True),
        ("[root](../../.ai/specs/README.md)", False),
        ("[sibling](../../thought-khoral-contracts/.ai/specs/README.md)", False),
        ("[public](https://github.com/thoughtkhoral/thought-khoral/blob/main/.ai/specs/README.md)", True),
    ]
    for text, accepted in cases:
        doc.write_text(text + "\n")
        result = subprocess.run(["bash", str(checker), str(root)], capture_output=True, text=True)
        assert (result.returncode == 0) == accepted, (text, result.stdout, result.stderr)
print("repository-reference regression checks passed (4 cases)")
TEST_LINKS
