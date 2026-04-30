function update_all -d "Update all tools and regenerate cached init scripts"
    echo "Updating all tools..."

    type -q brew; and echo "Homebrew..." && brew update && brew upgrade && brew cleanup
    type -q mise; and echo "mise..." && mise self-update 2>/dev/null && mise upgrade
    type -q claude; and echo "Claude CLI..." && claude update
    type -q rustup; and echo "Rust..." && rustup update
    type -q uv; and echo "uv..." && uv self update
    type -q fisher; and echo "Fisher..." && fisher update 2>/dev/null

    set -l dotfiles_dir $HOME/ghq/github.com/nwiizo/dotfiles
    if type -q nix; and type -q home-manager; and test -f $dotfiles_dir/flake.nix
        echo "Home Manager..."
        pushd $dotfiles_dir >/dev/null
        nix flake update
        and home-manager switch --flake .#nwiizo
        popd >/dev/null
    end

    test -r ~/.config/fish/conf.d/zz_sponge_compat.fish; and source ~/.config/fish/conf.d/zz_sponge_compat.fish
    type -q nvim; and echo "Neovim plugins..." && nvim --headless "+Lazy! sync" +qa 2>/dev/null

    # Regenerate cached tool init scripts (conf.d/)
    echo "Regenerating cached init scripts..."
    set -l conf_d ~/.config/fish/conf.d
    type -q atuin; and atuin init fish --disable-up-arrow >$conf_d/atuin.fish
    type -q direnv; and direnv hook fish >$conf_d/direnv.fish
    type -q zoxide; and zoxide init fish --cmd z >$conf_d/zoxide.fish

    echo "Done!"
end
