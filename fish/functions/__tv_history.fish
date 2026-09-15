function __tv_history -d "Search current Fish history without executing the selection"
    type -q tv; or return 1
    if not set -q fish_private_mode; or test -z "$fish_private_mode"
        history merge
    end
    set -l query (commandline --current-buffer | string collect)
    set -l preview "printf '%s\\n' '{replace:s/^.*? │ //|replace:s/'/'\\\\''/g}' | fish_indent --ansi"
    # Feed the current shell, including unsaved/private history. NUL keeps multiline commands together.
    set -l selected (history search --null --show-time='%m-%d %H:%M:%S │ ' | tv \
        --source-entry-delimiter '\0' --source-output '{replace:s/^.*? │ //}' --no-sort \
        --preview-command "$preview" --input-header History --input "$query" --inline --no-remote \
        | string collect; test $pipestatus[2] -eq 0)
    if test $status -eq 0; and test -n "$selected"
        commandline --current-buffer --replace -- "$selected"
    end
    commandline --function repaint
end
