# 🌿 dotfiles

My personal development environment. Built by hand, maintained over time.

> **⚠️ Warning**: Breaking changes may occur. I'll stop when I get bored.

## 🏡 This Is a Garden

There are two kinds of development environments: the ones given to you, and the ones you grow.

Using someone else's defaults is easy. Everyone installs the same editor with the same extensions, pressing the same keybindings. It might be efficient — but it's fundamentally different from choosing your own tools, sharpening them, and arranging them yourself. Installing something convenient and consuming it is not the same as composing your own environment with your own hands. What stays with you afterward is completely different.

Writing dotfiles means building your own workspace from the ground up. 🛠️

A garden never turns out exactly as planned. What you plant doesn't always grow the way you expect, and sometimes things take root on their own. Dotfiles are the same way. Neovim keymaps settle into muscle memory over years, while AI integration configs get rewritten monthly. Fish abbreviations need time before your fingers learn them, and sometimes — like migrating to Ghostty — you have to tear up the soil entirely. Multiple timelines overlap in a single place, and you can't control all of them at once.

And that's fine. 🌱

A perfectly managed environment is, by definition, someone else's managed environment. It becomes *your* place precisely because it contains parts you can't fully tame. Deciding whether to pull the weeds or let them stay — that's part of tending it with your own hands. What you build up over time like that becomes the foundation of who you are as someone who writes code.

If all you want is efficiency, off-the-shelf is fine. But if you want to leave traces of how you think and how you move your hands — you have no choice but to keep a garden. 🪴

## 📁 Structure

```
dotfiles/
# 🟢 Active (2026)
├── fish/           # 🐟 Fish config, functions, and Fisher plugin list
├── nvim/           # ✏️  Neovim (LazyVim) config
├── ghostty/        # 👻 Ghostty terminal config
├── warp/           # ⚡ Warp terminal config (keybindings + themes + workflows)
├── git/            # 📝 Git config and helper scripts
├── scripts/        # 🔗 Bootstrap/link scripts
├── Brewfile        # 🍺 Homebrew packages that replace the old Nix profile
│
# 📦 Archive (kept for reference, all under archive/)
├── archive/
│   ├── bash/       # Bash → migrated to Fish
│   ├── zsh/        # Zsh → migrated to Fish
│   ├── vim/        # Vim → migrated to Neovim
│   ├── tmux/       # tmux → migrated to Ghostty splits
│   ├── lvim/       # LunarVim → migrated to LazyVim
│   ├── nvchad/     # NvChad → migrated to LazyVim
│   ├── nvchad-v2.5/# NvChad v2.5 (2026-03まで使用)
│   ├── dockerfile/ # Dockerfile examples
│   └── ssh/        # SSH config examples
```

## ⚡ Setup

Homebrew owns binaries; the repo owns config files via symlinks.
Bootstrap once:

```bash
cd ~/ghq/github.com/nwiizo/dotfiles
./scripts/bootstrap.sh
```

After that, the `update_all` fish function takes care of brew + mise
tools + Claude CLI + rustup + nvim plugins in one shot. Use flags like
`--no-brew`, `--no-rust`, or `--no-nvim` to skip slower parts.

## 🍺 Package And Config Management

Nix/Home Manager is no longer required. Management is split by the tool
that naturally owns each layer:

- Homebrew: CLI tools, terminal apps, GUI casks, fonts
- Fisher: Fish plugins from `fish/fish_plugins`
- mise / rustup / language-native managers: language toolchains
- Lazy.nvim / Mason: Neovim plugins and editor tooling
- `scripts/link.sh`: symlinks repo config into `~/.config`, `~/.warp`,
  and `~/.local/bin`

Apply config links again:

```bash
./scripts/link.sh
```

Install/update Fish plugins:

```bash
fish scripts/install-fish-plugins.fish
```

Install Homebrew dependencies:

```bash
brew bundle --file Brewfile
```

### Edit-then-reflect cheatsheet

Most config paths are symlinks to this repo. Editing the repo is enough;
restart the owning app or open a new shell.

| Edit | `switch` needed? |
|---|---|
| Existing `nvim/lua/**.lua` | No — restart nvim |
| Existing `fish/functions/*.fish` | No — open a new shell |
| Add/remove a file under `nvim/` | No — restart nvim |
| Add/remove a file under `fish/functions/` | Run `./scripts/link.sh` |
| Fish plugins | Edit `fish/fish_plugins`, then `fish scripts/install-fish-plugins.fish` |
| Homebrew packages | Edit `Brewfile`, then `brew bundle --file Brewfile` |
| Ghostty / Warp / Git / Bat / Atuin configs | No — app restart or new shell |

---

## 🐟 Fish Shell

### ⌨️ Keybindings

| Key | Action |
|-----|--------|
| `Ctrl+G` | Select ghq repository (fzf) |
| `Ctrl+R` | History search (atuin) |
| `Ctrl+F` | File search (fzf) |
| `Ctrl+B` | Git branch selection (fzf) |
| `Ctrl+L` | Clear screen |
| `Tab` | History completion on empty cmdline |

### 🔤 Abbreviations

```bash
# Git
g=git  gst=status  gaa=add --all  gc=commit -v  gcm=commit -m
gco=checkout  gcb=checkout -b  gp=push  gpl=pull  gd=diff  gl=log
gf=commit --amend --no-edit

# Docker / Kubernetes
d=docker  dc=docker compose  dcu=up  dcd=down  dps=ps
k=kubectl  kgp=get pods  kgs=get svc  kgd=get deploy  kctx=config use-context  kns=config set-context --current --namespace

# fzf shortcuts
ff=fzf  fgl=git log (fzf)  fgs=git stash (fzf)  fp=process (fzf)
fv=nvim (fzf)  fh=history (fzf)  gb=git branch (fzf)

# Tools
v=nvim  lg=lazygit  c=claude

# AI workflow
actx=ai_context  actxc=ai_context|pbcopy  arv=ai_review
acm=ai_commit_msg  apr=ai_pr
```

### 🧰 Utility Commands

```bash
update_all            # Update brew + mise tools + Claude + rustup + nvim plugins
update_all --no-nvim  # Skip Lazy.nvim plugin sync
z <substring>         # zoxide jump
```

### 🔄 Modern CLI Replacements

| Legacy | Replacement | Notes |
|--------|-------------|-------|
| `ls` | `eza` | `ll` (detailed+Git), `la` (hidden), `lt` (tree) |
| `cat` | `bat` | Syntax highlighting |
| `grep` | `ripgrep` | `-t rust "fn"`, `-C 3 "error"` |
| `find` | `fd` | `fd "*.rs"`, `fd -t d config` |
| `cd` | `zoxide` | `z <path>` (learning) |
| `history` | `atuin` | Search with `Ctrl+R` |
| `git diff` | `delta` | Auto (`GIT_PAGER=delta`) |

---

## 👻 Ghostty Terminal

### 🪟 Panes

| Key | Action |
|-----|--------|
| `Cmd+D` | Split right |
| `Cmd+Shift+D` | Split down |
| `Ctrl+H/J/K/L` | Navigate panes (Vim-style) |
| `Cmd+W` | Close pane |
| `Cmd+Shift+Return` | Toggle zoom |

### 📑 Tabs & Windows

| Key | Action |
|-----|--------|
| `Cmd+T` | New tab |
| `Cmd+N` | New window |
| `Cmd+Shift+]` / `[` | Switch tabs |

### 📜 Scrolling

| Key | Action |
|-----|--------|
| `Ctrl+U` | Half page up |
| `Alt+B` | Full page up |
| `Alt+G` | Scroll to top |
| `Alt+Shift+G` | Scroll to bottom |
| `Ctrl+Shift+Up/Down` | Jump between prompts |
| `Cmd+Shift+Space` | Quick terminal |

Config: Hack Nerd Font Mono 24pt / Tokyo Night / Bar cursor 🎨

---

## ✏️ Neovim

LazyVim base. Minimal UI with no statusline (cmdheight=0, incline.nvim for floating buffer names). catppuccin mocha + blink.cmp.

### 🔧 Basics

| Key | Action |
|-----|--------|
| `;` | `:` (command mode) |
| `jk` | `<Esc>` |
| `<C-s>` | Save |
| `<C-d>/<C-u>` | Half-page scroll + center |
| `<C-h/j/k/l>` | Window navigation |
| `<S-h>/<S-l>` | Buffer navigation |
| `<leader>x` | Close buffer |

### 🔍 Search & Navigation (Snacks.nvim = primary, Telescope = secondary)

| Key | Action |
|-----|--------|
| `<leader><leader>` | Smart picker (files/buffers/recent) |
| `<leader>sf` | Find files |
| `<leader>sg` | Grep search |
| `<leader>sw` | Grep word under cursor |
| `<leader>sb` | Buffer list |
| `<leader>sc` | Command search |
| `<leader>ss` | LSP symbols |
| `<leader>sr` | Recent files |
| `<leader>sh` | Help pages |
| `<leader>sk` | Keymaps |
| `<leader>sd` | Diagnostics |
| `<leader>sR` | Resume last picker |
| `<leader>tt` | Toggle terminal |
| `<C-p>` / `<leader>ff` | Telescope find files |
| `<leader>fg` | Telescope grep |
| `-` / `<leader>e` | Oil.nvim (file manager) |
| `s` | Flash.nvim (jump) |

### 🔭 Code Peek (overlook.nvim)

| Key | Action |
|-----|--------|
| `<leader>pd` | Peek definition |
| `<leader>pc` | Close all popups |
| `<leader>pu` / `<leader>pU` | Restore last / all popups |
| `<leader>pf` | Toggle focus |
| `<leader>ps` / `<leader>pv` | Open in split / vsplit |
| `<leader>po` | Open in original |

### 🧠 LSP

| Key | Action |
|-----|--------|
| `gd` / `gD` | Definition / Declaration |
| `gi` / `gr` | Implementation / References |
| `K` | Hover info |
| `<leader>rn` | Rename |
| `<leader>ca` | Code action |
| `<leader>fm` / `<leader>bf` | Format |
| `<leader>lk` | Signature help |
| `<leader>lD` | Type definition |
| `<leader>lwa/lwr/lwl` | Workspace folder add/remove/list |
| `[d` / `]d` | Navigate diagnostics |
| `<leader>ld` | Show diagnostic (float) |

Languages: Rust (rustaceanvim), Go (gopls, golangci-lint), Python (pylsp), Lua (lua_ls), Terraform (terraformls), Bash (bashls), Zig (zls), HTML/CSS

### 🌿 Git

| Key | Action |
|-----|--------|
| `<leader>gg` | LazyGit |
| `<leader>gl` | Git log |
| `<leader>gf` | LazyGit file log |
| `<leader>gd` | Diffview (working tree) |
| `<leader>gD` | Diffview (vs previous commit) |
| `<leader>gm` / `<leader>gM` | Diffview vs main / master |
| `<leader>gs` | Diffview (staged changes) |
| `<leader>gh` / `<leader>gH` | File / Branch history |
| `<leader>gt` | Toggle file panel |
| `<leader>gp` | Hunk preview |
| `<leader>gb` / `<leader>gB` | Blame / Toggle blame |
| `<leader>gy` / `<leader>gY` | Copy / Open Git permalink |
| `<leader>hs` / `<leader>hr` / `<leader>hu` | Stage / Reset / Undo stage hunk |
| `]c` / `[c` | Hunk navigation |

### 🚨 Diagnostics (Trouble.nvim)

| Key | Action |
|-----|--------|
| `<leader>xx` | All diagnostics |
| `<leader>xX` | Buffer diagnostics |
| `<leader>xs` | Document symbols |
| `<leader>xl` | LSP definitions |
| `<leader>xq` | Quickfix (Trouble) |
| `<leader>xt` | TODO list |
| `<leader>sT` | Search TODOs (Telescope) |
| `]t` / `[t` | TODO navigation |

### 🦀 Rust (rustaceanvim)

| Key | Action |
|-----|--------|
| `<leader>ra` | Code action |
| `<leader>rr` / `<leader>rR` | Run / Re-run |
| `<leader>rt` / `<leader>rT` | Test / Re-test |
| `<leader>rd` | Debuggables |
| `<leader>rm` | Expand macro |
| `<leader>rc` | Open Cargo.toml |
| `<leader>rp` | Parent module |
| `<leader>rj` | Join lines |
| `<leader>rs` | Structural search replace |
| `<leader>re` | Explain error |
| `<leader>rD` | Render diagnostic |
| `<leader>rv` / `<leader>rV` | View HIR / MIR |
| `K` | Rust hover actions (override) |
| `J` | Rust join lines (override) |

### 📦 Crates (crates.nvim, in Cargo.toml)

| Key | Action |
|-----|--------|
| `<leader>ct` | Toggle crates |
| `<leader>cr` | Reload |
| `<leader>cv` | Show versions |
| `<leader>cf` | Show features |
| `<leader>cd` | Show dependencies |
| `<leader>cu` / `<leader>cU` | Update / Upgrade crate |
| `<leader>cA` | Upgrade all crates |
| `<leader>cH` / `<leader>cR` | Open homepage / repository |
| `<leader>cD` / `<leader>cC` | Open docs.rs / crates.io |

### 🐛 Debug (DAP)

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dc` | Continue |
| `<leader>dC` | Run to cursor |
| `<leader>di` / `<leader>do` / `<leader>dO` | Step in / out / over |
| `<leader>dp` | Pause |
| `<leader>dt` | Terminate |
| `<leader>dr` | Toggle REPL |
| `<leader>ds` | Session |
| `<leader>du` | Toggle DAP UI |
| `<leader>de` | Eval expression |

### 🧪 Test (neotest)

| Key | Action |
|-----|--------|
| `<leader>Tr` | Run nearest test |
| `<leader>Tf` | Run file tests |
| `<leader>Td` | Debug nearest test |
| `<leader>Ts` | Toggle test summary |
| `<leader>To` | Show test output |
| `<leader>Tp` | Toggle output panel |
| `[T` / `]T` | Navigate failed tests |

### 🤖 AI

**CopilotChat:**

| Key | Action |
|-----|--------|
| `<leader>ao` | Open chat |
| `<leader>aq` | Close chat |
| `<leader>ar` | Reset chat |
| `<leader>am` / `<leader>aP` | Select model / Prompt library |
| `<leader>ae` / `<leader>af` | Explain / Fix |
| `<leader>aO` | Optimize |
| `<leader>at` / `<leader>ad` | Generate tests / Docs |
| `<leader>aR` | Code review |
| `<leader>ag` / `<leader>aG` | Review staged / unstaged diff |
| `<leader>aW` | Workspace tool chat |

**Avante:**

| Key | Action |
|-----|--------|
| `<leader>aa` | Ask |
| `<leader>ax` | Edit |
| `<leader>aS` | Refresh response |

**Claude Code:**

| Key | Action |
|-----|--------|
| `<leader>ac` | Toggle |
| `<leader>aF` | Focus |
| `<leader>au` | Resume session |
| `<leader>aK` | Continue conversation |
| `<leader>aM` | Select model |
| `<leader>ab` | Add current buffer |
| `<leader>as` | Send to Claude (visual) |
| `<leader>ay` / `<leader>an` | Accept / Deny diff |

### 💬 Completion (blink.cmp)

Priority: Copilot (1000) > LSP (900) > Snippet (800) > Buffer (500) > Path (400)

| Key | Action |
|-----|--------|
| `<C-Space>` | Open completion |
| `<Tab>/<S-Tab>` | Select |
| `<CR>` | Confirm |
| `<C-e>` | Cancel |

---

## 🔧 Troubleshooting

```bash
# Fish
exec fish                              # Reload
fish --profile-startup /tmp/fish.prof -c exit  # Profile startup

# Neovim
nvim --startuptime /tmp/nvim.log       # Profile startup
```

```vim
:Lazy sync            " Sync plugins
:Mason                " LSP/tool manager
:checkhealth          " Run diagnostics
:LspInfo              " Check LSP status
```

## 🎨 Customization

```bash
# Fish local config (gitignored)
~/.config/fish/local.fish
```

```lua
-- Add plugins: nvim/lua/plugins/init.lua
-- Add keymaps: nvim/lua/mappings.lua
```
