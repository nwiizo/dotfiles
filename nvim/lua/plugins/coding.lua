-- Coding enhancements
-- LazyVim manages: mini.ai, yanky (via extra)
return {
  -- Preview alignment without replacing Vim's ga character information.
  {
    "nvim-mini/mini.align",
    version = "*",
    keys = {
      { "gA", mode = { "n", "x" }, desc = "Align with Preview" },
    },
    opts = { mappings = { start = "", start_with_preview = "gA" } },
  },

  -- Select individual matches for simultaneous editing; keep Insert-mode C-n.
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    keys = {
      {
        "<C-n>",
        function()
          require("multicursor-nvim").matchAddCursor(1)
        end,
        mode = { "n", "x" },
        desc = "Add Cursor at Next Match",
      },
      {
        "<leader>cN",
        function()
          require("multicursor-nvim").matchSkipCursor(1)
        end,
        mode = { "n", "x" },
        desc = "Skip Cursor Match",
      },
    },
    opts = {},
    config = function(_, opts)
      local mc = require("multicursor-nvim")
      mc.setup(opts)
      -- Restore the existing Escape mapping when the last extra cursor is gone.
      mc.addKeymapLayer(function(set)
        set("n", "<Esc>", mc.clearCursors)
      end)
    end,
  },

  -- better-escape.nvim: jk/jj to escape
  {
    "max397574/better-escape.nvim",
    -- Install after LazyVim's j/k mappings, including before the first InsertEnter.
    event = "User LazyVimKeymaps",
    opts = {
      timeout = vim.o.timeoutlen,
      default_mappings = false,
      mappings = {
        i = { j = { k = "<Esc>", j = "<Esc>" } },
        c = { j = { k = "<Esc>", j = "<Esc>" } },
        t = { j = { k = "<C-\\><C-n>", j = "<C-\\><C-n>" } },
        x = { j = { k = "<Esc>" } },
        s = { j = { k = "<Esc>" } },
      },
    },
  },

  -- nvim-surround (replaces mini.surround)
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- mini.ai: Add an argument text object; LazyVim already defines o/f/c/t/d/e/g/u/U and n_lines
  {
    "nvim-mini/mini.ai",
    opts = function(_, opts)
      local ai = require("mini.ai")
      opts.custom_textobjects = opts.custom_textobjects or {}
      opts.custom_textobjects.a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" })
      return opts
    end,
  },

  -- vim-matchup: Enhanced % matching with treesitter (replaces disabled matchit/matchparen)
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      vim.g.matchup_treesitter_enabled = 1
    end,
  },

  -- nvim-autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
        rust = { "string", "raw_string_literal" },
      },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = "$",
        before_key = "h",
        after_key = "l",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
  },

  -- yanky.nvim: Disable <leader>p (conflicts with Peek group), use <leader>sy for yank history
  {
    "gbprod/yanky.nvim",
    keys = {
      { "<leader>p", false, mode = { "n", "x" } },
      {
        "<leader>sy",
        function()
          Snacks.picker.yanky()
        end,
        desc = "Yank History",
        mode = { "n", "x" },
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
        remap = true, -- Expand mini.ai's `ag` mapping after the operator.
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
