-- Navigation & Search plugins
-- LazyVim manages: Snacks.nvim (picker included), flash.nvim, persistence.nvim
return {
  -- Snacks.nvim: Override LazyVim defaults. Feature toggles, zen/zoom keys, <leader>gg and the
  -- lazygit theme already come from LazyVim and Snacks defaults.
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
      -- <leader>gB opens and <leader>gY copies a permalink for the cursor line or visual range.
      gitbrowse = { what = "permalink" },
      picker = {
        sources = {
          files = { hidden = true, ignored = false },
          grep = { hidden = true },
          buffers = { current = false },
        },
        win = { input = { keys = { ["<Esc>"] = { "close", mode = { "n", "i" } } } } },
      },
    },
    keys = {
      {
        "<leader><leader>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart Picker",
      },
      {
        "<C-p>",
        function()
          LazyVim.pick("files")()
        end,
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>gl",
        function()
          Snacks.lazygit.log()
        end,
        desc = "LazyGit Log",
      },
      {
        "<leader>gf",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "LazyGit File Log",
      },
      {
        "<leader>gC",
        function()
          Snacks.picker.git_status({ cwd = LazyVim.root.git() })
        end,
        desc = "Changed Files (Git Root)",
      },
    },
  },

  -- hbac.nvim: Auto close unused buffers
  {
    "axkirillov/hbac.nvim",
    event = "VeryLazy",
    opts = { autoclose = true, threshold = 10, close_buffers_with_windows = false },
  },

  -- fff: Rust-backed file/content search with typo tolerance and frecency.
  {
    "dmtrKovalenko/fff",
    -- Numeric commit tags can win over release tags with version = "*".
    version = "^0.10.6",
    lazy = true,
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    opts = {},
    keys = {
      {
        "<leader>fP",
        function()
          require("fff").find_files({ cwd = LazyVim.root() })
        end,
        desc = "Find Files (fff, Root)",
      },
      {
        "<leader>sF",
        function()
          require("fff").live_grep({ cwd = LazyVim.root() })
        end,
        desc = "Search Content (fff, Root)",
      },
    },
  },

  -- oil.nvim: File explorer (custom plugin, not a LazyVim extra)
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      default_file_explorer = true,
      columns = { "icon", "permissions", "size", "mtime" },
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = { show_hidden = true, natural_order = true },
      float = { padding = 2, max_width = 120, max_height = 40, border = "rounded" },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["-"] = "actions.parent",
        ["g."] = "actions.toggle_hidden",
      },
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      { "<leader>e", "<cmd>Oil<cr>", desc = "File Explorer (Oil)" },
    },
  },

  -- flash.nvim: Override for rainbow labels (label set and multi_window are defaults)
  {
    "folke/flash.nvim",
    opts = {
      label = { rainbow = { enabled = true, shade = 5 } },
      modes = { char = { jump_labels = true } },
    },
  },

  -- treewalker.nvim: Syntax-tree-aware movement and node swapping
  {
    "aaronik/treewalker.nvim",
    opts = { highlight = true, highlight_duration = 250 },
    keys = {
      { "[w", "<cmd>Treewalker Up<cr>", desc = "Treewalker Up (prev sibling)", mode = { "n", "x" } },
      { "]w", "<cmd>Treewalker Down<cr>", desc = "Treewalker Down (next sibling)", mode = { "n", "x" } },
      { "<A-h>", "<cmd>Treewalker Left<cr>", desc = "Treewalker Left (parent)", mode = { "n", "x" } },
      { "<A-l>", "<cmd>Treewalker Right<cr>", desc = "Treewalker Right (child)", mode = { "n", "x" } },
      { "<A-S-k>", "<cmd>Treewalker SwapUp<cr>", desc = "Swap Node Up" },
      { "<A-S-j>", "<cmd>Treewalker SwapDown<cr>", desc = "Swap Node Down" },
      { "<A-S-h>", "<cmd>Treewalker SwapLeft<cr>", desc = "Swap Node Left" },
      { "<A-S-l>", "<cmd>Treewalker SwapRight<cr>", desc = "Swap Node Right" },
    },
  },

  -- overlook.nvim: Code peek in floating popups
  {
    "WilliamHsieh/overlook.nvim",
    event = "LspAttach",
    keys = {
      {
        "<leader>pd",
        function()
          require("overlook").open_definition()
        end,
        desc = "Peek Definition",
      },
      {
        "<leader>pc",
        function()
          require("overlook").close_all()
        end,
        desc = "Close All Popups",
      },
      {
        "<leader>pu",
        function()
          require("overlook").restore_one()
        end,
        desc = "Restore Last Popup",
      },
      {
        "<leader>pU",
        function()
          require("overlook").restore_all()
        end,
        desc = "Restore All Popups",
      },
      {
        "<leader>pf",
        function()
          require("overlook").toggle_focus()
        end,
        desc = "Toggle Focus",
      },
      {
        "<leader>ps",
        function()
          require("overlook").open_in_split()
        end,
        desc = "Open in Split",
      },
      {
        "<leader>pv",
        function()
          require("overlook").open_in_vsplit()
        end,
        desc = "Open in VSplit",
      },
      {
        "<leader>po",
        function()
          require("overlook").open_in_original()
        end,
        desc = "Open in Original",
      },
    },
    opts = { border = "rounded", max_width = 100, max_height = 20 },
  },
}
