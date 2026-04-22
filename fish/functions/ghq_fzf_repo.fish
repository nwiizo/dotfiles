function ghq_fzf_repo -d "Select repository with fzf"
    type -q ghq; and type -q fzf; or return 1

    set -l selected (ghq list -p | fzf \
        --prompt="Repository: " \
        --preview='eza -la --icons --git {}' \
        --preview-window=right:50%:wrap)

    test -n "$selected"; and cd $selected; and commandline -f repaint
end
