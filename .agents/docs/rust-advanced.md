# Rust Advanced

## tonic gRPC

### Service Implementation
```rust
// Rust 1.75+ で async fn in traits が安定化。#[async_trait] は不要
impl MyService for MyServiceImpl {
    async fn get_item(&self, req: Request<GetItemRequest>) -> Result<Response<GetItemResponse>, Status> {
        let inner = req.into_inner();
        let result = self.usecase.get(inner.id).await.map_err(Status::from)?;
        Ok(Response::new(result.into()))
    }
}
```

### Server with Health + Reflection
```rust
let (mut health_reporter, health_service) = tonic_health::server::health_reporter();
health_reporter.set_serving::<MyServiceServer<MyServiceImpl>>().await;

Server::builder()
    .add_service(health_service)
    .add_service(tonic_reflection::server::Builder::configure().register_encoded_file_descriptor_set(FILE_DESCRIPTOR_SET).build()?)
    .add_service(MyServiceServer::new(svc))
    .serve_with_shutdown(addr, shutdown_signal())
    .await?;
```

### buf for Proto Generation
```yaml
# buf.gen.yaml
version: v2
plugins:
  - remote: buf.build/community/neoeinstein-prost
    out: gen
  - remote: buf.build/community/neoeinstein-tonic
    out: gen
```
```sh
buf generate   # build.rs 不要
```

## Async Patterns

### Decision: async が必要か？
I/O bound → yes / CPU bound → `spawn_blocking` / 単純処理 → no

### Exponential Backoff
```rust
struct RetryConfig { max_retries: u32, initial_delay: Duration, max_delay: Duration, multiplier: f64 }

async fn retry<F, Fut, T, E>(config: &RetryConfig, f: F) -> Result<T, E>
where F: Fn() -> Fut, Fut: Future<Output = Result<T, E>>, E: IsRetryable {
    let mut delay = config.initial_delay;
    for attempt in 0..config.max_retries {
        match f().await {
            Ok(v) => return Ok(v),
            Err(e) if !e.is_retryable() => return Err(e),
            Err(_) => { tokio::time::sleep(delay).await; delay = (delay.mul_f64(config.multiplier)).min(config.max_delay); }
        }
    }
    f().await
}
```

### Concurrency Limit
```rust
let sem = Arc::new(Semaphore::new(10));
for item in items {
    let permit = sem.clone().acquire_owned().await?;
    tokio::spawn(async move { process(item).await; drop(permit); });
}
```

### Lock Safety
```rust
// WRONG: lock held across await
let guard = mutex.lock().await;
some_async_op().await; // deadlock risk

// RIGHT: drop before await
let data = { let guard = mutex.lock().await; guard.clone() };
some_async_op().await;
```

## SecretString
```rust
pub struct Config { pub database_url: secrecy::SecretString } // Display → [REDACTED]
pool = PgPool::connect(config.database_url.expose_secret()).await?;
```

## Integer Overflow
```toml
[profile.release]
overflow-checks = true
```
```rust
a.checked_add(b).ok_or(Error::Overflow)?
counter.saturating_add(1)
hash.wrapping_add(value)
```

## Constants Module Structure
```rust
pub mod validation { pub const MAX_NAME_LENGTH: usize = 255; pub const MAX_SIZE: u64 = 10 * 1024 * 1024; }
pub mod pagination { pub const DEFAULT_PAGE_SIZE: i64 = 20; pub const MAX_PAGE_SIZE: i64 = 100; }
pub mod retry { pub const MAX_RETRIES: u32 = 3; pub const INITIAL_DELAY_MS: u64 = 100; pub const MULTIPLIER: f64 = 2.0; }
```

## cargo-mutants (Mutation Testing)
```sh
cargo install --locked cargo-mutants
cargo mutants                    # 全体
cargo mutants -f src/usecase/    # ビジネスロジックのみ
# missed.txt → テスト追加が必要な箇所
```

Priority: usecase/ > error handling > data transformation > config/utils

## Production Checklist
1. `cargo clippy -- -D warnings` pass
2. No `.unwrap()` — use `?` or `.expect("context")`
3. All error types have `is_retryable()`
4. SecretString for credentials
5. `cargo audit` clean
6. Graceful shutdown with `tokio::select!` + `signal::ctrl_c()`
7. `cargo mutants` — missed.txt が空
