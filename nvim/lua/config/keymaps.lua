-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- ┌─────────────────────────────────────────────────────────────┐
-- │ LazyVim provides (DO NOT redefine here):                    │
-- │  <C-h/j/k/l>  window navigation                            │
-- │  <S-h/l>      buffer prev/next                             │
-- │  <leader>bd   buffer delete                                │
-- │  <leader>bo   delete other buffers                         │
-- │  <C-s>        save file                                    │
-- │  <Esc>        clear hlsearch                               │
-- │  [d / ]d      prev/next diagnostic                         │
-- │  <leader>|    vertical split                               │
-- │  <leader>-    horizontal split                             │
-- │  <leader>cf   format (conform)                             │
-- │  <leader>cr   rename (LSP)                                 │
-- │  <leader>ca   code action                                  │
-- │  gd/gr/gI/gy  definition/references/impl/type def          │
-- │  K            hover                                        │
-- │  <A-j/k>      move lines (normal/insert/visual)            │
-- │  <leader>/    grep (root)                                  │
-- │  <leader>fn   new file                                     │
-- │  <leader>uf   toggle auto-format                           │
-- │  <leader>ul   toggle line numbers                          │
-- │  <leader>us   toggle spelling                              │
-- │  <leader>uw   toggle wrap                                  │
-- │  <leader>ud   toggle diagnostics                           │
-- │  <leader>uh   toggle inlay hints                           │
-- │  <c-/>        terminal                                     │
-- └─────────────────────────────────────────────────────────────┘

local map = vim.keymap.set

-- ═══════════════════════════════════════════════════════════════
-- Basic Operations (supplements LazyVim)
-- ═══════════════════════════════════════════════════════════════

map("n", ";", ":", { desc = "CMD enter command mode" })

-- ═══════════════════════════════════════════════════════════════
-- Centered Navigation (LazyVim doesn't center these)
-- ═══════════════════════════════════════════════════════════════

map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- ═══════════════════════════════════════════════════════════════
-- Visual Mode (supplements LazyVim's <A-j/k>)
-- ═══════════════════════════════════════════════════════════════

-- Also allow J/K in visual mode (in addition to LazyVim's <A-j/k>)
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move lines down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move lines up" })

-- Better paste/delete (preserve register)
map("x", "<leader>p", [["_dP]], { desc = "Paste without overwrite" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank" })

-- ═══════════════════════════════════════════════════════════════
-- LSP Extras (not in LazyVim defaults)
-- ═══════════════════════════════════════════════════════════════

map("n", "<leader>fm", function() require("conform").format({ async = true }) end, { desc = "Format buffer (legacy)" })
map("n", "<leader>lk", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("n", "<leader>lD", vim.lsp.buf.type_definition, { desc = "Type definition" })
map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
map("n", "<leader>lwl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "List workspace folders" })

-- ═══════════════════════════════════════════════════════════════
-- Diagnostics Extras (not in LazyVim defaults)
-- ═══════════════════════════════════════════════════════════════

map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- ═══════════════════════════════════════════════════════════════
-- Terminal (supplements LazyVim's <c-/>)
-- ═══════════════════════════════════════════════════════════════

map("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ═══════════════════════════════════════════════════════════════
-- Clipboard & Productivity
-- ═══════════════════════════════════════════════════════════════

map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })

-- Quickfix navigation
map("n", "<leader>j", "<cmd>cnext<cr>zz", { desc = "Next quickfix" })
map("n", "<leader>k", "<cmd>cprev<cr>zz", { desc = "Prev quickfix" })

-- Search and replace word under cursor (manual, complements LazyVim's grug-far)
map("n", "<leader>sW", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word (inline)" })

-- Make file executable
map("n", "<leader>cx", "<cmd>!chmod +x %<cr>", { silent = true, desc = "Make file executable" })

-- ═══════════════════════════════════════════════════════════════
-- Window Management (supplements LazyVim)
-- ═══════════════════════════════════════════════════════════════

map("n", "<leader>w=", "<C-w>=", { desc = "Equal split sizes" })
map("n", "<leader>wm", "<cmd>only<cr>", { desc = "Maximize window" })
