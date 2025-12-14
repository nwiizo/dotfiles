# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Fish Shell - Stable Configuration (Fixed)
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
# 3. PATH CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════
set -gx PATH \
    $HOME/.local/bin \
    /opt/homebrew/bin \
    /opt/homebrew/sbin \
    $HOME/.cargo/bin \
    $HOME/.krew/bin \
    $HOME/go/bin \
    $HOME/gopath/bin \
    /usr/local/kubebuilder/bin \
    $HOME/.istioctl/bin \
    $PATH

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
    set -gx BAT_THEME "Dracula"
    # パイプ時は行数を表示しない（plain style）
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
# 6. FISH SHELL BEHAVIOR
# ═══════════════════════════════════════════════════════════════════════════
set -g fish_prompt_pwd_dir_length 3
set -g fish_history_size 10000
set -g fish_history_max_size 20000

# 補完の改善
set -g fish_complete_path $fish_complete_path $XDG_CONFIG_HOME/fish/completions
set -g fish_function_path $fish_function_path $XDG_CONFIG_HOME/fish/functions

# 補完動作の調整
set -g fish_autosuggestion_enabled 1
set -g fish_color_autosuggestion brblack
set -g fish_pager_color_completion normal
set -g fish_pager_color_description yellow
set -g fish_pager_color_prefix cyan
set -g fish_pager_color_progress cyan

if test -n "$TMUX"
    set -g fish_term24bit 1
    set -g fish_escape_delay_ms 10
end

# ═══════════════════════════════════════════════════════════════════════════
# 7. MODERN CLI TOOL REPLACEMENTS
# ═══════════════════════════════════════════════════════════════════════════
if type -q eza
    function ls --wraps eza --description "List files with eza"
        eza --icons --group-directories-first $argv
    end

    function ll --wraps eza --description "Long list with eza"
        eza -l --icons --git --group-directories-first $argv
    end

    function la --wraps eza --description "List all with eza"
        eza -la --icons --git --group-directories-first $argv
    end

    function lt --wraps eza --description "Tree view with eza"
        eza --tree --level=2 --icons $argv
    end
end

if type -q bat
    function cat --wraps bat --description "Cat with syntax highlighting"
        # パイプやリダイレクト時は行数を表示しない
        if isatty stdout
            # ターミナル出力時は通常のスタイル
            bat --paging=never $argv
        else
            # パイプやリダイレクト時はプレーンテキスト
            bat --paging=never --style=plain $argv
        end
    end
end

if type -q rg
    function grep --wraps rg --description "Grep with ripgrep"
        rg $argv
    end
end

# ═══════════════════════════════════════════════════════════════════════════
# 8. FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════
function ghq_fzf_repo -d "Select repository with fzf"
    if not type -q ghq; or not type -q fzf
        echo "Error: ghq and fzf are required" >&2
        return 1
    end

    set -l selected (ghq list -p | fzf \
        --prompt="📁 Repository: " \
        --preview='ls -la {}' \
        --preview-window=right:50%:wrap)

    if test -n "$selected"
        cd $selected
        commandline -f repaint
    end
end

function update_all -d "Update all tools"
    echo "🔄 Updating all tools..."

    if type -q brew
        echo "📦 Updating Homebrew..."
        brew update && brew upgrade && brew cleanup
    end

    if type -q mise
        echo "🔧 Updating mise..."
        mise self-update 2>/dev/null
        mise upgrade
    end

    if type -q rustup
        echo "🦀 Updating Rust..."
        rustup update
    end

    echo "✅ All updates complete!"
end

function sysinfo -d "Display system information"
    echo "System:   "(uname -s)" "(uname -m)
    echo "Hostname: "(hostname)
    echo "User:     "(whoami)

    if test (uname) = Darwin
        echo "Memory:   "(top -l 1 | grep "PhysMem" | awk '{print $2" used,",$6" free"}')
    end

    if type -q git; and test -d .git
        echo "Git:      "(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    end
end

function mkcd -d "Create and enter directory"
    if test (count $argv) -eq 0
        echo "Usage: mkcd <directory>"
        return 1
    end
    mkdir -p $argv[1]; and cd $argv[1]
end

function port -d "Check port"
    if test (count $argv) -eq 0
        echo "Usage: port <port_number>"
        return 1
    end
    lsof -i :$argv[1]
end

# ═══════════════════════════════════════════════════════════════════════════
# 9. KEY BINDINGS
# ═══════════════════════════════════════════════════════════════════════════
function fish_user_key_bindings
    # FZF キーバインド
    if type -q fzf
        if test -f /opt/homebrew/opt/fzf/shell/key-bindings.fish
            source /opt/homebrew/opt/fzf/shell/key-bindings.fish
        end

        # Ctrl+R: コマンド履歴検索
        if functions -q fzf-history-widget
            bind \cr fzf-history-widget
        end

        # Ctrl+G: ghq リポジトリ検索
        bind \cg ghq_fzf_repo

        # Ctrl+F: ファイル検索
        if functions -q fzf-file-widget
            bind \cf fzf-file-widget
        end
    end

    # Ctrl+L: 画面クリア
    bind \cl 'clear; commandline -f repaint'
end

# ═══════════════════════════════════════════════════════════════════════════
# 10. ABBREVIATIONS
# ═══════════════════════════════════════════════════════════════════════════
if status is-interactive
    # 既存のabbreviationをクリーンアップ（エラーを無視）
    abbr --erase -- - 2>/dev/null
    abbr --erase .. 2>/dev/null
    abbr --erase ... 2>/dev/null
    abbr --erase .... 2>/dev/null
    abbr --erase g 2>/dev/null
    abbr --erase ga 2>/dev/null
    abbr --erase gaa 2>/dev/null
    abbr --erase gc 2>/dev/null
    abbr --erase gcm 2>/dev/null
    abbr --erase gco 2>/dev/null
    abbr --erase gcb 2>/dev/null
    abbr --erase gp 2>/dev/null
    abbr --erase gpl 2>/dev/null
    abbr --erase gst 2>/dev/null
    abbr --erase gd 2>/dev/null
    abbr --erase gl 2>/dev/null
    abbr --erase gf 2>/dev/null
    abbr --erase d 2>/dev/null
    abbr --erase dc 2>/dev/null
    abbr --erase dcu 2>/dev/null
    abbr --erase dcd 2>/dev/null
    abbr --erase dps 2>/dev/null
    abbr --erase k 2>/dev/null
    abbr --erase kgp 2>/dev/null
    abbr --erase kgs 2>/dev/null
    abbr --erase kgd 2>/dev/null
    abbr --erase c 2>/dev/null
    abbr --erase v 2>/dev/null
    abbr --erase vim 2>/dev/null
    abbr --erase lg 2>/dev/null

    # ナビゲーション
    abbr --add --global -- - 'cd -'
    abbr --add --global .. 'cd ..'
    abbr --add --global ... 'cd ../..'
    abbr --add --global .... 'cd ../../..'

    # Git
    abbr --add --global g git
    abbr --add --global ga 'git add'
    abbr --add --global gaa 'git add --all'
    abbr --add --global gc 'git commit -v'
    abbr --add --global gcm 'git commit -m'
    abbr --add --global gco 'git checkout'
    abbr --add --global gcb 'git checkout -b'
    abbr --add --global gp 'git push'
    abbr --add --global gpl 'git pull'
    abbr --add --global gst 'git status'
    abbr --add --global gd 'git diff'
    abbr --add --global gl 'git log'
    abbr --add --global gf 'git commit --amend --no-edit'

    # Docker
    abbr --add --global d docker
    abbr --add --global dc 'docker compose'
    abbr --add --global dcu 'docker compose up'
    abbr --add --global dcd 'docker compose down'
    abbr --add --global dps 'docker ps'

    # Kubernetes
    abbr --add --global k kubectl
    abbr --add --global kgp 'kubectl get pods'
    abbr --add --global kgs 'kubectl get svc'
    abbr --add --global kgd 'kubectl get deploy'

    # その他
    abbr --add --global c 'claude --dangerously-skip-permissions'
    abbr --add --global v nvim
    abbr --add --global vim nvim
    abbr --add --global lg lazygit
end

# ═══════════════════════════════════════════════════════════════════════════
# 11. TOOL INTEGRATIONS (local.fishより前に読み込む)
# ═══════════════════════════════════════════════════════════════════════════

# direnv (2025 essential - project-specific environment)
# Reference: https://direnv.net/docs/hook.html
if type -q direnv
    # eval_on_arrow: trigger direnv at prompt and on every directory change (default)
    # eval_after_arrow: trigger only after directory changes before executing command
    # disable_arrow: trigger direnv at prompt only
    set -g direnv_fish_mode eval_on_arrow
    direnv hook fish | source
end

# mise (asdf の後継)
if type -q mise
    if test (pwd) = $HOME; or test -f .mise.toml; or test -f .tool-versions
        mise activate fish 2>/dev/null | source
    end
end

# zoxide (cd の改善版)
if type -q zoxide
    zoxide init fish --cmd z | source
end

# Cargo (Rust)
if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
end

# GitHub CLI
if type -q gh
    gh completion -s fish 2>/dev/null | source
end

# kubectl
if type -q kubectl
    kubectl completion fish 2>/dev/null | source
end

# delta (git diff)
if type -q delta
    set -gx GIT_PAGER 'delta'
end

# ═══════════════════════════════════════════════════════════════════════════
# 12. LOAD LOCAL CONFIG (Starshipより前に)
# ═══════════════════════════════════════════════════════════════════════════
# 注意: local.fishでfish_promptを定義しないこと！
if test -f $XDG_CONFIG_HOME/fish/local.fish
    source $XDG_CONFIG_HOME/fish/local.fish
end

# ═══════════════════════════════════════════════════════════════════════════
# 13. STARSHIP PROMPT (必ず最後に初期化)
# ═══════════════════════════════════════════════════════════════════════════
# Starshipの初期化は必ず最後に行うこと
# これにより、他のツールがプロンプトを上書きするのを防ぐ
if type -q starship
    starship init fish | source
end

# ═══════════════════════════════════════════════════════════════════════════
# 注意事項
# ═══════════════════════════════════════════════════════════════════════════
# 1. conf.d/ は Fish が自動的に読み込むため、ここで手動読み込みはしない
# 2. local.fish で fish_prompt を定義しないこと（Starshipと競合）
# 3. functions/fish_prompt.fish は削除すること（Starshipと競合）
# 4. Starshipの初期化は必ず最後に行うこと
