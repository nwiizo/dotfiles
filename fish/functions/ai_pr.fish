function ai_pr -d "Generate a PR description from the current branch diff"
    type -q claude
    or begin
        echo "ai_pr: claude command not found" >&2
        return 127
    end

    set -l base (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | string replace 'refs/remotes/origin/' '')
    test -z "$base"; and set base main

    set -l diff (git diff $base...HEAD 2>/dev/null)
    set -l log (git log --oneline $base..HEAD 2>/dev/null)

    if test -z "$diff"
        echo "No changes vs $base"
        return 1
    end

    printf "Commits:\n%s\n\nDiff:\n%s\n" "$log" "$diff" | claude -p "Generate a concise PR description with sections: Summary, Changes, Tests. Mention risks or follow-ups only when they are visible from the diff."
end
