---
paths:
  - "**/*.go"
  - "**/go.mod"
---

# Go Rules

- Never ignore error returns
- First param: `context.Context` for I/O functions
- Error wrapping: `fmt.Errorf("context: %w", err)`
- Quality: `go fmt ./... && golangci-lint run && go test -race ./...`
