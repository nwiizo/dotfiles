-- Run with the normal config and isolated HOME/XDG directories:
-- nvim --headless -i NONE '+lua dofile("nvim/tests/plugin_config.lua")'
vim.defer_fn(function()
  local ok, err = pcall(function()
    -- Exercise both initial loading and setup; WARN must still emit warnings.
    assert(require("avante.path").available(), "Avante native library did not load")
    local log = require("avante.utils.log")
    assert(log.level == vim.log.levels.WARN, "Avante warning threshold changed")
    assert(log.warn(), "Avante warnings are disabled")
    assert(not log.info(), "Avante informational logging was enabled")

    require("lazy").load({ plugins = { "incline.nvim", "conform.nvim" } })
    local buf = vim.api.nvim_create_buf(false, true)
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
    print(err)
    vim.cmd.cquit()
    return
  end
  print("plugin-config-ok: Avante logging, diagnostic counts, Ruff formatting")
  vim.cmd("qa!")
end, 2000)
