---
name: home-self-review
description: 指定された変更を実装側と異なるAI CLIで独立レビューする。レビューの依頼や、独立確認が必要な具体的懸念があるときに使う。
---

# Review Through the Other AI Client

If the prompt begins `This is a delegated peer review.` or
`HOME_SELF_REVIEW_DELEGATED=1`, review the supplied target read-only and return
findings, or `No findings.`. Do not delegate again.

Resolve the requested target: working diff plus untracked files by default,
staged diff, an explicit commit, branch comparison, PR, or file.
Confirm the comparison base instead of assuming every branch uses origin/main.

Choose the requested perspective: code, simplify, rust, cli, design,
constructive, or second. `codex` is an alias for second.
Use all perspectives only for an explicit `all` request; reject unknown names.

Use the runtime product to select the opposite client:
Codex calls Claude Code; Claude Code calls Codex.
Pass the target, raw diff, scope, and finding-ID prefix without the implementer's
preferred conclusion. Prefix instructions with the delegated-review marker and
set its environment guard only on that child process.

For Claude, send the raw diff through stdin and instructions through
`--append-system-prompt`. Select the corresponding `home-*-reviewer` persona
and use `--disable-slash-commands --permission-mode dontAsk
--tools "Read,Grep,Glob" --no-session-persistence`.
Second uses the code reviewer with an independent final-check perspective.

For Codex, use `codex exec review --ephemeral` with the matching uncommitted,
base, or commit target. For other inputs use
`codex exec --ephemeral --sandbox read-only`.
Check installed help if supported flags differ; keep read-only permissions.

Poll a running process rather than launching the same review twice.
Success requires exit code 0 and nonempty final output.
Report unavailable clients, authentication failures, timeouts, and empty output;
do not silently substitute a same-product agent.

Validate findings against code. Review-only requests return findings;
requested fixes use [finding resolution](../nwiizo-coding-style/references/review-findings.md)
and actual verification.
