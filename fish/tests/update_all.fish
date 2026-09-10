# Run with: fish --no-config fish/tests/update_all.fish
# All updater and Codex processes are test doubles. No network or account access.
set -l fish_dir (path resolve (path dirname (status filename))/..)
set -gx UPDATE_ALL_TEST_FISH (status fish-path)
set -gx UPDATE_ALL_TEST_DIR (mktemp -d)
or exit 1

function cleanup_update_all_test --on-event fish_exit
    rm -rf -- "$UPDATE_ALL_TEST_DIR"
end

function check --argument-names label
    if not $argv[2..]
        echo "FAIL: $label" >&2
        cat "$UPDATE_ALL_TEST_DIR/output" >&2
        exit 1
    end
end

mkdir -p "$UPDATE_ALL_TEST_DIR/bin" "$UPDATE_ALL_TEST_DIR/tmp"
cp "$fish_dir/tests/fixtures/update_all-command" "$UPDATE_ALL_TEST_DIR/command"
chmod +x "$UPDATE_ALL_TEST_DIR/command"
for name in fish mktemp date brew mise codex nvim pipx
    ln -s "$UPDATE_ALL_TEST_DIR/command" "$UPDATE_ALL_TEST_DIR/bin/$name"
end
set -gx PATH "$UPDATE_ALL_TEST_DIR/bin" /usr/bin /bin /usr/sbin /sbin
set -gx TMPDIR "$UPDATE_ALL_TEST_DIR/tmp"
set -g fish_function_path "$fish_dir/functions" $fish_function_path
set -e UPDATE_ALL_CODEX_ACTIVE

set -l skips --no-claude --no-rust --no-nvim --no-mason --no-fisher --no-npm --no-cargo --no-go --no-uv --no-pipx --no-gem --no-mas

set -l pipx_skips --no-brew --no-mise (string match -v -- --no-pipx $skips)
printf '%s\n' 'caller input must not reach a non-interactive updater' >"$UPDATE_ALL_TEST_DIR/input"
for mode in default --non-interactive --parallel
    set -l mode_args $mode
    if test "$mode" = default
        set mode_args
    end
    for input in data closed
        rm -f "$UPDATE_ALL_TEST_DIR/pipx.calls"
        set -l code
        if test "$input" = data
            update_all $mode_args --no-codex $pipx_skips <"$UPDATE_ALL_TEST_DIR/input" >"$UPDATE_ALL_TEST_DIR/output" 2>&1
            set code $status
        else
            update_all $mode_args --no-codex $pipx_skips <&- >"$UPDATE_ALL_TEST_DIR/output" 2>&1
            set code $status
        end
        check "$mode with $input stdin succeeds" test $code -eq 0
        check "$mode with $input stdin runs pipx" test -f "$UPDATE_ALL_TEST_DIR/pipx.calls"
        check "$mode with $input stdin disables prompts" grep -qx 0 "$UPDATE_ALL_TEST_DIR/pipx.interactive"
        check "$mode with $input stdin skips Codex" test ! -f "$UPDATE_ALL_TEST_DIR/codex.calls"
        check "$mode with $input stdin removes success logs" test (count "$TMPDIR"/*) -eq 0
    end
    echo "PASS: $mode isolates updater stdin from caller input and closed descriptors"
end

if isatty stdin; and isatty stdout
    update_all --no-codex $pipx_skips
    check 'terminal updater keeps interactive stdin' test $status -eq 0
    check 'terminal updater enables prompts' grep -qx 1 "$UPDATE_ALL_TEST_DIR/pipx.interactive"
    echo 'PASS: terminal updater keeps interactive stdin'
end

for mode in default --non-interactive --parallel
    set -l mode_args $mode
    if test "$mode" = default
        set mode_args
    end
    set -gx UPDATE_ALL_TEST_BREW_EXIT 7
    set -gx UPDATE_ALL_TEST_MISE_EXIT 8
    set -gx UPDATE_ALL_TEST_CLEANUP_EXIT 0
    set -gx UPDATE_ALL_TEST_CODEX_EXIT 0
    rm -f "$UPDATE_ALL_TEST_DIR/codex.calls"
    update_all $mode_args $skips >"$UPDATE_ALL_TEST_DIR/output" 2>&1
    set -l code $status
    check "$mode preserves updater failure" test $code -eq 1
    check "$mode invokes Codex" test -f "$UPDATE_ALL_TEST_DIR/codex.calls"
    check "$mode invokes Codex once" test (count (cat "$UPDATE_ALL_TEST_DIR/codex.calls")) -eq 1
    check "$mode includes Homebrew failure" grep -q '^失敗した更新: .*Homebrew' "$UPDATE_ALL_TEST_DIR/codex.args"
    check "$mode includes mise failure" grep -q '^失敗した更新: .*mise' "$UPDATE_ALL_TEST_DIR/codex.args"
    check "$mode prevents recursive handoff" grep -qx 1 "$UPDATE_ALL_TEST_DIR/codex.guard"
    check "$mode uses non-interactive Codex" grep -qx exec "$UPDATE_ALL_TEST_DIR/codex.args"
    check "$mode keeps failure logs" test (count "$TMPDIR"/*/homebrew.log) -eq 1
    check "$mode keeps failure status" grep -qx 7 "$TMPDIR"/*/homebrew.status
    rm -rf "$TMPDIR"/*

    rm -f "$UPDATE_ALL_TEST_DIR/codex.calls"
    update_all $mode_args --no-codex $skips >"$UPDATE_ALL_TEST_DIR/output" 2>&1
    check "$mode opt-out returns failure" test $status -eq 1
    check "$mode opt-out skips Codex" test ! -f "$UPDATE_ALL_TEST_DIR/codex.calls"
    rm -rf "$TMPDIR"/*

    set -gx UPDATE_ALL_CODEX_ACTIVE 1
    update_all $mode_args $skips >"$UPDATE_ALL_TEST_DIR/output" 2>&1
    check "$mode recursive invocation returns failure" test $status -eq 1
    check "$mode recursion skips Codex" test ! -f "$UPDATE_ALL_TEST_DIR/codex.calls"
    set -e UPDATE_ALL_CODEX_ACTIVE
    rm -rf "$TMPDIR"/*

    set -gx UPDATE_ALL_TEST_BREW_EXIT 0
    set -gx UPDATE_ALL_TEST_MISE_EXIT 0
    update_all $mode_args $skips >"$UPDATE_ALL_TEST_DIR/output" 2>&1
    check "$mode success returns zero" test $status -eq 0
    check "$mode success skips Codex" test ! -f "$UPDATE_ALL_TEST_DIR/codex.calls"
    check "$mode success removes logs" test (count "$TMPDIR"/*) -eq 0

    set -gx UPDATE_ALL_TEST_CLEANUP_EXIT 9
    update_all $mode_args $skips >"$UPDATE_ALL_TEST_DIR/output" 2>&1
    check "$mode cleanup failure returns failure" test $status -eq 1
    check "$mode cleanup failure invokes Codex" test -f "$UPDATE_ALL_TEST_DIR/codex.calls"
    check "$mode cleanup output is logged" grep -qx 'cleanup output' "$TMPDIR"/*/homebrew-cleanup.log
    check "$mode cleanup status is logged" grep -qx 9 "$TMPDIR"/*/homebrew-cleanup.status
    rm -rf "$TMPDIR"/*

    set -gx UPDATE_ALL_TEST_CODEX_EXIT 42
    update_all $mode_args $skips >"$UPDATE_ALL_TEST_DIR/output" 2>&1
    check "$mode Codex failure preserves updater exit" test $status -eq 1
    check "$mode Codex failure is visible" grep -q 'Codex.*42' "$UPDATE_ALL_TEST_DIR/output"
    rm -rf "$TMPDIR"/*

    rm "$UPDATE_ALL_TEST_DIR/bin/codex" "$UPDATE_ALL_TEST_DIR/codex.calls"
    update_all $mode_args $skips >"$UPDATE_ALL_TEST_DIR/output" 2>&1
    check "$mode missing Codex preserves updater exit" test $status -eq 1
    check "$mode missing Codex is visible" grep -q 'codex.*not found' "$UPDATE_ALL_TEST_DIR/output"
    check "$mode missing Codex keeps logs" test (count "$TMPDIR"/*/homebrew.log) -eq 1
    ln -s "$UPDATE_ALL_TEST_DIR/command" "$UPDATE_ALL_TEST_DIR/bin/codex"
    rm -rf "$TMPDIR"/*
    echo "PASS: $mode failure handoff, opt-out, recursion, success, cleanup, and Codex errors"
end

set -gx UPDATE_ALL_TEST_CODEX_EXIT 0
set -gx UPDATE_ALL_TEST_TIMEOUT 1
set -l timeout_skips (string match -v -- --no-nvim $skips)
update_all --parallel --no-brew --no-mise $timeout_skips >"$UPDATE_ALL_TEST_DIR/output" 2>&1
check 'parallel timeout returns failure' test $status -eq 1
check 'parallel timeout keeps exit 124' grep -qx 124 "$TMPDIR"/*/nvim.status
check 'parallel timeout explains the failure' grep -q 'timed out after 900s' "$TMPDIR"/*/nvim.log
check 'parallel timeout is sent to Codex' grep -q '^失敗した更新: Neovim plugins' "$UPDATE_ALL_TEST_DIR/codex.args"
set -e UPDATE_ALL_TEST_TIMEOUT
echo 'PASS: parallel updater timeout'

mkdir "$UPDATE_ALL_TEST_DIR/direct"
__update_all_codex "$UPDATE_ALL_TEST_DIR/direct" 1 Homebrew
check 'direct handoff succeeds' test $status -eq 0
check 'guard does not leak into the caller' test "$UPDATE_ALL_CODEX_ACTIVE" != 1
if isatty stdin; and isatty stdout
    check 'terminal handoff uses interactive approval' grep -qx on-request "$UPDATE_ALL_TEST_DIR/codex.args"
    check 'terminal handoff does not use exec' test (count (grep -x exec "$UPDATE_ALL_TEST_DIR/codex.args")) -eq 0
    echo 'PASS: interactive Codex handoff'
else
    check 'redirected terminal handoff uses exec' grep -qx exec "$UPDATE_ALL_TEST_DIR/codex.args"
    echo 'PASS: non-terminal Codex fallback'
end
