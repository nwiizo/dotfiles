-- Diagnostics & Code Quality plugins
-- LazyVim manages: trouble.nvim, todo-comments.nvim
return {
  -- nvim-bqf: Better quickfix preview and filtering
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    keys = {
      {
        "zf",
        function()
          require("config.television").quickfix()
        end,
        ft = "qf",
        desc = "Filter Quickfix (Television)",
      },
    },
    opts = {
      auto_enable = true,
      func_map = { fzffilter = "" },
      preview = {
        border = "rounded",
      },
    },
  },

  -- trouble.nvim: Override
  {
    "folke/trouble.nvim",
    opts = { auto_close = true, auto_preview = true, focus = true },
  },

  -- todo-comments.nvim: Override keywords; <leader>st / <leader>sT pickers come from LazyVim
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
  },
}
