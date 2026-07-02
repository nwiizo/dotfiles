#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo"

fail=0

check_link() {
  local path="$1"
  local expected="$2"

  if [[ ! -L "$path" ]]; then
    echo "not a symlink: $path" >&2
    fail=1
    return
  fi

  local actual
  actual="$(readlink "$path")"
  if [[ "$actual" != "$expected" ]]; then
    echo "wrong symlink: $path -> $actual (expected $expected)" >&2
    fail=1
  fi

  if [[ ! -e "$path" ]]; then
    echo "broken symlink: $path -> $actual" >&2
    fail=1
  fi
}

check_link ".claude/agents" "../.agents/agents"
check_link ".claude/rules" "../.agents/rules"
check_link ".claude/skills" "../.agents/skills"
check_link ".codex/agents" "../.agents/codex/agents"

if find .agents .claude .codex -name __pycache__ -o -name '*.pyc' -o -name '.DS_Store' | grep -q .; then
  echo "generated files found under agent config" >&2
  fail=1
fi

if rg -n -i '(^|[^a-z])nix([^a-z]|$)|home manager|home-manager|nix-darwin|/nix/store|flake\.nix|\.nix|add-nix-config' \
  README.md AGENTS.md CLAUDE.md .agents .claude .codex scripts fish/config.fish archive \
  --glob '!scripts/audit-agent-config.sh' >/tmp/dotfiles-agent-audit-nix.txt; then
  echo "removed package-manager references found:" >&2
  cat /tmp/dotfiles-agent-audit-nix.txt >&2
  fail=1
fi

if command -v git-secrets >/dev/null 2>&1; then
  git-secrets --scan
fi

if command -v python3 >/dev/null 2>&1; then
  python3 - <<'PY'
import pathlib, tomllib
for path in pathlib.Path(".agents/codex/agents").glob("*.toml"):
    tomllib.loads(path.read_text())
PY
fi

if [[ "$fail" -ne 0 ]]; then
  exit "$fail"
fi

echo "agent-config-audit-ok"
