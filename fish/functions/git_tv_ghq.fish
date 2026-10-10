function git_tv_ghq -d "Pick a Git repository managed by ghq with Television, then cd"
    type -q ghq; and type -q tv; or return 1

    set -l repositories (ghq list --full-path); or return $status
    set -q repositories[1]; or return 0

    # Reuse zoxide's frequency/recency ranking, restricted to ghq roots.
    # Remove matches before appending the unvisited repositories in ghq order.
    set -l ranked
    if type -q zoxide
        for directory in (zoxide query --list 2>/dev/null)
            if set -l index (contains --index -- "$directory" $repositories)
                set -a ranked "$directory"
                set -e repositories[$index]
            end
        end
    end

    set -l selected (printf '%s\n' $ranked $repositories | tv git-repos --no-sort --inline --no-remote \
        --keybindings 'tab="select_next_entry";backtab="select_prev_entry"')
    test $status -eq 0; or return 0

    test -n "$selected"; or return 0
    git -C "$selected" rev-parse --is-inside-work-tree >/dev/null 2>&1; or begin
        echo "git_tv_ghq: not a Git repository: $selected" >&2
        return 1
    end
    cd -- "$selected"
end
