-- LSP, Formatting & Treesitter plugins
-- LazyVim manages: nvim-lspconfig, mason, conform, treesitter
return {
  -- nvim-lspconfig: Configure servers and diagnostics
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
        virtual_lines = { current_line = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded" },
      },
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = { unusedparams = true },
              staticcheck = true,
              gofumpt = true,
              usePlaceholders = true,
              experimentalPostfixCompletions = true,
            },
          },
        },
        zls = {
          settings = {
            zls = {
              enable_inlay_hints = true,
              inlay_hints_show_builtin = true,
              inlay_hints_exclude_single_argument = true,
              inlay_hints_hide_redundant_param_names = true,
              inlay_hints_hide_redundant_param_names_last_token = true,
              warn_style = true,
              highlight_global_var_declarations = true,
              enable_autofix = true,
              enable_import_pop = true,
              include_at_in_builtins = true,
              enable_build_on_save = true,
              build_on_save_step = "check",
            },
          },
        },
        -- html, cssls, bashls, pylsp, terraformls: use LazyVim defaults from extras
      },
    },
  },

  -- conform.nvim: Override formatters
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        typescript = { "prettier", "deno_fmt" },
        javascript = { "prettier" },
        typescriptreact = { "prettier" },
        javascriptreact = { "prettier" },
        lua = { "stylua" },
        terraform = { "terraform_fmt" },
        bash = { "shfmt" },
        sh = { "shfmt" },
        python = { "ruff_format", "ruff_organize_imports" },
        rust = { "rustfmt", lsp_format = "fallback" },
        zig = { "zigfmt" },
        go = { "gofmt", "goimports", "gofumpt" },
        yaml = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
    },
    keys = {
      {
        "<leader>bf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        desc = "Format Buffer",
      },
    },
  },

  -- mason.nvim: Override ensure_installed
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "typescript-language-server",
        "deno",
        "emmet-ls",
        "json-lsp",
        "shfmt",
        "shellcheck",
        "goimports",
        "gopls",
        "gofumpt",
        "terraform-ls",
        "ruff",
        "rust-analyzer",
        "yaml-language-server",
        "bash-language-server",
        "pyright",
        "zls",
        "codelldb",
      },
    },
  },

  -- treesitter: Override ensure_installed
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
        "markdown_inline",
        "terraform",
        "hcl",
        "bash",
        "python",
        "rust",
        "go",
        "typescript",
        "javascript",
        "tsx",
        "json",
        "yaml",
        "toml",
        "zig",
      },
    },
  },

  -- schemastore.nvim
  { "b0o/schemastore.nvim", lazy = true },
}
