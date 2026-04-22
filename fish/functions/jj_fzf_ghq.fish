function jj_fzf_ghq -d "Pick any ghq repo with fzf; offer to colocate jj if missing, then cd"
    type -q ghq; and type -q jj; and type -q fzf; or return 1

    # Preview runs through $SHELL (bash/zsh). Keep it POSIX.
    #   .jj  → jj log of @ ancestry
    #   .git → yellow note + git log, signaling a colocate offer on cd
    #   else → directory listing
    set -l preview 'if [ -d {}/.jj ]; then jj --color=always -R {} log -r "::@" --no-graph --limit 15 2>&1; elif [ -d {}/.git ]; then printf "\033[33m[not jj-colocated yet]\033[0m\n\n"; git -C {} log --oneline --color=always -15 2>&1; else eza -la --icons --git {} 2>&1; fi'

    set -l selected (ghq list -p | fzf \
        --prompt="repo: " \
        --preview=$preview \
        --preview-window=right:55%:wrap)

    test -n "$selected"; or return

    # Non-destructive default: any non-yes answer (including empty / EOF
    # / Ctrl-C) skips the colocate step and just cd's.
    if test -d $selected/.git; and not test -d $selected/.jj
        read -l -P "jj: colocate $selected? [y/N] " answer
        switch $answer
            case y Y yes Yes
                jj git init --colocate $selected >/dev/null 2>&1
                or echo "jj_fzf_ghq: colocate failed" >&2
        end
    end

    cd $selected
    commandline -f repaint
end
