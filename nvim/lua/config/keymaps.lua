-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- LazyVim provides: <C-h/j/k/l> window nav, <S-h/l> buffer nav,
-- <leader>bd/bo buffer, <C-s> save, <Esc> clear hl, [d/]d diagnostics,
-- <leader>|/- splits, <leader>cf format, <leader>cr rename, <leader>ca code action,
-- gd/gr/gI/gy LSP nav, K hover, <A-j/k> move lines, <leader>/ grep,
-- <leader>fn new file, <leader>uf toggle format, <c-/> terminal

local map = vim.keymap.set

local function copy_file_reference(include_line, visual)
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Current buffer has no file path", vim.log.levels.WARN)
    return
  end

  local root = vim.fs.root(file, { ".jj", ".git" }) or vim.uv.cwd()
  local reference = vim.fs.relpath(root, file) or file

  if include_line then
    local first = vim.fn.line(".")
    local last = first
    if visual then
      first = vim.fn.line("v")
      last = vim.fn.line(".")
      if first > last then
        first, last = last, first
      end
    end
    reference = reference .. ":" .. first
    if last ~= first then
      reference = reference .. "-" .. last
    end
  end

  vim.fn.setreg("+", reference)
  vim.fn.setreg('"', reference)
  vim.notify("Copied " .. reference)
end

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

-- Utility
map("n", "<leader>cx", "<cmd>!chmod +x %<cr>", { silent = true, desc = "Make file executable" })
map("n", "<leader>sR", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })
map("n", "<leader>yp", function()
  copy_file_reference(false, false)
end, { desc = "Copy repository-relative path" })
map("n", "<leader>yl", function()
  copy_file_reference(true, false)
end, { desc = "Copy path with line" })
map("x", "<leader>yl", function()
  copy_file_reference(true, true)
end, { desc = "Copy path with line range" })
