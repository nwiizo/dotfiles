{ pkgs, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
      style = "changes,header";
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
    hyperfine
    jq
    tokei
    tree
    yq-go
  ];
}
