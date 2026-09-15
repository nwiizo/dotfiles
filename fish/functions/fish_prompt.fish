# Catppuccin Mocha prompt using Fish's native Git and path helpers.
# Completed commands collapse to ❯ via fish_transient_prompt.
function fish_prompt
    set -l last_status $status
    set -l last_pipestatus $pipestatus
    set -l last_duration $CMD_DURATION

    set -l c_red f38ba8
    set -l c_green a6e3a1
    set -l c_yellow f9e2af
    set -l c_blue 89b4fa
    set -l c_lavender b4befe
    set -l c_frame 7f849c
    set -l c_status $c_green
    test $last_status -ne 0; and set c_status $c_red

    # Keep text separate from set_color: it may produce nothing with NO_COLOR.
    if contains -- --final-rendering $argv
        set_color --bold $c_status
        printf '❯ '
        set_color normal
        return
    end

    printf '\n'
    set_color $c_frame
    printf '╭─ '

    # Native prompt_pwd shortens and sanitizes the path around the repo root.
    set -l git_root (command git rev-parse --show-toplevel 2>/dev/null)
    set_color $c_lavender
    if test -n "$git_root"
        set -l parent (prompt_pwd --dir-length 1 --full-length-dirs 0 -- (path dirname "$git_root"))
        set -l repo_name (path basename "$git_root" | string replace -ra '[[:cntrl:]]' '')
        printf '%s/' "$parent"
        set_color --bold $c_blue
        printf '%s' "$repo_name"
        set_color normal
        if test "$PWD" != "$git_root"
            set -l rel_path (string replace -- "$git_root/" '' "$PWD")
            set_color $c_lavender
            printf '/%s' (prompt_pwd --dir-length 1 --full-length-dirs 1 -- "$rel_path")
        end
    else
        printf '%s' (prompt_pwd --dir-length 1 --full-length-dirs 1)
    end
    set_color normal

    fish_git_prompt '   %s'

    set -l job_count (count (jobs -p))
    if test $job_count -gt 0
        set_color $c_blue
        printf '  &%s' "$job_count"
        set_color normal
    end

    if test -n "$last_duration"; and test "$last_duration" -gt 2000
        set -l secs (math --scale=0 "$last_duration / 1000")
        set_color $c_yellow
        if test $secs -ge 3600
            printf '  %sh%sm%ss' (math --scale=0 "$secs / 3600") (math --scale=0 "$secs % 3600 / 60") (math --scale=0 "$secs % 60")
        else if test $secs -ge 60
            printf '  %sm%ss' (math --scale=0 "$secs / 60") (math --scale=0 "$secs % 60")
        else
            printf '  %ss' "$secs"
        end
        set_color normal
    end

    if test $last_status -ne 0
        set_color $c_red
        if test (count $last_pipestatus) -gt 1
            printf '  ✗ [%s]' (string join '|' $last_pipestatus)
        else
            printf '  ✗ %s' "$last_status"
        end
        set_color normal
    end

    printf '\n'
    set_color $c_frame
    printf '╰─'
    set_color --bold $c_status
    printf '❯ '
    set_color normal
end
