#!/usr/bin/env fish
set -l repo (dirname (status --current-filename))/..
set -l plugin_file "$repo/fish/fish_plugins"
set -l live_plugin_file "$HOME/.config/fish/fish_plugins"

if not test -f "$plugin_file"
    echo "fish_plugins not found: $plugin_file" >&2
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
    rm -f "$live_plugin_file"
end

set -l plugins (string match -rv '^\s*(#|$)' <"$plugin_file")
set -l wanted_base_norm

for plugin in $plugins
    set -l plugin_base (string replace -r '@[^/]+$' '' -- $plugin)
    set -a wanted_base_norm (string lower -- $plugin_base)
end

for plugin in (fisher list 2>/dev/null)
    set -l plugin_base (string replace -r '@[^/]+$' '' -- $plugin)
    set -l base_norm (string lower -- $plugin_base)
    contains -- $base_norm $wanted_base_norm; and continue
    fisher remove $plugin
end

set -l installed_plugins
if test -f "$live_plugin_file"
    set installed_plugins (string match -rv '^\s*(#|$)' <"$live_plugin_file")
end

for plugin in $installed_plugins
    set -l plugin_base (string replace -r '@[^/]+$' '' -- $plugin)
    set -l base_norm (string lower -- $plugin_base)

    if not contains -- $base_norm $wanted_base_norm
        fisher remove $plugin
        continue
    end
end

fisher install $plugins
set -l install_status $status
if test $install_status -ne 0
    exit $install_status
end

set -l normalized_plugins
set -l seen_norm
for plugin in $plugins
    set -l norm (string lower -- $plugin)
    contains -- $norm $seen_norm; and continue
    set -a seen_norm $norm
    set -a normalized_plugins $norm
end
set -U _fisher_plugins $normalized_plugins

exit 0
