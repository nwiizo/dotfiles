---
name: home-validate-on-oss
description: 開発中ツールを代表的な実プロジェクトで検証し、誤検出・クラッシュ・処理時間を調べる。実プロジェクト検証の明示依頼に使う。
disable-model-invocation: true
---

# Validate Against Real Inputs

Choose the behavior to measure and a representative set for supported languages
and structures. Prefer suitable existing checkouts.
For downloads use an isolated temporary directory and record revisions.
Determine expected behavior from requirements and inspected cases, rather than
project reputation or attractive scores.

Record tool revision, command, input size, and results.
Reproduce concrete failures before fixing them and inspect source behind findings.
Reduce useful cases to maintainable regressions, respecting source licenses.

Rerun affected cases after a fix. Expand the sample for new evidence or a requested
generalization claim. Stop at the accepted criteria.
Report tested revisions, coverage, observed performance, fixes, and limitations;
one project's success does not establish broad applicability.
