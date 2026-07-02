# Go Patterns

## Preferences
- First param: `context.Context` for I/O functions
- Accept interfaces, return concrete types
- Error wrapping: `fmt.Errorf("context: %w", err)`
- `strings.Builder` for string concatenation

## Quality
```sh
go fmt ./... && golangci-lint run && go test -cover -race ./...
govulncheck ./...   # Vulnerability check
```
