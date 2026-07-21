function ai_watch --description 'Re-run a verification command when an agent edits files'
    if contains -- $argv[1] -h --help
        echo 'usage: ai_watch COMMAND [ARG...]'
        echo 'Re-run COMMAND directly (without a shell) whenever project files change.'
        echo 'example: ai_watch cargo test --all'
        return 0
    end

    if test (count $argv) -eq 0
        echo 'usage: ai_watch COMMAND [ARG...]' >&2
        echo 'example: ai_watch cargo test --all' >&2
        return 2
    end

    set -l watchexec_path (command -s watchexec)
    if test -x /opt/homebrew/bin/watchexec
        set watchexec_path /opt/homebrew/bin/watchexec
    end
    if test -z "$watchexec_path"
        echo 'ai_watch: watchexec is not installed' >&2
        return 127
    end

    command "$watchexec_path" --clear --restart --shell=none -- $argv
end
