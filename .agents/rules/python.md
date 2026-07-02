---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
---

# Python Rules

- **ONLY `uv`**, NEVER `pip install`
- Type hints required for all functions
- Quality: `uv run --frozen ruff format . && uv run --frozen ruff check . && uv run --frozen pytest`
