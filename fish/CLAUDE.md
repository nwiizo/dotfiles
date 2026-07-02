# Fish Configuration Notes

Fish is managed directly from this directory. `scripts/link.sh` symlinks
`config.fish`, `conf.d/zz_sponge_compat.fish`, and every file under
`functions/` into `~/.config/fish/`. `fish/fish_plugins` is the desired
plugin list; Fisher owns the normalized live `~/.config/fish/fish_plugins`
file after `scripts/install-fish-plugins.fish` runs.

## Where to edit what

| Change | Location |
|---|---|
| Shell init, env, PATH, abbreviations, integrations | `fish/config.fish` |
| Plugins | `fish/fish_plugins` |
| Prompt / AI helpers / jj wrappers / `update_all` | `fish/functions/*.fish` |
| Sponge fish 4.x compat patch | `fish/conf.d/zz_sponge_compat.fish` |

## Apply changes

```bash
../scripts/link.sh
fish ../scripts/install-fish-plugins.fish
exec fish
```

## Don't do

- Don't edit `~/.config/fish/config.fish` directly.
- Don't reintroduce Home Manager or Nix-generated fish config.
- Don't define `fish_prompt` / `fish_right_prompt` anywhere except
  `fish/functions/`.
