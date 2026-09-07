function git_fzf_ghq -d "Pick a Git repository managed by ghq with fzf, then cd"
    type -q ghq; and type -q fzf; or return 1

    set -l preview 'if git -C {} rev-parse --is-inside-work-tree >/dev/null 2>&1; then git -C {} log --oneline --decorate --color=always -15 2>&1; else eza -la --icons --git {} 2>&1; fi'
    set -l selected (ghq list --full-path | fzf \
        --prompt='git repo> ' \
        --preview "$preview" \
        --preview-window='right:60%')

    test -n "$selected"; or return 0
    git -C "$selected" rev-parse --is-inside-work-tree >/dev/null 2>&1; or begin
        echo "git_fzf_ghq: not a Git repository: $selected" >&2
        return 1
    end
    cd "$selected"
end
