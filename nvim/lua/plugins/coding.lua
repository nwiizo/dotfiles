-- Coding enhancements
return {
  -- yanky.nvim: Disable <leader>p (conflicts with Peek group), use <leader>sy for yank history
  {
    "gbprod/yanky.nvim",
    keys = {
      { "<leader>p", false },
      { "<leader>sy", function() require("telescope").extensions.yank_history.yank_history({}) end, desc = "Yank History" },
    },
  },

  -- refactoring.nvim: Treesitter-based refactoring (<leader>R prefix to avoid Rust <leader>r)
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>Rf", function() require("refactoring").refactor("Extract Function") end, desc = "Extract Function", mode = "x" },
      { "<leader>RF", function() require("refactoring").refactor("Extract Function To File") end, desc = "Extract Function to File", mode = "x" },
      { "<leader>Rv", function() require("refactoring").refactor("Extract Variable") end, desc = "Extract Variable", mode = "x" },
      { "<leader>Ri", function() require("refactoring").refactor("Inline Variable") end, desc = "Inline Variable", mode = { "n", "x" } },
      { "<leader>Rb", function() require("refactoring").refactor("Extract Block") end, desc = "Extract Block" },
      { "<leader>RB", function() require("refactoring").refactor("Extract Block To File") end, desc = "Extract Block to File" },
      { "<leader>Rp", function() require("refactoring").debug.printf({ below = false }) end, desc = "Debug Print" },
      { "<leader>RP", function() require("refactoring").debug.print_var() end, desc = "Debug Print Variable", mode = { "n", "x" } },
      { "<leader>Rc", function() require("refactoring").debug.cleanup({}) end, desc = "Debug Cleanup" },
      {
        "<leader>Rs",
        function() require("telescope").extensions.refactoring.refactors() end,
        desc = "Refactoring Picker",
        mode = { "n", "x" },
      },
    },
    opts = {},
  },
}
