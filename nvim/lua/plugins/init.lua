-- Plugin loader: imports all plugin modules
-- Each module returns a table of lazy.nvim plugin specs

local function merge_plugins(...)
  local result = {}
  for _, plugins in ipairs { ... } do
    for _, plugin in ipairs(plugins) do
      table.insert(result, plugin)
    end
  end
  return result
end

return merge_plugins(
  require "plugins.ui",         -- UI: incline, modes, noice, notify, vimade, better-escape, which-key, indent-blankline
  require "plugins.navigation", -- Navigation: snacks, telescope, oil, flash, overlook, hbac
  require "plugins.git",        -- Git: gitsigns, diffview
  require "plugins.diagnostics",-- Diagnostics: trouble, todo-comments
  require "plugins.lsp",        -- LSP: conform, lspconfig, mason, schemastore, treesitter
  require "plugins.ai",         -- AI: copilot, copilot-chat, avante, claudecode
  require "plugins.completion", -- Completion: nvim-cmp
  require "plugins.lang"        -- Language: crates, rustaceanvim, cargo, marp
)
