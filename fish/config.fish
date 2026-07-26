# Main fish configuration. This file is symlinked directly by scripts/link.sh.

# Only execute this file once per shell.
set -q __nwiizo_fish_config_sourced; and exit
set -g __nwiizo_fish_config_sourced 1

# Critical init
if not test -d (pwd) 2>/dev/null
    builtin cd $HOME 2>/dev/null; or builtin cd /
end

set -g fish_greeting

# XDG
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_CACHE_HOME $HOME/.cache

# Editors
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx KUBE_EDITOR nvim

# Go
set -gx GOPATH $HOME/gopath
set -gx GOPROXY direct
set -gx GOSUMDB off

# Containers / Kubernetes
set -gx DOCKER_BUILDKIT 1
set -gx COMPOSE_DOCKER_CLI_BUILD 1
set -gx USE_GKE_GCLOUD_AUTH_PLUGIN True
set -gx KUBECONFIG $HOME/.kube/config

# Locale
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Man pages
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx HOMEBREW_AUTO_UPDATE_SECS 3600
set -gx HOMEBREW_UPGRADE_GREEDY 1

# PATH
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.krew/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/gopath/bin
fish_add_path /usr/local/kubebuilder/bin
fish_add_path $HOME/.istioctl/bin

set -q MANPATH; or set MANPATH ''
set -gx MANPATH /opt/homebrew/share/man $MANPATH

set -q INFOPATH; or set INFOPATH ''
set -gx INFOPATH /opt/homebrew/share/info $INFOPATH

test -f "$HOME/.cargo/env.fish"; and source "$HOME/.cargo/env.fish"

# mise and direnv hooks are initialized from conf.d. The remainder is interactive-only.
status is-interactive; or exit

# Abbreviations: navigation
abbr --add -- - 'cd -'

# Abbreviations: git
abbr --add -- g git
abbr --add -- ga 'git add'
abbr --add -- gaa 'git add --all'
abbr --add -- gc 'git commit -v'
abbr --add -- gcm 'git commit -m'
abbr --add -- gco 'git checkout'
abbr --add -- gcb 'git checkout -b'
abbr --add -- gp 'git push'
abbr --add -- gpl 'git pull'
abbr --add -- gst 'git status'
abbr --add -- gd 'git diff'
abbr --add -- gl 'git log --oneline'
abbr --add -- gf 'git commit --amend --no-edit'
abbr --add -- gs 'git stash'
abbr --add -- gsp 'git stash pop'
abbr --add -- gsl 'git stash list'
abbr --add -- grb 'git rebase'
abbr --add -- gcp 'git cherry-pick'
abbr --add -- gbl 'git blame'
abbr --add -- gcl 'git clone'
abbr --add -- grv 'git remote -v'

# Abbreviations: Docker
abbr --add -- d docker
abbr --add -- dc 'docker compose'
abbr --add -- dcu 'docker compose up'
abbr --add -- dcd 'docker compose down'
abbr --add -- dps 'docker ps'
abbr --add -- dcl 'docker compose logs -f'
abbr --add -- dcr 'docker compose restart'
abbr --add -- dcb 'docker compose build'
abbr --add -- dsp 'docker system prune -af'

# Abbreviations: Kubernetes
abbr --add -- k kubectl
abbr --add -- kgp 'kubectl get pods'
abbr --add -- kgs 'kubectl get svc'
abbr --add -- kgd 'kubectl get deploy'
abbr --add -- kctx 'kubectl config use-context'
abbr --add -- kns 'kubectl config set-context --current --namespace'
abbr --add -- kl 'kubectl logs -f'
abbr --add -- ke 'kubectl exec -it'
abbr --add -- kd 'kubectl describe'
abbr --add -- ka 'kubectl apply -f'
abbr --add -- kdel 'kubectl delete'
abbr --add -- kgn 'kubectl get nodes'
abbr --add -- kpf 'kubectl port-forward'
abbr --add -- ktp 'kubectl top pods'
abbr --add -- ktn 'kubectl top nodes'

# Abbreviations: AI tools
abbr --add -- c claude
abbr --add -- cc 'claude --dangerously-skip-permissions'
abbr --add -- cr 'claude --resume'
abbr --add -- clp 'claude -p'
abbr --add -- cplan 'claude --permission-mode plan'
abbr --add -- cbare 'claude --bare'
abbr --add -- csafe 'claude --safe-mode'
abbr --add -- cdoc 'claude doctor'
abbr --add -- cagents 'claude agents'
abbr --add -- cultra 'claude ultrareview'
abbr --add -- cx 'codex --dangerously-bypass-approvals-and-sandbox'
abbr --add -- cxq 'codex -q'
abbr --add -- cxs 'codex --sandbox workspace-write --ask-for-approval on-request'
abbr --add -- cxro 'codex --sandbox read-only'
abbr --add -- cxe 'codex exec'
abbr --add -- cxel 'codex exec resume --last'
abbr --add -- cxr 'codex resume'
abbr --add -- cxrl 'codex resume --last'
abbr --add -- cxrev 'codex review --uncommitted'
abbr --add -- cxdoc 'codex doctor'
abbr --add -- cxm 'codex mcp list'
abbr --add -- ai aider
abbr --add -- aiw 'aider --watch-files'
abbr --add -- aia 'aider --architect'
abbr --add -- actx ai_context
abbr --add -- actxc 'ai_context | pbcopy'
abbr --add -- arv ai_review
abbr --add -- acm ai_commit_msg
abbr --add -- apr ai_pr

# Abbreviations: agent-assisted development
abbr --add -- ast ast-grep
abbr --add -- awatch ai_watch
abbr --add -- wx watchexec

# Abbreviations: editor / TUI
abbr --add -- v nvim
abbr --add -- vi nvim
abbr --add -- vim nvim
abbr --add -- lg lazygit

# Abbreviations: misc productivity
abbr --add -- reload 'exec fish'
abbr --add -- private 'fish --private'
abbr --add -- myip 'curl -s ifconfig.me'
abbr --add -- listening 'lsof -iTCP -sTCP:LISTEN -n -P'

# Abbreviations: fzf shortcuts
abbr --add -- ff _fzf_search_directory
abbr --add -- fgl _fzf_search_git_log
abbr --add -- fgs _fzf_search_git_status
abbr --add -- fp _fzf_search_processes
abbr --add -- fv _fzf_search_variables
abbr --add -- fh 'atuin search -i'
abbr --add -- gb git_fzf_branch
abbr --add -- kc kubectl_fzf_ctx
abbr --add -- de docker_fzf_exec
abbr --add -- repo ghq_fzf_repo

# FZF configuration
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

# Fish behavior
set -g fish_prompt_pwd_dir_length 3
set -g fish_color_autosuggestion brblack
set -g fish_pager_color_completion normal
set -g fish_pager_color_description yellow
set -g fish_pager_color_prefix cyan
set -g fish_pager_color_progress cyan

# Command-not-found: let mise auto-install tools, then fall back to fish.
function __nwiizo_setup_cnf --on-event fish_prompt
    functions --erase __nwiizo_setup_cnf
    function fish_command_not_found
        if type -q mise
            and string match -qrv -- '^(?:mise$|mise-)' -- $argv[1]
            and command mise hook-not-found -s fish -- $argv[1]
            command mise hook-env -s fish | source
            return
        end
        __fish_default_command_not_found_handler $argv
    end
end

# fish-abbreviation-tips
if functions -q __abbr_tips_init
    set -g ABBR_TIPS_REGEXES \
        '(^(\w+\s+)+(-{1,2})\w+)(\s\S+)' \
        '(^(\s?(\w-?)+){3}).*' \
        '(^(\s?(\w-?)+){2}).*' \
        '(^(\s?(\w-?)+){1}).*'
    set -g ABBR_TIPS_PROMPT '\n💡 \e[1m{{ .abbr }}\e[0m => {{ .cmd }}'
    set -g ABBR_TIPS_AUTO_UPDATE background

    function __nwiizo_abbr_tips_lazy_init --on-event fish_postexec
        functions --erase __nwiizo_abbr_tips_lazy_init
        __abbr_tips_init
    end
end

# Prompt configuration
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
set -g __fish_git_prompt_char_upstream_equal ''
set -g __fish_git_prompt_char_stateseparator ''
set -g __fish_git_prompt_showcolorhints yes
set -g __fish_git_prompt_color_branch cba6f7 --bold
set -g __fish_git_prompt_color_upstream eba0ac
set -g __fish_git_prompt_color_dirtystate eba0ac
set -g __fish_git_prompt_color_stagedstate a6e3a1
set -g __fish_git_prompt_color_untrackedfiles eba0ac
set -g __fish_git_prompt_color_stashstate 74c7ec
set -g __fish_git_prompt_color_merging f9e2af
set -g __fish_git_prompt_color_cleanstate a6e3a1

# Tool integrations
type -q zoxide; and __nwiizo_cached_init zoxide zoxide init fish --cmd z
type -q carapace; and __nwiizo_cached_init carapace carapace _carapace fish
type -q atuin; and __nwiizo_cached_init atuin atuin init fish --disable-up-arrow

# Machine-specific local config.
test -f $XDG_CONFIG_HOME/fish/local.fish; and source $XDG_CONFIG_HOME/fish/local.fish
