function git_tv_ghq -d "Pick a Git repository managed by ghq with Television, then cd"
    type -q ghq; and type -q tv; or return 1

    set -l selected (tv git-repos --inline --no-remote \
        --keybindings 'tab="select_next_entry";backtab="select_prev_entry"')
    test $status -eq 0; or return 0

    test -n "$selected"; or return 0
    git -C "$selected" rev-parse --is-inside-work-tree >/dev/null 2>&1; or begin
        echo "git_tv_ghq: not a Git repository: $selected" >&2
        return 1
    end
    cd -- "$selected"
end
