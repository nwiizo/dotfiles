#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
backup_suffix="pre-dotfiles-link-$(date +%Y%m%d%H%M%S)"
backup_root="$HOME/.dotfiles-link-backups/$backup_suffix"
backup_created=false

report_link_error() {
  local status="$?"
  if [[ "$backup_created" == true ]]; then
    echo "Linking failed; conflicting paths were moved to $backup_root" >&2
  fi
  exit "$status"
}
trap report_link_error ERR

backup_if_needed() {
  local target="$1"

  [[ -e "$target" || -L "$target" ]] || return 0

  local backup="$backup_root$target"
  mkdir -p "$(dirname "$backup")"
  mv "$target" "$backup"
  backup_created=true
}

ensure_dir() {
  local target="$1"

  if [[ -d "$target" && ! -L "$target" ]]; then
    return 0
  fi

  backup_if_needed "$target"
  mkdir -p "$target"
}

link_path() {
  local source="$1"
  local target="$2"

  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    return 0
  fi

  mkdir -p "$(dirname "$target")"
  backup_if_needed "$target"
  ln -s "$source" "$target"
}

link_dir_children() {
  local source_dir="$1"
  local target_dir="$2"

  ensure_dir "$target_dir"
  for target in "$target_dir"/*; do
    [[ -L "$target" ]] || continue
    local dest
    dest="$(readlink "$target" || true)"
    if [[ "$dest" == "$source_dir"/* && ! -e "$dest" ]]; then
      rm -f "$target"
    fi
  done

  for source in "$source_dir"/*; do
    [[ -e "$source" ]] || continue
    link_path "$source" "$target_dir/$(basename "$source")"
  done
}

remove_managed_link() {
  local target="$1"
  local expected="$2"

  if [[ -L "$target" && "$(readlink "$target")" == "$expected" ]]; then
    rm -f "$target"
  fi
}

link_path "$repo/fish/config.fish" "$HOME/.config/fish/config.fish"
link_dir_children "$repo/fish/conf.d" "$HOME/.config/fish/conf.d"
link_dir_children "$repo/fish/functions" "$HOME/.config/fish/functions"

link_path "$repo/nvim" "$HOME/.config/nvim"
link_path "$repo/ghostty/config" "$HOME/.config/ghostty/config"
link_path "$repo/gpane/config.yaml" "$HOME/.config/gpane/config.yaml"
link_path "$repo/bat/config" "$HOME/.config/bat/config"
link_path "$repo/atuin/config.toml" "$HOME/.config/atuin/config.toml"
link_path "$repo/tealdeer/config.toml" "$HOME/.config/tealdeer/config.toml"
link_path "$repo/git/config" "$HOME/.config/git/config"
link_path "$repo/gh/config.yml" "$HOME/.config/gh/config.yml"
link_path "$repo/git/power_pull.sh" "$HOME/.local/bin/power_pull"
chmod +x "$HOME/.local/bin/power_pull"

if command -v brew >/dev/null 2>&1; then
  brew_prefix="$(brew --prefix)"
  docker_compose_plugin="$brew_prefix/lib/docker/cli-plugins/docker-compose"
  docker_compose_target="$HOME/.docker/cli-plugins/docker-compose"
  if [[ -e "$docker_compose_plugin" ]]; then
    link_path "$docker_compose_plugin" "$docker_compose_target"
  else
    remove_managed_link "$docker_compose_target" "$docker_compose_plugin"
    echo "Docker Compose plugin not found at $docker_compose_plugin; run brew bundle --file $repo/Brewfile" >&2
  fi
fi

remove_managed_link "$HOME/.local/bin/ghostty-notification-bell" "$repo/ghostty/notification-bell.sh"
link_path "$repo/ghostty/claude-notification.sh" "$HOME/.local/bin/ghostty-claude-notification"
chmod +x "$HOME/.local/bin/ghostty-claude-notification"

link_path "$repo/warp/keybindings.yaml" "$HOME/.warp/keybindings.yaml"
link_path "$repo/warp/themes/custom.yaml" "$HOME/.warp/themes/custom.yaml"
link_path "$repo/warp/themes/catppuccin-mocha.yaml" "$HOME/.warp/themes/catppuccin-mocha.yaml"

for workflow_file in "$repo"/warp/workflows/*.yaml; do
  link_path "$workflow_file" "$HOME/.warp/workflows/$(basename "$workflow_file")"
done

nippo_skill="$HOME/ghq/github.com/nwiizo/nippo/.claude/skills/nippo"

link_path "$repo/.agents/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link_path "$repo/.agents/RTK.md" "$HOME/.claude/RTK.md"
link_path "$repo/.agents/claudeignore" "$HOME/.claude/.claudeignore"
link_path "$repo/.agents/agents" "$HOME/.claude/agents"
link_path "$repo/.agents/docs" "$HOME/.claude/docs"
link_path "$repo/.agents/rules" "$HOME/.claude/rules"
link_dir_children "$repo/.agents/skills" "$HOME/.claude/skills"
[[ -d "$nippo_skill" ]] && link_path "$nippo_skill" "$HOME/.claude/skills/nippo"

# ~/.agents is the cross-client Agent Skills location. Product-specific
# agents, rules, and docs stay under ~/.claude or ~/.codex.
remove_managed_link "$HOME/.agents/agents" "$repo/.agents/agents"
remove_managed_link "$HOME/.agents/docs" "$repo/.agents/docs"
remove_managed_link "$HOME/.agents/rules" "$repo/.agents/rules"
link_dir_children "$repo/.agents/skills" "$HOME/.agents/skills"
[[ -d "$nippo_skill" ]] && link_path "$nippo_skill" "$HOME/.agents/skills/nippo"

link_dir_children "$repo/.agents/codex/agents" "$HOME/.codex/agents"

"$repo/scripts/apply-ghostty-ai-notifications.sh"

echo "Linked dotfiles from $repo"
if [[ "$backup_created" == true ]]; then
  echo "Backed up conflicting paths under $backup_root"
fi
