-- Run with the normal config and isolated HOME/XDG directories.
vim.api.nvim_exec_autocmds("UIEnter", { modeline = false })

vim.defer_fn(function()
  local ok, err = pcall(function()
    require("lazy").load({ plugins = { "refactoring.nvim", "mini.ai" } })
    local original = { "local value = 1", "print(value)", "-- keep trailing content" }
    vim.api.nvim_buf_set_lines(0, 0, -1, false, original)
    vim.bo.filetype = "lua"
    vim.treesitter.start(0, "lua")

    for _, keys in ipairs({ " RP", " Rp", "viw RP" }) do
      vim.api.nvim_win_set_cursor(0, { 2, 7 })
      vim.api.nvim_feedkeys(keys, "xt", false)
      assert(
        vim.wait(3000, function()
          return vim.api.nvim_buf_line_count(0) > #original
        end),
        "Debug print did not insert a statement: " .. keys
      )
      vim.api.nvim_feedkeys(" Rc", "xt", false)
      assert(
        vim.wait(3000, function()
          return vim.deep_equal(vim.api.nvim_buf_get_lines(0, 0, -1, false), original)
        end),
        "Debug cleanup did not remove the generated statement while preserving the original print: " .. keys
      )
    end
  end)
  if not ok then
    io.stderr:write(tostring(err) .. "\n")
    vim.cmd.cquit()
    return
  end
  io.stdout:write("refactoring-ok: variable/location prints, Visual selection, whole-buffer cleanup\n")
  vim.cmd("qa!")
end, 2000)
