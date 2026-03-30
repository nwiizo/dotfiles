-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- LazyVim provides: <C-h/j/k/l> window nav, <S-h/l> buffer nav,
-- <leader>bd/bo buffer, <C-s> save, <Esc> clear hl, [d/]d diagnostics,
-- <leader>|/- splits, <leader>cf format, <leader>cr rename, <leader>ca code action,
-- gd/gr/gI/gy LSP nav, K hover, <A-j/k> move lines, <leader>/ grep,
-- <leader>fn new file, <leader>uf toggle format, <c-/> terminal

local map = vim.keymap.set

-- Basic
map("n", ";", ":", { desc = "CMD enter command mode" })

-- Centered navigation
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- Visual mode: move lines (also available via LazyVim's <A-j/k>)
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move lines down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move lines up" })

-- Paste/delete without yank
map("x", "<leader>P", [["_dP]], { desc = "Paste without overwrite" })
map({ "n", "v" }, "<leader>D", [["_d]], { desc = "Delete without yank" })

-- LSP extras (not in LazyVim defaults)
map("n", "<leader>lk", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
map("n", "<leader>lwl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "List workspace folders" })

-- Diagnostics extras
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- Terminal
map("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Quickfix navigation
map("n", "<leader>j", "<cmd>cnext<cr>zz", { desc = "Next quickfix" })
map("n", "<leader>k", "<cmd>cprev<cr>zz", { desc = "Prev quickfix" })

-- Window management
map("n", "<leader>w=", "<C-w>=", { desc = "Equal split sizes" })
map("n", "<leader>wm", "<cmd>only<cr>", { desc = "Maximize window" })
