---
name: home-data-shape-contract
description: DB・保存ファイル・API・イベント・CLI・MCPツールの入出力を設計するとき、具体例と読み書きの互換性を確認する。
---

# Persisted Data and Public Interfaces

Read existing readers, writers, stored data, and agreed requirements.
For an unresolved structural choice, show concrete values before and after the
change and explain which consumers remain compatible.
Already specified shapes need implementation, not another approval.

Choose named fields when their meaning and evolution matter. Store derived
values only with a reason and an update/recovery strategy.
Check unknown fields and enum values, null versus absent values, and preservation
of meaning across versions.

For migrations, map old/new readers and writers at each stage, including delayed
workers and event replay. Handle partial dual writes, concurrent backfills,
interruption and reruns. Inspect database-version-specific locks and rewrites.
Remove old formats only after accounting for consumers and rollback compatibility.

Verify representative old/new data, mixed versions, and failed migrations.
Distinguish code rollback from recovery of removed data.
Production data mutation needs authorization for that target.

Read [examples](references/samples.md) for design comparisons,
[boundaries](references/pitfalls.md) for null/time/number cases, and
[agent tools](references/agent-tools.md) for authorization, partial results,
side effects, and retries.
