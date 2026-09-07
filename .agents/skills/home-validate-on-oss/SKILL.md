---
name: home-validate-on-oss
description: 開発中のツールを代表的な実プロジェクトで検証し、誤検出・クラッシュ・処理時間を改善する。OSSでの実用性や一般化可能性の確認を明示的に求められたときに使う。
disable-model-invocation: true
---

# Validate a Tool on Real Projects

Use this workflow when behavior on real projects is part of the success criteria.
Ordinary implementation and its unit tests do not require an external repository sweep.

## Select Evidence

1. Define what is being measured: correctness, false positives, actionable output, runtime, or memory.
2. Select a small representative set based on supported languages and project structure. Existing local checkouts are preferable when suitable.
3. For downloaded fixtures, create an isolated temporary directory with `mktemp -d`, record the repository revision, and keep the user's working trees untouched.
4. Decide the expected behavior from documented requirements or inspected cases. Never assign expected grades based on a project's reputation.

Rust tools may use projects such as bat, fd, ripgrep, eza, or tokei when those inputs fit the tool. They are examples, not a required suite.

## Iterate from Failures

- Run the current tool and its own tests first. Record the command, revision, input size, and observed outcome.
- Reproduce a concrete failure before editing. Fix crashes and incorrect results before noise or presentation issues.
- Inspect representative findings against the source. Equal grades or a long runtime are not failures without a relevant acceptance criterion.
- Reduce a useful failing case to a maintainable regression test when possible; respect the source project's license.
- Rerun affected cases after a fix. Broaden the sample only when a new failure or an explicit generalization claim warrants it.
- Stop when the agreed criteria pass. Do not create modes, flags, or formatting variants merely because another tool once needed them.

## Output

Report the tested revisions, commands, coverage, concrete failures and fixes, and remaining limits.
Separate observed performance from estimates and one-project results from broader claims.
Do not claim a tool is validated solely because it produced attractive scores.
