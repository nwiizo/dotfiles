function __tv_z_complete -d "Complete z paths or select a ranked directory after keywords"
    set -l tokens (commandline --current-process --tokenize)
    set -l before_cursor (commandline --cut-at-cursor --current-process --tokenize)
    if test (count $tokens) -le 2; and test (count $before_cursor) -eq 1
        complete --do-complete "'' "(commandline --cut-at-cursor --current-token) | string match --regex -- '.*/$'
    else if test (count $tokens) -eq (count $before_cursor)
        set -l selected (__tv_zoxide --exclude "$PWD" -- $tokens[2..-1] | string collect)
        if test $pipestatus[1] -eq 0; and test -n "$selected"
            commandline --replace -- "cd "(string escape -- "$selected")
            commandline --function repaint execute
        end
    end
end
