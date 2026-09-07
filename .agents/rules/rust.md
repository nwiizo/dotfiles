---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
---

# Rust Rules

- Propagate recoverable failures with `?`. Reserve `expect("invariant")` for established invariants; changing `unwrap()` to `expect()` alone does not make input handling safe.
- Prefer `Arc::clone(&x)` to make shared ownership explicit.
- `pub(crate)` > `pub` for crate-internal items
- Use the repository's fmt, Clippy, and test commands for affected crates. Preserve its feature matrix and lint policy; do not invent a stricter workspace-wide gate for a local change.
