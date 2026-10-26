-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Keep intentional overrides; leave shared defaults to Neovim and LazyVim.

local o = vim.o

-- File lifecycle: commands and navigation must not publish unsaved edits to agents.
-- Keep LazyVim's persistent undo, save confirmation and format-on-save.
o.autowrite = false -- LazyVim: true; autowriteall already defaults to false.
o.swapfile = false

-- Statusline-less UI leaves more room for code and agent terminals.
o.cmdheight = 0 -- LazyVim: 1
o.laststatus = 0 -- LazyVim: 3

-- Reading: keep code unwrapped (LazyVim default); prose is handled in autocmds.lua.
o.scrolloff = 8
o.breakindent = true

-- Floating windows
o.winborder = "rounded"

-- Preview substitutions, including matches outside the visible window.
o.inccommand = "split"

-- Copilot: inline ghost text only. LazyVim would otherwise add copilot as a
-- blink.cmp source that outranks LSP items; inline keeps <Tab>/<M-l> accept.
vim.g.ai_cmp = false
