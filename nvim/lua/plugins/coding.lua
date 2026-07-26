-- Coding enhancements
return {
  -- yanky.nvim: Disable <leader>p (conflicts with Peek group), use <leader>sy for yank history
  {
    "gbprod/yanky.nvim",
    keys = {
      { "<leader>p", false },
      {
        "<leader>sy",
        function()
          require("telescope").extensions.yank_history.yank_history({})
        end,
        desc = "Yank History",
      },
    },
  },

  -- refactoring.nvim: Treesitter-based refactoring (<leader>R prefix to avoid Rust <leader>r)
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "lewis6991/async.nvim" },
    keys = {
      {
        "<leader>Rf",
        function()
          return require("refactoring").extract_func()
        end,
        desc = "Extract Function",
        mode = { "n", "x" },
        expr = true,
      },
      {
        "<leader>RF",
        function()
          return require("refactoring").extract_func_to_file()
        end,
        desc = "Extract Function to File",
        mode = { "n", "x" },
        expr = true,
      },
      {
        "<leader>Rv",
        function()
          return require("refactoring").extract_var()
        end,
        desc = "Extract Variable",
        mode = { "n", "x" },
        expr = true,
      },
      {
        "<leader>Ri",
        function()
          return require("refactoring").inline_var()
        end,
        desc = "Inline Variable",
        mode = { "n", "x" },
        expr = true,
      },
      {
        "<leader>Rp",
        function()
          return require("refactoring.debug").print_loc({ output_location = "below" })
        end,
        desc = "Debug Print Location",
        expr = true,
      },
      {
        "<leader>RP",
        function()
          -- refactoring.nvim v2 returns an operator; target the current word.
          return require("refactoring.debug").print_var({ output_location = "below" }) .. "iw"
        end,
        desc = "Debug Print Variable",
        mode = "n",
        expr = true,
      },
      {
        "<leader>RP",
        function()
          return require("refactoring.debug").print_var({ output_location = "below" })
        end,
        desc = "Debug Print Variable",
        mode = "x",
        expr = true,
      },
      {
        "<leader>Rc",
        function()
          -- `ag` is LazyVim's mini.ai textobject for the whole buffer.
          return require("refactoring.debug").cleanup({ restore_view = true }) .. "ag"
        end,
        desc = "Debug Cleanup",
        expr = true,
      },
      {
        "<leader>Rs",
        function()
          require("refactoring").select_refactor()
        end,
        desc = "Refactoring Selector",
        mode = { "n", "x" },
      },
    },
    opts = {},
  },

  -- treesj: Split/join syntax nodes using Treesitter
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>cj", "<cmd>TSJToggle<cr>", desc = "Toggle Split/Join Node" },
      { "<leader>cJ", "<cmd>TSJSplit<cr>", desc = "Split Node" },
      { "<leader>cK", "<cmd>TSJJoin<cr>", desc = "Join Node" },
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 160,
    },
  },
}
