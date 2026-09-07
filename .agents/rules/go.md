---
paths:
  - "**/*.go"
  - "**/go.mod"
---

# Go Rules

- Never ignore error returns
- Pass `context.Context` first where cancellation, deadlines, or request scope need to propagate; follow the surrounding API.
- Error wrapping: `fmt.Errorf("context: %w", err)`
- Format changed files and run affected package tests and the repository's configured linter. Use `-race` for concurrency changes where supported; do not require an unconfigured linter.
