require "nvchad.options"

local o = vim.o
local opt = vim.opt

-- UI
o.cursorlineopt = "both" -- Enable cursorline
o.relativenumber = true -- Relative line numbers
o.scrolloff = 8 -- Keep 8 lines above/below cursor
o.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
o.signcolumn = "yes" -- Always show sign column

-- Editing
o.tabstop = 2 -- Tab width
o.shiftwidth = 2 -- Indent width
o.expandtab = true -- Use spaces instead of tabs
o.smartindent = true -- Smart indentation
o.wrap = false -- Don't wrap lines

-- Search
o.ignorecase = true -- Ignore case in search
o.smartcase = true -- Override ignorecase if search has uppercase
o.hlsearch = true -- Highlight search results
o.incsearch = true -- Incremental search

-- Performance
o.updatetime = 250 -- Faster CursorHold
o.timeoutlen = 300 -- Faster key sequence completion

-- Files
o.undofile = true -- Persistent undo
o.backup = false -- No backup files
o.swapfile = false -- No swap files

-- Split behavior
o.splitbelow = true -- Horizontal splits below
o.splitright = true -- Vertical splits right

-- Clipboard
o.clipboard = "unnamedplus" -- Use system clipboard

-- Completion
o.completeopt = "menu,menuone,noselect"

-- Spelling (for markdown, git commits)
opt.spelllang = { "en_us" }
