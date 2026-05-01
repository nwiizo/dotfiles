{ pkgs, ... }:

{
  imports = [
    ./fish.nix
  ];

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = false;
    viAlias = false;
    vimAlias = false;
  };

  home.packages = with pkgs; [
    # Nix language tooling
    nil
    nixfmt
    statix

    # Modern CLI replacements
    bat
    eza
    fd
    fzf
    ripgrep

    # Git ecosystem
    delta
    gh
    ghq
    lazygit

    # General utilities
    hyperfine
    jq
    tokei
    tree
    yq-go
  ];

  xdg.configFile."nvim".source = ./nvim;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
