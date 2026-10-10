# Run: fish --no-config fish/tests/install_plugins.fish
# Use the installed Fisher implementation with local fixture plugins; no network.
set -l repo (path resolve (status dirname)/../..)
set -l fisher_source "$HOME/.config/fish/functions/fisher.fish"
test -f "$fisher_source"; or begin
    echo 'Install Fisher before running the plugin installer checks.' >&2
    exit 1
end

set -g plugin_test_dir (realpath (mktemp -d)); or exit 1
function cleanup_plugin_test --on-event fish_exit
    command rm -rf -- "$plugin_test_dir"
end
function fail --argument-names message
    echo "FAIL: $message" >&2
    test -f "$plugin_test_dir/log"; and cat "$plugin_test_dir/log" >&2
    exit 1
end

set -l fixture "$plugin_test_dir/repo"
set -l plugin_home "$plugin_test_dir/home"
set -l plugin_config "$plugin_test_dir/config"
mkdir -p "$fixture/scripts" "$fixture/fish" "$plugin_home" "$plugin_config/fish/functions"
cp "$repo/scripts/install-fish-plugins.fish" "$fixture/scripts/"
cp "$fisher_source" "$plugin_config/fish/functions/"

# Child processes have no inherited credentials, user config, caches, or history.
set -g plugin_test_env env -i HOME="$plugin_home" XDG_CONFIG_HOME="$plugin_config" \
    XDG_DATA_HOME="$plugin_test_dir/data" XDG_CACHE_HOME="$plugin_test_dir/cache" \
    XDG_STATE_HOME="$plugin_test_dir/state" PATH=/usr/bin:/bin:/usr/sbin:/sbin \
    TERM=dumb MISE_FISH_AUTO_ACTIVATE=0 (status fish-path)
set -l old "$plugin_test_dir/sample@v1"
set -l new "$plugin_test_dir/sample@v2"
set -l steady "$plugin_test_dir/steady"
set -l retired "$plugin_test_dir/retired"
for plugin in "$old" "$new" "$steady" "$retired"
    mkdir -p "$plugin/functions"
end
printf 'function fixture_version; echo v1; end\n' >"$old/functions/fixture_version.fish"
printf 'function fixture_version; echo v2; end\n' >"$new/functions/fixture_version.fish"
printf 'function fixture_steady; echo steady; end\n' >"$steady/functions/fixture_steady.fish"
printf 'function fixture_retired; echo retired; end\n' >"$retired/functions/fixture_retired.fish"

$plugin_test_env -c 'fisher install $argv' -- "$old" "$steady" "$retired" </dev/null >"$plugin_test_dir/log" 2>&1
or fail 'fixture installation'
printf '# Desired plugins\n%s\n\n%s\n' "$new" "$steady" >"$fixture/fish/fish_plugins"

function run_installer
    $plugin_test_env "$plugin_test_dir/repo/scripts/install-fish-plugins.fish" </dev/null >"$plugin_test_dir/log" 2>&1
end

run_installer; or fail 'switching plugin versions'
test ($plugin_test_env -c fixture_version) = v2; or fail 'new plugin version was not installed'
test ! -e "$plugin_config/fish/functions/fixture_retired.fish"; or fail 'removed plugin files remain'
test ! -e "$plugin_home/.config/fish/fish_plugins"; or fail 'installer ignored XDG_CONFIG_HOME'
set -l installed ($plugin_test_env -c 'fisher list')
contains -- "$new" $installed; or fail 'new version is not registered'
contains -- "$old" $installed; and fail 'old version remains registered'
test (count $installed) -eq 2; or fail 'unexpected plugin registrations'

# A legacy symlink must be detached before Fisher rewrites its live manifest.
rm "$plugin_config/fish/fish_plugins"
ln -s "$fixture/fish/fish_plugins" "$plugin_config/fish/fish_plugins"
set -l desired_before (cat "$fixture/fish/fish_plugins" | string collect)
run_installer; or fail 'reapplying the desired list'
test ! -L "$plugin_config/fish/fish_plugins"; or fail 'live manifest is still a symlink'
test "$desired_before" = (cat "$fixture/fish/fish_plugins" | string collect); or fail 'source manifest was modified'

# Fisher may report overall success when one install conflicts but another updates.
set -l conflict "$plugin_test_dir/conflict"
mkdir -p "$conflict/functions"
printf 'function fixture_user; echo plugin; end\n' >"$conflict/functions/fixture_user.fish"
printf 'function fixture_user; echo user; end\n' >"$plugin_config/fish/functions/fixture_user.fish"
printf '%s\n' "$new" "$steady" "$conflict" >"$fixture/fish/fish_plugins"
run_installer; and fail 'partial installation reported success'
test ($plugin_test_env -c fixture_user) = user; or fail 'user function was overwritten'
set installed ($plugin_test_env -c 'fisher list')
contains -- "$conflict" $installed; and fail 'missing plugin was recorded as installed'

echo 'plugin installer checks passed'
