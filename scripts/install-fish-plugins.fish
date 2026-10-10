#!/usr/bin/env fish
set -l repo (dirname (status --current-filename))/..
set -l plugin_file "$repo/fish/fish_plugins"
set -l live_plugin_file "$__fish_config_dir/fish_plugins"

if not test -f "$plugin_file"
    echo "fish_plugins not found: $plugin_file" >&2
    exit 1
end

set -l plugins (string trim <"$plugin_file" | string match -rv '^(#|$)')
if not set -q plugins[1]
    echo "No plugins listed in $plugin_file" >&2
    exit 1
end

if not functions -q fisher
    set -l fisher_url https://raw.githubusercontent.com/jorgebucaran/fisher/a04308be92daa6cfecdbb0ca58b1e8508664cff2/functions/fisher.fish
    set -l fisher_sha256 0fb6c81ae3003e95b5671766fa6c25c3597066e29965b7772f6c1b007387356d
    set -l fisher_tmp (mktemp); or exit 1

    curl -fsSL --output $fisher_tmp $fisher_url; or begin
        rm -f $fisher_tmp
        exit 1
    end

    set -l actual_sha256 (shasum -a 256 $fisher_tmp | string split ' ' --fields 1)
    if test "$actual_sha256" != "$fisher_sha256"
        echo "Fisher bootstrap checksum mismatch" >&2
        rm -f $fisher_tmp
        exit 1
    end

    source $fisher_tmp
    set -l source_status $status
    rm -f $fisher_tmp
    test $source_status -eq 0; or exit $source_status
end

if test -L "$live_plugin_file"
    rm -f "$live_plugin_file"; or exit 1
end

# Fisher reconciles exact refs through its manifest, including removal of an
# old ref before installing the replacement's files. Keep its state private.
mkdir -p "$__fish_config_dir"; or exit 1
printf '%s\n' $plugins >"$live_plugin_file"; or exit 1
fisher update </dev/null; or exit $status

# Fisher can return success after a partial install (for example, one plugin's
# files conflict while another updates). Do not register missing plugins by hand.
set -l expected (string lower -- $plugins | sort -u)
set -l installed (fisher list | string lower | sort -u)
if test "$expected" != "$installed"
    echo "Fish plugin installation incomplete. Resolve the Fisher errors and rerun this script." >&2
    exit 1
end

exit 0
