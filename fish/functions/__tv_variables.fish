function __tv_variables -d "Inspect current Fish variables with Television" -a details names
    type -q tv; or return 1
    set -l snapshot (mktemp -d); or return 1
    if test -n "$details"; and test -n "$names"
        command cp -- "$details" "$snapshot/details"
        command cp -- "$names" "$snapshot/names"
    else
        set --show >"$snapshot/details"
        set --names >"$snapshot/names"
    end
    set -l token (commandline --current-token | string collect)
    set -l query (string replace --regex '^\$' '' -- "$token")
    set -l preview 'awk -v name=\'{}\' \'index($0, "$" name ":") == 1 || index($0, "$" name "[") == 1\' '(string escape --style=script -- "$snapshot/details")
    set -l selected (string match --invert history <"$snapshot/names" | tv --input "$query" \
        --input-header Variables --inline --no-remote --preview-command "$preview")
    set -l picker_status $status
    command rm -r -- "$snapshot"
    if test $picker_status -eq 0; and set -q selected[1]
        if string match --quiet '$*' -- "$token"
            set selected \$$selected
        end
        commandline --current-token --replace -- (string join ' ' -- $selected)
    end
    commandline --function repaint
end
