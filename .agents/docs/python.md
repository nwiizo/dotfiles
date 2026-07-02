# Python Patterns

## Constraints
- **ONLY `uv`**, NEVER `pip`
- Type hints required for all functions
- Line length: 88 chars
- Async: `anyio` for testing, not `asyncio`

## Quality
```sh
uv run --frozen ruff format . && uv run --frozen ruff check . --fix
uv run --frozen pyright       # Type check
uv run --frozen pytest --cov  # Test
uv run --frozen bandit -r .   # Security
```
