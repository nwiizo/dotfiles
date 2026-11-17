-- Run with the normal config and isolated HOME/XDG directories.
-- Load the AI clients in order: later plugins must not overwrite earlier mappings.
require("lazy").load({ plugins = { "claudecode.nvim" } })
require("lazy").load({ plugins = { "CopilotChat.nvim" } })
require("lazy").load({ plugins = { "yanky.nvim" } })
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
    for _, mode in ipairs({ "n", "x" }) do
      check(vim.fn.maparg("<leader>p", mode) == "", "Old Yanky prefix remains in " .. mode .. " mode")
      check(type(mapping("<leader>sy", mode).callback) == "function", "Yank history is missing in " .. mode .. " mode")
    end
    assert(#failures == 0, table.concat(failures, "\n"))
  end)
  if not ok then
    io.stderr:write(tostring(err) .. "\n")
    vim.cmd.cquit()
    return
  end
  io.stdout:write("keymap-conflicts-ok: AI load order, visual yank history\n")
  vim.cmd("qa!")
end, 2000)
