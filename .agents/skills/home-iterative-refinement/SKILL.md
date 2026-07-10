---
name: home-iterative-refinement
description: Build→Test→Feedback→Refineの反復改善ワークフロー。ツール開発時のフィードバックループとOSS検証を支援。
disable-model-invocation: true
---

# Iterative Refinement

Build → Test → Feedback → Refine → Repeat

## Phases

1. **Initial**: コア機能をまず動かす。最適化は後
2. **Internal Test**: 自分のコードベースでテスト。違和感をメモ
3. **Feedback**: テスト結果、実行ログ、実利用の摩擦から次の修正を決める。好みや実利用感などユーザーだけが答えられる点がある場合だけ、判断が変わる質問を1つずつ聞く
4. **Refinement**: 優先度順に修正
   1. Breaking issues → 2. Noise reduction → 3. Clarity → 4. Polish
5. **External Validation**: 一般化可能性が成功条件に含まれる場合だけ、代表的なOSSプロジェクトで検証する（→ `home-validate-on-oss`）

## Common Feedback → Action

| Feedback | Action |
|----------|--------|
| Too much noise | Strict mode, hide low-priority |
| Tables broken | Switch to bullet points |
| Need language support | Add --jp flag |
| Not actionable | Add specific suggestions |

## Learnings Template

```markdown
### What Didn't Work
- {feature}: {why}

### What Worked
- {feature}: {why}

### Key Insight
{one sentence}
```

## Example: cargo-coupling
1. Initial: 全 issue 表示 → 2. Feedback: "60件はノイズ" → 3. Strict mode 追加 → 4. 3件の actionable issue のみ表示
Learning: "Default to actionable, opt-in to verbose"
