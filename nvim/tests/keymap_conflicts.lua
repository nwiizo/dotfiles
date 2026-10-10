-- Run with the normal config and isolated HOME/XDG directories.
-- Load the other AI clients first: Avante must not overwrite their mappings.
require("lazy").load({ plugins = { "claudecode.nvim" } })
require("lazy").load({ plugins = { "CopilotChat.nvim" } })
require("lazy").load({ plugins = { "avante.nvim", "yanky.nvim" } })
vim.api.nvim_exec_autocmds("UIEnter", { modeline = false })

vim.defer_fn(function()
  local ok, err = pcall(function()
    local failures = {}
    local function check(condition, message)
      if not condition then
        failures[#failures + 1] = message
      end
    end
    local function mapping(lhs, mode)
      return vim.fn.maparg(lhs, mode or "n", false, true)
    end
    check(mapping("<leader>an").rhs == "<cmd>ClaudeCodeDiffDeny<cr>", "Claude diff denial was overwritten")
    check(mapping("<leader>am").rhs == "<cmd>CopilotChatModels<cr>", "CopilotChat model selection was overwritten")
    check(mapping("<leader>aM").rhs == "<cmd>ClaudeCodeSelectModel<cr>", "Claude model selection was overwritten")
    check(mapping("<leader>aX").rhs == "<Plug>(AvanteStop)", "Avante stop has no distinct key")
    check(mapping("<leader>aS").rhs == "<Plug>(AvanteRefresh)", "Avante refresh mapping was lost")
    check(mapping("<leader>aN").rhs == "<Plug>(AvanteAskNew)", "Avante new chat has no distinct key")
    check(mapping("<leader>aE", "x").rhs == "<Plug>(AvanteEdit)", "Avante visual edit mapping was lost")
    for _, mode in ipairs({ "n", "x" }) do
      check(vim.fn.maparg("<leader>p", mode) == "", "Old Yanky prefix remains in " .. mode .. " mode")
      check(type(mapping("<leader>sy", mode).callback) == "function", "Yank history is missing in " .. mode .. " mode")
    end
    assert(#failures == 0, table.concat(failures, "\n"))

    -- Only replace the external action boundary; dispatch through the real keys.
    local api = require("avante.api")
    local stop, refresh = api.stop, api.refresh
    local calls = {}
    api.stop = function()
      calls[#calls + 1] = "stop"
    end
    api.refresh = function()
      calls[#calls + 1] = "refresh"
    end
    vim.api.nvim_feedkeys(" aX aS", "xt", false)
    api.stop, api.refresh = stop, refresh
    assert(vim.deep_equal(calls, { "stop", "refresh" }), "Stop and refresh dispatched to the wrong action")
  end)
  if not ok then
    io.stderr:write(tostring(err) .. "\n")
    vim.cmd.cquit()
    return
  end
  io.stdout:write("keymap-conflicts-ok: AI load order, stop/refresh dispatch, visual yank history\n")
  vim.cmd("qa!")
end, 2000)
