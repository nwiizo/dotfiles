#!/usr/bin/env bash
set -euo pipefail

claude_settings_path="${CLAUDE_SETTINGS_PATH:-$HOME/.claude/settings.json}"
codex_config_path="${CODEX_CONFIG_PATH:-$HOME/.codex/config.toml}"
ai_backup_root="${DOTFILES_AI_BACKUP_ROOT:-$HOME/.dotfiles-link-backups/ai-notifications-$(date +%Y%m%d%H%M%S)}"
notification_hook='~/.local/bin/ghostty-claude-notification'
legacy_notification_hook='~/.local/bin/ghostty-notification-bell'

claude_existed=false
codex_existed=false
[[ -e "$claude_settings_path" ]] && claude_existed=true
[[ -e "$codex_config_path" ]] && codex_existed=true

mkdir -p "$(dirname "$claude_settings_path")" "$(dirname "$codex_config_path")"

if [[ ! -e "$claude_settings_path" ]]; then
  (umask 077 && printf '{}\n' > "$claude_settings_path")
fi

if [[ ! -e "$codex_config_path" ]]; then
  (umask 077 && : > "$codex_config_path")
fi

claude_tmp="$(mktemp "${claude_settings_path}.tmp.XXXXXX")"
codex_tmp="$(mktemp "${codex_config_path}.tmp.XXXXXX")"

cleanup() {
  rm -f "$claude_tmp" "$codex_tmp"
}
trap cleanup EXIT

backup_if_changed() {
  local source="$1"
  local existed="$2"

  [[ "$existed" == true ]] || return 0
  local backup="$ai_backup_root$source"
  mkdir -p "$(dirname "$backup")"
  cp -p "$source" "$backup"
}

jq \
  --arg hook_command "$notification_hook" \
  --arg legacy_hook_command "$legacy_notification_hook" '
  .preferredNotifChannel = "terminal_bell"
  | .hooks = (.hooks // {})
  | (
      (.hooks.Notification // [])
      | map(
          .hooks = [
            (.hooks // [])[]
            | select(.command != $legacy_hook_command)
          ]
        )
      | map(select((.hooks | length) > 0))
    ) as $existing
  | .hooks.Notification = (
      if any(
        $existing[]?;
        any(.hooks[]?; .type == "command" and .command == $hook_command)
      )
      then $existing
      else $existing + [
        {
          "hooks": [
            {
              "type": "command",
              "command": $hook_command
            }
          ]
        }
      ]
      end
    )
' "$claude_settings_path" > "$claude_tmp"

if cmp -s "$claude_settings_path" "$claude_tmp"; then
  printf 'Claude Code notifications already current: %s\n' "$claude_settings_path"
else
  backup_if_changed "$claude_settings_path" "$claude_existed"
  chmod "$(stat -f '%Lp' "$claude_settings_path")" "$claude_tmp"
  mv "$claude_tmp" "$claude_settings_path"
  printf 'Updated Claude Code notifications: %s\n' "$claude_settings_path"
fi

awk '
  function emit_notification_settings() {
    print "notifications = [\"agent-turn-complete\", \"approval-requested\"]"
    print "notification_method = \"osc9\""
    print "notification_condition = \"unfocused\""
  }

  BEGIN {
    in_tui = 0
    saw_tui = 0
  }

  /^\[tui\][[:space:]]*$/ {
    print
    emit_notification_settings()
    in_tui = 1
    saw_tui = 1
    next
  }

  /^\[/ {
    in_tui = 0
    if (!saw_tui && /^\[tui\./) {
      print "[tui]"
      emit_notification_settings()
      print ""
      saw_tui = 1
    }
  }

  in_tui && /^[[:space:]]*(notifications|notification_method|notification_condition)[[:space:]]*=/ {
    next
  }

  { print }

  END {
    if (!saw_tui) {
      if (NR > 0) print ""
      print "[tui]"
      emit_notification_settings()
    }
  }
' "$codex_config_path" > "$codex_tmp"

if cmp -s "$codex_config_path" "$codex_tmp"; then
  printf 'Codex notifications already current: %s\n' "$codex_config_path"
else
  backup_if_changed "$codex_config_path" "$codex_existed"
  chmod "$(stat -f '%Lp' "$codex_config_path")" "$codex_tmp"
  mv "$codex_tmp" "$codex_config_path"
  printf 'Updated Codex notifications: %s\n' "$codex_config_path"
fi
