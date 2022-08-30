set GOPATH $HOME/go
set GOROOT $HOME/go
set DOCKER_BUILDKIT 1
set -x GO111MODULE on
set -x GOPROXY direct
set -x GOSUMDB off
set -x GOPRIVATE gitlab.com/3-shake/metis/metis.git
set -x KUBECONFIG ./kubeconfig.yaml:/Users/nwiizo/.kube/config
set -gx PATH $PATH $HOME/.krew/bin
set PATH $PATH $GOPATH/bin $GOROOT/bin /usr/local/kubebuilder/bin

# set omf theme-bobthefish
set -g fish_prompt_pwd_dir_length 0
set -g theme_newline_cursor yes
set -g theme_display_git_master_branch yes
set -g theme_color_scheme dracula
set -g theme_display_date no
set -g theme_display_cmd_duration no

# git aliases
alias 'gf'='git commit --amend --no-edit'
alias 'gb'='gh browse'
alias 'gl'='git log --graph --decorate --pretty=oneline --abbrev-commit'

alias k kubectl
alias vim nvim

# Homebrew
set -gx HOMEBREW_PREFIX "/opt/homebrew";
set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar";
set -gx HOMEBREW_REPOSITORY "/opt/homebrew";
set -q PATH; or set PATH ''; set -gx PATH "/opt/homebrew/bin" "/opt/homebrew/sbin" $PATH;
set -q MANPATH; or set MANPATH ''; set -gx MANPATH "/opt/homebrew/share/man" $MANPATH;
set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH;

set fish_plugins theme peco
function fish_user_key_bindings
  bind \cr peco_select_history # Bind for prco history to Ctrl+r
end

eval (gh completion -s fish| source)
set fish_plugins theme git rbenv rails brew bundler gem osx pbcopy better-alias gi peco z tmux

source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/private/tmp/google-cloud-sdk/path.fish.inc' ]; . '/private/tmp/google-cloud-sdk/path.fish.inc'; end

# ghq + peco
function ghq_peco_repo
  set selected_repository (ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_repository" ]
    cd $selected_repository
    echo " $selected_repository "
    commandline -f repaint
  end
end

# fish key bindings
function fish_user_key_bindings
  bind /cg ghq_peco_repo
end

