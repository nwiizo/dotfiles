function jj_ghq_adopt -d "Colocate jj on every ghq-managed git repo that lacks .jj (--dry-run supported)"
    type -q ghq; and type -q jj; or return 1

    set -l dry 0
    contains -- --dry-run $argv; and set dry 1

    set -l count 0
    for repo in (ghq list -p)
        test -d $repo/.git; or continue
        test -d $repo/.jj; and continue
        set count (math $count + 1)
        if test $dry -eq 1
            echo "would colocate: $repo"
        else
            echo "colocating: $repo"
            jj git init --colocate $repo >/dev/null 2>&1
        end
    end
    echo "jj_ghq_adopt: "(test $dry -eq 1; and echo 'would touch'; or echo 'touched')" $count repo(s)"
end
