
function __complete_terraform
    set -lx COMP_LINE (string join ' ' (commandline -o))
    test (commandline -ct) = ""
    and set COMP_LINE "$COMP_LINE "
    /opt/homebrew/Cellar/tfenv/2.2.2/versions/1.0.0/terraform
end
complete -c terraform -a "(__complete_terraform)"

