#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
backup_suffix="pre-dotfiles-link-$(date +%Y%m%d%H%M%S)"
backup_root="$HOME/.dotfiles-link-backups/$backup_suffix"

backup_if_needed() {
  local target="$1"

  if [[ -e "$target" && ! -L "$target" ]]; then
    local backup="$backup_root$target"
    mkdir -p "$(dirname "$backup")"
    mv "$target" "$backup"
  elif [[ -L "$target" ]]; then
    rm -f "$target"
  fi
}

ensure_dir() {
  local target="$1"

  if [[ -L "$target" ]]; then
    rm -f "$target"
  elif [[ -e "$target" && ! -d "$target" ]]; then
    local backup="$backup_root$target"
    mkdir -p "$(dirname "$backup")"
    mv "$target" "$backup"
  fi
  mkdir -p "$target"
}

link_file() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"
  backup_if_needed "$target"
  ln -s "$source" "$target"
}

link_dir() {
  local source="$1"
  local target="$2"

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
    link_dir "$source" "$target_dir/$(basename "$source")"
  done
}

link_file "$repo/fish/config.fish" "$HOME/.config/fish/config.fish"
link_file "$repo/fish/conf.d/zz_sponge_compat.fish" "$HOME/.config/fish/conf.d/zz_sponge_compat.fish"

for function_file in "$repo"/fish/functions/*.fish; do
  link_file "$function_file" "$HOME/.config/fish/functions/$(basename "$function_file")"
done

link_dir "$repo/nvim" "$HOME/.config/nvim"
link_file "$repo/ghostty/config" "$HOME/.config/ghostty/config"
link_file "$repo/bat/config" "$HOME/.config/bat/config"
link_file "$repo/atuin/config.toml" "$HOME/.config/atuin/config.toml"
link_file "$repo/tealdeer/config.toml" "$HOME/.config/tealdeer/config.toml"
link_file "$repo/git/config" "$HOME/.config/git/config"
link_file "$repo/gh/config.yml" "$HOME/.config/gh/config.yml"
link_file "$repo/git/power_pull.sh" "$HOME/.local/bin/power_pull"
chmod +x "$HOME/.local/bin/power_pull"

link_file "$repo/warp/keybindings.yaml" "$HOME/.warp/keybindings.yaml"
link_file "$repo/warp/themes/custom.yaml" "$HOME/.warp/themes/custom.yaml"
link_file "$repo/warp/themes/catppuccin-mocha.yaml" "$HOME/.warp/themes/catppuccin-mocha.yaml"

for workflow_file in "$repo"/warp/workflows/*.yaml; do
  link_file "$workflow_file" "$HOME/.warp/workflows/$(basename "$workflow_file")"
done

nippo_skill="$HOME/ghq/github.com/nwiizo/nippo/.claude/skills/nippo"

link_file "$repo/.agents/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link_file "$repo/.agents/RTK.md" "$HOME/.claude/RTK.md"
link_file "$repo/.agents/claudeignore" "$HOME/.claude/.claudeignore"
link_dir "$repo/.agents/agents" "$HOME/.claude/agents"
link_dir "$repo/.agents/docs" "$HOME/.claude/docs"
link_dir "$repo/.agents/rules" "$HOME/.claude/rules"
link_dir_children "$repo/.agents/skills" "$HOME/.claude/skills"
[[ -d "$nippo_skill" ]] && link_dir "$nippo_skill" "$HOME/.claude/skills/nippo"

link_dir "$repo/.agents/agents" "$HOME/.agents/agents"
link_dir "$repo/.agents/docs" "$HOME/.agents/docs"
link_dir "$repo/.agents/rules" "$HOME/.agents/rules"
link_dir_children "$repo/.agents/skills" "$HOME/.agents/skills"
[[ -d "$nippo_skill" ]] && link_dir "$nippo_skill" "$HOME/.agents/skills/nippo"

link_dir_children "$repo/.agents/codex/agents" "$HOME/.codex/agents"

echo "Linked dotfiles from $repo"
