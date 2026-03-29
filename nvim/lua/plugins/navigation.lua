-- Navigation & Search plugins
-- LazyVim manages: Snacks.nvim, flash.nvim, persistence.nvim, telescope, oil
return {
  -- Snacks.nvim: Override LazyVim defaults
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
      bigfile = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = true },
      indent = { enabled = true },
      scroll = { enabled = true },
      zen = { enabled = true },
      rename = { enabled = true },
      input = { enabled = true },
      terminal = { enabled = true, win = { style = "terminal" } },
      lazygit = {
        configure = true,
        config = {
          os = { editPreset = "nvim-remote" },
          gui = { nerdFontsVersion = "3" },
        },
        theme_path = vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml"),
        theme = {
          [241] = { fg = "Special" },
          activeBorderColor = { fg = "MatchParen", bold = true },
          defaultFgColor = { fg = "Normal" },
          inactiveBorderColor = { fg = "FloatBorder" },
          selectedLineBgColor = { bg = "Visual" },
          unstagedChangesColor = { fg = "DiagnosticError" },
        },
      },
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
      { "<leader><leader>", function() Snacks.picker.smart() end, desc = "Smart Picker" },
      { "<leader>gg", function() Snacks.lazygit.open() end, desc = "LazyGit" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "LazyGit Log" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "LazyGit File Log" },
      { "<leader>tt", function() Snacks.terminal() end, desc = "Toggle Terminal" },
      { "<leader>uz", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<leader>uZ", function() Snacks.zen.zoom() end, desc = "Toggle Zen Zoom" },
    },
  },

  -- hbac.nvim: Auto close unused buffers
  {
    "axkirillov/hbac.nvim",
    event = "VeryLazy",
    opts = { autoclose = true, threshold = 10, close_buffers_with_windows = false },
  },

  -- telescope: Override for custom layout
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        prompt_prefix = "   ",
        selection_caret = " ",
        sorting_strategy = "ascending",
        layout_config = { horizontal = { prompt_position = "top", preview_width = 0.55 } },
        file_ignore_patterns = { "node_modules", ".git/", "target/", "dist/", "build/" },
      },
      pickers = {
        find_files = { hidden = true },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
      },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { "<leader>fc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
      { "<leader>fs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
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

  -- flash.nvim: Override for rainbow labels
  {
    "folke/flash.nvim",
    opts = {
      labels = "asdfghjklqwertyuiopzxcvbnm",
      search = { multi_window = true },
      label = { rainbow = { enabled = true, shade = 5 } },
      modes = { char = { jump_labels = true } },
    },
  },

  -- overlook.nvim: Code peek in floating popups
  {
    "WilliamHsieh/overlook.nvim",
    event = "LspAttach",
    keys = {
      { "<leader>pd", function() require("overlook").open_definition() end, desc = "Peek Definition" },
      { "<leader>pc", function() require("overlook").close_all() end, desc = "Close All Popups" },
      { "<leader>pu", function() require("overlook").restore_one() end, desc = "Restore Last Popup" },
      { "<leader>pU", function() require("overlook").restore_all() end, desc = "Restore All Popups" },
      { "<leader>pf", function() require("overlook").toggle_focus() end, desc = "Toggle Focus" },
      { "<leader>ps", function() require("overlook").open_in_split() end, desc = "Open in Split" },
      { "<leader>pv", function() require("overlook").open_in_vsplit() end, desc = "Open in VSplit" },
      { "<leader>po", function() require("overlook").open_in_original() end, desc = "Open in Original" },
    },
    opts = { border = "rounded", max_width = 100, max_height = 20 },
  },
}
