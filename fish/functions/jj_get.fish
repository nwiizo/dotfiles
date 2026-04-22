function jj_get -d "ghq get <url>, then colocate jj and cd there"
    type -q ghq; and type -q jj; or return 1
    test -n "$argv[1]"; or begin
        echo "usage: jj_get <url>" >&2
        return 2
    end

    ghq get $argv[1]; or return $status

    set -l dest (ghq list -p $argv[1] | head -n 1)
    test -d "$dest"; or begin
        echo "jj_get: could not locate ghq path for $argv[1]" >&2
        return 1
    end

    test -d $dest/.jj; or jj git init --colocate $dest
    cd $dest
    commandline -f repaint
end
