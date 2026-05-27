{ config, lib, ... }:

let
  repo = "${config.home.homeDirectory}/ghq/github.com/nwiizo/dotfiles";
  liveLink = path: config.lib.file.mkOutOfStoreSymlink "${repo}/${path}";

  # Each .yaml under warp/workflows/ is symlinked to ~/.warp/workflows/.
  # Per-file (not whole-dir) so user-created workflows from Warp UI can
  # coexist as plain files alongside.
  workflowFiles = [
    "ai-context.yaml"
    "ghq-cd.yaml"
    "git-cleanup-merged.yaml"
    "hm-build-check.yaml"
    "hm-switch.yaml"
    "jj-colocate-here.yaml"
    "k8s-context-switch.yaml"
    "nvim-lazy-sync.yaml"
    "update-all.yaml"
  ];

  workflowLinks = lib.listToAttrs (
    map (f: {
      name = ".warp/workflows/${f}";
      value.source = liveLink "warp/workflows/${f}";
    }) workflowFiles
  );
in
{
  # Warp config lives at ~/.warp/, not ~/.config/warp/. Use home.file.
  # ~/.warp/settings.toml is left alone — Warp writes back to it.
  home.file = {
    ".warp/keybindings.yaml".source = liveLink "warp/keybindings.yaml";
    ".warp/themes/custom.yaml".source = liveLink "warp/themes/custom.yaml";
    ".warp/themes/catppuccin-mocha.yaml".source = liveLink "warp/themes/catppuccin-mocha.yaml";
  }
  // workflowLinks;
}
