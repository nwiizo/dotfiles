# Optimized config.fish with original environment variables
# Last updated: 2024-08-30

# ===== 1. Environment Variables =====
set GOPATH $HOME/go
set GOROOT $HOME/go
set DOCKER_BUILDKIT 1
set -x GO111MODULE on
set -x GOPROXY direct
set -x GOSUMDB off
set -x USE_GKE_GCLOUD_AUTH_PLUGIN True

# Homebrew
set -gx HOMEBREW_PREFIX "/opt/homebrew"
set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar"
set -gx HOMEBREW_REPOSITORY "/opt/homebrew"

# ===== 2. PATH Configuration =====
set -gx PATH $PATH $HOME/.krew/bin $GOPATH/bin $GOROOT/bin /usr/local/kubebuilder/bin $HOME/.istioctl/bin $HOME/.local/bin "/opt/homebrew/bin" "/opt/homebrew/sbin"
set -q MANPATH; or set MANPATH ''; set -gx MANPATH "/opt/homebrew/share/man" $MANPATH
set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH

# ===== 3. Theme and Colors =====
set -g fish_prompt_pwd_dir_length 0
set -g theme_newline_cursor yes
set -g theme_display_git_master_branch yes
set -g theme_color_scheme dracula
set -g theme_display_date no
set -g theme_display_cmd_duration no

# ===== 4. Aliases =====
# Git aliases
alias gf='git commit --amend --no-edit'
alias gb='gh browse'
alias gl='git log --graph --decorate --pretty=oneline --abbrev-commit'
alias gs='git status'
alias ga='git add'
alias gp='git push'
alias gpl='git pull'

# Kubernetes aliases
alias k='kubectl'

# Vim aliases
alias vim='nvim'
alias vi='nvim'

# ===== 5. Functions =====
# ghq + peco repository selection
function ghq_peco_repo
    set selected_repository (ghq list -p | peco --query "$LBUFFER")
    if [ -n "$selected_repository" ]
        cd $selected_repository
        echo " $selected_repository "
        commandline -f repaint
    end
end

# Update all development tools
function update_all
    echo "Updating Homebrew..."
    brew update && brew upgrade
    echo "Updating asdf plugins..."
    asdf plugin update --all
    echo "Updating global npm packages..."
    npm update -g
    echo "Updating Rust..."
    rustup update
    echo "All updates complete!"
end

# System information display (on-demand function)
function sysinfo
    echo "CPU Usage: "(top -l 1 | grep "CPU usage" | awk '{print $3}')
    echo "Memory Usage: "(top -l 1 | grep "PhysMem" | awk '{print $2}')
    echo "Disk Usage: "(df -h / | awk 'NR==2 {print $5}')
end

# ===== 6. Key Bindings =====
function fish_user_key_bindings
    bind \cr peco_select_history # Bind for peco history to Ctrl+r
    bind /cg ghq_peco_repo
end

# ===== 7. Plugin and Tool Integration =====
# Fish plugins
set fish_plugins theme peco git rbenv rails brew bundler gem osx pbcopy better-alias gi peco z tmux

# Homebrew
eval (/opt/homebrew/bin/brew shellenv)

# asdf version manager
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# Google Cloud SDK
source "$(brew --prefix)/share/google-cloud-sdk/path.fish.inc"
if [ -f '/private/tmp/google-cloud-sdk/path.fish.inc' ]
    source '/private/tmp/google-cloud-sdk/path.fish.inc'
end

# GitHub CLI completion
eval (gh completion -s fish| source)

# ===== 8. Performance Optimization =====
# Disable greeting message
set -g fish_greeting

# ===== 9. Custom Project Settings =====
# Load project-specific configurations
for conf in ~/.config/fish/conf.d/*.fish
    source $conf
end

# ===== 10. Finalization =====
if status is-interactive
    # Initialize custom completions
    complete -f -c git -a '(__fish_git_aliases)'
end

# End of config.fish
