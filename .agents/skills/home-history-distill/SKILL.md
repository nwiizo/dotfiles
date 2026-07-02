---
name: home-history-distill
description: AIエージェント履歴を安全に集計し、再利用できる skills / agents / rules / scripts 候補だけを抽出する。履歴本文を公開せず、秘密情報を先に検出して抽象化したいときに使用。
---

# home-history-distill

Past prompts are useful raw material, but they are not publishable artifacts.
Use this skill to turn local AI history into reusable dotfiles assets without
leaking conversation content.

## Workflow

1. Run the prompt-review collector into `/tmp`, not the repository:

```bash
python3 .agents/skills/prompt-review/scripts/collect.py --days 0 > /tmp/dotfiles-prompt-review-data.json
```

2. Inspect aggregate data first:
   - total messages and tools
   - top projects
   - `secret_warnings`
   - category counts

```bash
python3 scripts/summarize-ai-history.py /tmp/dotfiles-prompt-review-data.json
```

3. If `secret_warnings` is non-empty:
   - do not quote the raw value
   - tell the user which project/tool/timestamp contains a credential-like item
   - recommend rotation or invalidation
   - update detection patterns if the warning came from an uncaught format

4. Extract reusable patterns:
   - repeated multi-step work -> skill
   - specialized read-only judgment -> agent
   - durable always-on convention -> `AGENTS.md` or `.agents/rules/`
   - deterministic local check -> script

5. Write only abstracted instructions. Do not include raw logs, credentials,
   private endpoints, account IDs, customer names, or personal paths.

6. Validate:

```bash
git secrets --scan
./scripts/audit-agent-config.sh
```

## Output

Report the data scope, high-frequency categories, created assets, skipped
candidates, and any secret-warning remediation needed.
