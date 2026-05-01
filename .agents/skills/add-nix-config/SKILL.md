---
name: add-nix-config
description: |
  Add a setting to this Home Manager dotfiles repo. Covers env vars,
  fish abbreviations, fish functions, arbitrary config files / symlinks,
  tool integrations, and non-nixpkgs flake inputs. Triggers on intents
  like "EDITOR を vim に", "fish abbr で gst 追加", "fish 関数 mkcd 作って",
  "~/.config/foo を HM 管理に", "RUST_BACKTRACE を環境変数で", "starship
  入れて fish 連携も", "nixpkgs に無いプラグインを使いたい". For
  installing a package without other config, prefer `add-package`.
---

# add-nix-config

Map the user's request to one of the patterns below, edit the right
module, validate, switch, verify. Detailed reference with examples:
[`home/HOWTO.md`](../../../home/HOWTO.md).

## Module map

| Concern | File |
|---|---|
| General CLI / misc `programs.X` | `home/packages.nix` |
| Git ecosystem | `home/git.nix` |
| Neovim | `home/neovim.nix` |
| Fish + fish-integrating tools (atuin/direnv/zoxide/mise/carapace/...) | `home/fish.nix` |
| Env vars, `programs.nh`, ghostty link, nix settings | `home/default.nix` |
| Non-nixpkgs Git sources | `flake.nix` |

## Patterns

1. **CLI package only** → `home.packages = [ pkgs.<x> ]` in `packages.nix`.
   Use `add-package` if that's the whole task.

2. **Tool with HM module + config** → `programs.<X>.enable = true; settings = {...}`.
   Discover modules: `ls /nix/store/*-source/modules/programs/`.

3. **Tool with fish init script** → `programs.<X>.enableFishIntegration = true`
   in `home/fish.nix`. Don't also hand-write `conf.d/<x>.fish`.

4. **Env var** → `home.sessionVariables.<NAME> = "value"` in `home/default.nix`.
   Not in fish `shellInit`.

5. **Fish abbreviation** → `programs.fish.shellAbbrs.<name> = "expansion"`,
   inside the matching `# ─── Group ───` comment.

6. **Fish function**
   - Short wrapper → `programs.fish.functions.<name> = { body; description; }`.
   - Long → file under `fish/functions/<name>.fish` + register via
     `xdg.configFile."fish/functions/<name>.fish".source = ../fish/functions/<name>.fish`.

7. **Arbitrary file/dir symlink** →
   - File: `xdg.configFile."<path>".source = ../<src>;`
   - Whole dir: `xdg.configFile."<path>".source = ../<srcdir>;` (read-only;
     don't use if the tool writes back into that dir).

8. **Executable script** → `home.file.".local/bin/<name>" = { source; executable = true; }`.

9. **Non-nixpkgs source** → declare in `flake.nix` `inputs` with
   `flake = false`, then reference via `inputs.<name>` in the module
   (already plumbed through `extraSpecialArgs = { inherit inputs; }`).

## Workflow

```bash
nixfmt ./home/*.nix ./flake.nix          # format
home-manager build --flake .#nwiizo      # validate; do NOT proceed on failure
home-manager switch --flake .#nwiizo     # apply
fish -i -c 'type <name>'                 # verify resolves to ~/.nix-profile/bin/
```

If the change conflicts with an existing live file (e.g. first time
`programs.X.enable` writes a config), back the file up first:

```bash
mv ~/.config/<tool>/<file> ~/.config/<tool>/<file>.pre-hm-backup
home-manager switch --flake .#nwiizo
```

## Don't

- Don't put env vars in `programs.fish.shellInit` — use `home.sessionVariables`.
- Don't symlink directories that the tool writes to (lockfiles, caches).
  Either redirect the tool to a writable path, or list files individually.
- Don't double-init tools (HM `enableFishIntegration` + manual hook).
- Don't add packages to `home/default.nix`; pick a domain module.
- Don't switch on a failed `build`. Fix the error first.
- Don't reformat or refactor unrelated parts of the file.
