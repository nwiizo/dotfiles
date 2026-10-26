# Run: fish --no-config fish/tests/repo_picker.fish
# Exercise real ghq, zoxide, Git, and Television against temporary repositories.
if not set -q REPO_PICKER_TEST_DIR
    set -l sandbox (realpath (mktemp -d)); or exit 1
    env -i HOME="$sandbox/home" XDG_CONFIG_HOME="$sandbox/config" \
        XDG_DATA_HOME="$sandbox/data" XDG_CACHE_HOME="$sandbox/cache" \
        XDG_STATE_HOME="$sandbox/state" REPO_PICKER_TEST_DIR="$sandbox" \
        PATH="$PATH" TERM=dumb MISE_FISH_AUTO_ACTIVATE=0 \
        (status fish-path) --no-config (status filename)
    set -l result $status
    command rm -rf -- "$sandbox"
    exit $result
end

set -g repo_picker_source (path resolve (status dirname)/../..)
source "$repo_picker_source/fish/functions/git_tv_ghq.fish"
set -gx GHQ_ROOT "$REPO_PICKER_TEST_DIR/ghq"
set -gx _ZO_DATA_DIR "$REPO_PICKER_TEST_DIR/zoxide"
mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$GHQ_ROOT"

function fail --argument-names message
    echo "FAIL: $message" >&2
    exit 1
end

set -l unused "$GHQ_ROOT/example.test/owner/a-unused"
set -l visited "$GHQ_ROOT/example.test/owner/m-visited"
set -l frequent "$GHQ_ROOT/example.test/owner/z 'frequent' repo"
for repository in "$unused" "$visited" "$frequent"
    command git init --quiet "$repository"; or fail 'Git fixture creation'
end
set -l unrelated "$REPO_PICKER_TEST_DIR/not-a-repository"
mkdir -p "$unrelated"
command zoxide add -- "$visited" "$frequent" "$frequent" "$unrelated" "$unrelated" "$unrelated"
or fail 'zoxide fixture creation'

set -g repo_picker_calls 0
set -g repo_picker_query ''
function tv
    set -g repo_picker_calls (math $repo_picker_calls + 1)
    command tv --config-file "$repo_picker_source/television/config.toml" \
        --cable-dir "$repo_picker_source/television/cable" \
        $argv --input "$repo_picker_query" --take-1
end

git_tv_ghq </dev/null; or fail 'ranked repository selection'
test "$PWD" = "$frequent"; or fail 'frequent repository should be first, not alphabetical or unrelated paths'

set -g repo_picker_query m-visited
git_tv_ghq </dev/null; or fail 'searching a visited repository'
test "$PWD" = "$visited"; or fail 'visited repository missing from candidates'
set -g repo_picker_query a-unused
git_tv_ghq </dev/null; or fail 'searching an unvisited repository'
test "$PWD" = "$unused"; or fail 'unvisited repository missing from candidates'

# Search quality must outrank visit history once a query is entered.
set -l exact "$GHQ_ROOT/example.test/owner/needle"
set -l partial "$GHQ_ROOT/example.test/owner/needle-tools"
set -l scattered "$GHQ_ROOT/example.test/owner/n-e-e-d-l-e-history"
for repository in "$exact" "$partial" "$scattered"
    command git init --quiet "$repository"; or fail 'search fixture creation'
end
command zoxide add -- "$partial" "$partial" "$scattered" "$scattered" "$scattered"
or fail 'search ranking fixture creation'
set -g repo_picker_query needle
git_tv_ghq </dev/null; or fail 'match-quality repository selection'
test "$PWD" = "$exact"; or fail 'exact repository name should outrank frequent partial and scattered matches'

# Empty/unavailable ranking data must still show every ghq repository.
set -g repo_picker_query ''
set -gx _ZO_DATA_DIR "$REPO_PICKER_TEST_DIR/empty-zoxide"
git_tv_ghq </dev/null; or fail 'selection without history'
test "$PWD" = "$unused"; or fail 'empty history should retain ghq order'

set -l original_pwd $PWD
set -l calls_before $repo_picker_calls
set -gx GHQ_ROOT "$REPO_PICKER_TEST_DIR/empty-ghq"
mkdir -p "$GHQ_ROOT"
git_tv_ghq </dev/null; or fail 'empty ghq list'
test $repo_picker_calls -eq $calls_before; or fail 'empty list opened the picker'
test "$PWD" = "$original_pwd"; or fail 'empty list changed directory'
set -gx GHQ_ROOT "$REPO_PICKER_TEST_DIR/ghq"

function tv
    return 130
end
git_tv_ghq </dev/null
test "$PWD" = "$original_pwd"; or fail 'cancellation changed directory'

function tv
    printf '%s\n' "$REPO_PICKER_TEST_DIR/not-a-repository"
end
git_tv_ghq </dev/null 2>/dev/null; and fail 'non-repository selection was accepted'
test "$PWD" = "$original_pwd"; or fail 'invalid selection changed directory'

function ghq
    return 1
end
git_tv_ghq </dev/null 2>/dev/null; and fail 'ghq failure reported success'

echo repo-picker-ok
