function y -d "Browse files with Yazi and keep its directory on exit"
    set -l tmp (mktemp -t yazi-cwd.XXXXXX); or return 1
    command yazi $argv --cwd-file="$tmp"
    set -l yazi_status $status

    set -l cwd
    if test $yazi_status -eq 0; and read -z cwd < "$tmp"; and test -d "$cwd"; and test "$cwd" != "$PWD"
        builtin cd -- "$cwd"
        set yazi_status $status
    end

    command rm -f -- "$tmp"
    return $yazi_status
end
