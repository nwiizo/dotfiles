# Rust Patterns

## Error Handling
- `thiserror` for libraries, `anyhow` for applications
- Add `is_retryable()` to all custom error types
- Newtype pattern for domain types: `struct Email(String)`

### Hierarchical Error Architecture
```rust
#[derive(thiserror::Error, Debug)]
pub enum AppError {
    #[error(transparent)]
    Domain(#[from] DomainError),
    #[error(transparent)]
    Infra(#[from] InfraError),
}

#[derive(thiserror::Error, Debug)]
pub enum InfraError {
    #[error(transparent)]
    Database(#[from] DatabaseError),
    #[error(transparent)]
    Storage(#[from] StorageError),
}

impl AppError {
    pub fn is_retryable(&self) -> bool {
        matches!(self, Self::Infra(InfraError::Database(DatabaseError::ConnectionLost(_))))
    }
}
```

### PostgreSQL Error Codes
```rust
fn from_sqlx(e: sqlx::Error) -> DatabaseError {
    match e.as_database_error().and_then(|e| e.code()) {
        Some(c) if c == "23505" => DatabaseError::UniqueViolation,
        Some(c) if c == "40001" => DatabaseError::SerializationFailure,
        _ => DatabaseError::Other(e),
    }
}
```

### gRPC Status Mapping
```rust
impl From<AppError> for tonic::Status {
    fn from(e: AppError) -> Self {
        match e {
            AppError::Domain(DomainError::Validation(_)) => Status::invalid_argument(e.to_string()),
            AppError::Domain(DomainError::NotFound(_))   => Status::not_found(e.to_string()),
            AppError::Infra(InfraError::Database(DatabaseError::Timeout(_))) => Status::deadline_exceeded(e.to_string()),
            _ => Status::internal("internal error"),
        }
    }
}
```

## Code Quality Config

### clippy.toml
```toml
cognitive-complexity-threshold = 25
too-many-arguments-threshold = 7
```

### rustfmt.toml
```toml
max_width = 100
imports_granularity = "Module"
group_imports = "StdExternalCrate"
```

## Non-obvious Patterns (from Programming Rust 3rd)
- Vec から値を安全に取り出す: `pop()`, `swap_remove()`, `std::mem::replace()`, `Option::take()` — インデックス直接ムーブは不可
- `Cow<'a, str>` で静的/動的文字列の分岐時にヒープ割り当てを遅延
- `BufWriter` ドロップ時のエラーは無視される — 確実に検知するなら `.flush()` を手動呼び出し
- `Result` イテレータの collect: `.collect::<io::Result<Vec<T>>>()?` — 最初の Err で停止
- `where Self: Sized` で dyn 非互換メソッドを個別除外しつつトレイト全体は dyn 互換に保つ
- 関連型 (`type Item`) は1実装1型、ジェネリックトレイト (`Mul<RHS>`) は複数型との関係
- クロージャの `Fn ⊂ FnMut ⊂ FnOnce` 包含関係 — コールバック格納は `Box<dyn Fn()>`
- `stdin().lock()` でミューテックス取得を1回に — 大量読み取り時のパフォーマンス

## Conventions
- `Arc::clone(&x)` not `x.clone()` — 明示的にコスト低を示す
- `#[allow(dead_code)]` には理由コメント必須
- `pub(crate)` > `pub` for crate-internal items
- `String::with_capacity(n)` — 長さが事前にわかる場合
- `stdin().lock()` — パフォーマンスが必要な場合
- `fs-err` クレート — エラーメッセージにファイル名を含める
- Display 実装 > ToString 実装（Display があれば ToString は自動提供）
