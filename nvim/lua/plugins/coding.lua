-- Coding enhancements
-- LazyVim manages: yanky (via extras)
return {
  -- yanky.nvim: Override picker key to avoid conflict with <leader>p (Peek)
  {
    "gbprod/yanky.nvim",
    keys = {
      { "<leader>sy", function() require("telescope").extensions.yank_history.yank_history({}) end, desc = "Yank History" },
    },
  },
}
