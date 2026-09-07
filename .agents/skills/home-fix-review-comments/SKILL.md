---
name: home-fix-review-comments
description: 会話中のレビュー指摘を実コードと照合し、妥当なものを修正・検証する。重複した指摘をまとめ、対応しない理由も報告する。
---

# Apply Review Findings

Use the review in the conversation or the user's specified review target.
Check each finding against the actual code, requirements, and relevant evidence;
a reviewer label or severity is not proof that the change is necessary.

Apply valid findings within the requested scope, consolidating duplicates.
For style-only suggestions, prefer consistency with the surrounding code.
Do not turn a rejected finding into an unrelated refactor.

Verify the affected behavior after the edits. Report what was changed and why
other findings were declined or remain unresolved. Preserve finding identifiers
when available so the user can trace decisions back to the review.
Choose a concise format appropriate to the number of findings; no fixed report
template or extra approval round is needed.
