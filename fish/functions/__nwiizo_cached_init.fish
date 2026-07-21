function __nwiizo_cached_init --description 'Source cached shell integration code'
    if test (count $argv) -lt 3
        echo 'usage: __nwiizo_cached_init CACHE_KEY COMMAND ARG...' >&2
        return 2
    end

    set -l cache_key $argv[1]
    set -l executable $argv[2]
    set -e argv[1..2]

    set -l executable_path (command -s $executable)
    test -n "$executable_path"; or return 127

    set -l cache_dir "$XDG_CACHE_HOME/fish/generated"
    set -l cache_file "$cache_dir/$cache_key.fish"
    set -l cache_header "# command: "(string join ' ' -- (string escape -- $executable_path $argv))
    set -l cached_header
    test -r "$cache_file"; and read -l cached_header <"$cache_file"

    if not test -s "$cache_file"
        or test "$cached_header" != "$cache_header"
        or test "$executable_path" -nt "$cache_file"
        command mkdir -p "$cache_dir"; or return
        set -l temporary_file "$cache_file.$fish_pid.tmp"

        begin
            echo "$cache_header"
            command $executable $argv
        end >"$temporary_file"
        set -l generate_status $status

        if test $generate_status -eq 0; and test -s "$temporary_file"
            command chmod 600 "$temporary_file"
            command mv -f "$temporary_file" "$cache_file"
        else
            command rm -f "$temporary_file"
            return $generate_status
        end
    end

    source "$cache_file"
end
