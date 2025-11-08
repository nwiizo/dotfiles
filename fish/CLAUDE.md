# CLAUDE.md - Fish Shell Configuration Guide

This file provides guidance to Claude Code and AI assistants when working with this Fish shell configuration.

## 📋 Overview

This is a **production-ready Fish shell configuration** (`~/.config/fish/`) for developers and infrastructure engineers. The configuration emphasizes:

- ✨ Modern CLI tools (eza, bat, ripgrep, fzf, zoxide)
- 🚀 Developer productivity (Starship prompt, smart keybindings)
- 🐳 Infrastructure workflows (Docker, Kubernetes, cloud tools)
- 📦 Clean organization (docs/, scripts/, backups/)
- 🛡️ Stability (tested configurations, comprehensive documentation)

**Last Updated:** 2025-11-08
**Config Version:** 2025 Best Practices Edition

---

## 🗂️ Directory Structure

```
~/.config/fish/
├── README.md                 ← Main documentation (comprehensive guide)
├── CLAUDE.md                 ← This file (AI assistant guidelines)
├── config.fish               ← Main configuration (13 sections)
├── .gitignore                ← Git ignore patterns
│
├── docs/                     ← Documentation
│   ├── QUICK_REFERENCE.md    ← Troubleshooting guide
│   ├── CHANGES_EXPLAINED.md  ← Detailed change log
│   └── ASYNC_PROMPT_ISSUE.md ← Prompt problem resolution
│
├── scripts/                  ← Utility scripts
│   └── test_config.fish      ← Diagnostic tool
│
├── backups/                  ← Configuration backups
│   ├── config.fish.backup.*
│   └── config_enhanced.fish
│
├── completions/              ← Command completions
│   ├── ghq.fish
│   ├── kubectl.fish (auto-generated)
│   └── ...
│
├── conf.d/                   ← Auto-loaded configs (plugins)
│   ├── fzf.fish
│   ├── zoxide_warp_fix.fish
│   ├── __async_prompt.fish.disabled  ← DISABLED (conflicts with Starship)
│   └── ...
│
├── functions/                ← Custom functions
│   ├── fish_greeting.fish
│   ├── ghq_fzf_repo.fish
│   ├── update_all.fish
│   └── ...
│
└── fish_variables            ← Fish internal state (auto-managed)
```

---

## 🎯 Critical Rules for AI Assistants

### ✅ DO
1. **Always read README.md first** - Contains complete documentation
2. **Respect Starship initialization order** - Must be last in config.fish
3. **Use existing directory structure** - docs/, scripts/, backups/
4. **Test changes** - Use `fish -n config.fish` to validate syntax
5. **Document changes** - Update relevant docs/ files
6. **Preserve user customizations** - Check for local.fish

### ❌ NEVER
1. **NEVER create functions/fish_prompt.fish** - Conflicts with Starship
2. **NEVER create functions/fish_right_prompt.fish** - Conflicts with Starship
3. **NEVER manually load conf.d/** - Fish auto-loads it
4. **NEVER load configs after Starship** - Breaks prompt initialization
5. **NEVER enable __async_prompt.fish** - Known conflict with Starship
6. **NEVER remove backups/** - User safety net

---

## 🏗️ config.fish Architecture

### Section Overview (13 Sections)

```fish
# 0.  CRITICAL INITIALIZATION    - Directory validation, greeting
# 1.  XDG BASE DIRECTORY         - Standard paths
# 2.  HOMEBREW                   - Homebrew setup
# 3.  PATH CONFIGURATION         - Binary paths
# 4.  ENVIRONMENT VARIABLES      - EDITOR, GOPATH, Docker, etc.
# 5.  FZF CONFIGURATION          - Fuzzy finder setup
# 6.  FISH SHELL BEHAVIOR        - History, completion paths
# 7.  MODERN CLI REPLACEMENTS    - eza, bat, rg wrappers
# 8.  FUNCTIONS                  - Custom utility functions
# 9.  KEY BINDINGS               - Ctrl+R, Ctrl+G, etc.
# 10. ABBREVIATIONS              - Git, Docker, K8s shortcuts
# 11. TOOL INTEGRATIONS          - mise, zoxide, cargo, gh, kubectl
# 12. LOCAL CONFIG               - Load local.fish (before Starship!)
# 13. STARSHIP PROMPT            - MUST BE LAST!
```

### Load Order (CRITICAL)

```
1. /etc/fish/config.fish (system)
2. ~/.config/fish/config.fish (user - sections 0-12)
3. ~/.config/fish/conf.d/*.fish (auto-loaded by Fish)
4. ~/.config/fish/local.fish (section 12)
5. Starship initialization (section 13) ← MUST BE LAST!
```

**Why this order matters:**
- Starship overwrites `fish_prompt` and `fish_right_prompt`
- If anything loads after Starship, it may override the prompt
- conf.d/ is auto-loaded by Fish, no manual sourcing needed

---

## 🔧 Key Components

### 1. Modern CLI Tool Wrappers

```fish
# Defined in Section 7
ls  → eza --icons --group-directories-first
ll  → eza -l --icons --git
la  → eza -la --icons --git
cat → bat --paging=never
grep → rg
```

**Note:** These are Fish functions with `--wraps` for completion inheritance.

### 2. Custom Functions

Located in Section 8 and functions/ directory:

- **ghq_fzf_repo** - Repository navigation (Ctrl+G)
- **update_all** - Update Homebrew, mise, Rust
- **sysinfo** - Display system information
- **mkcd** - Create and enter directory
- **port** - Check port usage

### 3. Abbreviations (Section 10)

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

### 4. Tool Integrations (Section 11)

- **mise** - Runtime version manager (asdf successor)
- **zoxide** - Smart directory jumping
- **GitHub CLI** - gh completion
- **kubectl** - Kubernetes completion
- **delta** - Git diff pager

---

## 🚨 Known Issues and Solutions

### Issue 1: Broken Prompt (RESOLVED)

**Symptoms:**
```
File: /var/folders/.../tmp.xxx
_fish_prompt
<EMPTY>
1
2 ❯
```

**Cause:** `conf.d/__async_prompt.fish` conflicts with Starship

**Solution (APPLIED):**
```fish
# Already disabled
__async_prompt.fish → __async_prompt.fish.disabled
```

**Documentation:** `docs/ASYNC_PROMPT_ISSUE.md`

### Issue 2: Starship Not Appearing

**Diagnostic:**
```fish
# Check if Starship is installed
type -q starship

# Check config.fish has Starship init at the end
tail -20 ~/.config/fish/config.fish

# Verify nothing loads after Starship
grep -A 999 "starship init" ~/.config/fish/config.fish
```

**Solution:**
```fish
# Install Starship
brew install starship

# Ensure it's last in config.fish (Section 13)
# Reload Fish
exec fish
```

---

## 🛠️ Common Tasks for AI Assistants

### Task 1: Add a New Abbreviation

```fish
# Location: config.fish Section 10
if status is-interactive
    abbr -a <shortcut> '<full-command>'
end
```

**Example:**
```fish
abbr -a gl 'git log --oneline --graph'
```

### Task 2: Add a Custom Function

**Option A: Inline in config.fish (Section 8)**
```fish
function my_function -d "Description"
    # Implementation
end
```

**Option B: Separate file in functions/**
```fish
# Create: functions/my_function.fish
function my_function -d "Description"
    # Implementation
end
```

**Best Practice:** Use functions/ for complex functions (>10 lines).

### Task 3: Add Environment Variable

```fish
# Location: config.fish Section 4
set -gx MY_VAR "value"
```

### Task 4: Debug Configuration Issues

```fish
# 1. Run diagnostic script
fish ~/.config/fish/scripts/test_config.fish

# 2. Check syntax
fish -n ~/.config/fish/config.fish

# 3. Test in clean environment
fish --no-config

# 4. Profile startup time
fish --profile-startup /tmp/fish-startup.prof -ic exit
```

### Task 5: Add a Plugin

```fish
# Using Fisher (preferred)
fisher install <author>/<repo>

# Or add to fish_plugins file
echo "<author>/<repo>" >> ~/.config/fish/fish_plugins
fisher update
```

---

## 📚 Documentation Reference

### For Users
- **README.md** - Complete guide with examples
- **docs/QUICK_REFERENCE.md** - Quick troubleshooting
- **docs/ASYNC_PROMPT_ISSUE.md** - Prompt problem details

### For Developers/AI
- **CLAUDE.md** - This file (AI guidelines)
- **docs/CHANGES_EXPLAINED.md** - Detailed change rationale
- **scripts/test_config.fish** - Diagnostic tool

---

## 🧪 Testing Guidelines

### Before Committing Changes

```fish
# 1. Syntax check
fish -n ~/.config/fish/config.fish

# 2. Test in new session
fish -c "source ~/.config/fish/config.fish; echo 'Config loaded'"

# 3. Check prompt
fish -c "functions fish_prompt | head -5"

# 4. Verify tools
type -q starship eza bat rg fzf zoxide
```

### Creating Backups

```fish
# Automatic backup on changes
cp ~/.config/fish/config.fish \
   ~/.config/fish/backups/config.fish.backup.$(date +%Y%m%d_%H%M%S)
```

---

## 🎨 Customization: local.fish

For machine-specific settings that shouldn't be in git:

```fish
# ~/.config/fish/local.fish (create if needed)

# Machine-specific environment
set -gx WORK_PROXY "http://proxy.company.com:8080"

# Personal shortcuts
abbr -a vpn 'sudo openvpn /path/to/config.ovpn'

# Custom PATH additions
set -gx PATH $HOME/custom/bin $PATH

# ⚠️ NEVER define fish_prompt or fish_right_prompt here!
```

**Add to .gitignore:**
```gitignore
local.fish
```

---

## 🔍 Troubleshooting Decision Tree

```
Problem: Prompt is broken
├─ Contains "File:", "<EMPTY>", numbers?
│  └─ YES → Check conf.d/__async_prompt.fish.disabled
│           → Run: fish ~/.config/fish/scripts/test_config.fish
│
├─ Starship not showing?
│  └─ Run: type -q starship
│     ├─ NOT FOUND → brew install starship
│     └─ FOUND → Check config.fish Section 13
│
└─ Colors/icons missing?
   └─ Check: Terminal supports 24-bit color
              Nerd Font installed
```

**Quick Fix:**
```fish
# Clear prompt functions
functions -e fish_prompt fish_right_prompt

# Reload Fish
exec fish
```

---

## 📊 Performance Considerations

### Startup Time Budget
- **Target:** <100ms
- **Current:** ~50-80ms (with all plugins)

### Optimization Tips
1. ✅ Conditional loading (mise only in project dirs)
2. ✅ Lazy-load completions
3. ✅ Minimal conf.d/ plugins
4. ❌ Avoid heavy operations in config.fish

### Profile Startup
```fish
fish --profile-startup /tmp/fish-startup.prof -ic exit
cat /tmp/fish-startup.prof
```

---

## 🔐 Security Best Practices

### Secrets Management
- **NEVER** hardcode API keys in config.fish
- **USE** local.fish for sensitive values (in .gitignore)
- **PREFER** external secret managers (1Password, pass, etc.)

### Example: Safe Secret Loading
```fish
# In local.fish (gitignored)
if test -f ~/.secrets/api_keys.fish
    source ~/.secrets/api_keys.fish
end
```

---

## 🚀 Advanced Features

### 1. FZF Integration

```fish
# Ctrl+R - History search
# Ctrl+G - Repository search (ghq)
# Ctrl+F - File search
# Ctrl+Alt+C - Directory search
```

**Customization:** Section 5 in config.fish

### 2. Zoxide Integration

```fish
# Smart directory jumping
z <partial-path>  # Jump to frequently used directory
zi                # Interactive selection
```

### 3. mise (Runtime Manager)

```fish
# Auto-activates in project directories
# Reads: .mise.toml or .tool-versions
# Example: mise use node@20 python@3.11
```

---

## 📝 Contribution Guidelines (for AI)

### When Modifying config.fish

1. **Preserve section structure** (13 sections)
2. **Update section comments** if adding new functionality
3. **Test thoroughly** (syntax, functionality, startup time)
4. **Document changes** in relevant docs/ files
5. **Create backup** in backups/ directory

### When Creating New Files

1. **Use appropriate directory:**
   - Docs → docs/
   - Scripts → scripts/
   - Functions → functions/
   - Backups → backups/

2. **Follow naming conventions:**
   - Docs: SCREAMING_SNAKE_CASE.md
   - Scripts: snake_case.fish
   - Functions: snake_case.fish

3. **Add to .gitignore if needed**

---

## 🆘 Emergency Recovery

### Complete Reset

```fish
# 1. Backup current state
mv ~/.config/fish ~/.config/fish.broken

# 2. Restore from backup
cp -r ~/.config/fish/backups/config.fish.backup.* \
      ~/.config/fish/config.fish

# 3. Reload
exec fish
```

### Minimal Configuration

```fish
# Create minimal config.fish for debugging
echo '# Minimal config
set -gx PATH /opt/homebrew/bin $PATH
if type -q starship
    starship init fish | source
end' > ~/.config/fish/config.fish

exec fish
```

---

## 📖 External Resources

### Official Documentation
- [Fish Shell](https://fishshell.com/docs/current/)
- [Starship Prompt](https://starship.rs/)
- [Fisher Plugin Manager](https://github.com/jorgebucaran/fisher)

### Tool Documentation
- [eza](https://github.com/eza-community/eza)
- [bat](https://github.com/sharkdp/bat)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fzf](https://github.com/junegunn/fzf)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [mise](https://github.com/jdx/mise)

### Community Resources
- [Modern Unix Tools](https://github.com/ibraheemdev/modern-unix)
- [Awesome Fish](https://github.com/jorgebucaran/awsm.fish)

---

## ✅ Final Checklist for AI Assistants

Before completing any task:

- [ ] Read relevant documentation (README.md, docs/)
- [ ] Test changes with `fish -n config.fish`
- [ ] Verify Starship initialization is last
- [ ] Check no prompt functions in functions/
- [ ] Update documentation if needed
- [ ] Create backup in backups/
- [ ] Test in clean Fish session
- [ ] Verify no errors in startup

---

**This configuration is production-ready and battle-tested.**
**When in doubt, refer to README.md and docs/ for details.**

---

**Maintained by:** nwiizo
**AI Assistant:** Claude (Anthropic)
**Last Verified:** 2025-11-08
