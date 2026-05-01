{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "nwiizo";
        email = "syu.m.5151@gmail.com";
      };

      alias = {
        # Depends on `aicommits` (npm-installed, not in nixpkgs).
        ac = "!git add -A && aicommits -a";
      };

      push.autoSetupRemote = true;

      # macOS keychain over plaintext ~/.git-credentials.
      credential.helper = "osxkeychain";

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
}
