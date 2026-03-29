-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "aquarium",
  -- Transparent background for better integration with modes.nvim
  transparency = false,
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    -- Enhance cursorline visibility for modes.nvim
    CursorLine = { bg = "#2a2a3a" },
    CursorLineNr = { fg = "#fab387", bold = true },
  },
}

M.ui = {
  -- Disable NvChad statusline (using incline.nvim instead)
  statusline = {
    enabled = false,
  },
  -- Disable tabufline (using Snacks picker instead)
  tabufline = {
    enabled = false,
  },
  -- Disable NvChad's cmp icons (we have custom)
  cmp = {
    icons_left = false,
    style = "default",
  },
}

return M
