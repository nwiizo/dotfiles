function __tv_zoxide -d "Select a ranked zoxide path without changing directory"
    type -q zoxide; and type -q tv; or return 1
    set -l directories (zoxide query --list $argv)
    or return
    set -q directories[1]; or return 0
    set -l preview "eza --all --tree --level=2 --color=always --icons -- '{replace:s/'/'\\\\''/g}'"
    printf '%s\n' $directories | tv --preview-command "$preview" --no-sort --inline --no-remote \
        --input-header Zoxide --keybindings 'tab="select_next_entry";backtab="select_prev_entry"'
end
