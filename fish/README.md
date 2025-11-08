# 🐟 Fish Shell Configuration

**Version:** 2025 Best Practices Edition
**Last Updated:** 2025-11-08

This is a production-ready Fish shell configuration optimized for modern development workflows.

## ✨ Features

- 🚀 **Starship Prompt** - Fast, customizable prompt
- 🔍 **Modern CLI Tools** - eza, bat, ripgrep, fzf, zoxide integration
- ⌨️ **Smart Keybindings** - Ctrl+R (history), Ctrl+G (repo), Ctrl+F (file)
- 📦 **Clean Organization** - Structured docs/, scripts/ directories
- 🛡️ **Stable** - Tested configuration with comprehensive documentation

## 📁 Directory Structure

```
fish/
├── README.md              ← This file (dotfiles installation guide)
├── CLAUDE.md              ← AI assistant guidelines
├── config.fish            ← Main configuration (13 sections)
├── .gitignore             ← Git ignore patterns
├── fish_plugins           ← Fisher plugin list
│
├── docs/                  ← Documentation
│   ├── QUICK_REFERENCE.md
│   ├── CHANGES_EXPLAINED.md
│   └── ASYNC_PROMPT_ISSUE.md
│
└── scripts/               ← Utility scripts
    ├── test_config.fish   ← Diagnostic tool
    └── install.fish       ← Installation script
```

## 🚀 Quick Install

### Prerequisites

```bash
# Install Fish shell
brew install fish

# Install required tools
brew install starship eza bat ripgrep fzf zoxide mise

# Install Fisher (plugin manager)
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

### Installation

```bash
# Clone this dotfiles repository (if not already)
ghq get nwiizo/dotfiles

# Run installation script
fish ~/ghq/github.com/nwiizo/dotfiles/fish/scripts/install.fish

# Or manually create symlinks
ln -sf ~/ghq/github.com/nwiizo/dotfiles/fish/config.fish ~/.config/fish/config.fish
ln -sf ~/ghq/github.com/nwiizo/dotfiles/fish/CLAUDE.md ~/.config/fish/CLAUDE.md
ln -sf ~/ghq/github.com/nwiizo/dotfiles/fish/.gitignore ~/.config/fish/.gitignore
ln -sf ~/ghq/github.com/nwiizo/dotfiles/fish/fish_plugins ~/.config/fish/fish_plugins

# Create directories
mkdir -p ~/.config/fish/{docs,scripts}

# Link documentation
ln -sf ~/ghq/github.com/nwiizo/dotfiles/fish/docs/* ~/.config/fish/docs/
ln -sf ~/ghq/github.com/nwiizo/dotfiles/fish/scripts/* ~/.config/fish/scripts/

# Install Fisher plugins
fisher update

# Reload Fish
exec fish
```

## 📖 Documentation

### For Users
- **[docs/QUICK_REFERENCE.md](docs/QUICK_REFERENCE.md)** - Troubleshooting guide
- **[docs/ASYNC_PROMPT_ISSUE.md](docs/ASYNC_PROMPT_ISSUE.md)** - Prompt problem resolution

### For Developers/AI
- **[CLAUDE.md](CLAUDE.md)** - Comprehensive AI guidelines (561 lines)
- **[docs/CHANGES_EXPLAINED.md](docs/CHANGES_EXPLAINED.md)** - Detailed change rationale

### After Installation

```bash
# Test configuration
fish -n ~/.config/fish/config.fish

# Run diagnostic
fish ~/.config/fish/scripts/test_config.fish

# Verify Starship prompt
type -q starship && echo "✓ Starship installed" || echo "✗ Starship missing"
```

## ⚙️ Customization

### Local Settings

Create `~/.config/fish/local.fish` for machine-specific settings (gitignored):

```fish
# Machine-specific environment variables
set -gx COMPANY_PROXY "http://proxy.example.com:8080"

# Personal shortcuts
abbr -a work 'cd ~/workspace/myproject'

# ⚠️ NEVER define fish_prompt or fish_right_prompt!
```

### Starship Customization

Edit `~/.config/starship.toml`:

```toml
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"

[directory]
truncation_length = 3
truncate_to_repo = true
```

## 🔧 Installed Tools

### Modern CLI Replacements
- **eza** → `ls` (icons, Git integration)
- **bat** → `cat` (syntax highlighting)
- **ripgrep** → `grep` (fast search)
- **fzf** → fuzzy finder
- **zoxide** → smart `cd`
- **mise** → runtime version manager

### Key Bindings
- `Ctrl+R` - FZF history search
- `Ctrl+G` - ghq repository search
- `Ctrl+F` - File search
- `Ctrl+L` - Clear screen

### Abbreviations

```fish
# Git
g → git
gst → git status
gc → git commit -v
gp → git push

# Docker
d → docker
dc → docker compose
dcu → docker compose up

# Kubernetes
k → kubectl
kgp → kubectl get pods
```

## 🐛 Troubleshooting

### Broken Prompt

```fish
# Clear prompt functions
functions -e fish_prompt fish_right_prompt

# Reload Fish
exec fish
```

### Starship Not Showing

```fish
# Install Starship
brew install starship

# Verify installation
type -q starship

# Reload Fish
exec fish
```

### Run Diagnostics

```fish
fish ~/.config/fish/scripts/test_config.fish
```

## 📝 What's Included

### Core Files (Symlinked)
- ✅ `config.fish` - Main configuration (16KB, 362 lines)
- ✅ `CLAUDE.md` - AI guidelines (561 lines)
- ✅ `.gitignore` - Git ignore patterns
- ✅ `fish_plugins` - Fisher plugin list

### Documentation (Symlinked)
- ✅ `docs/QUICK_REFERENCE.md` - Quick troubleshooting
- ✅ `docs/CHANGES_EXPLAINED.md` - Detailed changes
- ✅ `docs/ASYNC_PROMPT_ISSUE.md` - Prompt problem fix

### Scripts (Symlinked)
- ✅ `scripts/test_config.fish` - Diagnostic tool
- ✅ `scripts/install.fish` - Installation script

### Not Included (Generated Locally)
- ❌ `backups/` - Local backups
- ❌ `fish_variables` - Local state
- ❌ `completions/` - Plugin-generated
- ❌ `conf.d/` - Plugin-generated
- ❌ `functions/` - Plugin-generated
- ❌ `local.fish` - Machine-specific (gitignored)

## 🔄 Updating

```bash
# Pull latest dotfiles
cd ~/ghq/github.com/nwiizo/dotfiles
git pull

# Symlinks automatically reflect changes
# Just reload Fish
exec fish

# Update plugins
fisher update
```

## 📊 Configuration Overview

### 13-Section Structure

1. **Critical Initialization** - Directory validation
2. **XDG Base Directory** - Standard paths
3. **Homebrew** - Package manager setup
4. **PATH Configuration** - Binary paths
5. **Environment Variables** - EDITOR, GOPATH, etc.
6. **FZF Configuration** - Fuzzy finder
7. **Fish Shell Behavior** - History, completions
8. **Modern CLI Replacements** - eza, bat, rg
9. **Functions** - Custom utilities
10. **Key Bindings** - Keyboard shortcuts
11. **Abbreviations** - Command shortcuts
12. **Tool Integrations** - mise, zoxide, etc.
13. **Starship Prompt** - MUST BE LAST!

## ⚠️ Important Notes

### Critical Rules
1. ✅ Starship initialization is **always last**
2. ❌ **Never** create `functions/fish_prompt.fish`
3. ❌ **Never** enable `__async_prompt.fish` (conflicts with Starship)
4. ✅ Use `local.fish` for machine-specific settings

### File Management
- **Symlinked files** - Edit in dotfiles repo, changes auto-apply
- **Local files** - `local.fish`, `fish_variables` (not in repo)
- **Plugin files** - Auto-generated in `completions/`, `conf.d/`, `functions/`

## 🆘 Getting Help

1. **Read Documentation** - Check `docs/QUICK_REFERENCE.md`
2. **Run Diagnostics** - `fish scripts/test_config.fish`
3. **Check AI Guidelines** - See `CLAUDE.md` for details
4. **Create Issue** - Report problems in dotfiles repo

## 📚 External Links

- [Fish Shell Official Docs](https://fishshell.com/docs/current/)
- [Starship Prompt](https://starship.rs/)
- [Fisher Plugin Manager](https://github.com/jorgebucaran/fisher)
- [Modern Unix Tools](https://github.com/ibraheemdev/modern-unix)

---

**Maintained by:** nwiizo
**Repository:** https://github.com/nwiizo/dotfiles
**License:** MIT (or your preferred license)

**Happy Fishing! 🐟**
