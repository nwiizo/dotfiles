# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Fish Shell Configuration - 2026 AI Era (Fish 4.6+)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ═══════════════════════════════════════════════════════════════════════════
# 0. CRITICAL INITIALIZATION
# ═══════════════════════════════════════════════════════════════════════════
if not test -d (pwd) 2>/dev/null
    builtin cd $HOME 2>/dev/null; or builtin cd /
end

set -g fish_greeting

# ═══════════════════════════════════════════════════════════════════════════
# 1. XDG BASE DIRECTORY SPECIFICATION
# ═══════════════════════════════════════════════════════════════════════════
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_CACHE_HOME $HOME/.cache

# ═══════════════════════════════════════════════════════════════════════════
# 2. HOMEBREW
# ═══════════════════════════════════════════════════════════════════════════
if test -d /opt/homebrew
    set -gx HOMEBREW_PREFIX /opt/homebrew
    set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
    set -gx HOMEBREW_REPOSITORY /opt/homebrew
    fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
end

set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_NO_ENV_HINTS 1

# ═══════════════════════════════════════════════════════════════════════════
# 2.5. NIX PACKAGE MANAGER
# ═══════════════════════════════════════════════════════════════════════════
if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
else if test -e $HOME/.nix-profile/etc/profile.d/nix.fish
    source $HOME/.nix-profile/etc/profile.d/nix.fish
end

if test -d /nix
    set -gx NIX_PATH nixpkgs=channel:nixpkgs-unstable $NIX_PATH
end

# ═══════════════════════════════════════════════════════════════════════════
# 3. PATH CONFIGURATION (using fish_add_path - Fish 3.2+)
# ═══════════════════════════════════════════════════════════════════════════
# fish_add_path automatically prevents duplicates and is idempotent
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.krew/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/gopath/bin
fish_add_path /usr/local/kubebuilder/bin
fish_add_path $HOME/.istioctl/bin

set -q MANPATH; or set MANPATH ''
set -gx MANPATH "/opt/homebrew/share/man" $MANPATH

set -q INFOPATH; or set INFOPATH ''
set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH

# ═══════════════════════════════════════════════════════════════════════════
# 4. ENVIRONMENT VARIABLES
# ═══════════════════════════════════════════════════════════════════════════
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx KUBE_EDITOR nvim

set -gx GOPATH $HOME/gopath
# GOROOT: not set - Go knows its own root via Homebrew/mise
# GO111MODULE: not set - default 'on' since Go 1.16
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

# ═══════════════════════════════════════════════════════════════════════════
# 5. FZF CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════
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

# ═══════════════════════════════════════════════════════════════════════════
# 6. FISH SHELL BEHAVIOR (Fish 4.6+ settings)
# ═══════════════════════════════════════════════════════════════════════════
set -g fish_prompt_pwd_dir_length 3

# Colors (Fish 4.3+ recommends setting in config.fish instead of universals)
set -g fish_color_autosuggestion brblack
set -g fish_pager_color_completion normal
set -g fish_pager_color_description yellow
set -g fish_pager_color_prefix cyan
set -g fish_pager_color_progress cyan

# done プラグイン設定（長時間コマンド完了時に通知）
# Ghosttyネイティブ通知を使用（コマンド名・所要時間が表示される）
set -g __done_min_cmd_duration 10000  # 10秒以上で通知
set -g __done_notification_urgency_level normal
set -g __done_notify_sound 1

# ═══════════════════════════════════════════════════════════════════════════
# 7. HISTORY CONTROL (Fish 4.0+ feature)
# ═══════════════════════════════════════════════════════════════════════════
function fish_should_add_to_history
    set -l cmd (string trim -- $argv)

    # Skip empty commands
    test -z "$cmd"; and return 1

    # Skip commands starting with space (private commands)
    string match -qr '^\s' -- $argv; and return 1

    # Skip sensitive commands
    string match -qr '^(export|set).*(TOKEN|SECRET|PASSWORD|KEY|PASS)' -- $cmd; and return 1
    string match -qr '(password|secret|token|api.?key)=' -- $cmd; and return 1
    string match -qr '^(curl|wget|http).+(-H|--header).*(auth|bearer|token)' -i -- $cmd; and return 1
    string match -qr '(AWS_SECRET|GITHUB_TOKEN|OPENAI_API_KEY|ANTHROPIC_API_KEY)' -- $cmd; and return 1
    string match -qr '^vault ' -- $cmd; and return 1

    # Skip bare interactive AI sessions (noisy single entries)
    string match -qr '^(claude|aider|gemini|codex|llm|goose|opencode)\s*$' -- $cmd; and return 1

    # Skip very short commands that are just noise
    test (string length -- $cmd) -le 2; and return 1

    return 0
end

# ═══════════════════════════════════════════════════════════════════════════
# 8. MODERN CLI TOOL REPLACEMENTS
# ═══════════════════════════════════════════════════════════════════════════
if type -q eza
    function ls --wraps eza -d "List files with eza"
        eza --icons --group-directories-first $argv
    end

    function ll --wraps eza -d "Long list with eza"
        eza -l --icons --git --group-directories-first $argv
    end

    function la --wraps eza -d "List all with eza"
        eza -la --icons --git --group-directories-first $argv
    end

    function lt --wraps eza -d "Tree view with eza"
        eza --tree --level=2 --icons $argv
    end
end

if type -q bat
    function cat --wraps bat -d "Cat with syntax highlighting"
        if isatty stdout
            bat --paging=never $argv
        else
            bat --paging=never --style=plain $argv
        end
    end
end

if type -q rg
    function grep --wraps rg -d "Grep with ripgrep"
        rg $argv
    end
end

# ═══════════════════════════════════════════════════════════════════════════
# 9. KEY BINDINGS (Fish 4.0+ notation)
# ═══════════════════════════════════════════════════════════════════════════
# Note: Warp terminal ignores custom keybindings. Use abbreviations instead:
#   ff=files, fgl=git log, fgs=git status, fp=processes, fh=history
#   gb=branch, kc=kubectl ctx, de=docker exec, repo=ghq
# 空のコマンドラインでTabを押した時に履歴から選択
function __history_tab_complete
    set -l cmd (commandline -b)

    if test -z "$cmd"
        # 空の場合、履歴からfzfで選択
        set -l selected (history | fzf --height=40% --layout=reverse --prompt="History: ")

        if test -n "$selected"
            commandline -r "$selected"
            commandline -f repaint
        end
    else
        # 空でない場合は通常の補完
        commandline -f complete
    end
end

function fish_user_key_bindings
    # fzf.fish plugin: only Ctrl+F for directory search
    # History → atuin (Ctrl+R), git/processes/variables → abbreviations (fgl, fgs, fp, fv)
    # Guard: プラグイン未インストールでもシェル起動が壊れないようにする
    if functions -q fzf_configure_bindings
        fzf_configure_bindings --directory=\cf --history= --git_log= --git_status= --processes= --variables=
    end

    # Custom bindings (work in Ghostty, iTerm2, etc. but NOT in Warp)
    bind ctrl-g ghq_fzf_repo
    # Alt-J: ghq repos with jj-aware preview. Offers to colocate jj on
    # cd when the repo is git-only. Sibling to Ctrl-G, not a replacement.
    bind \ej jj_fzf_ghq
    bind ctrl-b git_fzf_branch
    bind ctrl-l 'clear; commandline -f repaint'

    # 空入力でTabを押した時に履歴から選択
    bind \t __history_tab_complete
end

# ═══════════════════════════════════════════════════════════════════════════
# 10. ABBREVIATIONS (Interactive shell only)
# ═══════════════════════════════════════════════════════════════════════════
if status is-interactive
    # Navigation (.. ... .... are provided by fastdir plugin)
    abbr -a -- - 'cd -'

    # Git
    abbr -a g git
    abbr -a ga 'git add'
    abbr -a gaa 'git add --all'
    abbr -a gc 'git commit -v'
    abbr -a gcm 'git commit -m'
    abbr -a gco 'git checkout'
    abbr -a gcb 'git checkout -b'
    abbr -a gp 'git push'
    abbr -a gpl 'git pull'
    abbr -a gst 'git status'
    abbr -a gd 'git diff'
    abbr -a gl 'git log --oneline'
    abbr -a gf 'git commit --amend --no-edit'

    # Docker
    abbr -a d docker
    abbr -a dc 'docker compose'
    abbr -a dcu 'docker compose up'
    abbr -a dcd 'docker compose down'
    abbr -a dps 'docker ps'

    # Kubernetes
    abbr -a k kubectl
    abbr -a kgp 'kubectl get pods'
    abbr -a kgs 'kubectl get svc'
    abbr -a kgd 'kubectl get deploy'
    abbr -a kctx 'kubectl config use-context'
    abbr -a kns 'kubectl config set-context --current --namespace'

    # Git (extended)
    abbr -a gs 'git stash'
    abbr -a gsp 'git stash pop'
    abbr -a gsl 'git stash list'
    abbr -a grb 'git rebase'
    abbr -a gcp 'git cherry-pick'
    abbr -a gbl 'git blame'
    abbr -a gcl 'git clone'
    abbr -a grv 'git remote -v'

    # Docker (extended)
    abbr -a dcl 'docker compose logs -f'
    abbr -a dcr 'docker compose restart'
    abbr -a dcb 'docker compose build'
    abbr -a dsp 'docker system prune -af'

    # Kubernetes (extended)
    abbr -a kl 'kubectl logs -f'
    abbr -a ke 'kubectl exec -it'
    abbr -a kd 'kubectl describe'
    abbr -a ka 'kubectl apply -f'
    abbr -a kdel 'kubectl delete'
    abbr -a kgn 'kubectl get nodes'
    abbr -a kpf 'kubectl port-forward'
    abbr -a ktp 'kubectl top pods'
    abbr -a ktn 'kubectl top nodes'

    # Claude Code (primary AI tool)
    abbr -a c 'claude --dangerously-skip-permissions'
    abbr -a cc 'claude -c'
    abbr -a cr 'claude --resume'
    abbr -a clp 'claude -p'
    abbr -a cplan 'claude --permission-mode plan'

    # OpenAI Codex
    abbr -a cx codex
    abbr -a cxq 'codex -q'

    # Aider (AI pair programming)
    abbr -a ai aider
    abbr -a aiw 'aider --watch-files'
    abbr -a aia 'aider --architect'

    # AI workflow shortcuts
    abbr -a arv ai_review
    abbr -a acm ai_commit_msg
    abbr -a apr ai_pr

    # Tools
    abbr -a v nvim
    abbr -a vi nvim
    abbr -a vim nvim
    abbr -a lg lazygit

    # General productivity
    abbr -a reload 'exec fish'
    abbr -a myip 'curl -s ifconfig.me'
    abbr -a listening 'lsof -iTCP -sTCP:LISTEN -n -P'

    # fzf shortcuts (Warp doesn't support custom keybindings)
    abbr -a ff _fzf_search_directory
    abbr -a fgl _fzf_search_git_log
    abbr -a fgs _fzf_search_git_status
    abbr -a fp _fzf_search_processes
    abbr -a fv _fzf_search_variables
    abbr -a fh 'atuin search -i'
    abbr -a gb git_fzf_branch
    abbr -a kc kubectl_fzf_ctx
    abbr -a de docker_fzf_exec
    abbr -a repo ghq_fzf_repo
end

# ═══════════════════════════════════════════════════════════════════════════
# 11. TOOL INTEGRATIONS
# ═══════════════════════════════════════════════════════════════════════════
# mise (asdf successor) - always activate for version management
type -q mise; and mise activate fish 2>/dev/null | source

# atuin, direnv, zoxide: pre-generated to conf.d/ for fast startup
# Regenerate with: update_all (or manually)
#   atuin init fish --disable-up-arrow > ~/.config/fish/conf.d/atuin.fish
#   direnv hook fish > ~/.config/fish/conf.d/direnv.fish
#   zoxide init fish --cmd z > ~/.config/fish/conf.d/zoxide.fish

# Rust
test -f "$HOME/.cargo/env.fish"; and source "$HOME/.cargo/env.fish"

# delta for git diff
type -q delta; and set -gx GIT_PAGER delta

# carapace - universal completion engine
# Pre-generate completions for speed: carapace --list | while read cmd; carapace $cmd fish > completions/$cmd.fish; end
type -q carapace; and carapace _carapace fish | source

# ═══════════════════════════════════════════════════════════════════════════
# 12. LOCAL CONFIG (machine-specific, gitignored)
# ═══════════════════════════════════════════════════════════════════════════
test -f $XDG_CONFIG_HOME/fish/local.fish; and source $XDG_CONFIG_HOME/fish/local.fish

# ═══════════════════════════════════════════════════════════════════════════
# 13. PROMPT CONFIGURATION (native fish_prompt, see functions/fish_prompt.fish)
# ═══════════════════════════════════════════════════════════════════════════

# Transient prompt (Fish 4.1+): previous commands show only ❯
set -g fish_transient_prompt 1

# __fish_git_prompt configuration
set -g __fish_git_prompt_show_informative_status 0
set -g __fish_git_prompt_showdirtystate yes
set -g __fish_git_prompt_showuntrackedfiles yes
set -g __fish_git_prompt_showstashstate yes
set -g __fish_git_prompt_showupstream informative

# Git prompt characters (match previous Starship config)
set -g __fish_git_prompt_char_dirtystate '!'
set -g __fish_git_prompt_char_stagedstate '+'
set -g __fish_git_prompt_char_untrackedfiles '?'
set -g __fish_git_prompt_char_stashstate '≡'
set -g __fish_git_prompt_char_upstream_ahead '⇡'
set -g __fish_git_prompt_char_upstream_behind '⇣'
set -g __fish_git_prompt_char_upstream_diverged '⇕'
set -g __fish_git_prompt_char_upstream_equal ''
set -g __fish_git_prompt_char_stateseparator ''

# Git prompt colors (Catppuccin Mocha)
set -g __fish_git_prompt_showcolorhints yes
set -g __fish_git_prompt_color_branch cba6f7 --bold
set -g __fish_git_prompt_color_upstream eba0ac
set -g __fish_git_prompt_color_dirtystate eba0ac
set -g __fish_git_prompt_color_stagedstate a6e3a1
set -g __fish_git_prompt_color_untrackedfiles eba0ac
set -g __fish_git_prompt_color_stashstate 74c7ec
set -g __fish_git_prompt_color_merging f9e2af
set -g __fish_git_prompt_color_cleanstate a6e3a1
