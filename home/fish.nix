{ pkgs, lib, ... }:

let
  fish-ssh-agent = pkgs.fetchFromGitHub {
    owner = "danhper";
    repo = "fish-ssh-agent";
    rev = "f10d95775352931796fd17f54e6bf2f910163d1b";
    sha256 = "10c0sg5nyh36mk2xlnxw9fw00w8yraj11nbwhm0rw1fjnd1yhnkh";
  };

  fish-fastdir = pkgs.fetchFromGitHub {
    owner = "danhper";
    repo = "fish-fastdir";
    rev = "dddc6c13b4afe271dd91ec004fdd199d3bbb1602";
    sha256 = "1zks9zy8jq6k46nsvqlyl46ylw982hz9c20jdsv54agjxqsg7vla";
  };

  fish-abbreviation-tips = pkgs.fetchFromGitHub {
    owner = "gazorby";
    repo = "fish-abbreviation-tips";
    rev = "8ed76a62bb044ba4ad8e3e6832640178880df485";
    sha256 = "05b5qp7yly7mwsqykjlb79gl24bs6mbqzaj5b3xfn3v2b7apqnqp";
  };
in
{
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    flags = [ "--disable-up-arrow" ];
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd" "z" ];
  };

  programs.mise = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;

    plugins = [
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
      { name = "bass"; src = pkgs.fishPlugins.bass.src; }
      { name = "puffer"; src = pkgs.fishPlugins.puffer.src; }
      { name = "fish-ssh-agent"; src = fish-ssh-agent; }
      { name = "fish-fastdir"; src = fish-fastdir; }
      { name = "fish-abbreviation-tips"; src = fish-abbreviation-tips; }
    ];

    shellAbbrs = {
      "-" = "cd -";

      g = "git";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit -v";
      gcm = "git commit -m";
      gco = "git checkout";
      gcb = "git checkout -b";
      gp = "git push";
      gpl = "git pull";
      gst = "git status";
      gd = "git diff";
      gl = "git log --oneline";
      gf = "git commit --amend --no-edit";
      gs = "git stash";
      gsp = "git stash pop";
      gsl = "git stash list";
      grb = "git rebase";
      gcp = "git cherry-pick";
      gbl = "git blame";
      gcl = "git clone";
      grv = "git remote -v";

      d = "docker";
      dc = "docker compose";
      dcu = "docker compose up";
      dcd = "docker compose down";
      dps = "docker ps";
      dcl = "docker compose logs -f";
      dcr = "docker compose restart";
      dcb = "docker compose build";
      dsp = "docker system prune -af";

      k = "kubectl";
      kgp = "kubectl get pods";
      kgs = "kubectl get svc";
      kgd = "kubectl get deploy";
      kctx = "kubectl config use-context";
      kns = "kubectl config set-context --current --namespace";
      kl = "kubectl logs -f";
      ke = "kubectl exec -it";
      kd = "kubectl describe";
      ka = "kubectl apply -f";
      kdel = "kubectl delete";
      kgn = "kubectl get nodes";
      kpf = "kubectl port-forward";
      ktp = "kubectl top pods";
      ktn = "kubectl top nodes";

      c = "claude --dangerously-skip-permissions";
      cc = "claude -c";
      cr = "claude --resume";
      clp = "claude -p";
      cplan = "claude --permission-mode plan";

      cx = "codex";
      cxq = "codex -q";

      ai = "aider";
      aiw = "aider --watch-files";
      aia = "aider --architect";

      actx = "ai_context";
      actxc = "ai_context | pbcopy";
      arv = "ai_review";
      acm = "ai_commit_msg";
      apr = "ai_pr";

      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      lg = "lazygit";

      reload = "exec fish";
      myip = "curl -s ifconfig.me";
      listening = "lsof -iTCP -sTCP:LISTEN -n -P";

      ff = "_fzf_search_directory";
      fgl = "_fzf_search_git_log";
      fgs = "_fzf_search_git_status";
      fp = "_fzf_search_processes";
      fv = "_fzf_search_variables";
      fh = "atuin search -i";
      gb = "git_fzf_branch";
      kc = "kubectl_fzf_ctx";
      de = "docker_fzf_exec";
      repo = "ghq_fzf_repo";
    };

    functions = {
      ls = {
        body = "eza --icons --group-directories-first $argv";
        wraps = "eza";
        description = "List files with eza";
      };
      ll = {
        body = "eza -l --icons --git --group-directories-first $argv";
        wraps = "eza";
        description = "Long list with eza";
      };
      la = {
        body = "eza -la --icons --git --group-directories-first $argv";
        wraps = "eza";
        description = "List all with eza";
      };
      lt = {
        body = "eza --tree --level=2 --icons $argv";
        wraps = "eza";
        description = "Tree view with eza";
      };
      cat = {
        body = ''
          if isatty stdout
              command bat --paging=never $argv
          else
              command bat --paging=never --style=plain $argv
          end
        '';
        wraps = "bat";
        description = "Cat with syntax highlighting";
      };
      grep = {
        body = "command rg $argv";
        wraps = "rg";
        description = "Grep with ripgrep";
      };

      fish_should_add_to_history = ''
        set -l cmd (string trim -- $argv)

        test -z "$cmd"; and return 1
        string match -qr '^\s' -- $argv; and return 1
        string match -qr '^(export|set).*(TOKEN|SECRET|PASSWORD|KEY|PASS)' -- $cmd; and return 1
        string match -qr '(password|secret|token|api.?key)=' -- $cmd; and return 1
        string match -qr '^(curl|wget|http).+(-H|--header).*(auth|bearer|token)' -i -- $cmd; and return 1
        string match -qr '(AWS_SECRET|GITHUB_TOKEN|OPENAI_API_KEY|ANTHROPIC_API_KEY)' -- $cmd; and return 1
        string match -qr '^vault ' -- $cmd; and return 1
        string match -qr '^(claude|aider|gemini|codex|llm|goose|opencode)\s*$' -- $cmd; and return 1
        test (string length -- $cmd) -le 2; and return 1

        return 0
      '';

      __history_tab_complete = ''
        set -l cmd (commandline -b)

        if test -z "$cmd"
            set -l selected (history | fzf --height=40% --layout=reverse --prompt="History: ")

            if test -n "$selected"
                commandline -r "$selected"
                commandline -f repaint
            end
        else
            commandline -f complete
        end
      '';

      fish_user_key_bindings = ''
        if functions -q fzf_configure_bindings
            fzf_configure_bindings --directory=\cf --history= --git_log= --git_status= --processes= --variables=
        end

        bind ctrl-g ghq_fzf_repo
        bind \ej jj_fzf_ghq
        bind ctrl-b git_fzf_branch
        bind ctrl-l 'clear; commandline -f repaint'

        bind \t __history_tab_complete
      '';

      fish_right_prompt = "";
    };

    shellInit = ''
      # ─── Critical init ───────────────────────────────────────────
      if not test -d (pwd) 2>/dev/null
          builtin cd $HOME 2>/dev/null; or builtin cd /
      end

      set -g fish_greeting

      # ─── XDG ─────────────────────────────────────────────────────
      set -gx XDG_CONFIG_HOME $HOME/.config
      set -gx XDG_DATA_HOME $HOME/.local/share
      set -gx XDG_STATE_HOME $HOME/.local/state
      set -gx XDG_CACHE_HOME $HOME/.cache

      # ─── Homebrew ────────────────────────────────────────────────
      if test -d /opt/homebrew
          set -gx HOMEBREW_PREFIX /opt/homebrew
          set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
          set -gx HOMEBREW_REPOSITORY /opt/homebrew
          fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
      end

      set -gx HOMEBREW_NO_ANALYTICS 1
      set -gx HOMEBREW_NO_ENV_HINTS 1

      # ─── PATH (nix-profile/bin is added by Home Manager) ─────────
      fish_add_path $HOME/.local/bin
      fish_add_path $HOME/.cargo/bin
      fish_add_path $HOME/.krew/bin
      fish_add_path $HOME/go/bin
      fish_add_path $HOME/gopath/bin
      fish_add_path /usr/local/kubebuilder/bin
      fish_add_path $HOME/.istioctl/bin

      set -q MANPATH; or set MANPATH '''
      set -gx MANPATH "/opt/homebrew/share/man" $MANPATH

      set -q INFOPATH; or set INFOPATH '''
      set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH

      # ─── Environment variables ───────────────────────────────────
      set -gx EDITOR nvim
      set -gx VISUAL nvim
      set -gx KUBE_EDITOR nvim

      set -gx GOPATH $HOME/gopath
      set -gx GOPROXY direct
      set -gx GOSUMDB off

      set -gx DOCKER_BUILDKIT 1
      set -gx COMPOSE_DOCKER_CLI_BUILD 1

      set -gx USE_GKE_GCLOUD_AUTH_PLUGIN True
      set -gx KUBECONFIG $HOME/.kube/config

      if type -q bat
          set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
          set -gx BAT_THEME "Catppuccin Mocha"
          set -gx BAT_STYLE "changes,header"
      end

      set -gx LANG en_US.UTF-8
      set -gx LC_ALL en_US.UTF-8

      # ─── Tools that only need env vars ───────────────────────────
      type -q delta; and set -gx GIT_PAGER delta

      # ─── Rust env ────────────────────────────────────────────────
      test -f "$HOME/.cargo/env.fish"; and source "$HOME/.cargo/env.fish"
    '';

    interactiveShellInit = ''
      # ─── FZF configuration ───────────────────────────────────────
      if type -q fzf
          set -gx FZF_DEFAULT_OPTS "\
              --height 50% \
              --layout=reverse \
              --border rounded \
              --inline-info \
              --preview-window=right:50%:wrap \
              --bind='ctrl-/:toggle-preview' \
              --bind='ctrl-u:preview-page-up' \
              --bind='ctrl-d:preview-page-down' \
              --color=fg:#cdd6f4,bg:#1e1e2e,hl:#f38ba8 \
              --color=fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8 \
              --color=info:#89b4fa,prompt:#89dceb,pointer:#cba6f7 \
              --color=marker:#a6e3a1,spinner:#cba6f7,header:#89b4fa \
              --color=border:#6c7086,gutter:#1e1e2e"

          if type -q fd
              set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git --exclude node_modules"
              set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
              set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git --exclude node_modules"
          else if type -q rg
              set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --follow --glob '!.git/*' --glob '!node_modules/*'"
          end

          if type -q bat; and type -q eza
              set -gx FZF_CTRL_T_OPTS "--preview 'if test -d {}; eza --tree --level=2 --color=always --icons {}; else; bat --style=numbers,changes,header --color=always --line-range :500 {}; end'"
              set -gx FZF_ALT_C_OPTS "--preview 'eza --tree --level=2 --color=always --icons {} | head -200'"
          else if type -q bat
              set -gx FZF_CTRL_T_OPTS "--preview 'bat --style=numbers,changes,header --color=always --line-range :500 {}'"
          end
      end

      # ─── Fish behavior ───────────────────────────────────────────
      set -g fish_prompt_pwd_dir_length 3

      set -g fish_color_autosuggestion brblack
      set -g fish_pager_color_completion normal
      set -g fish_pager_color_description yellow
      set -g fish_pager_color_prefix cyan
      set -g fish_pager_color_progress cyan

      # done plugin (Ghostty native notifications)
      set -g __done_min_cmd_duration 10000
      set -g __done_notification_urgency_level normal
      set -g __done_notify_sound 1

      # ─── Local config (machine-specific, gitignored) ────────────
      test -f $XDG_CONFIG_HOME/fish/local.fish; and source $XDG_CONFIG_HOME/fish/local.fish

      # ─── Prompt configuration ────────────────────────────────────
      set -g fish_transient_prompt 1

      set -g __fish_git_prompt_show_informative_status 0
      set -g __fish_git_prompt_showdirtystate yes
      set -g __fish_git_prompt_showuntrackedfiles yes
      set -g __fish_git_prompt_showstashstate yes
      set -g __fish_git_prompt_showupstream informative

      set -g __fish_git_prompt_char_dirtystate '!'
      set -g __fish_git_prompt_char_stagedstate '+'
      set -g __fish_git_prompt_char_untrackedfiles '?'
      set -g __fish_git_prompt_char_stashstate '≡'
      set -g __fish_git_prompt_char_upstream_ahead '⇡'
      set -g __fish_git_prompt_char_upstream_behind '⇣'
      set -g __fish_git_prompt_char_upstream_diverged '⇕'
      set -g __fish_git_prompt_char_upstream_equal '''
      set -g __fish_git_prompt_char_stateseparator '''

      set -g __fish_git_prompt_showcolorhints yes
      set -g __fish_git_prompt_color_branch cba6f7 --bold
      set -g __fish_git_prompt_color_upstream eba0ac
      set -g __fish_git_prompt_color_dirtystate eba0ac
      set -g __fish_git_prompt_color_stagedstate a6e3a1
      set -g __fish_git_prompt_color_untrackedfiles eba0ac
      set -g __fish_git_prompt_color_stashstate 74c7ec
      set -g __fish_git_prompt_color_merging f9e2af
      set -g __fish_git_prompt_color_cleanstate a6e3a1
    '';
  };

  xdg.configFile = {
    "fish/functions/fish_prompt.fish".source = ../fish/functions/fish_prompt.fish;
    "fish/functions/ghq_fzf_repo.fish".source = ../fish/functions/ghq_fzf_repo.fish;
    "fish/functions/jj_fzf_ghq.fish".source = ../fish/functions/jj_fzf_ghq.fish;
    "fish/functions/jj_get.fish".source = ../fish/functions/jj_get.fish;
    "fish/functions/jj_ghq_adopt.fish".source = ../fish/functions/jj_ghq_adopt.fish;
    "fish/functions/ai_commit_msg.fish".source = ../fish/functions/ai_commit_msg.fish;
    "fish/functions/ai_context.fish".source = ../fish/functions/ai_context.fish;
    "fish/functions/ai_pr.fish".source = ../fish/functions/ai_pr.fish;
    "fish/functions/ai_review.fish".source = ../fish/functions/ai_review.fish;
    "fish/functions/update_all.fish".source = ../fish/functions/update_all.fish;
    "fish/conf.d/zz_sponge_compat.fish".source = ../fish/conf.d/zz_sponge_compat.fish;
  };
}
