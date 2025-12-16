return {
  -- ═══════════════════════════════════════════════════════════════════════════
  -- 2025 MINIMAL UI - Statusline-less workflow for maximum editing space
  -- ═══════════════════════════════════════════════════════════════════════════

  -- incline.nvim: Floating statusline for current file info
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local devicons = require "nvim-web-devicons"

      require("incline").setup {
        window = {
          padding = 0,
          margin = { horizontal = 0, vertical = 0 },
          placement = { horizontal = "right", vertical = "bottom" },
        },
        hide = { cursorline = false, focused_win = false, only_win = false },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end

          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified

          -- Show parent dir for generic filenames
          local generic_names = { "init.lua", "index.ts", "index.js", "mod.rs", "main.go", "main.rs", "lib.rs" }
          local display_name = filename
          for _, name in ipairs(generic_names) do
            if filename == name then
              local full_path = vim.api.nvim_buf_get_name(props.buf)
              local parent = vim.fn.fnamemodify(full_path, ":h:t")
              display_name = parent .. "/" .. filename
              break
            end
          end

          -- Diagnostics
          local diagnostics = {}
          local diag_counts = {
            error = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity.ERROR }),
            warn = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity.WARN }),
          }

          local has_diagnostics = diag_counts.error > 0 or diag_counts.warn > 0
          local text_hl = has_diagnostics and (diag_counts.error > 0 and "DiagnosticError" or "DiagnosticWarn")
            or (props.focused and "Normal" or "Comment")

          if diag_counts.error > 0 then
            table.insert(diagnostics, { "  ", guifg = "#ff6c6b" })
            table.insert(diagnostics, { tostring(diag_counts.error), guifg = "#ff6c6b" })
          end
          if diag_counts.warn > 0 then
            table.insert(diagnostics, { "  ", guifg = "#ECBE7B" })
            table.insert(diagnostics, { tostring(diag_counts.warn), guifg = "#ECBE7B" })
          end

          local res = { guibg = props.focused and "#1e1e2e" or "#11111b", { " " } }

          if ft_icon then
            table.insert(res, { ft_icon, guifg = ft_color })
            table.insert(res, { " " })
          end

          table.insert(res, { display_name, gui = modified and "bold,italic" or "bold", group = text_hl })

          if modified then
            table.insert(res, { " ", guifg = "#fab387" })
          end

          for _, diag in ipairs(diagnostics) do
            table.insert(res, diag)
          end

          table.insert(res, { " " })
          return res
        end,
      }
    end,
  },

  -- modes.nvim: Show mode via cursorline color
  {
    "mvllow/modes.nvim",
    event = "VeryLazy",
    config = function()
      require("modes").setup {
        colors = {
          bg = "",
          copy = "#f5c359",
          delete = "#c75c6a",
          insert = "#78ccc5",
          visual = "#9745be",
        },
        line_opacity = 0.25,
        set_cursor = true,
        set_cursorline = true,
        set_number = true,
        ignore_filetypes = { "NvimTree", "TelescopePrompt", "oil", "lazy", "Avante", "AvanteInput" },
      }
    end,
  },

  -- noice.nvim: Floating cmdline, messages, notifications
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    config = function()
      require("noice").setup {
        cmdline = {
          enabled = true,
          view = "cmdline_popup",
          format = {
            cmdline = { pattern = "^:", icon = "", lang = "vim" },
            search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
            filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
            lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
            help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
          },
        },
        messages = { enabled = true, view = "notify", view_error = "notify", view_warn = "notify" },
        popupmenu = { enabled = true, backend = "nui" },
        lsp = {
          progress = { enabled = true },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          hover = { enabled = true },
          signature = { enabled = true },
        },
        presets = {
          bottom_search = false,
          command_palette = true,
          long_message_to_split = true,
          lsp_doc_border = true,
        },
        views = {
          cmdline_popup = {
            position = { row = "50%", col = "50%" },
            size = { width = 60, height = "auto" },
            border = { style = "rounded", padding = { 0, 1 } },
          },
        },
      }
    end,
  },

  -- nvim-notify: Better notification UI
  {
    "rcarriga/nvim-notify",
    lazy = true,
    config = function()
      require("notify").setup {
        background_colour = "#000000",
        fps = 60,
        render = "compact",
        stages = "fade",
        timeout = 3000,
        top_down = false,
      }
    end,
  },

  -- Vimade: Dim inactive buffers
  {
    "TaDaa/vimade",
    event = "VeryLazy",
    config = function()
      require("vimade").setup {
        fadelevel = 0.5,
        basebg = "#11111b",
        blocklist = { default = { buf_opts = { buftype = { "terminal" } } } },
      }
    end,
  },

  -- better-escape.nvim: jk/jj to escape
  {
    "max397574/better-escape.nvim",
    event = { "InsertEnter", "CmdlineEnter", "TermEnter" },
    opts = {
      timeout = vim.o.timeoutlen,
      default_mappings = false,
      mappings = {
        i = { j = { k = "<Esc>", j = "<Esc>" } },
        c = { j = { k = "<Esc>", j = "<Esc>" } },
        t = { j = { k = "<C-\\><C-n>", j = "<C-\\><C-n>" } },
        v = { j = { k = "<Esc>" } },
        s = { j = { k = "<Esc>" } },
      },
    },
  },

  -- which-key.nvim: Key binding hints (2025 essential)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 300,
      icons = { mappings = true, keys = {} },
      spec = {
        { "<leader>a", group = "AI", icon = "" },
        { "<leader>b", group = "Buffer", icon = "" },
        { "<leader>c", group = "Code/Claude", icon = "" },
        { "<leader>f", group = "Find (Telescope)", icon = "" },
        { "<leader>g", group = "Git", icon = "" },
        { "<leader>l", group = "LSP", icon = "" },
        { "<leader>p", group = "Peek", icon = "" },
        { "<leader>s", group = "Search (Snacks)", icon = "" },
        { "<leader>t", group = "Terminal", icon = "" },
        { "<leader>u", group = "Toggle", icon = "" },
        { "<leader>x", group = "Diagnostics", icon = "" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show { global = false } end, desc = "Buffer Keymaps" },
    },
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- Snacks.nvim: Modern utilities (picker, lazygit, bufdelete, terminal)
  -- ═══════════════════════════════════════════════════════════════════════════

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

  -- ═══════════════════════════════════════════════════════════════════════════
  -- Navigation & Search
  -- ═══════════════════════════════════════════════════════════════════════════

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
          live_grep = { additional_args = function() return { "--hidden" } end },
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

  -- ═══════════════════════════════════════════════════════════════════════════
  -- Git Integration
  -- ═══════════════════════════════════════════════════════════════════════════

  -- gitsigns.nvim: Inline Git info
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      current_line_blame = false,
      current_line_blame_opts = { delay = 500, virtual_text_pos = "eol" },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Next Hunk" })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Prev Hunk" })

        -- Actions
        map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
        map("n", "<leader>gb", function() gs.blame_line { full = true } end, { desc = "Blame Line" })
        map("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Toggle Blame" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
        map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
      end,
    },
  },

  -- diffview.nvim: Git diff visualization
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diff (working tree)" },
      { "<leader>gD", "<cmd>DiffviewOpen HEAD~1<cr>", desc = "Diff vs previous commit" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
      { "<leader>gm", "<cmd>DiffviewOpen main...HEAD<cr>", desc = "Diff vs main branch" },
      { "<leader>gM", "<cmd>DiffviewOpen master...HEAD<cr>", desc = "Diff vs master branch" },
      { "<leader>gs", "<cmd>DiffviewOpen --staged<cr>", desc = "Staged changes" },
      { "<leader>gt", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle file panel" },
    },
    config = function()
      local actions = require "diffview.actions"
      require("diffview").setup {
        enhanced_diff_hl = true,
        use_icons = true,
        view = {
          default = { layout = "diff2_horizontal", winbar_info = true },
          merge_tool = { layout = "diff3_horizontal", disable_diagnostics = true },
          file_history = { layout = "diff2_horizontal", winbar_info = true },
        },
        file_panel = {
          listing_style = "tree",
          tree_options = { flatten_dirs = true },
          win_config = { position = "left", width = 35 },
        },
        keymaps = {
          view = {
            { "n", "<tab>", actions.select_next_entry, { desc = "Next file" } },
            { "n", "<s-tab>", actions.select_prev_entry, { desc = "Prev file" } },
            { "n", "gf", actions.goto_file_edit, { desc = "Open file" } },
            { "n", "[x", actions.prev_conflict, { desc = "Prev conflict" } },
            { "n", "]x", actions.next_conflict, { desc = "Next conflict" } },
            { "n", "<leader>co", actions.conflict_choose "ours", { desc = "Choose ours" } },
            { "n", "<leader>ct", actions.conflict_choose "theirs", { desc = "Choose theirs" } },
            { "n", "<leader>cb", actions.conflict_choose "base", { desc = "Choose base" } },
            { "n", "<leader>ca", actions.conflict_choose "all", { desc = "Choose all" } },
            { "n", "dx", actions.conflict_choose "none", { desc = "Delete conflict" } },
          },
          file_panel = {
            { "n", "j", actions.next_entry, { desc = "Next entry" } },
            { "n", "k", actions.prev_entry, { desc = "Prev entry" } },
            { "n", "<cr>", actions.select_entry, { desc = "Select entry" } },
            { "n", "-", actions.toggle_stage_entry, { desc = "Stage/unstage" } },
            { "n", "s", actions.toggle_stage_entry, { desc = "Stage/unstage" } },
            { "n", "S", actions.stage_all, { desc = "Stage all" } },
            { "n", "U", actions.unstage_all, { desc = "Unstage all" } },
            { "n", "X", actions.restore_entry, { desc = "Restore entry" } },
            { "n", "L", actions.open_commit_log, { desc = "Open commit log" } },
            { "n", "g?", actions.help "file_panel", { desc = "Help" } },
          },
        },
      }
    end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- Diagnostics & Code Quality
  -- ═══════════════════════════════════════════════════════════════════════════

  -- trouble.nvim: Diagnostics panel
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
    },
    opts = { auto_close = true, auto_preview = true, focus = true, use_diagnostic_signs = true },
  },

  -- todo-comments.nvim
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      { "<leader>sT", "<cmd>TodoTelescope<cr>", desc = "Search TODOs" },
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo" },
    },
    opts = {
      signs = true,
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE" } },
      },
    },
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- Formatting & LSP
  -- ═══════════════════════════════════════════════════════════════════════════

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      { "<leader>cf", function() require("conform").format { async = true, lsp_fallback = true } end, desc = "Format Buffer" },
    },
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          typescript = { "prettier", "deno_fmt" },
          javascript = { "prettier" },
          typescriptreact = { "prettier" },
          javascriptreact = { "prettier" },
          lua = { "stylua" },
          terraform = { "terraform_fmt" },
          bash = { "shfmt" },
          sh = { "shfmt" },
          python = { "black", "isort" },
          rust = { "rustfmt", lsp_format = "fallback" },
          go = { "gofmt", "goimports", "gofumpt" },
          yaml = { "prettier" },
          json = { "prettier" },
          markdown = { "prettier" },
        },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server", "stylua", "html-lsp", "css-lsp", "prettier",
        "typescript-language-server", "deno", "emmet-ls", "json-lsp", "shfmt",
        "shellcheck", "goimports", "gopls", "gofumpt", "terraform-ls", "black", "isort",
        "rust-analyzer", "yaml-language-server", "bash-language-server", "pyright",
      },
    },
  },

  { "b0o/schemastore.nvim", lazy = true },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc", "html", "css", "markdown", "markdown_inline",
        "terraform", "hcl", "bash", "python", "rust", "go", "typescript",
        "javascript", "tsx", "json", "yaml", "toml",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  { "lukas-reineke/indent-blankline.nvim", main = "ibl", config = function() require("ibl").setup() end },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- 2025 AI Integration - Focused on Claude & Copilot
  -- ═══════════════════════════════════════════════════════════════════════════

  -- Copilot: Inline completions
  {
    "zbirenbaum/copilot.lua",
    lazy = false,
    priority = 1000,
    config = function()
      require("copilot").setup {
        suggestion = { enabled = false }, -- Use copilot-cmp instead
        panel = { enabled = false },
        filetypes = { yaml = true, markdown = true, gitcommit = true, ["*"] = true },
      }
    end,
  },

  -- Copilot-cmp: Copilot as completion source
  {
    "zbirenbaum/copilot-cmp",
    event = { "BufRead" },
    dependencies = { "copilot.lua", "nvim-cmp" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- CopilotChat: AI chat with Claude model
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = "VeryLazy",
    branch = "main",
    dependencies = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim" },
    opts = {
      model = "claude-sonnet-4", -- Fast for chat
      debug = false,
      window = { layout = "vertical", width = 0.35 },
      mappings = { close = { normal = "q", insert = "<C-c>" } },
    },
    keys = {
      { "<leader>ao", "<cmd>CopilotChatOpen<cr>", desc = "Open Chat" },
      { "<leader>aq", "<cmd>CopilotChatClose<cr>", desc = "Close Chat" },
      { "<leader>ar", "<cmd>CopilotChatReset<cr>", desc = "Reset Chat" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "Explain Code", mode = { "n", "v" } },
      { "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "Fix Code", mode = { "n", "v" } },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "Generate Tests", mode = { "n", "v" } },
      { "<leader>ad", "<cmd>CopilotChatDocs<cr>", desc = "Generate Docs", mode = { "n", "v" } },
      { "<leader>aR", "<cmd>CopilotChatReview<cr>", desc = "Review Code", mode = { "n", "v" } },
    },
  },

  -- Avante: Cursor-like IDE experience with AI
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      provider = "copilot",
      mode = "agentic",
      providers = {
        copilot = {
          endpoint = "https://api.githubcopilot.com",
          model = "claude-sonnet-4", -- Balance of speed and quality
          timeout = 30000,
        },
      },
      mappings = {
        ask = "<leader>aa",
        edit = "<leader>ax", -- Changed to avoid conflict
        refresh = "<leader>aS",
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
      },
      windows = { position = "right", width = 35 },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      { "HakonHarnes/img-clip.nvim", event = "VeryLazy", opts = {} },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
  },

  -- Claude Code: Direct Claude integration (terminal)
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("claude-code").setup()
    end,
    cmd = { "ClaudeCode", "ClaudeCodeContinue", "ClaudeCodeResume" },
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Claude Code" },
      { "<leader>cr", "<cmd>ClaudeCodeResume<cr>", desc = "Resume Conversation" },
      { "<leader>cC", "<cmd>ClaudeCodeContinue<cr>", desc = "Continue Conversation" },
    },
  },

  -- nvim-cmp: Completion engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "zbirenbaum/copilot-cmp",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require "cmp"
      local lspkind = require "lspkind"
      dofile(vim.g.base46_cache .. "cmp")

      cmp.setup {
        completion = { completeopt = "menu,menuone,noselect" },
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = lspkind.cmp_format {
            mode = "symbol_text",
            maxwidth = 50,
            symbol_map = { Copilot = "" },
          },
        },
        mapping = {
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require("luasnip").expand_or_jumpable() then
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = {
          { name = "copilot", priority = 1000, group_index = 1 },
          { name = "nvim_lsp", priority = 900, group_index = 1 },
          { name = "luasnip", priority = 800, group_index = 1 },
          { name = "buffer", priority = 500, group_index = 2 },
          { name = "path", priority = 400, group_index = 2 },
        },
        experimental = { ghost_text = { hl_group = "Comment" } },
      }

      -- Cmdline completion
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
    end,
  },

  -- ═══════════════════════════════════════════════════════════════════════════
  -- Language Specific
  -- ═══════════════════════════════════════════════════════════════════════════

  -- Rust
  { "saecki/crates.nvim", tag = "stable", ft = { "toml" }, config = function() require("crates").setup() end },
  { "mrcjkb/rustaceanvim", version = "^5", lazy = false },

  -- Local Cargo plugin
  {
    "nwiizo/cargo.nvim",
    dir = vim.fn.expand "~/ghq/github.com/nwiizo/cargo.nvim",
    ft = { "rust", "toml" },
    cmd = { "CargoBuild", "CargoRun", "CargoTest", "CargoCheck", "CargoClippy" },
    opts = { float_window = true, window_width = 0.8, window_height = 0.8 },
    config = true,
  },

  -- Marp (Markdown presentations)
  {
    "nwiizo/marp.nvim",
    ft = "markdown",
    config = function()
      require("marp").setup {
        marp_command = "/opt/homebrew/opt/node/bin/node /opt/homebrew/bin/marp",
      }
    end,
  },
}
