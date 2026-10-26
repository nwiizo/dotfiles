-- Run with the normal config and isolated HOME/XDG directories:
-- nvim --headless -i NONE '+lua dofile("nvim/tests/plugin_config.lua")'
-- Headless Neovim needs UIEnter to trigger the normal VeryLazy startup path.
vim.api.nvim_exec_autocmds("UIEnter", { modeline = false })
vim.defer_fn(function()
  local ok, err = pcall(function()
    assert(vim.fn.exists(":Avante") == 2, "Avante command was not registered after VeryLazy")
    vim.cmd("Avante --help")
    -- Exercise both initial loading and setup; WARN must still emit warnings.
    assert(require("avante.path").available(), "Avante native library did not load")
    local log = require("avante.utils.log")
    assert(log.level == vim.log.levels.WARN, "Avante warning threshold changed")
    assert(log.warn(), "Avante warnings are disabled")
    assert(not log.info(), "Avante informational logging was enabled")

    require("lazy").load({ plugins = { "incline.nvim", "conform.nvim", "nvim-lspconfig" } })
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].buftype = "" -- Exercise modified state on a normal file buffer.
    vim.api.nvim_buf_set_name(buf, vim.fn.tempname() .. ".py")
    local ns = vim.api.nvim_create_namespace("plugin_config_test")
    local severity = vim.diagnostic.severity
    local function displayed_counts()
      local rendered = require("incline.config").render({ buf = buf, focused = false })
      local counts = {}
      for _, part in ipairs(rendered) do
        if type(part) == "table" and type(part[1]) == "string" and part[1]:match("^%d+$") then
          counts[#counts + 1] = part[1]
        end
      end
      return counts
    end
    assert(vim.deep_equal(displayed_counts(), {}), "Empty buffer shows diagnostic counts")
    vim.diagnostic.set(ns, buf, {
      { lnum = 0, col = 0, message = "error one", severity = severity.ERROR },
      { lnum = 0, col = 0, message = "error two", severity = severity.ERROR },
      { lnum = 0, col = 0, message = "warning", severity = severity.WARN },
      { lnum = 0, col = 0, message = "hint", severity = severity.HINT },
    })
    assert(vim.deep_equal(displayed_counts(), { "2", "1" }), "Error/warning counts changed")
    local visible_sign = false
    for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, { details = true })) do
      visible_sign = visible_sign or (mark[4].sign_text or ""):find("%S") ~= nil
    end
    assert(visible_sign, "Diagnostics have no visible severity sign")

    local function label()
      local parts = {}
      for _, part in ipairs(require("incline.config").render({ buf = buf, focused = false })) do
        if type(part) == "table" and type(part[1]) == "string" then
          parts[#parts + 1] = part[1]
        end
      end
      return table.concat(parts)
    end
    assert(label():find("E2", 1, true) and label():find("W1", 1, true), "Diagnostic counts lack severity labels")
    vim.bo[buf].modified = true
    assert(label():find("●", 1, true), "Unsaved edits have no visible marker")
    vim.bo[buf].modified = false
    assert(not label():find("●", 1, true), "Saved buffer still shows the unsaved marker")
    vim.diagnostic.reset(ns, buf)
    assert(vim.deep_equal(displayed_counts(), {}), "Cleared diagnostics remain visible")

    local conform = require("conform")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "import zlib", "import os", "value=  1" })
    local function format()
      local done = false
      conform.format({ bufnr = buf, formatters = conform.formatters_by_ft.python, timeout_ms = 5000 }, function(e)
        assert(not e, vim.inspect(e))
        done = true
      end)
      assert(done, "Synchronous formatting did not complete")
      return vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    end
    local formatted = format()
    assert(vim.deep_equal(formatted, { "import os", "import zlib", "", "value = 1" }), "Python format failed")
    assert(vim.deep_equal(format(), formatted), "A second format changed the output")
    vim.api.nvim_buf_delete(buf, { force = true })
  end)
  if not ok then
    io.stderr:write(tostring(err) .. "\n")
    vim.cmd.cquit()
    return
  end
  io.stdout:write("plugin-config-ok: Avante command and logging, diagnostic counts, Ruff formatting\n")
  vim.cmd("qa!")
end, 2000)
