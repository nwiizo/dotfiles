function ai_context -d "Generate bounded project context for AI tools"
    argparse 'd/depth=' 'l/lines=' -- $argv
    or return 2

    set -l target (pwd)
    test (count $argv) -gt 0; and set target $argv[1]

    set -l depth 3
    set -q _flag_depth; and set depth $_flag_depth

    set -l max_lines 80
    set -q _flag_lines; and set max_lines $_flag_lines

    set -l root (git -C $target rev-parse --show-toplevel 2>/dev/null)
    test -n "$root"; and set target $root

    echo "# AI Context"
    echo ""
    echo "- Project: "(basename $target)
    echo "- Path: $target"
    echo "- Generated: "(date -u +"%Y-%m-%dT%H:%M:%SZ")

    if git -C $target rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "- Branch: "(git -C $target branch --show-current 2>/dev/null)
        echo ""
        echo "## Git Status"
        echo '```'
        git -C $target status --short
        echo '```'

        echo ""
        echo "## Recent Commits"
        echo '```'
        git -C $target log --oneline -8
        echo '```'

        echo ""
        echo "## Change Summary"
        echo '```'
        git -C $target diff --stat
        echo '```'
    end

    echo ""
    echo "## File Structure"
    echo '```'
    if type -q eza
        eza --tree --level=$depth --icons=never --git-ignore $target 2>/dev/null
    else if type -q fd
        fd --hidden --type f --exclude .git --exclude node_modules --exclude target --exclude .direnv . $target | sed "s|^$target/||" | head -120
    else if type -q rg
        rg --files --hidden --glob '!.git/*' --glob '!node_modules/*' --glob '!target/*' $target | sed "s|^$target/||" | head -120
    end
    echo '```'

    set -l important_files \
        AGENTS.md CLAUDE.md CLAUDE.local.md README.md \
        .github/copilot-instructions.md \
        flake.nix home.nix package.json pyproject.toml Cargo.toml go.mod deno.json \
        Makefile Justfile

    for f in $important_files
        set -l path "$target/$f"
        if test -f "$path"
            echo ""
            echo "## $f"
            echo '```'
            head -n $max_lines "$path"
            echo '```'
        end
    end
end
