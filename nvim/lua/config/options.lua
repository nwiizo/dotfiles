-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local o = vim.o

-- 2026 Minimal UI: statusline-less workflow for maximum editing space
o.cmdheight = 0
o.laststatus = 0
o.showmode = false

-- Line numbers
o.number = true
o.relativenumber = true
o.numberwidth = 4

-- Scrolling
o.scrolloff = 8
o.sidescrolloff = 8

-- Indentation
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true

-- Clipboard
o.clipboard = "unnamedplus"

-- Undo
o.undofile = true
o.undolevels = 10000

-- Performance
o.updatetime = 200
o.timeoutlen = 300

-- UI
o.termguicolors = true
o.signcolumn = "yes"
o.cursorline = true
o.cursorlineopt = "both"
o.winborder = "rounded"

-- Files
o.swapfile = false
o.backup = false
o.autoread = true

-- Word wrap
o.wrap = true
o.linebreak = true
o.breakindent = true

-- Splits
o.splitright = true
o.splitbelow = true
