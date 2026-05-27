function update_all -d "Update tools with their native managers"
    argparse h/help no-brew no-mise no-claude no-rust no-nvim -- $argv
    or return 2

    if set -q _flag_help
        echo "usage: update_all [--no-brew] [--no-mise] [--no-claude] [--no-rust] [--no-nvim]"
        echo
        echo "  --no-brew    skip Homebrew update/upgrade/cleanup"
        echo "  --no-mise    skip mise-managed tool updates"
        echo "  --no-claude  skip Claude CLI update"
        echo "  --no-rust    skip rustup update"
        echo "  --no-nvim    skip Lazy.nvim plugin sync"
        return 0
    end

    if test (count $argv) -gt 0
        echo "update_all: unexpected argument: $argv[1]" >&2
        echo "usage: update_all [--no-brew] [--no-mise] [--no-claude] [--no-rust] [--no-nvim]" >&2
        return 2
    end

    echo "Updating tools..."

    if set -q _flag_no_brew
        echo "Homebrew skipped (--no-brew)."
    else if type -q brew
        echo "Homebrew..."
        brew update
        and brew upgrade
        and brew cleanup
        or return $status
    else
        echo "Homebrew skipped (brew not found)."
    end

    if set -q _flag_no_mise
        echo "mise skipped (--no-mise)."
    else if type -q mise
        echo "mise tools..."
        mise upgrade
        or return $status
    else
        echo "mise skipped (mise not found)."
    end

    if set -q _flag_no_claude
        echo "Claude CLI skipped (--no-claude)."
    else if type -q claude
        echo "Claude CLI..."
        claude update
        or return $status
    else
        echo "Claude CLI skipped (claude not found)."
    end

    if set -q _flag_no_rust
        echo "Rust skipped (--no-rust)."
    else if type -q rustup
        echo "Rust..."
        rustup update
        or return $status
    else
        echo "Rust skipped (rustup not found)."
    end

    if set -q _flag_no_nvim
        echo "Neovim plugins skipped (--no-nvim)."
    else if type -q nvim
        echo "Neovim plugins..."
        nvim --headless "+Lazy! sync" +qa 2>/dev/null
        or return $status
    else
        echo "Neovim plugins skipped (nvim not found)."
    end

    echo "Done!"
end
