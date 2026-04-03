# Catppuccin Mocha prompt — replaces Starship
#
# Layout:
#   [line1] dir  branch status  jobs duration  exit
#   [line2] ❯

function fish_prompt
    set -l last_status $status
    set -l last_pipestatus $pipestatus
    set -l last_duration $CMD_DURATION

    # Catppuccin Mocha palette
    set -l c_red f38ba8
    set -l c_green a6e3a1
    set -l c_yellow f9e2af
    set -l c_blue 89b4fa
    set -l c_lavender b4befe
    set -l c_mauve cba6f7
    set -l c_maroon eba0ac

    # Transient prompt: ❯ only
    if contains -- --final-rendering $argv
        if test $last_status -eq 0
            echo -n (set_color --bold $c_green)'❯ '(set_color normal)
        else
            echo -n (set_color --bold $c_red)'❯ '(set_color normal)
        end
        return
    end

    # Newline before prompt (separates from previous command output)
    echo

    # ── Directory with repo root highlighting ──
    set -l git_root (git rev-parse --show-toplevel 2>/dev/null)

    if test -n "$git_root"
        set -l repo_name (path basename $git_root)
        set -l cwd (pwd)
        # Path before repo root (abbreviated)
        set -l parent (string replace $HOME '~' (path dirname $git_root))
        set -l abbreviated_parent (string replace -ar '([^/])[^/]+/' '$1/' $parent)

        if test "$cwd" = "$git_root"
            echo -n (set_color $c_lavender)$abbreviated_parent/(set_color --bold $c_blue)$repo_name(set_color normal)
        else
            set -l rel_path (string replace "$git_root/" '' $cwd)
            # Abbreviate intermediate dirs to 1 char, keep last full
            set -l parts (string split '/' $rel_path)
            set -l display_parts
            for i in (seq (count $parts))
                if test $i -eq (count $parts)
                    set -a display_parts $parts[$i]
                else
                    set -a display_parts (string sub -l 1 $parts[$i])
                end
            end
            echo -n (set_color $c_lavender)$abbreviated_parent/(set_color --bold $c_blue)$repo_name(set_color normal)(set_color $c_lavender)/(string join '/' $display_parts)(set_color normal)
        end
    else
        echo -n (set_color $c_lavender)(prompt_pwd --dir-length 1 --full-length-dirs 1)(set_color normal)
    end

    # ── Git branch + status ──
    echo -n (__fish_git_prompt)

    # ── Jobs ──
    set -l job_count (count (jobs -p))
    if test $job_count -gt 0
        echo -n ' '(set_color $c_blue)' '$job_count(set_color normal)
    end

    # ── Command duration (> 2s) ──
    if test -n "$last_duration" -a "$last_duration" -gt 2000
        set -l secs (math --scale=0 "$last_duration / 1000")
        if test $secs -ge 3600
            set -l h (math --scale=0 "$secs / 3600")
            set -l m (math --scale=0 "$secs % 3600 / 60")
            set -l s (math --scale=0 "$secs % 60")
            echo -n ' '(set_color $c_yellow)"took {$h}h{$m}m{$s}s"(set_color normal)
        else if test $secs -ge 60
            set -l m (math --scale=0 "$secs / 60")
            set -l s (math --scale=0 "$secs % 60")
            echo -n ' '(set_color $c_yellow)"took {$m}m{$s}s"(set_color normal)
        else
            echo -n ' '(set_color $c_yellow)"took {$secs}s"(set_color normal)
        end
    end

    # ── Exit status (pipestatus) ──
    if test $last_status -ne 0
        echo -n ' '(set_color $c_red)' '
        if test (count $last_pipestatus) -gt 1
            echo -n '['(string join '|' $last_pipestatus)']'
        else
            echo -n $last_status
        end
        echo -n (set_color normal)
    end

    # ── Line break + character ──
    echo
    if test $last_status -eq 0
        echo -n (set_color --bold $c_green)'❯ '(set_color normal)
    else
        echo -n (set_color --bold $c_red)'❯ '(set_color normal)
    end
end
