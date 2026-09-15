function git_tv_branch -d "Pick a local Git branch with Television, then switch"
    type -q git; and type -q tv; or return 1

    set -l branches (git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/)
    or return
    test (count $branches) -gt 0; or return 0

    set -l selected (printf '%s\n' $branches | tv --inline --no-remote --no-preview --no-sort \
        --input-header 'Git branch' --keybindings 'tab="select_next_entry";backtab="select_prev_entry"')
    test $status -eq 0; or return 0
    test -n "$selected"; or return 0
    git switch -- "$selected"
end
