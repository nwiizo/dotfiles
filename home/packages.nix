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

    # General utilities
    hyperfine
    jq
    tokei
    tree
    yq-go
  ];
}
