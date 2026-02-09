require "nvchad.options"

local o = vim.o

-- 2026 Minimal UI Settings
-- statusline-less workflow for maximum editing space
o.cmdheight = 0 -- No command line (noice.nvim handles it)
o.laststatus = 0 -- No statusline (incline.nvim handles it)
o.showmode = false -- No mode text (modes.nvim shows via cursorline color)

-- Line numbers
o.number = true
o.relativenumber = true
o.numberwidth = 4

-- Scrolling
o.scrolloff = 8 -- Keep 8 lines visible above/below cursor
o.sidescrolloff = 8 -- Keep 8 columns visible left/right of cursor

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
o.clipboard = "unnamedplus" -- System clipboard integration

-- Undo
o.undofile = true -- Persistent undo
o.undolevels = 10000

-- Performance
o.updatetime = 200 -- Faster completion
o.timeoutlen = 300 -- Faster key sequence completion

-- UI
o.termguicolors = true
o.signcolumn = "yes" -- Always show sign column
o.cursorline = true -- Highlight current line (for modes.nvim)
o.cursorlineopt = "both" -- Enable cursorline for modes.nvim

-- Files
o.swapfile = false -- No swap files
o.backup = false -- No backup files

-- Splits
o.splitright = true -- Vertical splits to the right
o.splitbelow = true -- Horizontal splits below

-- Ensure line numbers are always enabled (autocmd for safety)
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
  callback = function()
    local exclude_ft = { "NvimTree", "lazy", "mason", "help", "TelescopePrompt", "Avante", "AvanteInput" }
    if not vim.tbl_contains(exclude_ft, vim.bo.filetype) then
      vim.wo.number = true
      vim.wo.relativenumber = true
    end
  end,
  desc = "Ensure line numbers are always shown",
})
