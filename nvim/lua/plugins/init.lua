return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      local options = {
        formatters_by_ft = {
          lua = { "stylua" },
          terraform = { "terraform_fmt" },
          ansible = { "ansible-lint" },
          bash = { "shfmt" },
          python = { "black", "isort" },
          rust = { "rustfmt", lsp_format = "fallback" },
          go = { "gofmt", "goimports", "gofumpt" },
          -- css = { "prettier" },
          -- html = { "prettier" },
        },

        format_on_save = true, -- format_on_save を true に設定
        format_options = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      }
      require("conform").setup(options)
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  --
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "lua-language-server",
        "stylua",
        "css-lsp",
        "html-lsp",
        "typescript-language-server",
        "deno",
        "emmet-ls",
        "json-lsp",
        "shfmt",
        "shellcheck",
        "goimports",
        "gopls",
        "terraform-ls",
        "black",
        "isort",
        "rust-analyzer",
      },
    },
  },
  -- tree
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "markdown",
        "terraform",
        "hcl",
        "bash",
        "python",
        "rust",
        "go",
      },
    },
  },
  --#copilot.lua + copilot.cmp
  {
    "zbirenbaum/copilot.lua",
    lazy = false,
    priority = 1000,
    config = function()
      require("copilot").setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
        server_opts_overrides = {
          trace = "verbose",
          settings = {
            advanced = {
              listCount = 10,
              inlineSuggestCount = 3,
            },
          },
        },
        filetypes = {
          yaml = true,
          markdown = true,
          help = false,
          gitcommit = true,
          gitrebase = true,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
          ["*"] = true,
        },
      }
    end,
  },
  ---
  {
    "zbirenbaum/copilot-cmp",
    event = { "BufRead" },
    after = { "copilot.lua", "nvim-cmp" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  -- for copilot chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = { "VeryLazy" },
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  ---
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup() -- デフォルト設定のみを使用
    end,
  },
  ---
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
    },
    config = function()
      local cmp = require "cmp"
      dofile(vim.g.base46_cache .. "cmp")

      local cmp_ui = require("nvconfig").ui.cmp
      local cmp_style = cmp_ui.style

      -- Define source labels and their priority
      local source_config = {
        copilot = { label = "[Copilot]", group_index = 2, priority = 1000 },
        nvim_lsp = { label = "[LSP]", group_index = 1, priority = 900 },
        luasnip = { label = "[Snippet]", group_index = 1, priority = 800 },
        nvim_lua = { label = "[Lua]", group_index = 1, priority = 700 },
        buffer = { label = "[Buffer]", group_index = 3, priority = 500 },
        path = { label = "[Path]", group_index = 3, priority = 400 },
      }

      -- Define completion item arrangement
      local field_arrangement = {
        atom = { "kind", "abbr", "menu" },
        atom_colored = { "kind", "abbr", "menu" },
      }

      -- Helper function for borders
      local function border(hl_name)
        return {
          { "╭", hl_name },
          { "─", hl_name },
          { "╮", hl_name },
          { "│", hl_name },
          { "╯", hl_name },
          { "─", hl_name },
          { "╰", hl_name },
          { "│", hl_name },
        }
      end

      -- Format completion items
      local formatting_style = {
        fields = field_arrangement[cmp_style] or { "abbr", "kind", "menu" },

        format = function(entry, item)
          local icons = require "nvchad.icons.lspkind"
          local icon = (cmp_ui.icons and icons[item.kind]) or ""
          local source_info = source_config[entry.source.name] or { label = "" }

          if cmp_style == "atom" or cmp_style == "atom_colored" then
            icon = " " .. icon .. " "
            item.menu =
              string.format("%s %s", source_info.label, cmp_ui.lspkind_text and ("(" .. item.kind .. ")") or "")
            item.kind = icon
          else
            icon = cmp_ui.lspkind_text and (" " .. icon .. " ") or icon
            item.kind = string.format("%s %s %s", icon, item.kind, source_info.label)
          end

          return item
        end,
      }

      -- Define keymappings
      local keymaps = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
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
      }

      -- Configure completion sources
      local sources = vim.tbl_map(function(name)
        local conf = source_config[name]
        return {
          name = name,
          group_index = conf.group_index,
          priority = conf.priority,
        }
      end, {
        "copilot",
        "nvim_lsp",
        "luasnip",
        "nvim_lua",
        "buffer",
        "path",
      })

      -- Main configuration
      local options = {
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        window = {
          completion = {
            side_padding = (cmp_style ~= "atom" and cmp_style ~= "atom_colored") and 1 or 0,
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
            scrollbar = false,
          },
          documentation = {
            border = border "CmpDocBorder",
            winhighlight = "Normal:CmpDoc",
          },
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        formatting = formatting_style,
        mapping = keymaps,
        sources = sources,
        experimental = {
          ghost_text = true,
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      }

      -- Add border if not using atom style
      if cmp_style ~= "atom" and cmp_style ~= "atom_colored" then
        options.window.completion.border = border "CmpBorder"
      end

      -- Setup completion
      cmp.setup(options)

      -- Set up special completion for specific filetypes
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources {
          { name = "conventional_commits" },
          { name = "buffer" },
        },
      })

      -- Set up completion for search mode
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Set up completion for command mode
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
}
