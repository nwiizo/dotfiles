# Fish configuration

Read this reference for changes under `fish/`.

## Place code by startup semantics

- Remember that user `conf.d/*.fish` snippets run before `config.fish` and run
  for interactive and non-interactive shells.
- Put paths needed by later snippets in an early file such as
  `fish/conf.d/00-paths.fish`; do not make a snippet depend on PATH changes in
  `config.fish`.
- Use a user `conf.d` file with the same basename only when intentionally
  replacing a system or vendor hook. Fish executes the first matching
  basename, so document the upstream hook being replaced.
- Put reusable commands in autoloaded `fish/functions/<name>.fish`. Keep user
  environment and abbreviations in the existing groups in `config.fish`.
- Guard UI, prompt, key binding, and shell-hook work with
  `status is-interactive`.

## Keep PATH and generated hooks deterministic

- Use `fish_add_path --path` for repo-managed PATH entries that must affect the
  current process. Do not persist repository policy in universal
  `fish_user_paths`, and never edit `fish_variables`.
- Prefer full activation for interactive shells and tool shims for
  non-interactive agent or script commands when the version manager supports
  both.
- Cache static generated Fish code only when the cache key covers the
  executable path, executable modification time, and init arguments.
- Do not cache directory-dependent environment output such as `direnv export`
  or `mise hook-env`; cache the static hook that invokes it.

## Evaluate plugins

- Check Fish core, existing Fisher plugins, Atuin, Ghostty, mise, and other
  configured tools for overlap before adding a plugin.
- Check current maintenance and open regressions, then add only a plugin that
  closes a concrete workflow gap.

## Validate

Run for every Fish change:

```bash
fish -n fish/config.fish fish/conf.d/*.fish
for f in fish/functions/*.fish; do fish -n "$f" || exit 1; done
```

For PATH, `conf.d`, hook, plugin, or other startup-sensitive changes, also test
normal and minimal inherited PATHs. Warm generated-code caches before measuring,
run benchmarks sequentially, and compare variance as well as the median:

```bash
hyperfine --warmup 10 --runs 30 'fish -i -c exit'
profile_file="$(mktemp)"
trap 'rm -f "$profile_file"' EXIT
fish --profile-startup "$profile_file" -i -c exit
sed -n '1,80p' "$profile_file"
```

Profile the dominant external init commands separately when whole-shell timing
is noisy.

Official references:

- [Fish configuration-file order](https://fishshell.com/docs/current/language.html#configuration-files)
- [`fish_add_path`](https://fishshell.com/docs/current/cmds/fish_add_path.html)
