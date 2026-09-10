-- LSP, Formatting & Treesitter plugins
-- LazyVim manages: nvim-lspconfig, mason, conform, treesitter
local function js_formatters(bufnr)
  if vim.fs.root(bufnr, { "deno.json", "deno.jsonc" }) then
    return { "deno_fmt" }
  end
  return { "prettier" }
end

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
      codelens = { enabled = true },
      servers = {
        -- lua_ls: LazyVim and lazydev.nvim provide Neovim types; no manual workspace.library.
        -- Web
        html = {},
        cssls = {},
        emmet_language_server = {}, -- maintained successor of emmet_ls
        -- Shell
        bashls = {},
        -- Go linting comes from the go extra (nvim-lint golangci-lint); golangci_lint_ls would duplicate it.
        -- zls: keys checked against the zls 0.16 schema; schema defaults are omitted.
        zls = {
          settings = {
            zls = {
              inlay_hints_hide_redundant_param_names = true,
              inlay_hints_hide_redundant_param_names_last_token = true,
              warn_style = true,
              highlight_global_var_declarations = true,
              enable_build_on_save = true,
            },
          },
        },
      },
    },
  },

  -- conform.nvim: Override formatters (let LazyVim manage format-on-save via <leader>uf)
  -- LazyVim already sets lua/sh; the terraform extra sets terraform.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        typescript = js_formatters,
        javascript = js_formatters,
        typescriptreact = js_formatters,
        javascriptreact = js_formatters,
        bash = { "shfmt" },
        python = { "ruff_format", "ruff_organize_imports" },
        rust = { "rustfmt" },
        zig = { "zigfmt" },
        yaml = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier_markdown" },
      },
      formatters = {
        prettier_markdown = {
          inherit = "prettier",
          prepend_args = { "--prose-wrap", "never" },
        },
      },
    },
  },

  -- mason.nvim: Add only CLI tools. LSP servers are installed by mason-lspconfig
  -- from nvim-lspconfig's server names, so listing their Mason package names here
  -- can race LazyVim's LSP installer.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      local tools = {
        "prettier",
        "deno",
        "shellcheck",
      }

      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, tools)

      local seen = {}
      opts.ensure_installed = vim.tbl_filter(function(tool)
        if seen[tool] then
          return false
        end
        seen[tool] = true
        return true
      end, opts.ensure_installed)
    end,
  },

  -- nvim-lint: Disable markdownlint (too noisy for READMEs, CLAUDE.md, Marp slides)
  {
    "mfussenegger/nvim-lint",
    opts = { linters_by_ft = { markdown = {} } },
  },

  -- treesitter: LazyVim core and the language extras already install every parser
  -- this config needs except css. opts_extend appends to ensure_installed.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "css" } },
  },
}
