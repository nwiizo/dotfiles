function ai_review -d "Review staged changes, or unstaged changes when nothing is staged"
    type -q claude
    or begin
        echo "ai_review: claude command not found" >&2
        return 127
    end

    set -l diff (git diff --staged 2>/dev/null)
    if test -z "$diff"
        set diff (git diff 2>/dev/null)
    end

    if test -z "$diff"
        echo "No changes to review"
        return 1
    end

    printf "%s\n" "$diff" | claude -p "Review this diff. Lead with bugs, security issues, regressions, and missing tests. Be concise and cite file paths when possible."
end
