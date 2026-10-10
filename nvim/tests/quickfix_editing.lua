-- Run with the normal config and isolated HOME/XDG directories.
vim.api.nvim_exec_autocmds("UIEnter", { modeline = false })
vim.defer_fn(function()
  local dir = vim.fn.tempname()
  vim.fn.mkdir(dir, "p")
  local ok, err = pcall(function()
    local paths = { dir .. "/first.txt", dir .. "/second.txt" }
    local original = { "before", "old value", "after" }
    for _, path in ipairs(paths) do
      vim.fn.writefile(original, path)
    end
    vim.cmd.edit(vim.fn.fnameescape(paths[1]))
    local first = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(first, 0, 1, false, { "unsaved work" })
    vim.fn.setqflist({}, " ", {
      title = "Editing search results",
      items = {
        { filename = paths[1], lnum = 2, col = 1, text = "old value" },
        { filename = paths[2], lnum = 2, col = 1, text = "old value" },
      },
    })
    vim.cmd.copen()
    local qf = vim.api.nvim_get_current_buf()
    assert(vim.bo[qf].modifiable, "Quickfix results cannot be edited")

    local function key(lhs)
      local mapping = vim.fn.maparg(lhs, "n", false, true)
      assert(type(mapping.callback) == "function", "Missing quickfix mapping: " .. lhs)
      mapping.callback()
    end
    key(">")
    assert(
      vim.wait(2000, function()
        return #vim.fn.getqflist() > 2
      end),
      "Context lines did not expand"
    )
    key("<")
    assert(
      vim.wait(2000, function()
        return #vim.fn.getqflist() == 2
      end),
      "Context lines did not collapse"
    )
    assert(vim.fn.maparg("zf", "n") ~= "", "Television filter mapping was lost")
    assert(vim.fn.maparg("<C-v>", "n") ~= "", "bqf split mapping was lost")

    -- Line numbers are drawn asynchronously; wait before editing their text.
    assert(
      vim.wait(2000, function()
        local ns = vim.api.nvim_get_namespaces().quicker_locations
        return ns and #vim.api.nvim_buf_get_extmarks(qf, ns, 0, -1, {}) == 2
      end),
      "Quickfix line numbers did not render"
    )
    -- Use a real editing command so quickfix's line-tracking extmarks survive.
    vim.cmd("%s/old value/new value/g")
    vim.cmd.write()
    for index, path in ipairs(paths) do
      local buf = vim.fn.bufnr(path)
      local expected = { index == 1 and "unsaved work" or "before", "new value", "after" }
      local actual = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      assert(vim.deep_equal(actual, expected), "Unexpected source contents: " .. vim.inspect(actual))
      assert(vim.bo[buf].modified, "Source buffer was saved automatically")
      assert(vim.deep_equal(vim.fn.readfile(path), original), "Quickfix unexpectedly wrote a source file")
    end
    vim.cmd.cclose()
  end)
  vim.fn.delete(dir, "rf")
  if not ok then
    io.stderr:write(tostring(err) .. "\n")
    vim.cmd.cquit()
    return
  end
  io.stdout:write("quickfix-editing-ok: context, bqf keys, multi-file edits, unsaved work and disk preserved\n")
  vim.cmd("qa!")
end, 2000)
