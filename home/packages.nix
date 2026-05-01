{ pkgs, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
      style = "changes,header";
    };
  };

  programs.tealdeer = {
    enable = true;
    settings = {
      display.compact = true;
      updates.auto_update = true;
    };
  };

  home.packages = with pkgs; [
    # Nix language tooling
    nil
    nixfmt
    statix

    # Modern CLI replacements
    eza
    fd
    fzf
    ripgrep

    # Git ecosystem (programs.git/gh/delta/lazygit live in home/git.nix)
    ghq

    # General utilities
    dust
    hyperfine
    jq
    tokei
    tree
    yq-go
  ];
}
