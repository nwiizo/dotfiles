-- Diagnostics & Code Quality plugins
-- LazyVim manages: trouble.nvim, todo-comments.nvim
return {
  -- trouble.nvim: Override
  {
    "folke/trouble.nvim",
    opts = { auto_close = true, auto_preview = true, focus = true, use_diagnostic_signs = true },
  },

  -- todo-comments.nvim: Override
  {
    "folke/todo-comments.nvim",
    opts = {
      signs = true,
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE" } },
      },
    },
    keys = {
      { "<leader>sT", "<cmd>TodoTelescope<cr>", desc = "Search TODOs" },
    },
  },
}
