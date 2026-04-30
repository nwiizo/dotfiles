-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Only settings that DIFFER from LazyVim defaults are listed here.

local o = vim.o

local nix_profile_bin = vim.fn.expand("~/.nix-profile/bin")
local path = vim.env.PATH or ""
if vim.fn.isdirectory(nix_profile_bin) == 1 and not path:find(nix_profile_bin, 1, true) then
  vim.env.PATH = nix_profile_bin .. ":" .. path
end

-- 2026 Minimal UI: statusline-less workflow for maximum editing space
o.cmdheight = 0 -- LazyVim: 1
o.laststatus = 0 -- LazyVim: 3
o.numberwidth = 4

-- Scrolling (LazyVim: scrolloff=4)
o.scrolloff = 8

-- Search (not in LazyVim defaults)
o.hlsearch = true
o.incsearch = true

-- Undo (not in LazyVim defaults)
o.undolevels = 10000

-- UI (not in LazyVim defaults)
o.cursorlineopt = "both"
o.winborder = "rounded"

-- Files (not in LazyVim defaults)
o.swapfile = false
o.backup = false
o.autoread = true

-- Word wrap (LazyVim: wrap=false)
o.wrap = true
o.linebreak = true
o.breakindent = true
