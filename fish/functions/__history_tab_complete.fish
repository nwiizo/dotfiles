function __history_tab_complete
    set -l cmd (commandline -b)

    if test -z "$cmd"
        set -l selected (history | fzf --height=40% --layout=reverse --prompt="History: ")

        if test -n "$selected"
            commandline -r "$selected"
            commandline -f repaint
        end
    else
        commandline -f complete
    end
end
