local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- Language server configurations using new vim.lsp.config API (Neovim 0.11+)
local servers = {
  -- Web Development
  "html",
  "cssls",

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

  -- Rust: managed by rustaceanvim (do NOT add rust_analyzer here)

  -- Zig
  "zls",

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

  -- rust_analyzer: removed, managed by rustaceanvim (see plugins/lang.lua)

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

-- Diagnostic configuration
-- NvChad sets virtual_text in diagnostic_config(), we override it here
-- and re-apply on LspAttach to ensure our settings survive plugin load order
local diag_opts = {
  virtual_text = false, -- Replaced by virtual_lines
  virtual_lines = { current_line = true }, -- Neovim 0.11+: detailed diagnostics on cursor line
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
}
vim.diagnostic.config(diag_opts)

vim.api.nvim_create_autocmd("LspAttach", {
  once = true,
  callback = function()
    vim.diagnostic.config(diag_opts)
  end,
})

-- Diagnostic signs are now defined via vim.diagnostic.config signs.text above
