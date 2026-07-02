---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
---

# Rust Rules

- No `.unwrap()` in production — use `?` or `.expect("context")`
- `Arc::clone(&x)` not `x.clone()` — 明示的にコスト低を示す
- `pub(crate)` > `pub` for crate-internal items
- Quality: `cargo fmt && cargo clippy -- -D warnings && cargo test`
