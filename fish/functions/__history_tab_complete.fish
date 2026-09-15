function __history_tab_complete
    set -l cmd (commandline -b)

    if test -z "$cmd"
        __tv_history
    else
        commandline -f complete
    end
end
