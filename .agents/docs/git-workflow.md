# Git Workflow

## Worktree Convention
```sh
git worktree add ../project-<type>-<desc> <branch>
# Types: feature, bugfix, hotfix, experiment, refactor

git worktree list                            # List
git worktree remove ../project-feature-auth  # Cleanup
git worktree prune                           # Prune stale
```

## Multi-Language Project Init
```sh
mkdir -p {rust,go,typescript,python}/src
echo '[workspace]\nmembers = ["rust/*"]' > Cargo.toml
go mod init github.com/user/project
npm init -y
uv init python/
```
