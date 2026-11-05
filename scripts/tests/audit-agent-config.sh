#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
audit_test_dir="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-agent-audit-test.XXXXXX")"
trap 'rm -rf -- "$audit_test_dir"' EXIT
audit_test_home="$audit_test_dir/home"

mkdir -p "$audit_test_home/.claude/skills" "$audit_test_home/.agents/skills" \
  "$audit_test_home/.codex/agents"
ln -s "$repo/.agents/agents" "$audit_test_home/.claude/agents"
ln -s "$repo/.agents/CLAUDE.md" "$audit_test_home/.claude/CLAUDE.md"
ln -s "$repo/.agents/RTK.md" "$audit_test_home/.claude/RTK.md"
ln -s "$repo/.agents/claudeignore" "$audit_test_home/.claude/.claudeignore"
ln -s "$repo/.agents/RTK.md" "$audit_test_home/.codex/RTK.md"
ln -s "$repo/.agents/codex/AGENTS.md" "$audit_test_home/.codex/AGENTS.md"
for source in "$repo"/.agents/skills/*; do
  ln -s "$source" "$audit_test_home/.claude/skills/$(basename "$source")"
  ln -s "$source" "$audit_test_home/.agents/skills/$(basename "$source")"
done
for source in "$repo"/.agents/codex/agents/*.toml; do
  ln -s "$source" "$audit_test_home/.codex/agents/$(basename "$source")"
done

run_audit() {
  env HOME="$audit_test_home" \
    XDG_CONFIG_HOME="$audit_test_home/.config" \
    XDG_DATA_HOME="$audit_test_home/.local/share" \
    XDG_STATE_HOME="$audit_test_home/.local/state" \
    XDG_CACHE_HOME="$audit_test_home/.cache" \
    "$repo/scripts/audit-agent-config.sh" >"$audit_test_dir/output" 2>&1
}

if ! run_audit; then
  cat "$audit_test_dir/output" >&2
  echo "FAIL: valid managed links must pass" >&2
  exit 1
fi
echo "PASS: valid managed links"

for installation in .claude/skills .agents/skills .codex/agents; do
  case "$installation" in
    .codex/agents) source_dir="$repo/.agents/codex/agents" ;;
    *) source_dir="$repo/.agents/skills" ;;
  esac
  target="$audit_test_home/$installation/retired-audit-fixture"
  ln -s "$source_dir/retired-audit-fixture" "$target"
  if run_audit; then
    echo "FAIL: stale managed link was accepted: $installation" >&2
    exit 1
  fi
  if ! rg -Fq "retired managed link: $target" "$audit_test_dir/output"; then
    cat "$audit_test_dir/output" >&2
    echo "FAIL: stale link must have a specific diagnostic" >&2
    exit 1
  fi
  rm "$target"
  echo "PASS: stale managed link in $installation"

  ln -s "$repo/archive/agent-config/README.md" "$target"
  if run_audit; then
    echo "FAIL: archived asset was accepted: $installation" >&2
    exit 1
  fi
  if ! rg -Fq "archived asset installed: $target" "$audit_test_dir/output"; then
    cat "$audit_test_dir/output" >&2
    echo "FAIL: archived asset must have a specific diagnostic" >&2
    exit 1
  fi
  rm "$target"
  echo "PASS: archived asset in $installation"
done

mkdir -p "$audit_test_dir/external-skill"
ln -s "$audit_test_dir/external-skill" "$audit_test_home/.agents/skills/external-fixture"
ln -s "$audit_test_dir/missing-external-skill" "$audit_test_home/.claude/skills/external-fixture"
if ! run_audit; then
  cat "$audit_test_dir/output" >&2
  echo "FAIL: independently managed external links must be left to their owner" >&2
  exit 1
fi
echo "PASS: external links retain independent ownership"
