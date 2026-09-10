-- Colorscheme: catppuccin mocha
-- Plugin integrations come from catppuccin's auto_integrations and LazyVim's spec.
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      custom_highlights = function(colors)
        return {
          Comment = { style = { "italic" } },
          ["@comment"] = { style = { "italic" } },
          CursorLine = { bg = colors.surface0 },
          CursorLineNr = { fg = colors.peach, style = { "bold" } },
        }
      end,
    },
  },
}
