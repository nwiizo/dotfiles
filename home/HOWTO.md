# HOWTO — Adding settings via Home Manager

This is the quick reference for adding things to the Nix configuration.
Skill counterpart: [`add-nix-config`](../.agents/skills/add-nix-config/SKILL.md).
Package-only flow: [`add-package`](../.agents/skills/add-package/SKILL.md).

## Common workflow

```
1. Edit the right module under home/
2. nixfmt ./home/*.nix ./flake.nix
3. home-manager build --flake .#nwiizo   # validate, no activation
4. home-manager switch --flake .#nwiizo  # apply
5. Verify the change is live
6. git add → commit (→ push)
```

If `build` fails, fix and re-run; **never run `switch` on a failed build.**

---

## Pattern 1 — CLI tool, no `programs.X` module

Just install the binary.

```nix
# home/packages.nix
home.packages = with pkgs; [
  ...
  tealdeer  # tldr replacement
];
```

Find the package: `nix search nixpkgs <name>`.

## Pattern 2 — Tool with an HM module (`programs.X`)

Prefer the module; it usually manages config too.

```nix
# home/packages.nix (or the relevant module)
programs.tealdeer = {
  enable = true;
  settings = {
    display.compact = true;
    updates.auto_update = true;
  };
};
```

Discover: `ls /nix/store/*-source/modules/programs/ | sort -u` or browse
[home-manager options](https://home-manager-options.extranix.com/).

## Pattern 3 — Tool with fish integration

Let HM generate the init script in `~/.config/fish/conf.d/`.

```nix
# home/fish.nix
programs.starship = {
  enable = true;
  enableFishIntegration = true;
  settings = { /* starship.toml as Nix attrset */ };
};
```

Don't also write the init script manually — that double-loads.

## Pattern 4 — Environment variable

```nix
# home/default.nix
home.sessionVariables = {
  ...
  RUST_BACKTRACE = "1";
};
```

Don't add `set -gx` in fish `shellInit` for this; HM emits
`hm-session-vars.fish` automatically.

## Pattern 5 — Fish abbreviation

```nix
# home/fish.nix → programs.fish.shellAbbrs
shellAbbrs = {
  ...
  # ─── Git ─────────────────────────────────────────
  gco = "git checkout";
};
```

Place inside the matching grouping comment.

## Pattern 6 — Fish function

**Short / one-shot wrapper** — inline in `programs.fish.functions`:

```nix
# home/fish.nix → programs.fish.functions
mkcd = {
  body = "mkdir -p $argv[1]; and cd $argv[1]";
  description = "mkdir + cd";
};
```

**Long / non-trivial** — a file under `fish/functions/`, then register:

```nix
# home/fish.nix → xdg.configFile
xdg.configFile = {
  ...
  "fish/functions/my_func.fish".source = ../fish/functions/my_func.fish;
};
```

## Pattern 7 — Arbitrary config file

A single file:

```nix
# home/default.nix (or domain module)
xdg.configFile."foo/config.yaml".source = ../foo/config.yaml;
```

A whole directory (becomes a read-only symlink into `/nix/store`):

```nix
xdg.configFile."foo".source = ../foo;
```

If the tool writes back to its config dir at runtime (lockfile, cache,
state), don't symlink the whole directory — list each file individually,
or move the writable bits to a different path (cf. neovim's
`lazy-lock.json` redirect to `stdpath("data")`).

## Pattern 8 — Executable script

```nix
# home/default.nix or domain module
home.file.".local/bin/myscript" = {
  source = ../scripts/myscript.sh;
  executable = true;
};
```

The repo's `git/power_pull.sh` follows this pattern.

## Pattern 9 — Non-nixpkgs source as a flake input

When you need a Git source that isn't in nixpkgs (typically a fish/zsh
plugin), declare it as a flake input so `nix flake update` keeps it
fresh:

```nix
# flake.nix
inputs.my-thing = {
  url = "github:owner/my-thing";
  flake = false;
};
```

Reference it from a module via `extraSpecialArgs`:

```nix
# home/fish.nix
plugins = [
  { name = "my-thing"; src = inputs.my-thing; }
];
```

---

## Where to add things — module map

| What | Module |
|---|---|
| General CLI tool / `programs.X` for misc tools | `home/packages.nix` |
| Git ecosystem (git, gh, delta, lazygit, ghq, scripts) | `home/git.nix` |
| Neovim (`programs.neovim`, `nvim/` symlink) | `home/neovim.nix` |
| Fish itself, fish-integrating tools (atuin/direnv/zoxide/mise/carapace) | `home/fish.nix` |
| Env vars, `programs.nh`, ghostty link, nix settings | `home/default.nix` |
| Non-nixpkgs sources | `flake.nix` |

Don't sprinkle `home.packages` across multiple modules; keep it in
`packages.nix` unless the package's `programs.<X>` config is in another
module (then keep them together).

## Validation reference

```bash
nixfmt --check ./flake.nix ./home/*.nix
home-manager build --flake .#nwiizo
home-manager switch --flake .#nwiizo

# Spot-check binaries resolve through Nix:
fish -i -c 'type <command>'
# Should print: ~/.nix-profile/bin/<command>
```
