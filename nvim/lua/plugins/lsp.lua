-- LSP, Formatting & Treesitter plugins
return {
  -- conform.nvim: Formatting
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>bf",
        function()
          require("conform").format { async = true, lsp_format = "fallback" }
        end,
        desc = "Format Buffer",
      },
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
          python = { "ruff_format", "ruff_organize_imports" },
          rust = { "rustfmt", lsp_format = "fallback" },
          zig = { "zigfmt" },
          go = { "gofmt", "goimports", "gofumpt" },
          yaml = { "prettier" },
          json = { "prettier" },
          markdown = { "prettier" },
        },
        format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
      }
    end,
  },

  -- nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  -- mason.nvim: LSP/DAP/Linter installer
  {
    "williamboman/mason.nvim",
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
        -- DAP adapters (2026)
        "codelldb",
      },
    },
  },

  -- schemastore.nvim: JSON schemas
  { "b0o/schemastore.nvim", lazy = true },

  -- nvim-treesitter
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
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
}
