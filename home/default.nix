{ pkgs, config, ... }:

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
    withRuby = false;
    withPython3 = false;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "nwiizo";
        email = "syu.m.5151@gmail.com";
      };

      alias = {
        ac = "!git add -A && aicommits -a";
      };

      push.autoSetupRemote = true;
      credential.helper = "store";

      diff.sopsdiffer.textconv = "sops -d";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.gh = {
    enable = true;
    settings = {
      version = "1";
      git_protocol = "https";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
      };
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
      style = "changes,header";
    };
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

  home.file.".local/bin/power_pull" = {
    source = ../git/power_pull.sh;
    executable = true;
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

    # Git ecosystem (delta, gh, git provided by programs.*)
    ghq
    lazygit

    # General utilities
    hyperfine
    jq
    tokei
    tree
    yq-go
  ];

  xdg.configFile."nvim".source = ../nvim;

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
