function __tv_complete -d "Insert Television selections into the current command" -a channel
    type -q tv; or return 1
    set -l query (commandline --current-token --tokens-expanded | string collect)
    set -l current_prompt (commandline --current-process | string collect)
    set -l tv_args --autocomplete-prompt "$current_prompt"
    if test -n "$channel"
        set tv_args $channel
    end
    # Like the former picker, a trailing slash scopes file search to that directory.
    set -l base
    if contains -- "$channel" files paths dirs
        and string match --quiet '*/' -- "$query"
        and test -d "$query"
        set base "$query"
        set -a tv_args "$base"
        set query ''
    end
    set -l selected (tv $tv_args --input "$query" --inline --no-remote)
    if test $status -eq 0; and set -q selected[1]
        if test -n "$base"
            set selected "$base"$selected
        end
        commandline --current-token --replace -- (string join ' ' -- (string escape -- $selected))' '
    end
    commandline --function repaint
end
