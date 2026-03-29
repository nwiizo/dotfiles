-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Auto-reload files changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "silent! checktime",
  desc = "Auto-reload files changed outside of nvim",
})

vim.api.nvim_create_autocmd("FileChangedShell", {
  callback = function()
    if vim.bo.modified then
      vim.v.fcs_choice = "ask"
      vim.notify("File changed externally (buffer has unsaved edits)", vim.log.levels.WARN)
    else
      vim.v.fcs_choice = "reload"
    end
  end,
  desc = "Auto-reload unmodified buffers, ask if buffer has unsaved changes",
})

-- Ensure line numbers are always enabled
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
  callback = function()
    local exclude_ft = { "NvimTree", "lazy", "mason", "help", "TelescopePrompt", "Avante", "AvanteInput", "snacks_dashboard" }
    if not vim.tbl_contains(exclude_ft, vim.bo.filetype) then
      vim.wo.number = true
      vim.wo.relativenumber = true
    end
  end,
  desc = "Ensure line numbers are always shown",
})
