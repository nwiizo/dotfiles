---
name: home-terraform-change-review
description: Terraformの差分とplanを利用側の動作へ対応させ、再作成・権限・停止・データ移行・復旧への影響をレビューする。
---

# Read the Plan as an Operational Change

Resolve account/project, workspace, backend, input variables, provider/tool
versions, and the revision that produced the plan. Preserve sensitive values.
Check stale or partial plans and flags that limit observation.

For deletion or replacement, trace stored data, names, endpoints, downtime, and
recovery. In-place updates can still change access or connectivity.
Unknown values remain uncertain until resolved; no replacement is not a safety proof.

For refactoring, map old and new resource addresses, including each count/for_each
instance. Use supported moved blocks and verify unintended destroy/create is absent.
Keep migration declarations while unupgraded consumers still need them.

Distinguish configuration rollback, state repair, data restoration, and consumer
reconnection. A Git revert or state backup does not restore deleted real data.

Use fmt/validate for structure and a current plan for resource effects.
Inspect terraform test run/setup/provider behavior before execution; it can apply.
Detailed plan exit codes mean 0 no diff, 1 error, 2 diff.
Review or local edits do not authorize apply, import, or state mutation.
Report the resource change, user-visible impact, evidence, and remaining checks.
