-- UI plugins: Custom UI components for minimal UI workflow
-- LazyVim manages: noice, which-key, mini.ai, nvim-notify (via Snacks)
return {
  -- incline.nvim: Floating statusline (replaces lualine)
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local devicons = require("nvim-web-devicons")

      require("incline").setup({
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
            table.insert(diagnostics, { "  ", guifg = "#f38ba8" })
            table.insert(diagnostics, { tostring(diag_counts.error), guifg = "#f38ba8" })
          end
          if diag_counts.warn > 0 then
            table.insert(diagnostics, { "  ", guifg = "#f9e2af" })
            table.insert(diagnostics, { tostring(diag_counts.warn), guifg = "#f9e2af" })
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
      })
    end,
  },

  -- modes.nvim: Cursorline color indicates mode
  {
    "mvllow/modes.nvim",
    event = "VeryLazy",
    config = function()
      require("modes").setup({
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
        ignore = { "NvimTree", "TelescopePrompt", "oil", "lazy", "Avante", "AvanteInput", "snacks_dashboard" },
      })
    end,
  },

  -- noice.nvim: Override LazyVim defaults for centered cmdline
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
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
      views = {
        cmdline_popup = {
          position = { row = "50%", col = "50%" },
          size = { width = 60, height = "auto" },
          border = { style = "rounded", padding = { 0, 1 } },
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
  },

  -- vimade: Dim inactive buffers
  {
    "TaDaa/vimade",
    event = "VeryLazy",
    config = function()
      require("vimade").setup({
        fadelevel = 0.5,
        basebg = "#11111b",
        blocklist = { default = { buf_opts = { buftype = { "terminal" } } } },
      })
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

  -- which-key.nvim: Override for custom group names
  {
    "folke/which-key.nvim",
    opts = {
      preset = "helix",
      delay = 300,
      spec = {
        { "<leader>a", group = "AI", icon = "" },
        { "<leader>C", group = "Claude Code", icon = "" },
        { "<leader>l", group = "LSP Extra", icon = "" },
        { "<leader>p", group = "Peek", icon = "" },
        { "<leader>r", group = "Rust", icon = "" },
        { "<leader>R", group = "Refactoring", icon = "" },
        { "<leader>T", group = "Test", icon = "" },
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

  -- mini.ai: Override for custom text objects
  {
    "nvim-mini/mini.ai",
    opts = function(_, opts)
      local ai = require("mini.ai")
      opts.n_lines = 500
      opts.custom_textobjects = {
        o = ai.gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
      }
      return opts
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
}
