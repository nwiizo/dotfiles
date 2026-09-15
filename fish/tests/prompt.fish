# Run with: fish --no-config fish/tests/prompt.fish
set -l repo_root (path resolve (path dirname (status filename))/../..)
source "$repo_root/fish/functions/fish_prompt.fish"

# Rendering must keep its text when set_color produces no escape sequences.
set -gx NO_COLOR 1
set -gx TERM dumb
set -g CMD_DURATION 0
set -g prompt_test_failures 0

function assert_contains --argument-names label needle output
    if not string match --quiet --regex -- (string escape --style=regex -- "$needle") "$output"
        printf 'FAIL: %s\nExpected: %s\nActual: %s\n' "$label" "$needle" "$output" >&2
        set -g prompt_test_failures (math $prompt_test_failures + 1)
    end
end

set -l rendered (fish_prompt | string collect)
assert_contains 'directory remains visible without color' (path basename "$PWD") "$rendered"
assert_contains 'input marker remains visible without color' '❯ ' "$rendered"

set -l transient (fish_prompt --final-rendering | string collect)
assert_contains 'transient prompt remains visible without color' '❯ ' "$transient"

function render_failed_prompt
    command false
    fish_prompt
end
assert_contains 'failed commands show the exit code without color' '✗ 1' (render_failed_prompt | string collect)

function render_failed_pipeline
    command true | command false
    fish_prompt
end
assert_contains 'failed pipelines keep all exit codes' '[0|1]' (render_failed_pipeline | string collect)

function render_duration_prompt
    set -g CMD_DURATION 65000
    fish_prompt
end
assert_contains 'duration uses readable units' 1m5s (render_duration_prompt | string collect)

functions --erase assert_contains render_failed_prompt render_failed_pipeline render_duration_prompt
if test $prompt_test_failures -gt 0
    exit 1
end
echo 'prompt tests passed'
