# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Fish Shell Configuration - 2026 Best Practices (Fish 4.3+)
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
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv 2>/dev/null)
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
fish_add_path --path $HOME/.local/bin
fish_add_path --path $HOME/.cargo/bin
fish_add_path --path $HOME/.krew/bin
fish_add_path --path $HOME/go/bin
fish_add_path --path $HOME/gopath/bin
fish_add_path --path /usr/local/kubebuilder/bin
fish_add_path --path $HOME/.istioctl/bin

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
set -gx GOROOT $HOME/go
set -gx GO111MODULE on
set -gx GOPROXY direct
set -gx GOSUMDB off

set -gx DOCKER_BUILDKIT 1
set -gx COMPOSE_DOCKER_CLI_BUILD 1

set -gx USE_GKE_GCLOUD_AUTH_PLUGIN True
set -gx KUBECONFIG $HOME/.kube/config

if type -q bat
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx BAT_THEME Dracula
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
        --bind='ctrl-d:preview-page-down'"

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
# 6. FISH SHELL BEHAVIOR (Fish 4.3+ settings)
# ═══════════════════════════════════════════════════════════════════════════
set -g fish_prompt_pwd_dir_length 3

# Colors (Fish 4.3+ recommends setting in config.fish instead of universals)
set -g fish_color_autosuggestion brblack
set -g fish_pager_color_completion normal
set -g fish_pager_color_description yellow
set -g fish_pager_color_prefix cyan
set -g fish_pager_color_progress cyan

# TMUX optimizations
if test -n "$TMUX"
    set -g fish_escape_delay_ms 10
end

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
# 9. UTILITY FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════
function ghq_fzf_repo -d "Select repository with fzf"
    type -q ghq; and type -q fzf; or return 1

    set -l selected (ghq list -p | fzf \
        --prompt="Repository: " \
        --preview='eza -la --icons --git {}' \
        --preview-window=right:50%:wrap)

    test -n "$selected"; and cd $selected; and commandline -f repaint
end

function update_all -d "Update all tools"
    echo "Updating all tools..."

    type -q brew; and echo "Homebrew..." && brew update && brew upgrade && brew cleanup
    type -q mise; and echo "mise..." && mise self-update 2>/dev/null; mise upgrade
    type -q claude; and echo "Claude CLI..." && claude update
    type -q rustup; and echo "Rust..." && rustup update
    type -q fisher; and echo "Fisher..." && fisher update 2>/dev/null
    type -q nvim; and echo "Neovim plugins..." && nvim --headless "+Lazy! sync" +qa 2>/dev/null

    echo "Done!"
end

function mkcd -d "Create and enter directory"
    test (count $argv) -eq 0; and echo "Usage: mkcd <directory>"; and return 1
    mkdir -p $argv[1]; and cd $argv[1]
end

function port -d "Check process using port"
    test (count $argv) -eq 0; and echo "Usage: port <number>"; and return 1
    lsof -i :$argv[1]
end

function git_fzf_branch -d "Switch git branch with fzf"
    git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return 1

    set -l branch (git branch -a --sort=-committerdate | \
        string trim | \
        string replace -r '^\* ' '' | \
        string replace -r '^remotes/origin/' '' | \
        sort -u | \
        fzf --prompt="Branch: " \
            --preview='git log --oneline --graph --color=always -20 {}' \
            --preview-window=right:50%:wrap)

    test -n "$branch"; and git checkout $branch; and commandline -f repaint
end

function kubectl_fzf_ctx -d "Switch kubectl context with fzf"
    type -q kubectl; or return 1

    set -l ctx (kubectl config get-contexts -o name | \
        fzf --prompt="Context: " \
            --preview='kubectl config view --context={} --minify' \
            --preview-window=right:50%:wrap)

    test -n "$ctx"; and kubectl config use-context $ctx; and commandline -f repaint
end

function docker_fzf_exec -d "Exec into docker container with fzf"
    type -q docker; or return 1

    set -l container (docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" | \
        tail -n +2 | \
        fzf --prompt="Container: " \
            --preview='docker logs --tail 20 {1}' \
            --preview-window=right:50%:wrap | \
        awk '{print $1}')

    test -n "$container"; and docker exec -it $container /bin/sh -c "command -v bash >/dev/null && exec bash || exec sh"
end

# ═══════════════════════════════════════════════════════════════════════════
# 10. KEY BINDINGS (Fish 4.0+ notation)
# ═══════════════════════════════════════════════════════════════════════════
# Note: Warp terminal ignores custom keybindings. Use abbreviations instead:
#   ff=files, fgl=git log, fgs=git status, fp=processes, fh=history
#   gb=branch, kc=kubectl ctx, de=docker exec, repo=ghq
function fish_user_key_bindings
    # These work in iTerm2, Ghostty, etc. but NOT in Warp
    bind ctrl-g ghq_fzf_repo
    bind ctrl-b git_fzf_branch
    bind ctrl-l 'clear; commandline -f repaint'
end

# ═══════════════════════════════════════════════════════════════════════════
# 11. ABBREVIATIONS (Interactive shell only)
# ═══════════════════════════════════════════════════════════════════════════
if status is-interactive
    # Navigation
    abbr -a -- - 'cd -'
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    abbr -a .... 'cd ../../..'

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

    # Tools
    abbr -a c claude
    abbr -a v nvim
    abbr -a vi nvim
    abbr -a vim nvim
    abbr -a lg lazygit

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
# 12. TOOL INTEGRATIONS
# ═══════════════════════════════════════════════════════════════════════════
# mise (asdf successor) - always activate for version management
type -q mise; and mise activate fish 2>/dev/null | source

# direnv - for per-directory environments
type -q direnv; and direnv hook fish | source

# zoxide - smarter cd
type -q zoxide; and zoxide init fish --cmd z | source

# Rust
test -f "$HOME/.cargo/env.fish"; and source "$HOME/.cargo/env.fish"

# GitHub CLI completion
type -q gh; and gh completion -s fish 2>/dev/null | source

# kubectl completion
type -q kubectl; and kubectl completion fish 2>/dev/null | source

# delta for git diff
type -q delta; and set -gx GIT_PAGER delta

# atuin - magical shell history (replaces Ctrl+R from fzf.fish)
if type -q atuin
    atuin init fish --disable-up-arrow | source
    # fzf.fish history is disabled via fzf_configure_bindings in conf.d
end

# ═══════════════════════════════════════════════════════════════════════════
# 13. LOCAL CONFIG (machine-specific, gitignored)
# ═══════════════════════════════════════════════════════════════════════════
test -f $XDG_CONFIG_HOME/fish/local.fish; and source $XDG_CONFIG_HOME/fish/local.fish

# ═══════════════════════════════════════════════════════════════════════════
# 14. STARSHIP PROMPT (must be last)
# ═══════════════════════════════════════════════════════════════════════════
type -q starship; and starship init fish | source
