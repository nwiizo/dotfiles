# Homebrew installs a vendor hook with the same basename. Keep full activation
# for interactive shells and use shims for scripts and agent commands.
if status is-interactive
    if type -q mise
        __nwiizo_cached_init mise mise activate fish
    end
else
    fish_add_path --path "$HOME/.local/share/mise/shims"
end
