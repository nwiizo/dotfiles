-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Keep intentional overrides; leave shared defaults to Neovim and LazyVim.

local o = vim.o

-- Statusline-less UI leaves more room for code and agent terminals.
o.cmdheight = 0 -- LazyVim: 1
o.laststatus = 0 -- LazyVim: 3

-- Scrolling (LazyVim: scrolloff=4)
o.scrolloff = 8

-- Floating windows
o.winborder = "rounded"

-- Files (not in LazyVim defaults)
o.swapfile = false

-- Word wrap (LazyVim: wrap=false)
o.wrap = true
o.breakindent = true

-- Copilot: inline ghost text only. LazyVim would otherwise add copilot as a
-- blink.cmp source that outranks LSP items; inline keeps <Tab>/<M-l> accept.
vim.g.ai_cmp = false
