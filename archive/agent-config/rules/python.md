---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
---

# Python Rules

- Use `uv` for Python environments and dependencies; do not use `pip install` or change managers as a side effect of another task.
- Type hints required for all functions
- Use the repository's locked environment and configured formatter, linter, and tests. Prefer `uv run --frozen`; format changed files and test the affected behavior without adding tools solely for a check.
