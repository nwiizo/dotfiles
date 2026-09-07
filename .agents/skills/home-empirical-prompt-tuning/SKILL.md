---
name: home-empirical-prompt-tuning
description: 高頻度・高リスクの指示や、期待どおり動かないスキルを、固定した依頼と独立した実行者で比較する。通常の文言整理には静的確認を使い、モデルの振る舞いを確かめたいときに使う。
---

# Evaluate Instruction Changes

Evaluate whether instructions improve observable work, rather than whether
they look comprehensive. Match the evaluation effort to the uncertainty and
consequences of failure.

## Behavioral Comparison

- Freeze representative requests, raw inputs, and observable acceptance criteria
  before comparing versions. Include the ordinary case and a meaningful boundary;
  reserve a separate case when testing generalization matters.
- Use independent subagents for behavioral evaluation when delegation is allowed.
  Give them the task, relevant instruction version, and raw artifacts without
  the proposed fix, desired conclusion, or prior evaluator results.
- Inspect generated artifacts and tool results as well as self-reports.
  Distinguish an instruction defect from missing context or an unavailable tool.
- Compare versions under comparable conditions. Record inherited context and
  tool limitations; fresh agents do not guarantee complete isolation.
- Change instructions in response to an observed problem, then rerun affected
  cases. Keep acceptance criteria fixed instead of redefining a failure as success.
- Stop when the target behavior is supported and further evaluation is unlikely
  to change the decision. Do not require a fixed number of clean iterations or
  stable timing measurements to declare the editing task finished.

Use [evaluation.md](references/evaluation.md) for evidence and stopping decisions,
[dispatch.md](references/dispatch.md) when setting up an evaluator, and
[formats.md](references/formats.md) when reporting a comparison.

For static cleanup, inspect scope, metadata, references, and representative task
routing. If execution is unavailable, report that limit and finish the useful
static work; do not call it behavioral validation. A small evaluation supports
only the tested cases, not a general claim about a newer model's capability.
