-- Set leader keys before lazy.nvim loads (required)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Use development versions (recommended by LazyVim docs:
  -- "a lot of plugins that support versioning have outdated releases")
  { "folke/lazy.nvim", version = false },

  -- LazyVim core
  {
    "LazyVim/LazyVim",
    version = false,
    import = "lazyvim.plugins",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },

  -- LazyVim Extras: Languages
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.lang.terraform" },
  { import = "lazyvim.plugins.extras.lang.zig" },
  { import = "lazyvim.plugins.extras.lang.docker" },
  { import = "lazyvim.plugins.extras.lang.toml" },
  { import = "lazyvim.plugins.extras.lang.git" },
  { import = "lazyvim.plugins.extras.lang.nix" },

  -- LazyVim Extras: Editor
  { import = "lazyvim.plugins.extras.editor.telescope" },

  -- LazyVim Extras: DAP & Test
  { import = "lazyvim.plugins.extras.dap.core" },
  { import = "lazyvim.plugins.extras.test.core" },

  -- LazyVim Extras: Coding
  { import = "lazyvim.plugins.extras.coding.yanky" },

  -- LazyVim Extras: UI
  { import = "lazyvim.plugins.extras.ui.treesitter-context" },

  -- LazyVim Extras: Editor enhancements
  { import = "lazyvim.plugins.extras.editor.inc-rename" },
  { import = "lazyvim.plugins.extras.editor.dial" },

  -- LazyVim Extras: AI
  { import = "lazyvim.plugins.extras.ai.copilot" },
  { import = "lazyvim.plugins.extras.ai.copilot-chat" },

  -- Custom plugins
  { import = "plugins" },
}, {
  defaults = { lazy = false, version = false },
  install = { colorscheme = { "catppuccin-mocha", "habamax" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
