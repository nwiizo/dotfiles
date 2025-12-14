local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- Language server configurations using new vim.lsp.config API (Neovim 0.11+)
local servers = {
  -- Web Development
  "html",
  "cssls",
  "ts_ls", -- TypeScript/JavaScript (2025: renamed from tsserver)
  "eslint", -- ESLint integration
  "jsonls", -- JSON with schema support

  -- Go Development
  "golangci_lint_ls",
  "gopls",

  -- Shell scripting
  "bashls",

  -- Python
  "pylsp",

  -- Infrastructure as Code
  "terraform_lsp",
  "terraformls",
  "yamlls", -- YAML with schema support

  -- Rust
  "rust_analyzer",

  -- Lua
  "lua_ls",
}

-- Custom server configurations
local custom_configs = {
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using
          version = "LuaJIT",
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        -- Do not send telemetry data
        telemetry = {
          enable = false,
        },
      },
    },
  },

  gopls = {
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
        usePlaceholders = true,
        experimentalPostfixCompletions = true,
      },
    },
  },

  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
          extraArgs = { "--all", "--", "-W", "clippy::all" },
        },
        cargo = {
          allFeatures = true,
        },
      },
    },
  },

  -- TypeScript/JavaScript (2025 best practices)
  ts_ls = {
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },

  -- JSON with schema support
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").schemas(),
        validate = { enable = true },
      },
    },
  },

  -- YAML with schema support
  yamlls = {
    settings = {
      yaml = {
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = require("schemastore").yaml_schemas(),
        validate = true,
        hover = true,
        completion = true,
      },
    },
  },
}

-- Setup all servers using new vim.lsp.config API (Neovim 0.11+)
for _, lsp in ipairs(servers) do
  local config = {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }

  -- Merge custom config if it exists
  if custom_configs[lsp] then
    config = vim.tbl_deep_extend("force", config, custom_configs[lsp])
  end

  -- Use new vim.lsp.config API for Neovim 0.11+
  if vim.lsp.config then
    vim.lsp.config(lsp, config)
    vim.lsp.enable(lsp)
  else
    -- Fallback for older Neovim versions
    local ok, lspconfig = pcall(require, "lspconfig")
    if ok then
      lspconfig[lsp].setup(config)
    end
  end
end

-- Additional keymaps and settings can be added here
vim.diagnostic.config {
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}

-- Set diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
