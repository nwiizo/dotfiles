-- Colorscheme: catppuccin mocha
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      integrations = {
        cmp = true,
        flash = true,
        gitsigns = true,
        mason = true,
        mini = true,
        native_lsp = { enabled = true },
        noice = true,
        notify = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        trouble = true,
        which_key = true,
      },
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
