{ pkgs, ... }:

{
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

  programs.lazygit.enable = true;

  home.file.".local/bin/power_pull" = {
    source = ../git/power_pull.sh;
    executable = true;
  };

  home.packages = with pkgs; [ ghq ];
}
