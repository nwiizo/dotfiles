-- Disable LazyVim defaults that conflict with our minimal UI
return {
  -- No statusline (using incline.nvim floating statusline)
  { "nvim-lualine/lualine.nvim", enabled = false },
  -- No bufferline (using Snacks picker for buffer selection)
  { "akinsho/bufferline.nvim", enabled = false },
  -- Use nvim-surround instead of mini.surround
  { "echasnovski/mini.surround", enabled = false },
  -- Use nvim-autopairs instead of mini.pairs
  { "echasnovski/mini.pairs", enabled = false },
  -- Disable dashboard (start instantly)
  { "folke/snacks.nvim", opts = { dashboard = { enabled = false } } },
}
