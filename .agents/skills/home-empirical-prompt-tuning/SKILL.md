---
name: home-empirical-prompt-tuning
description: 指示の効果を代表的な依頼と固定した評価基準で比較する。高頻度・高リスク・期待どおり動かないスキルの振る舞いを確かめるときに使う。
---

# Evaluate Observable Instruction Effects

Freeze representative requests, raw inputs, and acceptance criteria before
comparing instruction versions. Include an ordinary case and a meaningful
boundary; reserve a separate case when generalization matters.

Validate automated checkers or judges against a known-good artifact and a
plausible defective result before scoring candidates.
Inspect produced artifacts and tool results as well as self-reports.

Use independent evaluators only when delegation is authorized.
Keep task conditions comparable and record inherited context and tool limits.
Distinguish instruction defects, missing context, and unavailable tools.
Change instructions for an observed problem, then rerun affected cases without
moving acceptance criteria.

Use [evaluation](references/evaluation.md) for evidence and stopping,
[dispatch](references/dispatch.md) for authorized evaluation,
[formats](references/formats.md) for reports, and
[trace efficiency](references/trace-efficiency.md) for measured cost and latency.

For static cleanup, validate metadata, references, and representative routing.
Finish useful static work when execution is unavailable and report that limit.
A small comparison supports its tested tasks, rather than a general model ranking.
