return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      local options = {
        formatters_by_ft = {
          typescript = { "prettier", "deno_fmt" },
          lua = { "stylua" },
          terraform = { "terraform_fmt" },
          ansible = { "ansible-lint" },
          bash = { "shfmt" },
          python = { "black", "isort" },
          rust = { "rustfmt", lsp_format = "fallback" },
          go = { "gofmt", "goimports", "gofumpt" },
          yaml = { "prettier", "prettierd" },
          buf = { "buf" },
        },

        format_on_save = true,
        format_options = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      }
      require("conform").setup(options)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      local lspconfig = require "lspconfig"

      lspconfig.rust_analyzer.setup {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
              extraArgs = { "--all", "--", "-W", "clippy::all" },
            },
          },
        },
      }

      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Lua language server
        "lua-language-server",
        -- Lua formatter
        "stylua",
        -- HTML language server
        "html-lsp",
        -- CSS language server
        "css-lsp",
        -- Prettier formatter
        "prettier",
        -- TypeScript language server
        "typescript-language-server",
        -- Deno language server
        "deno",
        -- Emmet language server
        "emmet-ls",
        -- JSON language server
        "json-lsp",
        -- Shell script formatter
        "shfmt",
        -- Shell script linter
        "shellcheck",
        -- Go imports formatter
        "goimports",
        -- Go language server
        "gopls",
        -- Terraform language server
        "terraform-ls",
        -- Python formatter
        "black",
        -- Python import sorter
        "isort",
        -- TypeScript
        "denols",
        -- Clippyは自動インストールできないため、手動でインストールが必要です
        -- https://rust-lang.github.io/rust-clippy/master/index.html
        -- `rustup component add clippy`
        -- Rust analyzer
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
        "typescript",
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
      "sourcegraph/sg.nvim",
    },
    config = function()
      local cmp = require "cmp"
      dofile(vim.g.base46_cache .. "cmp")

      vim.api.nvim_set_hl(0, "CmpItemKindCody", { fg = "#00ff00" })

      local cmp_ui = require("nvconfig").ui.cmp
      local cmp_style = cmp_ui.style

      local source_config = {
        copilot = { label = "[Copilot]", group_index = 2, priority = 1000 },
        cody = { label = "[Cody]", group_index = 2, priority = 950 },
        nvim_lsp = { label = "[LSP]", group_index = 1, priority = 900 },
        luasnip = { label = "[Snippet]", group_index = 1, priority = 800 },
        nvim_lua = { label = "[Lua]", group_index = 1, priority = 700 },
        buffer = { label = "[Buffer]", group_index = 3, priority = 500 },
        path = { label = "[Path]", group_index = 3, priority = 400 },
      }

      local field_arrangement = {
        atom = { "kind", "abbr", "menu" },
        atom_colored = { "kind", "abbr", "menu" },
      }

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
        ["<C-a>"] = cmp.mapping.complete {
          config = {
            sources = {
              { name = "cody" },
            },
          },
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

      local sources = vim.tbl_map(function(name)
        local conf = source_config[name]
        return {
          name = name,
          group_index = conf.group_index,
          priority = conf.priority,
        }
      end, {
        "copilot",
        "cody",
        "nvim_lsp",
        "luasnip",
        "nvim_lua",
        "buffer",
        "path",
      })

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

      if cmp_style ~= "atom" and cmp_style ~= "atom_colored" then
        options.window.completion.border = border "CmpBorder"
      end

      cmp.setup(options)

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources {
          { name = "conventional_commits" },
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

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
  --- nvim-cmp source for cody
  {
    "sourcegraph/sg.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    build = "nvim -l build/init.lua",
    event = { "BufReadPre", "BufNewFile" },
    -- プラグインを読み込んだ後に設定を適用
    config = function()
      require("sg").setup {
        enable_cody = true,
        cody = {
          -- デバッグログを有効化
          debug = {
            enable = true,
            verbose = true,
          },
          -- コードコンテキストの設定
          experimental = {
            symfContext = true, -- シンボリックコンテキストを有効化
          },
          -- チャットウィンドウの設定
          window = {
            border = "rounded",
            winhighlight = "Normal:CodeyWindow,FloatBorder:CodeyBorder",
            zindex = 50,
          },

          -- リクエスト設定
          request = {
            timeout = 10,
            max_tokens = 2048,
            temperature = 0.5,
          },
        },
      }
    end,
  },
  --- add avante.nvim to your neovim config
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      provider = "copilot", -- copilotを使用
      -- auto_suggestions_provider = "copilot", -- 自動提案もcopilotを使用

      behaviour = {
        auto_suggestions = false, -- 自動提案を有効化
        auto_set_highlight_group = true, -- ハイライトグループを自動設定
        auto_set_keymaps = true, -- キーマップを自動設定
        auto_apply_diff_after_generation = true, -- 生成後に差分を自動適用
        support_paste_from_clipboard = true, -- クリップボードからの貼り付けをサポート
        minimize_diff = true, -- 差分を最小化
      },

      windows = {
        position = "right",
        wrap = true,
        width = 30,
        sidebar_header = {
          enabled = true,
          align = "center",
          rounded = true,
        },
        input = {
          prefix = "> ",
          height = 8,
        },
        edit = {
          border = "rounded",
          start_insert = true,
        },
        ask = {
          floating = false,
          start_insert = true,
          border = "rounded",
          focus_on_apply = "ours",
        },
      },
    },
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  -- codecompanion.nvim
  -- {
  --   "olimorris/codecompanion.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   opts = {
  --     adapters = {
  --       copilot = function()
  --         return require("codecompanion.adapters").extend("copilot", {
  --           -- 必要に応じてCopilotの設定をここに追加
  --         })
  --       end,
  --     },
  --     strategies = {
  --       -- デフォルトアダプターとしてcopilotを使用
  --       chat = {
  --         adapter = "copilot",
  --       },
  --       inline = {
  --         adapter = "copilot",
  --       },
  --     },
  --   },
  --   cmd = {
  --     "CodeCompanion",
  --     "CodeCompanionChat",
  --     "CodeCompanionToggle",
  --   },
  --   keys = {
  --     -- お好みのキーマップを設定
  --     { "<leader>cc", "<cmd>CodeCompanionChat<cr>", desc = "Open CodeCompanion Chat" },
  --     { "<leader>ct", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle CodeCompanion Chat" },
  --   },
  -- },
  -- crates.nvim
  {
    "saecki/crates.nvim",
    tag = "stable",
    ft = { "toml" },
    config = function()
      require("crates").setup()
    end,
  },
  -- rustaceanvim
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  -- nwiizo/nvim-cargo-add
  {
    "nwiizo/nvim-cargo-add",
    -- ローカル開発用の設定
    dir = vim.fn.expand "~/ghq/github.com/nwiizo/nvim-cargo-add",
    build = function()
      vim.notify("Building nvim-cargo-add...", vim.log.levels.INFO)
      local plugin_dir = vim.fn.expand "~/ghq/github.com/nwiizo/nvim-cargo-add"

      -- ビルドコマンドの実行
      local result = vim.fn.system(string.format("cd %s && cargo build --release", vim.fn.shellescape(plugin_dir)))

      -- ビルド結果の確認
      local lib_path = plugin_dir .. "/target/release/libnvim_cargo_add.dylib"
      if vim.fn.filereadable(lib_path) == 0 then
        error("Failed to build: " .. result)
      end

      vim.notify("Build completed successfully", vim.log.levels.INFO)
    end,
    config = function()
      -- プラグインの設定
      require("nvim_cargo_add").setup {
        auto_format = true, -- 自動フォーマットを有効化
        float_preview = true, -- フローティングウィンドウでのプレビューを有効化
      }
    end,
    -- プラグインの読み込み設定
    lazy = false,
    -- 依存関係の指定（必要に応じて）
    dependencies = {
      -- 必要な依存関係があれば追加
    },
    -- Cargo.tomlを開いたときに読み込む
    ft = { "toml" },
    -- コマンドを使用したときに読み込む
    cmd = {
      "CargoAdd",
      "CargoAddDev",
      "CargoRemove",
      "CargoDeps",
      "CargoAddDebug",
    },
  },
  -- nwiizo/cargo.nvim
  {
    "nwiizo/cargo.nvim",
    dir = vim.fn.expand "~/ghq/github.com/nwiizo/cargo.nvim",
    build = function()
      local plugin_dir = vim.fn.expand "~/ghq/github.com/nwiizo/cargo.nvim"
      vim.fn.system(string.format("cd %s && cargo build --release", vim.fn.shellescape(plugin_dir)))
    end,
    ft = { "rust", "toml" },
    cmd = {
      "CargoBench",
      "CargoBuild",
      "CargoClean",
      "CargoDoc",
      "CargoNew",
      "CargoRun",
      "CargoTest",
      "CargoUpdate",
      "CargoCheck",
      "CargoFmt",
      "CargoClippy",
    },
    opts = {
      float_window = true,
      window_width = 0.8,
      window_height = 0.8,
      close_timeout = 30000,
      show_progress = true,
    },
    config = true,
  },
}
