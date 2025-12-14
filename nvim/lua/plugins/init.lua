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

      -- Load the main lspconfig which handles all servers including rust_analyzer
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
          cmd = {
            vim.fn.expand "~/.config/nvim/copilot/bin/copilot-language-server",
            "--stdio",
          },
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
      model = "claude-opus-4", -- model name
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
            enable = false,
            verbose = false,
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
            timeout = 30,
            max_tokens = 2048,
            temperature = 0.5,
          },
        },
      }
    end,
  },
  --- add avante.nvim to your neovim config
  -- avante.nvim - Cursor AI IDE-like features for Neovim
  -- Usage:
  --   <leader>aa - Ask AI about current code
  --   <leader>ae - Edit code with AI assistance
  --   <leader>ar - Refresh AI response
  --   :MCPHub - Open MCP server management UI (if mcphub.nvim is installed)
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Never set this value to "*"! Never!
    opts = {
      debug = false, -- Enable debug mode for troubleshooting
      provider = "copilot", -- use copilot
      auto_suggestions_provider = "copilot", -- use copilot for auto suggestions
      -- WARNING: auto-suggestions with copilot can be expensive due to high request frequency
      -- Consider using a different provider or disabling auto_suggestions in behaviour
      mode = "agentic", -- use agent mode

      -- Updated configuration structure per migration guide
      providers = {
        copilot = {
          endpoint = "https://api.githubcopilot.com",
          model = "claude-sonnet-4", -- Use claude-sonnet-4 as requested
          timeout = 30000,
          extra_request_body = {
            temperature = 0,
            max_tokens = 8096,
            -- max_completion_tokens = 8096, -- For reasoning models
            -- reasoning_effort = "medium", -- low|medium|high for reasoning models
          },
        },
        -- Optional: Add other providers for easy switching
        -- openai = {
        --   endpoint = "https://api.openai.com/v1",
        --   model = "gpt-4-turbo-preview",
        --   timeout = 30000,
        --   extra_request_body = {
        --     temperature = 0.7,
        --     max_tokens = 4096,
        --   },
        -- },
      },

      -- MCP Integration via mcphub.nvim
      -- system_prompt and custom_tools are functions to ensure mcphub is loaded
      system_prompt = function()
        -- Check if mcphub is loaded and available
        local ok, mcphub = pcall(require, "mcphub")
        if not ok then
          return "" -- Return empty string if mcphub is not available
        end

        local hub = mcphub.get_hub_instance()
        return hub and hub:get_active_servers_prompt() or ""
      end,

      -- Custom tools configuration for MCP
      custom_tools = function()
        -- Check if mcphub is loaded and available
        local ok, mcphub = pcall(require, "mcphub")
        if not ok then
          return {} -- Return empty table if mcphub is not available
        end

        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,

      -- Add custom keymaps
      mappings = {
        ask = "<leader>aa",
        edit = "<leader>ae",
        refresh = "<leader>ar",
        diff = {
          ours = "<leader>ao",
          theirs = "<leader>at",
          all = "<leader>aA",
          both = "<leader>ab",
          none = "<leader>a0",
          current = "<leader>ac",
        },
        suggestion = {
          accept = "<Tab>",
          dismiss = "<C-]>",
          next = "<M-]>",
          prev = "<M-[>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
      },

      behaviour = {
        auto_suggestions = false, -- Disabled due to high cost with copilot provider
        auto_set_highlight_group = true, -- Automatically set highlight group
        auto_set_keymaps = true, -- Automatically set keymaps
        auto_apply_diff_after_generation = true, -- Automatically apply diff after generation
        support_paste_from_clipboard = true, -- Support paste from clipboard
        enable_cursor_planning_mode = true, -- Enable cursor planning mode
        minimize_diff = true, -- Minimize diff
        jump_result_buffer_on_finish = false, -- Jump to result buffer after generation
      },

      -- Suggestion settings
      suggestion = {
        debounce = 300, -- Debounce time in ms
        delay = 1000, -- Delay before showing suggestions
        -- Note: auto-suggestions can be expensive with copilot provider
      },

      -- Add diff mode configuration
      diff = {
        autojump = true, -- Automatically jump to the next diff
        list_opener = "copen", -- Command to open the diff list
      },

      windows = {
        position = "right",
        wrap = true,
        width = 30, -- Default width
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
          floating = false, -- Consider true for floating window
          start_insert = true,
          border = "rounded",
          focus_on_apply = "ours", -- "ours"|"theirs"|false
        },
        -- Add response window configuration
        response = {
          border = "rounded",
        },
      },

      -- Add highlights configuration
      highlights = {
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },

      -- Add history configuration
      -- History configuration
      history = {
        storage_path = vim.fn.stdpath "state" .. "/avante",
        max_tokens = 4096, -- Max tokens for history context
        paste = {
          extension = "png",
          filename = "pasted-%Y-%m-%d-%H-%M-%S",
        },
      },

      -- Image paste configuration
      img_paste = {
        url_encode_path = true,
        template = "\nimage: $FILE_PATH\n",
      },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
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
      {
        -- MCP (Model Context Protocol) integration for avante.nvim
        -- Provides AI tools and resources management
        "ravitemer/mcphub.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        cmd = "MCPHub", -- Lazy load on :MCPHub command
        build = "npm install -g mcp-hub@latest",
        config = function()
          require("mcphub").setup {
            -- Optional configuration (defaults work fine)
            config = vim.fn.expand "~/.config/mcphub/servers.json",
            port = 37373,
            auto_approve = false, -- Set to true to auto-approve tool calls
            extensions = {
              avante = {
                make_slash_commands = true, -- Enable /mcp:server:prompt commands
              },
            },
          }
        end,
      },
    },
  },
  -- codecompanion.nvim
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            -- 必要に応じてCopilotの設定をここに追加
          })
        end,
      },
      strategies = {
        -- デフォルトアダプターとしてcopilotを使用
        chat = {
          adapter = "copilot",
        },
        inline = {
          adapter = "copilot",
        },
      },
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionToggle",
    },
    keys = {
      -- お好みのキーマップを設定
      { "<leader>cc", "<cmd>CodeCompanionChat<cr>", desc = "Open CodeCompanion Chat" },
      { "<leader>ct", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle CodeCompanion Chat" },
    },
  },
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
      "CargoRunTerm",
      "CargoTest",
      "CargoUpdate",
      "CargoCheck",
      "CargoFmt",
      "CargoClippy",
      "CargoAutodd",
    },
    opts = {
      float_window = true,
      window_width = 0.8,
      window_height = 0.8,
      close_timeout = 30000,
      show_progress = true,
      wrap_output = true,
    },
    config = true,
  },
  -- Note: mcphub.nvim is configured as dependency of avante.nvim above

  --- greggh/claude-code.nvim
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require("claude-code").setup()
    end,
    cmd = {
      "ClaudeCode",
      "ClaudeCodeContinue",
      "ClaudeCodeResume",
      "ClaudeCodeVerbose",
    },
    keys = {
      { "<leader>cl", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code terminal window" },
      { "<leader>cc", "<cmd>ClaudeCodeContinue<cr>", desc = "Resume most recent conversation" },
      { "<leader>cr", "<cmd>ClaudeCodeResume<cr>", desc = "Show interactive conversation picker" },
      { "<leader>cv", "<cmd>ClaudeCodeVerbose<cr>", desc = "Enable verbose logging" },
    },
  },
  -- marp.nvim for local development
  {
    "nwiizo/marp.nvim",
    ft = "markdown",
    config = function()
      require("marp").setup {
        -- Optional configuration
        marp_command = "/opt/homebrew/opt/node/bin/node /opt/homebrew/bin/marp",
        browser = nil, -- auto-detect
        server_mode = false, -- Use watch mode (-w)
      }
    end,
  },
}
