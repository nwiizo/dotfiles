-- Run with the normal config and isolated HOME/XDG directories.
vim.api.nvim_exec_autocmds("UIEnter", { modeline = false })
vim.defer_fn(function()
  local dir = vim.fn.tempname()
  vim.fn.mkdir(dir, "p")
  local definition = vim.lsp.buf.definition
  local ok, err = pcall(function()
    require("lazy").load({ plugins = { "overlook.nvim" } })
    vim.o.lines = 50
    vim.o.columns = 140
    vim.fn.writefile({ "first", "second" }, dir .. "/example.txt")
    vim.cmd.edit(vim.fn.fnameescape(dir .. "/example.txt"))
    local source = vim.api.nvim_get_current_buf()
    local root = vim.api.nvim_get_current_win()
    local function key(lhs)
      local mapping = vim.fn.maparg(lhs, "n", false, true)
      assert(type(mapping.callback) == "function", "Missing callback: " .. lhs)
      mapping.callback()
    end
    local function popups()
      return vim.tbl_filter(function(win)
        return vim.w[win].is_overlook_popup
      end, vim.api.nvim_list_wins())
    end
    -- Only the LSP response is simulated; the mapped callback and windows are real.
    vim.lsp.buf.definition = function(opts)
      opts.on_list({
        items = {
          { user_data = { uri = vim.uri_from_bufnr(source) }, filename = "example.txt", lnum = 2, col = 1 },
        },
      })
    end
    key("<leader>pd")
    assert(#popups() == 1, "Definition preview did not open")
    assert(vim.api.nvim_get_current_buf() == source, "Definition opened wrong buffer")
    assert(vim.api.nvim_win_get_cursor(0)[1] == 2, "Definition lost target line")
    key("<leader>pf")
    assert(vim.api.nvim_get_current_win() == root, "Focus did not return to source")
    key("<leader>pf")
    assert(vim.w.is_overlook_popup, "Focus did not return to popup")
    key("<leader>pc")
    assert(#popups() == 0, "Close left popups open")
    key("<leader>pu")
    assert(#popups() == 1, "Restore last popup failed")
    key("<leader>pp")
    assert(#popups() == 2, "Cursor preview did not stack")
    key("<leader>pc")
    key("<leader>pU")
    assert(#popups() == 2, "Restore all popups failed")
    key("<leader>pc")

    for _, split in ipairs({ { "<leader>ps", "col" }, { "<leader>pv", "row" } }) do
      key("<leader>pp")
      key(split[1])
      assert(#popups() == 0, "Promotion left popup open")
      assert(vim.fn.winlayout()[1] == split[2], "Incorrect split orientation")
      assert(vim.api.nvim_get_current_buf() == source, "Split lost source buffer")
      vim.cmd.only()
    end
    key("<leader>pp")
    key("<leader>po")
    assert(#popups() == 0 and vim.fn.winlayout()[1] == "leaf", "Original-window promotion failed")

    local oil = require("oil")
    oil.open(dir)
    local oil_buf = vim.api.nvim_get_current_buf()
    local function entry_row(name)
      for row = 1, vim.api.nvim_buf_line_count(oil_buf) do
        local entry = oil.get_entry_on_line(oil_buf, row)
        if entry and entry.name == name then
          return row
        end
      end
    end
    assert(
      vim.wait(3000, function()
        return entry_row("example.txt") ~= nil
      end),
      "Oil did not load directory"
    )
    vim.fn.writefile({ "external" }, dir .. "/added.txt")
    assert(
      vim.wait(3000, function()
        return entry_row("added.txt") ~= nil
      end),
      "Oil did not notice external file creation"
    )
    assert(vim.fn.rename(dir .. "/added.txt", dir .. "/renamed.txt") == 0)
    assert(
      vim.wait(3000, function()
        return entry_row("renamed.txt") ~= nil and entry_row("added.txt") == nil
      end),
      "Oil did not notice external rename"
    )

    for _, split in ipairs({ { "<C-v>", "row" }, { "<C-s>", "col" } }) do
      vim.api.nvim_win_set_cursor(0, { assert(entry_row("example.txt")), 0 })
      key(split[1])
      assert(
        vim.wait(3000, function()
          return vim.api.nvim_get_current_buf() == source
        end),
        "Oil selection did not open file"
      )
      assert(vim.fn.winlayout()[1] == split[2], "Oil split orientation changed")
      vim.cmd.close()
    end
    -- An external refresh must not overwrite an uncommitted Oil rename.
    assert(
      vim.wait(3000, function()
        return vim.bo[oil_buf].modifiable
      end),
      "Oil did not finish refreshing"
    )
    local row = assert(entry_row("example.txt"))
    local line = vim.api.nvim_buf_get_lines(oil_buf, row - 1, row, false)[1]
    vim.api.nvim_buf_set_lines(oil_buf, row - 1, row, false, { (line:gsub("example%.txt", "pending.txt")) })
    local pending = vim.api.nvim_buf_get_lines(oil_buf, 0, -1, false)
    vim.fn.writefile({ "external" }, dir .. "/another.txt")
    vim.wait(500, function()
      return not vim.deep_equal(pending, vim.api.nvim_buf_get_lines(oil_buf, 0, -1, false))
    end)
    assert(vim.deep_equal(pending, vim.api.nvim_buf_get_lines(oil_buf, 0, -1, false)), "Oil discarded pending edits")
    assert(vim.fn.filereadable(dir .. "/example.txt") == 1, "Test unexpectedly saved Oil edits")
  end)
  vim.lsp.buf.definition = definition
  vim.fn.delete(dir, "rf")
  if not ok then
    io.stderr:write(tostring(err) .. "\n")
    vim.cmd.cquit()
    return
  end
  io.stdout:write("navigation-plugins-ok: Overlook mappings, Oil splits and external changes\n")
  vim.cmd("qa!")
end, 2000)
