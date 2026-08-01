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

check_absent() {
  local path="$1"

  if [[ -e "$path" || -L "$path" ]]; then
    echo "obsolete agent path: $path" >&2
    fail=1
  fi
}

check_link ".claude/agents" "../.agents/agents"
check_link ".claude/rules" "../.agents/rules"
check_link ".claude/skills" "../.agents/skills"
check_link ".codex/agents" "../.agents/codex/agents"

check_link "$HOME/.claude/agents" "$repo/.agents/agents"
check_link "$HOME/.claude/docs" "$repo/.agents/docs"
check_link "$HOME/.claude/rules" "$repo/.agents/rules"

for skill in "$repo"/.agents/skills/*; do
  check_link "$HOME/.claude/skills/$(basename "$skill")" "$skill"
  check_link "$HOME/.agents/skills/$(basename "$skill")" "$skill"
done

for agent in "$repo"/.agents/codex/agents/*.toml; do
  check_link "$HOME/.codex/agents/$(basename "$agent")" "$agent"
done

for claude_agent in "$repo"/.agents/agents/*.md; do
  agent_name="$(basename "$claude_agent" .md)"
  if [[ ! -f "$repo/.agents/codex/agents/$agent_name.toml" ]]; then
    echo "missing Codex agent counterpart: $agent_name" >&2
    fail=1
  fi
done

for codex_agent in "$repo"/.agents/codex/agents/*.toml; do
  agent_name="$(basename "$codex_agent" .toml)"
  if [[ ! -f "$repo/.agents/agents/$agent_name.md" ]]; then
    echo "missing Claude Code agent counterpart: $agent_name" >&2
    fail=1
  fi
done

if ! command -v ruby >/dev/null 2>&1; then
  echo "ruby with Psych is required to validate agent YAML" >&2
  fail=1
elif ! ruby <<'RUBY'
require "yaml"

errors = []

def load_yaml_mapping(text, path, label, errors)
  metadata = YAML.safe_load(text, [], [], false) || {}
  unless metadata.is_a?(Hash)
    errors << "#{label} must be a mapping: #{path}"
    return nil
  end
  metadata
rescue StandardError => error
  errors << "invalid #{label}: #{path}: #{error.message}"
  nil
end

Dir[".agents/agents/*.md"].sort.each do |agent_file|
  agent_name = File.basename(agent_file, ".md")
  content = File.read(agent_file)
  match = content.match(/\A---\r?\n(.*?)\r?\n---\r?\n/m)

  unless match
    errors << "missing or malformed agent frontmatter: #{agent_file}"
    next
  end

  metadata =
    load_yaml_mapping(match[1], agent_file, "agent frontmatter", errors)
  next unless metadata

  unless metadata["name"] == agent_name
    errors << "agent name must match filename: #{agent_file}"
  end
  unless metadata["description"].is_a?(String) && !metadata["description"].strip.empty?
    errors << "agent description must be a non-empty string: #{agent_file}"
  end
end

Dir[".agents/skills/*/SKILL.md"].sort.each do |skill_file|
  skill_dir = File.dirname(skill_file)
  skill_name = File.basename(skill_dir)
  content = File.read(skill_file)
  match = content.match(/\A---\r?\n(.*?)\r?\n---\r?\n/m)

  unless match
    errors << "missing or malformed skill frontmatter: #{skill_file}"
    next
  end

  metadata =
    load_yaml_mapping(match[1], skill_file, "skill frontmatter", errors)
  next unless metadata

  unless metadata["name"] == skill_name
    errors << "skill name must match directory: #{skill_file}"
  end
  unless metadata["description"].is_a?(String) && !metadata["description"].strip.empty?
    errors << "skill description must be a non-empty string: #{skill_file}"
  end

  openai_file = File.join(skill_dir, "agents", "openai.yaml")
  openai_metadata = {}
  if File.file?(openai_file)
    openai_metadata =
      load_yaml_mapping(
        File.read(openai_file),
        openai_file,
        "Codex skill metadata",
        errors
      )
    next unless openai_metadata
  end

  claude_manual_only = metadata["disable-model-invocation"] == true
  policy = openai_metadata["policy"]
  codex_manual_only =
    policy.is_a?(Hash) && policy["allow_implicit_invocation"] == false
  if claude_manual_only != codex_manual_only
    errors << "manual-only policy differs between Claude Code and Codex: #{skill_dir}"
  end
end

errors.each { |error| warn(error) }
exit 1 unless errors.empty?
RUBY
then
  fail=1
fi

check_absent "$HOME/.agents/agents"
check_absent "$HOME/.agents/docs"
check_absent "$HOME/.agents/rules"

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
  if ! python3 - <<'PY'
import pathlib, tomllib

errors = []
for path in pathlib.Path(".agents/codex/agents").glob("*.toml"):
    metadata = tomllib.loads(path.read_text())
    if metadata.get("name") != path.stem:
        errors.append(f"Codex agent name must match filename: {path}")
    description = metadata.get("description")
    if not isinstance(description, str) or not description.strip():
        errors.append(f"Codex agent description must be a non-empty string: {path}")

if errors:
    raise SystemExit("\n".join(errors))
PY
  then
    fail=1
  fi
fi

if [[ "$fail" -ne 0 ]]; then
  exit "$fail"
fi

echo "agent-config-audit-ok"
