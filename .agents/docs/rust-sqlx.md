# sqlx Patterns

## Pool Configuration
```rust
let pool = PgPoolOptions::new()
    .max_connections(10)
    .acquire_timeout(Duration::from_secs(3))
    .connect(&database_url).await?;
```

## Startup Migration
```rust
pub static MIGRATOR: sqlx::migrate::Migrator = sqlx::migrate!("./migrations");

// main.rs
MIGRATOR.run(&pool).await?;
```

## Compile-time Queries
```rust
sqlx::query_as!(Row, r#"SELECT id, status as "status: StatusType" FROM t WHERE id = $1"#, id)
    .fetch_optional(&self.pool).await?;
```

## Offline Mode (CI/CD)
```bash
DATABASE_URL="postgres://..." cargo sqlx prepare --workspace
git add .sqlx/
```

## Test Pattern
```rust
#[cfg(test)]
pub static MIGRATOR: sqlx::migrate::Migrator = sqlx::migrate!("../../migrations");

#[sqlx::test(migrator = "crate::MIGRATOR")]
async fn test_query(pool: sqlx::PgPool) -> sqlx::Result<()> {
    // Auto-rollback, no cleanup needed
    Ok(())
}
```

## QueryBuilder (Dynamic Queries)
```rust
let mut qb = sqlx::QueryBuilder::new("SELECT * FROM users WHERE 1=1");
if let Some(name) = &filter.name {
    qb.push(" AND name = ").push_bind(name);
}
let rows = qb.build_query_as::<UserRow>().fetch_all(&pool).await?;
```

## UNNEST Bulk Insert
```rust
sqlx::query!(r#"
    INSERT INTO t (name, value)
    SELECT name, value FROM UNNEST($1::TEXT[], $2::INT[]) AS t(name, value)
"#, &names, &values).execute(&mut **tx).await?;
```

## Keyset Pagination (base64 cursor)
```rust
use base64::{engine::general_purpose::STANDARD, Engine};

pub fn encode_cursor(id: &str) -> String { STANDARD.encode(id) }
pub fn decode_cursor(token: &str) -> Option<String> {
    STANDARD.decode(token).ok().and_then(|b| String::from_utf8(b).ok())
}

// Query: WHERE id > $cursor ORDER BY id LIMIT $page_size
```

## Optimistic Locking
```sql
SELECT * FROM tasks WHERE status = 'pending' ORDER BY id LIMIT 1 FOR UPDATE SKIP LOCKED
```

## PostGIS
```rust
// <-> for index-assisted ordering, ST_Distance for accuracy
sqlx::query_as!(Row, r#"
    SELECT *, ST_Distance(location, ST_SetSRID(ST_MakePoint($1, $2), 4326)::GEOGRAPHY) AS distance
    FROM station ORDER BY location <-> ST_SetSRID(ST_MakePoint($1, $2), 4326)::GEOGRAPHY LIMIT $4
"#, lon, lat, threshold, limit)
```

## Repository + mockall
```rust
#[cfg_attr(test, automock)]
#[async_trait]
pub trait UserRepository: Send + Sync {
    async fn find_by_id(&self, id: &str) -> Result<Option<User>>;
}
```

## Notes
- `cargo sqlx prepare` after query changes
- Type cast `as "col: Type"` in query_as!
- UNNEST needs explicit cast (`$1::TEXT[]`)
- Enum: `#[sqlx(type_name = "text", rename_all = "snake_case")]`
