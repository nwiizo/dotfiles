-- Navigation & Search plugins: snacks, telescope, oil, flash, overlook, hbac
return {
  -- Snacks.nvim: Modern utilities (picker, lazygit, bufdelete, terminal)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      notifier = { enabled = false },
      quickfile = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = true },
      bufdelete = { enabled = true },
      terminal = { enabled = true, win = { style = "terminal" } },
      lazygit = {
        enabled = true,
        configure = true,
        config = {
          os = { editPreset = "nvim-remote" },
          gui = { nerdFontsVersion = "3" },
        },
        theme_path = vim.fs.normalize(vim.fn.stdpath "cache" .. "/lazygit-theme.yml"),
        theme = {
          [241] = { fg = "Special" },
          activeBorderColor = { fg = "MatchParen", bold = true },
          defaultFgColor = { fg = "Normal" },
          inactiveBorderColor = { fg = "FloatBorder" },
          selectedLineBgColor = { bg = "Visual" },
          unstagedChangesColor = { fg = "DiagnosticError" },
        },
        win = { style = "lazygit" },
      },
      picker = {
        enabled = true,
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
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
      { "<leader>sf", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Grep Word", mode = { "n", "x" } },
      { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>sr", function() Snacks.picker.recent() end, desc = "Recent Files" },
      { "<leader>sc", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume Last Picker" },
      { "<leader>tt", function() Snacks.terminal() end, desc = "Toggle Terminal" },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          vim.print = _G.dd
          Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
          Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
          Snacks.toggle.diagnostics():map "<leader>ud"
          Snacks.toggle.inlay_hints():map "<leader>uh"
        end,
      })
    end,
  },

  -- hbac.nvim: Auto close unused buffers
  {
    "axkirillov/hbac.nvim",
    event = "VeryLazy",
    opts = { autoclose = true, threshold = 10, close_buffers_with_windows = false },
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    cmd = "Telescope",
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
    config = function()
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      telescope.setup {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = " ",
          sorting_strategy = "ascending",
          layout_config = { horizontal = { prompt_position = "top", preview_width = 0.55 } },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Esc>"] = actions.close,
            },
          },
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
        extensions = {
          fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true },
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      }
      telescope.load_extension "fzf"
      telescope.load_extension "ui-select"
    end,
  },

  -- oil.nvim: File manager
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      { "<leader>e", "<cmd>Oil<cr>", desc = "File Explorer (Oil)" },
    },
    config = function()
      require("oil").setup {
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
      }
    end,
  },

  -- flash.nvim: Fast navigation
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    },
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
    opts = {
      border = "rounded",
      max_width = 100,
      max_height = 20,
    },
  },
}
