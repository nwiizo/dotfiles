{ pkgs, config, ... }:

{
  imports = [
    ./fish.nix
    ./git.nix
    ./neovim.nix
    ./packages.nix
  ];

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/ghq/github.com/nwiizo/dotfiles";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    KUBE_EDITOR = "nvim";

    GOPATH = "${config.home.homeDirectory}/gopath";
    GOPROXY = "direct";
    GOSUMDB = "off";

    DOCKER_BUILDKIT = "1";
    COMPOSE_DOCKER_CLI_BUILD = "1";

    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
    KUBECONFIG = "${config.home.homeDirectory}/.kube/config";

    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";

    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };

  xdg.configFile."ghostty/config".source = ../ghostty/config;

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };
}
