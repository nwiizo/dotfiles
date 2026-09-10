-- Language-specific plugins
-- LazyVim manages: rustaceanvim, crates, neotest, nvim-dap (via extras)
-- Rust debugging uses rustaceanvim with the mason codelldb adapter; no manual nvim-dap config.
return {
  -- nvim-ts-autotag: Auto-close and auto-rename HTML/JSX/TSX tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },

  -- rustaceanvim: Override, preserve LazyVim on_attach
  {
    "mrcjkb/rustaceanvim",
    opts = function(_, opts)
      local prev_on_attach = opts.server and opts.server.on_attach
      opts.tools = vim.tbl_deep_extend("force", opts.tools or {}, {
        float_win_config = { border = "rounded", auto_focus = true },
        code_actions = { ui_select_fallback = true },
        rustc = { edition = "2024" },
      })
      opts.server = opts.server or {}
      opts.server.on_attach = function(client, bufnr)
        if prev_on_attach then
          prev_on_attach(client, bufnr)
        end
        local kopts = { silent = true, buf = bufnr }
        local map = vim.keymap.set
        map("n", "<leader>ra", function()
          vim.cmd.RustLsp("codeAction")
        end, vim.tbl_extend("force", kopts, { desc = "Rust code action" }))
        map("n", "<leader>rd", function()
          vim.cmd.RustLsp("debuggables")
        end, vim.tbl_extend("force", kopts, { desc = "Rust debuggables" }))
        map("n", "<leader>rr", function()
          vim.cmd.RustLsp("runnables")
        end, vim.tbl_extend("force", kopts, { desc = "Rust runnables" }))
        map("n", "<leader>rR", function()
          vim.cmd.RustLsp({ "runnables", bang = true })
        end, vim.tbl_extend("force", kopts, { desc = "Rerun last runnable" }))
        map("n", "<leader>rt", function()
          vim.cmd.RustLsp("testables")
        end, vim.tbl_extend("force", kopts, { desc = "Rust testables" }))
        map("n", "<leader>rT", function()
          vim.cmd.RustLsp({ "testables", bang = true })
        end, vim.tbl_extend("force", kopts, { desc = "Rerun last test" }))
        map("n", "<leader>rm", function()
          vim.cmd.RustLsp("expandMacro")
        end, vim.tbl_extend("force", kopts, { desc = "Expand macro" }))
        map("n", "<leader>rc", function()
          vim.cmd.RustLsp("openCargo")
        end, vim.tbl_extend("force", kopts, { desc = "Open Cargo.toml" }))
        map("n", "<leader>rp", function()
          vim.cmd.RustLsp("parentModule")
        end, vim.tbl_extend("force", kopts, { desc = "Parent module" }))
        map("n", "<leader>rj", function()
          vim.cmd.RustLsp("joinLines")
        end, vim.tbl_extend("force", kopts, { desc = "Join lines" }))
        map("n", "<leader>rs", function()
          vim.cmd.RustLsp("ssr")
        end, vim.tbl_extend("force", kopts, { desc = "Structural search replace" }))
        map("n", "<leader>re", function()
          vim.cmd.RustLsp("explainError")
        end, vim.tbl_extend("force", kopts, { desc = "Explain error" }))
        map("n", "<leader>rD", function()
          vim.cmd.RustLsp("renderDiagnostic")
        end, vim.tbl_extend("force", kopts, { desc = "Render diagnostic" }))
        map("n", "<leader>rv", function()
          vim.cmd.RustLsp({ "view", "hir" })
        end, vim.tbl_extend("force", kopts, { desc = "View HIR" }))
        map("n", "<leader>rV", function()
          vim.cmd.RustLsp({ "view", "mir" })
        end, vim.tbl_extend("force", kopts, { desc = "View MIR" }))
        map("n", "K", function()
          vim.cmd.RustLsp({ "hover", "actions" })
        end, vim.tbl_extend("force", kopts, { desc = "Rust hover actions" }))
      end
      -- LazyVim's rust extra already sets cargo, procMacro, checkOnSave, diagnostics.enable and files.exclude.
      -- Keys follow the current schema (`rust-analyzer --print-config-schema`): clippy lives under `check`.
      opts.server.default_settings = vim.tbl_deep_extend("force", opts.server.default_settings or {}, {
        ["rust-analyzer"] = {
          check = {
            command = "clippy",
            extraArgs = { "--workspace", "--", "-W", "clippy::all" },
          },
          inlayHints = {
            chainingHints = { enable = true },
            typeHints = { enable = true, hideClosureInitialization = true },
            parameterHints = { enable = true },
            closureReturnTypeHints = { enable = "with_block" },
            lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = true },
            maxLength = 25,
            bindingModeHints = { enable = true },
            closureCaptureHints = { enable = true },
            discriminantHints = { enable = "fieldless" },
            expressionAdjustmentHints = { enable = "reborrow" },
            rangeExclusiveHints = { enable = true },
          },
          completion = {
            autoimport = { enable = true },
            postfix = { enable = true },
            callable = { snippets = "fill_arguments" },
            fullFunctionSignatures = { enable = true },
            privateEditable = { enable = true },
          },
          imports = {
            granularity = { group = "module" },
            prefix = "self",
            preferNoStd = false,
          },
          lens = {
            enable = true,
            references = {
              adt = { enable = true },
              enumVariant = { enable = true },
              method = { enable = true },
              trait = { enable = true },
            },
            implementations = { enable = true },
            run = { enable = true },
            debug = { enable = true },
          },
          diagnostics = { experimental = { enable = true }, styleLints = { enable = true } },
          semanticHighlighting = {
            operator = { specialization = { enable = true } },
            punctuation = { enable = true, specialization = { enable = true } },
            strings = { enable = true },
          },
          hover = {
            actions = {
              enable = true,
              references = { enable = true },
              run = { enable = true },
              debug = { enable = true },
              gotoTypeDef = { enable = true },
              implementations = { enable = true },
            },
            documentation = { enable = true, keywords = { enable = true } },
            links = { enable = true },
          },
          workspace = { symbol = { search = { kind = "all_symbols" } } },
        },
      })
      opts.dap = { autoload_configurations = true }
      return opts
    end,
  },

  -- crates.nvim: Override; two-key <leader>r* keys apply only in Cargo.toml buffers,
  -- so they do not collide with the rustaceanvim <leader>r* keys in .rs buffers.
  {
    "saecki/crates.nvim",
    opts = {
      completion = {
        crates = { enabled = true, max_results = 8, min_chars = 3 },
      },
      lsp = {
        enabled = true,
        on_attach = function(_, bufnr)
          local crates = require("crates")
          local opts = { silent = true, buf = bufnr }
          local map = vim.keymap.set
          map("n", "<leader>rt", crates.toggle, vim.tbl_extend("force", opts, { desc = "Toggle crates" }))
          map("n", "<leader>rr", crates.reload, vim.tbl_extend("force", opts, { desc = "Reload crates" }))
          map("n", "<leader>rv", crates.show_versions_popup, vim.tbl_extend("force", opts, { desc = "Show versions" }))
          map("n", "<leader>rf", crates.show_features_popup, vim.tbl_extend("force", opts, { desc = "Show features" }))
          map(
            "n",
            "<leader>rd",
            crates.show_dependencies_popup,
            vim.tbl_extend("force", opts, { desc = "Show dependencies" })
          )
          map("n", "<leader>ru", crates.update_crate, vim.tbl_extend("force", opts, { desc = "Update crate" }))
          map("v", "<leader>ru", crates.update_crates, vim.tbl_extend("force", opts, { desc = "Update crates" }))
          map("n", "<leader>rU", crates.upgrade_crate, vim.tbl_extend("force", opts, { desc = "Upgrade crate" }))
          map("v", "<leader>rU", crates.upgrade_crates, vim.tbl_extend("force", opts, { desc = "Upgrade crates" }))
          map(
            "n",
            "<leader>rA",
            crates.upgrade_all_crates,
            vim.tbl_extend("force", opts, { desc = "Upgrade all crates" })
          )
          map("n", "<leader>rH", crates.open_homepage, vim.tbl_extend("force", opts, { desc = "Open homepage" }))
          map("n", "<leader>rR", crates.open_repository, vim.tbl_extend("force", opts, { desc = "Open repository" }))
          map("n", "<leader>rD", crates.open_documentation, vim.tbl_extend("force", opts, { desc = "Open docs.rs" }))
          map("n", "<leader>rC", crates.open_crates_io, vim.tbl_extend("force", opts, { desc = "Open crates.io" }))
        end,
        actions = true,
        completion = true,
        hover = true,
      },
      popup = { border = "rounded", show_version_date = true, max_height = 30, min_width = 20 },
    },
  },

  -- neotest: Output settings and failed-test jumps. Run/summary keys come from
  -- LazyVim test.core under <leader>t; adapters come from the language extras.
  {
    "nvim-neotest/neotest",
    opts = {
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          require("trouble").open({ mode = "quickfix", focus = false })
        end,
      },
    },
    keys = {
      {
        "[T",
        function()
          require("neotest").jump.prev({ status = "failed" })
        end,
        desc = "Prev failed test",
      },
      {
        "]T",
        function()
          require("neotest").jump.next({ status = "failed" })
        end,
        desc = "Next failed test",
      },
    },
  },

  -- cargo.nvim: Local Cargo plugin
  {
    "nwiizo/cargo.nvim",
    dir = vim.fn.expand("~/ghq/github.com/nwiizo/cargo.nvim"),
    build = "cargo build --locked --release",
    ft = { "rust", "toml" },
    cmd = { "CargoBuild", "CargoRun", "CargoTest", "CargoCheck", "CargoClippy" },
    opts = { float_window = true, window_width = 0.8, window_height = 0.8 },
    config = true,
  },

  -- marp.nvim: Markdown presentations
  {
    "nwiizo/marp.nvim",
    dir = vim.fn.expand("~/ghq/github.com/nwiizo/marp.nvim"),
  },
}
