#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
herdr_test_dir="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-herdr-integrations.XXXXXX")"
trap 'rm -rf -- "$herdr_test_dir"' EXIT
herdr_test_home="$herdr_test_dir/home"
mkdir -p "$herdr_test_home/.claude" "$herdr_test_home/.codex"

cat >"$herdr_test_home/.claude/settings.json" <<'JSON'
{
  "env": {"DOTFILES_FIXTURE": "preserved"},
  "hooks": {
    "Notification": [{"hooks": [{"type": "command", "command": "fixture-notification"}]}],
    "SessionStart": [{"hooks": [{"type": "command", "command": "fixture-session-start"}]}]
  }
}
JSON
cat >"$herdr_test_home/.codex/config.toml" <<'TOML'
model = "fixture-model"
[tui]
notifications = ["agent-turn-complete", "approval-requested"]
notification_method = "osc9"
notification_condition = "unfocused"
TOML
cat >"$herdr_test_home/.codex/hooks.json" <<'JSON'
{"hooks":{"SessionStart":[{"hooks":[{"type":"command","command":"fixture-codex-start"}]}]}}
JSON

run_isolated() {
  env -u CLAUDE_CONFIG_DIR -u CODEX_HOME -u CLAUDE_SETTINGS_PATH -u CODEX_CONFIG_PATH \
    -u DOTFILES_AI_BACKUP_ROOT \
    HOME="$herdr_test_home" \
    XDG_CONFIG_HOME="$herdr_test_home/.config" \
    XDG_DATA_HOME="$herdr_test_home/.local/share" \
    XDG_STATE_HOME="$herdr_test_home/.local/state" \
    XDG_CACHE_HOME="$herdr_test_home/.cache" \
    HERDR_CONFIG_PATH="$herdr_test_home/.config/herdr/config.toml" \
    "$@"
}

run_isolated bash "$repo/scripts/apply-ghostty-ai-notifications.sh"
run_isolated bash "$repo/scripts/install-herdr.sh" --integrations-only

jq -e '
  .env.DOTFILES_FIXTURE == "preserved" and
  .preferredNotifChannel == "terminal_bell" and
  ([.hooks.Notification[].hooks[].command] | index("fixture-notification") != null) and
  ([.hooks.Notification[].hooks[].command] | index("~/.local/bin/ghostty-claude-notification") != null) and
  ([.hooks.SessionStart[].hooks[].command] | index("fixture-session-start") != null) and
  ([.hooks.SessionStart[].hooks[].command] | any(contains("herdr-agent-state")))
' "$herdr_test_home/.claude/settings.json" >/dev/null
jq -e '
  ([.hooks.SessionStart[].hooks[].command] | index("fixture-codex-start") != null) and
  ([.hooks.SessionStart[].hooks[].command] | any(contains("herdr-agent-state")))
' "$herdr_test_home/.codex/hooks.json" >/dev/null
yq -p toml -o json '.' "$herdr_test_home/.codex/config.toml" | jq -e '
  .model == "fixture-model" and
  .tui.notification_method == "osc9" and
  .tui.notification_condition == "unfocused" and
  .tui.notifications == ["agent-turn-complete", "approval-requested"]
' >/dev/null
echo "PASS: Herdr preserves Ghostty notifications and unrelated client settings"

cp "$herdr_test_home/.claude/settings.json" "$herdr_test_dir/claude-settings.json"
cp "$herdr_test_home/.codex/hooks.json" "$herdr_test_dir/codex-hooks.json"
cp "$herdr_test_home/.codex/config.toml" "$herdr_test_dir/codex-config.toml"
run_isolated bash "$repo/scripts/install-herdr.sh" --integrations-only
run_isolated bash "$repo/scripts/apply-ghostty-ai-notifications.sh"
cmp "$herdr_test_dir/claude-settings.json" "$herdr_test_home/.claude/settings.json"
cmp "$herdr_test_dir/codex-hooks.json" "$herdr_test_home/.codex/hooks.json"
cmp "$herdr_test_dir/codex-config.toml" "$herdr_test_home/.codex/config.toml"
echo "PASS: repeated Herdr and Ghostty installation keeps settings unchanged"
