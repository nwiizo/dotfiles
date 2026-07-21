-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Keep 'autoread' responsive to agent edits without checking on every cursor
-- move. CursorHold also covers filesystems where change detection is delayed.
local external_changes = vim.api.nvim_create_augroup("nwiizo_external_changes", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave" }, {
  group = external_changes,
  command = "silent! checktime",
  desc = "Auto-reload files changed outside of nvim",
})

vim.api.nvim_create_autocmd("FileChangedShell", {
  group = external_changes,
  callback = function(args)
    if vim.bo[args.buf].modified or vim.v.fcs_reason == "deleted" then
      vim.v.fcs_choice = "ask"
      local reason = vim.v.fcs_reason == "deleted" and "file was deleted" or "buffer has unsaved edits"
      vim.notify("File changed externally (" .. reason .. ")", vim.log.levels.WARN)
    else
      vim.v.fcs_choice = "reload"
    end
  end,
  desc = "Auto-reload unmodified buffers, ask if buffer has unsaved changes",
})

-- Disable spell check for markdown (Japanese text causes false positives)
-- LazyVim enables spell via lazyvim_wrap_spell autocmd group
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")

-- Ensure line numbers are always enabled
local line_numbers = vim.api.nvim_create_augroup("nwiizo_line_numbers", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
  group = line_numbers,
  callback = function()
    local exclude_ft =
      { "NvimTree", "lazy", "mason", "help", "TelescopePrompt", "Avante", "AvanteInput", "snacks_dashboard" }
    if not vim.tbl_contains(exclude_ft, vim.bo.filetype) then
      vim.wo.number = true
      vim.wo.relativenumber = true
    end
  end,
  desc = "Ensure line numbers are always shown",
})
