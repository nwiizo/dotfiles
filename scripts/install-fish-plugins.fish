#!/usr/bin/env fish
set -l repo (dirname (status --current-filename))/..
set -l plugin_file "$repo/fish/fish_plugins"
set -l live_plugin_file "$HOME/.config/fish/fish_plugins"

if not test -f "$plugin_file"
    echo "fish_plugins not found: $plugin_file" >&2
    exit 1
end

if not functions -q fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
end

if test -L "$live_plugin_file"
    rm -f "$live_plugin_file"
end

set -l plugins (string match -rv '^\s*(#|$)' <"$plugin_file")
set -l wanted_norm

for plugin in (fisher list 2>/dev/null)
    contains -- $plugin $plugins; and continue
    fisher remove $plugin
end

for plugin in $plugins
    set -a wanted_norm (string lower -- $plugin)
end

set -l installed_plugins
if test -f "$live_plugin_file"
    set installed_plugins (string match -rv '^\s*(#|$)' <"$live_plugin_file")
end

for plugin in $installed_plugins
    set -l norm (string lower -- $plugin)

    if not contains -- $norm $wanted_norm
        fisher remove $plugin
        continue
    end
end

fisher install $plugins

set -l normalized_plugins
set -l seen_norm
for plugin in $_fisher_plugins
    set -l norm (string lower -- $plugin)
    contains -- $norm $seen_norm; and continue
    set -a seen_norm $norm
    set -a normalized_plugins $norm
end
set -U _fisher_plugins $normalized_plugins
