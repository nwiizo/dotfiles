function gpane --description 'Launch the Homebrew-managed gpane formula'
    set -l gpane_prefix (brew --prefix gpane)
    command "$gpane_prefix/bin/gpane" $argv
end
