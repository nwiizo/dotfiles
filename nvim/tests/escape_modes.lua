-- Start normally: no InsertEnter, CmdlineEnter, or TermEnter before this test.
-- Use isolated HOME/XDG directories, as for plugin_config.lua.
-- Headless Neovim has no attached UI; replay the event that triggers VeryLazy.
vim.api.nvim_exec_autocmds("UIEnter", { modeline = false })
vim.defer_fn(function()
  local ok, err = pcall(function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "first", "second", "third" })
    local function type_keys(keys)
      assert(
        vim.wait(2000, function()
          return not package.loaded.better_escape or not package.loaded.better_escape.waiting
        end),
        "Previous escape sequence did not time out"
      )
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "xt", false)
    end
    type_keys("vjk")
    assert(vim.fn.mode() == "n", "jk did not exit the first Visual selection after startup")
    type_keys("ghjk")
    assert(vim.fn.mode() == "n", "jk did not exit Select mode: " .. vim.fn.mode())
    type_keys("ihello jk")
    assert(vim.fn.mode() == "n", "jk did not exit Insert mode")
    assert(vim.api.nvim_get_current_line():find("hello ", 1, true), "Insert text was lost")
    assert(not vim.api.nvim_get_current_line():find("jk", 1, true), "Escape keys were inserted")
  end)
  if not ok then
    io.stderr:write(tostring(err) .. "\n")
    vim.cmd.cquit()
    return
  end
  io.stdout:write("escape-modes-ok: first Visual selection, Select and Insert modes\n")
  vim.cmd("qa!")
end, 2000)
