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
├── fish/           # 🐟 Fish shell
├── nvim/           # ✏️  Neovim (NvChad v3.0)
├── ghostty/        # 👻 Ghostty terminal
├── starship/       # 🚀 Prompt
├── git/            # 📝 Git scripts
│
# 📦 Archive (kept for reference)
├── warp/           # Warp terminal → migrated to Ghostty
├── bash/           # Bash → migrated to Fish
├── zsh/            # Zsh → migrated to Fish
├── vim/            # Vim → migrated to Neovim
├── tmux/           # tmux → migrated to Ghostty splits
├── lvim/           # LunarVim → migrated to NvChad
├── nvchad/         # Old NvChad config
├── dockerfile/     # Dockerfile examples
├── ssh/            # SSH config examples
```

## ⚡ Setup

```bash
# Tools
brew install fish neovim starship ghostty
brew install eza bat ripgrep fd fzf zoxide ghq direnv delta lazygit mise atuin

# Symlinks
ln -sf ~/ghq/github.com/nwiizo/dotfiles/fish/config.fish ~/.config/fish/config.fish
ln -sf ~/ghq/github.com/nwiizo/dotfiles/nvim ~/.config/nvim
ln -sf ~/ghq/github.com/nwiizo/dotfiles/starship/starship.toml ~/.config/starship.toml
mkdir -p ~/.config/ghostty && ln -sf ~/ghq/github.com/nwiizo/dotfiles/ghostty/config ~/.config/ghostty/config
```

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
```

### 🧰 Utility Commands

```bash
update_all            # Update everything: brew + mise + rustup + uv + Fisher + nvim plugins
mkcd <dir>            # mkdir + cd
port 8080             # Check process using port
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

### 📜 Scrolling (Vim-style)

| Key | Action |
|-----|--------|
| `Ctrl+U` | Half page up |
| `Ctrl+B` | Full page up |
| `Ctrl+Shift+Up/Down` | Jump between prompts |
| `Cmd+Shift+Space` | Quick terminal |

Config: Hack Nerd Font 24pt / Tokyo Night / Bar cursor 🎨

---

## ✏️ Neovim

NvChad v3.0 base. Minimal UI with no statusline (cmdheight=0, incline.nvim for floating buffer names).

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
| `<leader>sb` | Buffer list |
| `<leader>sc` | Command search |
| `<leader>ss` | LSP symbols |
| `<C-p>` / `<leader>ff` | Telescope find files |
| `<leader>fg` | Telescope grep |
| `-` / `<leader>e` | Oil.nvim (file manager) |
| `s` | Flash.nvim (jump) |

### 🧠 LSP

| Key | Action |
|-----|--------|
| `gd` / `gD` | Definition / Declaration |
| `gi` / `gr` | Implementation / References |
| `K` | Hover info |
| `<leader>rn` | Rename |
| `<leader>ca` | Code action |
| `<leader>fm` / `<leader>bf` | Format |
| `[d` / `]d` | Navigate diagnostics |
| `<leader>ld` | Show diagnostic (float) |

Languages: Rust, Go, TypeScript, Python, Lua, Terraform, Bash, Zig, HTML/CSS, JSON, YAML

### 🌿 Git

| Key | Action |
|-----|--------|
| `<leader>gg` | LazyGit |
| `<leader>gl` | Git log |
| `<leader>gd` | Diffview (working tree) |
| `<leader>gD` | Diffview (vs previous commit) |
| `<leader>gm` | Diffview (vs main) |
| `<leader>gh` / `<leader>gH` | File / Branch history |
| `<leader>gp` | Hunk preview |
| `<leader>gb` | Blame |
| `]c` / `[c` | Hunk navigation |

### 🚨 Diagnostics (Trouble.nvim)

| Key | Action |
|-----|--------|
| `<leader>xx` | All diagnostics |
| `<leader>xX` | Buffer diagnostics |
| `<leader>xs` | Document symbols |
| `<leader>xt` | TODO list |
| `]t` / `[t` | TODO navigation |

### 🦀 Rust

| Key | Action |
|-----|--------|
| `<leader>ra` | Code action (rustaceanvim) |
| `<leader>rr` / `<leader>rR` | Run / Re-run |
| `<leader>rt` / `<leader>rT` | Test / Re-test |
| `<leader>rd` | Debug |
| `<leader>rm` | Expand macro |
| `<leader>cr/cv/cu/cU` | crates.nvim (info/versions/update/upgrade) |

### 🐛 Debug (DAP)

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>di/do/dO` | Step in/out/over |

### 🧪 Test (neotest)

| Key | Action |
|-----|--------|
| `<leader>Tr` | Run nearest test |
| `<leader>Tf` | Run file tests |
| `<leader>Td` | Debug test |

### 🤖 AI

| Key | Action |
|-----|--------|
| `<leader>ao` | CopilotChat open |
| `<leader>ae` / `<leader>af` | Explain / Fix |
| `<leader>at` / `<leader>ad` | Generate tests / Docs |
| `<leader>aR` | Code review |
| `<leader>aa` | Avante: Ask |
| `<leader>ax` | Avante: Edit |
| `<leader>cc` | Claude Code toggle |
| `<leader>cf` | Claude Code focus |

### 💬 Completion (nvim-cmp)

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
