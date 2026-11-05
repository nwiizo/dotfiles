# Run: fish --no-config fish/tests/herdr_completion.fish
# Uses native Fish startup and the installed Herdr/Carapace completion providers.
if contains -- --child $argv
    function expect_candidate --argument-names input expected
        set -l candidates (complete --do-complete "$input" | string split --fields 1 \t)
        if not contains -- "$expected" $candidates
            printf 'FAIL: %s must offer %s\n' "$input" "$expected" >&2
            printf '%s\n' $candidates >&2
            exit 1
        end
    end

    expect_candidate 'herdr --ma' --machine
    expect_candidate 'herdr agent ' start
    expect_candidate 'herdr agent start --ki' --kind
    expect_candidate 'herdr agent start --kind ' codex
    expect_candidate 'herdr config ' check
    if complete --do-complete 'herdr --no-sess' | string match --quiet --regex '^--no-session(\t|$)'
        echo 'FAIL: completion offers the removed --no-session option' >&2
        exit 1
    end
    echo 'PASS: Herdr commands and arguments match the installed CLI'
    exit 0
end

set -l repo_root (path resolve (path dirname (status filename))/../..)
set -l test_file (path resolve (status filename))
set -gx HERDR_COMPLETION_TEST_DIR (mktemp -d /tmp/fish-herdr-completion.XXXXXX)
or exit 1
function cleanup_herdr_completion_test --on-event fish_exit
    rm -rf -- "$HERDR_COMPLETION_TEST_DIR"
end

set -l test_home "$HERDR_COMPLETION_TEST_DIR/home"
mkdir -p "$test_home/.config/fish" "$test_home/.local/share" \
    "$test_home/.local/state" "$test_home/.cache" "$HERDR_COMPLETION_TEST_DIR/workspace"
ln -s "$repo_root/fish/config.fish" "$test_home/.config/fish/config.fish"
ln -s "$repo_root/fish/functions" "$test_home/.config/fish/functions"
ln -s "$repo_root/fish/conf.d" "$test_home/.config/fish/conf.d"

# local.fish, universal variables, histories, and account settings are not copied.
cd "$HERDR_COMPLETION_TEST_DIR/workspace"; or exit 1
env -i PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin \
    TERM=xterm-256color LANG=en_US.UTF-8 HOME="$test_home" \
    XDG_CONFIG_HOME="$test_home/.config" XDG_DATA_HOME="$test_home/.local/share" \
    XDG_STATE_HOME="$test_home/.local/state" XDG_CACHE_HOME="$test_home/.cache" \
    HERDR_CONFIG_PATH="$test_home/.config/herdr/config.toml" \
    fish --private --interactive --command 'source "$argv[1]" --child' -- "$test_file"
exit $status
