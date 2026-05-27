function cat -d "Cat with syntax highlighting" -w bat
    if isatty stdout
        command bat --paging=never $argv
    else
        command bat --paging=never --style=plain $argv
    end
end
