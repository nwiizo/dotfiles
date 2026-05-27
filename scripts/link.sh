#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
backup_suffix="pre-nix-removal-$(date +%Y%m%d%H%M%S)"

backup_if_needed() {
  local target="$1"

  if [[ -e "$target" && ! -L "$target" ]]; then
    mv "$target" "$target.$backup_suffix"
  elif [[ -L "$target" ]]; then
    rm -f "$target"
  fi
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

remove_nix_store_symlinks() {
  local dir="$1"

  [[ -d "$dir" ]] || return 0

  while IFS= read -r link; do
    local dest
    dest="$(readlink "$link" || true)"
    case "$dest" in
      /nix/store/*) rm -f "$link" ;;
    esac
  done < <(find "$dir" -type l -print)
}

remove_nix_store_symlinks "$HOME/.config/fish/conf.d"
remove_nix_store_symlinks "$HOME/.config/fish/functions"
remove_nix_store_symlinks "$HOME/.config/atuin"
remove_nix_store_symlinks "$HOME/.config/bat"
remove_nix_store_symlinks "$HOME/.config/gh"
remove_nix_store_symlinks "$HOME/.config/git"
remove_nix_store_symlinks "$HOME/.config/ghostty"
remove_nix_store_symlinks "$HOME/.config/tealdeer"
remove_nix_store_symlinks "$HOME/.warp"

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

echo "Linked dotfiles from $repo"
