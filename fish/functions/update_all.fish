function update_all -d "Update all tools (Home Manager handles fish plugins and tool init scripts)"
    echo "Updating all tools..."

    type -q brew; and echo "Homebrew..." && brew update && brew upgrade && brew cleanup
    type -q mise; and echo "mise..." && mise self-update 2>/dev/null && mise upgrade
    type -q claude; and echo "Claude CLI..." && claude update
    type -q rustup; and echo "Rust..." && rustup update
    type -q uv; and echo "uv..." && uv self update

    set -l dotfiles_dir $HOME/ghq/github.com/nwiizo/dotfiles
    if type -q nix; and type -q home-manager; and test -f $dotfiles_dir/flake.nix
        echo "Home Manager..."
        pushd $dotfiles_dir >/dev/null
        nix flake update
        and home-manager switch --flake .#nwiizo
        popd >/dev/null
    end

    type -q nvim; and echo "Neovim plugins..." && nvim --headless "+Lazy! sync" +qa 2>/dev/null

    echo "Done!"
end
