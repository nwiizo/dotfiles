---
name: home-finops-notes
description: AWS・Google Cloud費用調査で、認証・請求・割引の解釈に必要なローカル補助ノートを参照する。調査全体は対応するFinOpsスキルで進める。
---

# Local Cloud Investigation Notes

Use the note for the current question alongside the main investigation workflow.
Reuse working authentication and current evidence. Keep the investigation
read-only; resource changes and discount purchases need target-specific authority.

| Question | AWS | Google Cloud |
|---|---|---|
| Authentication | [auth](references/aws/auth.md) | [auth](references/gcp/auth.md) |
| Billing interpretation | [cost](references/aws/cost_analysis.md) | [cost](references/gcp/cost_analysis.md) |
| Candidate discovery | [patterns](references/aws/detection_patterns.md) | [patterns](references/gcp/detection_patterns.md) |
| Discount coverage | [RI/SP](references/aws/ri_sp_gotchas.md) | [CUD/SUD](references/gcp/cud_sud_gotchas.md) |
| Reports | [reporting](references/aws/reporting.md) | [reporting](references/gcp/reporting.md) |

These are historical operational notes. Verify time-sensitive prices, product
coverage, and restrictions with current official documentation before using them.
State permissions, period, cost definition, and missing coverage.
Keep baseline denominators comparable and deduplicate savings.
Use billing, utilization, and ownership evidence before treating a recommendation
or a stopped resource as a safe saving opportunity.
