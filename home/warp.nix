{ config, ... }:

let
  repo = "${config.home.homeDirectory}/ghq/github.com/nwiizo/dotfiles";
  liveLink = path: config.lib.file.mkOutOfStoreSymlink "${repo}/${path}";
in
{
  # Warp config lives at ~/.warp/, not ~/.config/warp/. Use home.file.
  # ~/.warp/settings.toml is left alone — Warp writes back to it.
  home.file.".warp/keybindings.yaml".source = liveLink "warp/keybindings.yaml";
  home.file.".warp/themes/custom.yaml".source = liveLink "warp/themes/custom.yaml";
}
