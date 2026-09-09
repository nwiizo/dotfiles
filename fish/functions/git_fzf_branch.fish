function git_fzf_branch -d "Pick a local Git branch with fzf, then switch"
    type -q git; and type -q fzf; or return 1

    set -l branches (git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/)
    or return
    test (count $branches) -gt 0; or return 0

    set -l selected (printf '%s\n' $branches | fzf --no-multi --prompt='git branch> ')
    test -n "$selected"; or return 0
    git switch -- "$selected"
end
