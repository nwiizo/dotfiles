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
# Clear only the retired shared values. Otherwise preserve inherited corporate
# or machine-specific settings; Go supplies verified defaults when unset.
test "$GOPATH" = "$HOME/gopath"; and set -e GOPATH
test "$GOPROXY" = direct; and set -e GOPROXY
test "$GOSUMDB" = off; and set -e GOSUMDB

# Containers / Kubernetes
set -gx DOCKER_BUILDKIT 1
set -gx COMPOSE_DOCKER_CLI_BUILD 1
set -gx USE_GKE_GCLOUD_AUTH_PLUGIN True
set -gx KUBECONFIG $HOME/.kube/config

# Locale
set -gx LANG en_US.UTF-8

# Man pages
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx HOMEBREW_AUTO_UPDATE_SECS 3600
set -gx HOMEBREW_UPGRADE_GREEDY 1

# PATH
# Remove the retired custom GOPATH bin inherited by already-running terminals.
set -gx PATH (string match -v -- $HOME/gopath/bin $PATH)
fish_add_path --path $HOME/.cargo/bin
fish_add_path --path $HOME/.krew/bin
fish_add_path --path $HOME/go/bin
fish_add_path --path /usr/local/kubebuilder/bin
fish_add_path --path $HOME/.istioctl/bin

set -q MANPATH; or set MANPATH ''
set -gx MANPATH /opt/homebrew/share/man $MANPATH

set -q INFOPATH; or set INFOPATH ''
set -gx INFOPATH /opt/homebrew/share/info $INFOPATH

test -f "$HOME/.cargo/env.fish"; and source "$HOME/.cargo/env.fish"

# Machine-specific environment overrides must also apply to `fish -c` and Fish
# scripts. Interactive-only work in this file must guard itself.
test -f "$XDG_CONFIG_HOME/fish/local.fish"; and source "$XDG_CONFIG_HOME/fish/local.fish"

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
abbr --add -- gwt 'git worktree'
abbr --add --description='List worktrees and their branches' -- gwl 'git worktree list'
abbr --add --description='Create a separate working directory' -- gwa 'git worktree add'

# Abbreviations: Docker
abbr --add -- d docker
abbr --add -- dc 'docker compose'
abbr --add -- dcu 'docker compose up'
abbr --add -- dcd 'docker compose down'
abbr --add -- dps 'docker ps'
abbr --add -- dcl 'docker compose logs -f'
abbr --add -- dcr 'docker compose restart'
abbr --add -- dcb 'docker compose build'
abbr --add -- dsp 'docker system prune'
abbr --add -- dspunsafe 'docker system prune --all --force'

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
# ローカル例外: この c/cx 設定では「短いaliasは安全な既定にする」規約を無視し、permission bypassで起動する。
abbr --add -- c 'claude --dangerously-skip-permissions'
# cl, not cc: cc is the system C compiler and must stay reachable.
abbr --add -- cl claude
abbr --add -- cr 'claude --resume'
abbr --add -- clp 'claude -p'
abbr --add -- cplan 'claude --permission-mode plan'
abbr --add -- cbare 'claude --bare'
abbr --add -- csafe 'claude --safe-mode'
abbr --add -- cdoc 'claude doctor'
abbr --add -- cagents 'claude agents'
abbr --add -- cultra 'claude ultrareview'

# cctx changes the account for the next plain `claude` invocation.
if command -sq cctx
    command cctx --shell-init fish | source
end
abbr --add -- cx 'codex --dangerously-bypass-approvals-and-sandbox'
abbr --add -- cxq 'codex exec'
abbr --add -- cxs 'codex --sandbox workspace-write --ask-for-approval on-request'
abbr --add -- cxro 'codex --sandbox read-only'
abbr --add -- cxe 'codex exec'
abbr --add -- cxel 'codex exec resume --last'
abbr --add -- cxr 'codex resume'
abbr --add -- cxrl 'codex resume --last'
abbr --add -- cxrev 'codex review --uncommitted'
abbr --add -- cxdoc 'codex doctor'
abbr --add -- cxm 'codex mcp list'
abbr --add -- actx ai_context
abbr --add -- actxc 'ai_context | pbcopy'
abbr --add -- arv ai_review
abbr --add -- acm ai_commit_msg
abbr --add -- apr ai_pr

# Abbreviations: agent-assisted development
abbr --add -- ast ast-grep
abbr --add --description='Re-run a command when files change' -- awatch ai_watch
abbr --add -- wx watchexec

# Abbreviations: editor / TUI
abbr --add -- v nvim
abbr --add -- vi nvim
abbr --add -- vim nvim
abbr --add -- lg lazygit

# Abbreviations: misc productivity
# Rust-powered replacements stay interactive and visibly expand before running,
# so scripts retain the native command interfaces.
abbr --add -- cat bat
abbr --add -- grep rg
abbr --add -- ls 'eza --icons --group-directories-first'
abbr --add -- find fd
abbr --add -- du dust
abbr --add -- sed sd
abbr --add -- ps procs
abbr --add -- top btm
abbr --add -- ping gping
abbr --add -- http xh
abbr --add -- hex hexyl
abbr --add -- bench hyperfine
abbr --add -- b bat
abbr --add -- l 'eza --icons --group-directories-first'
abbr --add -- reload 'exec fish'
abbr --add --description='Start a shell without persistent history' -- private 'fish --private'
abbr --add -- myip 'curl -s ifconfig.me'
abbr --add -- listening 'lsof -iTCP -sTCP:LISTEN -n -P'

# Abbreviations: Television shortcuts
abbr --add --description='Find files and directories with a preview' -- ff '__tv_complete paths'
abbr --add --description='Browse Git commits with a diff preview' -- fgl '__tv_complete git-log'
abbr --add --description='Pick changed files with a diff preview' -- fgs '__tv_complete git-diff'
abbr --add --description='Search running processes' -- fp '__tv_complete processes'
abbr --add --description='Inspect shell variables' -- fv '__tv_variables (set --show | psub) (set --names | psub)'
abbr --add --description='Search synced history with Atuin' -- fh 'atuin search -i'
abbr --add --description='Select and switch a local Git branch' -- gb git_tv_branch
abbr --add --description='Select a Kubernetes context' -- kc kubectl_tv_ctx
abbr --add --description='Run a command in a selected container' -- de docker_tv_exec
abbr --add --description='Find a ghq repository and change directory' -- repo git_tv_ghq

# Catppuccin Mocha: global scope keeps the theme out of fish_variables.
set -g fish_prompt_pwd_dir_length 3
set -g fish_color_normal cdd6f4
set -g fish_color_command 89b4fa
set -g fish_color_builtin 89dceb
set -g fish_color_function b4befe
set -g fish_color_keyword cba6f7
set -g fish_color_quote a6e3a1
set -g fish_color_redirection f5c2e7
set -g fish_color_end fab387
set -g fish_color_error f38ba8 --bold
set -g fish_color_param cdd6f4
set -g fish_color_option fab387
set -g fish_color_comment 7f849c
set -g fish_color_selection --background=45475a
set -g fish_color_search_match --background=45475a
set -g fish_color_operator f5c2e7
set -g fish_color_escape eba0ac
set -g fish_color_autosuggestion 9399b2
set -g fish_color_cancel f38ba8
set -g fish_color_valid_path --underline
set -g fish_pager_color_progress cdd6f4 --background=45475a
set -g fish_pager_color_prefix cba6f7 --bold
set -g fish_pager_color_completion cdd6f4
set -g fish_pager_color_description a6adc8
set -g fish_pager_color_selected_background --background=45475a
set -g fish_pager_color_selected_prefix cba6f7 --bold
set -g fish_pager_color_selected_completion cdd6f4
set -g fish_pager_color_selected_description bac2de

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
if type -q zoxide
    __nwiizo_cached_init zoxide zoxide init fish --no-cmd
    # Keep zoxide's ranking/hooks, with Television's autoloaded zi picker.
    alias z __zoxide_z
    complete --erase --command z
    complete --command z --no-files --arguments '(__tv_z_complete)'
end
# Keep Fish's native Git completion, which handles non-ASCII paths correctly.
set -gx CARAPACE_EXCLUDES git
type -q carapace; and __nwiizo_cached_init carapace-excluding-git carapace _carapace fish
# Atuin records history and powers `fh`; Television owns Ctrl-R.
type -q atuin; and __nwiizo_cached_init atuin atuin init fish --disable-up-arrow --disable-ctrl-r
