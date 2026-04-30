function ai_commit_msg -d "Generate a conventional commit message from staged changes"
    type -q claude
    or begin
        echo "ai_commit_msg: claude command not found" >&2
        return 127
    end

    set -l diff (git diff --staged 2>/dev/null)
    if test -z "$diff"
        echo "No staged changes"
        return 1
    end

    printf "%s\n" "$diff" | claude -p "Generate one conventional commit message for this diff. Use '<type>(<scope>): <subject>' when a scope is clear. Keep the subject under 72 characters. Output only the message."
end
