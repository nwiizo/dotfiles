-- Language-specific plugins
-- LazyVim manages: rustaceanvim, crates, neotest, nvim-dap (via extras)
return {
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
        if prev_on_attach then prev_on_attach(client, bufnr) end
        local kopts = { silent = true, buffer = bufnr }
        local map = vim.keymap.set
        map("n", "<leader>ra", function() vim.cmd.RustLsp("codeAction") end, vim.tbl_extend("force", kopts, { desc = "Rust code action" }))
        map("n", "<leader>rd", function() vim.cmd.RustLsp("debuggables") end, vim.tbl_extend("force", kopts, { desc = "Rust debuggables" }))
        map("n", "<leader>rr", function() vim.cmd.RustLsp("runnables") end, vim.tbl_extend("force", kopts, { desc = "Rust runnables" }))
        map("n", "<leader>rR", function() vim.cmd.RustLsp({ "runnables", bang = true }) end, vim.tbl_extend("force", kopts, { desc = "Rerun last runnable" }))
        map("n", "<leader>rt", function() vim.cmd.RustLsp("testables") end, vim.tbl_extend("force", kopts, { desc = "Rust testables" }))
        map("n", "<leader>rT", function() vim.cmd.RustLsp({ "testables", bang = true }) end, vim.tbl_extend("force", kopts, { desc = "Rerun last test" }))
        map("n", "<leader>rm", function() vim.cmd.RustLsp("expandMacro") end, vim.tbl_extend("force", kopts, { desc = "Expand macro" }))
        map("n", "<leader>rc", function() vim.cmd.RustLsp("openCargo") end, vim.tbl_extend("force", kopts, { desc = "Open Cargo.toml" }))
        map("n", "<leader>rp", function() vim.cmd.RustLsp("parentModule") end, vim.tbl_extend("force", kopts, { desc = "Parent module" }))
        map("n", "<leader>rj", function() vim.cmd.RustLsp("joinLines") end, vim.tbl_extend("force", kopts, { desc = "Join lines" }))
        map("n", "<leader>rs", function() vim.cmd.RustLsp("ssr") end, vim.tbl_extend("force", kopts, { desc = "Structural search replace" }))
        map("n", "<leader>re", function() vim.cmd.RustLsp("explainError") end, vim.tbl_extend("force", kopts, { desc = "Explain error" }))
        map("n", "<leader>rD", function() vim.cmd.RustLsp("renderDiagnostic") end, vim.tbl_extend("force", kopts, { desc = "Render diagnostic" }))
        map("n", "<leader>rv", function() vim.cmd.RustLsp({ "view", "hir" }) end, vim.tbl_extend("force", kopts, { desc = "View HIR" }))
        map("n", "<leader>rV", function() vim.cmd.RustLsp({ "view", "mir" }) end, vim.tbl_extend("force", kopts, { desc = "View MIR" }))
        map("n", "K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, vim.tbl_extend("force", kopts, { desc = "Rust hover actions" }))
      end
      opts.server.default_settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
            extraArgs = { "--all", "--", "-W", "clippy::all" },
          },
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            buildScripts = { enable = true },
          },
          procMacro = { enable = true, attributes = { enable = true } },
          inlayHints = {
            enable = true,
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
            references = { enable = true, adt = { enable = true }, enumVariant = { enable = true }, method = { enable = true }, trait = { enable = true } },
            implementations = { enable = true },
            run = { enable = true },
            debug = { enable = true },
          },
          diagnostics = { enable = true, experimental = { enable = true }, styleLints = { enable = true } },
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
          typing = { autoClosingAngleBrackets = { enable = true } },
          workspace = { symbol = { search = { kind = "all_symbols" } } },
          files = { excludeDirs = { ".git", "node_modules", ".direnv", "target/debug/build" } },
        },
      }
      opts.dap = { autoload_configurations = true }
      return opts
    end,
  },

  -- crates.nvim: Override, keymaps under <leader>rc (Rust-Crates)
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
          local opts = { silent = true, buffer = bufnr }
          local map = vim.keymap.set
          map("n", "<leader>rct", crates.toggle, vim.tbl_extend("force", opts, { desc = "Toggle crates" }))
          map("n", "<leader>rcr", crates.reload, vim.tbl_extend("force", opts, { desc = "Reload crates" }))
          map("n", "<leader>rcv", crates.show_versions_popup, vim.tbl_extend("force", opts, { desc = "Show versions" }))
          map("n", "<leader>rcf", crates.show_features_popup, vim.tbl_extend("force", opts, { desc = "Show features" }))
          map("n", "<leader>rcd", crates.show_dependencies_popup, vim.tbl_extend("force", opts, { desc = "Show dependencies" }))
          map("n", "<leader>rcu", crates.update_crate, vim.tbl_extend("force", opts, { desc = "Update crate" }))
          map("v", "<leader>rcu", crates.update_crates, vim.tbl_extend("force", opts, { desc = "Update crates" }))
          map("n", "<leader>rcU", crates.upgrade_crate, vim.tbl_extend("force", opts, { desc = "Upgrade crate" }))
          map("v", "<leader>rcU", crates.upgrade_crates, vim.tbl_extend("force", opts, { desc = "Upgrade crates" }))
          map("n", "<leader>rcA", crates.upgrade_all_crates, vim.tbl_extend("force", opts, { desc = "Upgrade all crates" }))
          map("n", "<leader>rcH", crates.open_homepage, vim.tbl_extend("force", opts, { desc = "Open homepage" }))
          map("n", "<leader>rcR", crates.open_repository, vim.tbl_extend("force", opts, { desc = "Open repository" }))
          map("n", "<leader>rcD", crates.open_documentation, vim.tbl_extend("force", opts, { desc = "Open docs.rs" }))
          map("n", "<leader>rcC", crates.open_crates_io, vim.tbl_extend("force", opts, { desc = "Open crates.io" }))
        end,
        actions = true,
        completion = true,
        hover = true,
      },
      popup = { border = "rounded", show_version_date = true, max_height = 30, min_width = 20 },
    },
  },

  -- neotest: Override for adapters
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        ["neotest-rust"] = { args = { "--no-capture" }, dap_adapter = "lldb" },
        ["neotest-golang"] = {},
      },
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          require("trouble").open({ mode = "quickfix", focus = false })
        end,
      },
    },
    keys = {
      { "<leader>Tr", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
      { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
      { "<leader>To", function() require("neotest").output.open({ enter_on_open = true }) end, desc = "Show test output" },
      { "<leader>Tp", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
      { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
      { "[T", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Prev failed test" },
      { "]T", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Next failed test" },
    },
  },

  -- nvim-dap: Add LLDB adapter for Rust
  {
    "mfussenegger/nvim-dap",
    opts = function(_, opts)
      local dap = require("dap")
      dap.adapters.lldb = {
        type = "executable",
        command = "/opt/homebrew/opt/llvm/bin/lldb-dap",
        name = "lldb",
      }
      dap.configurations.rust = {
        {
          name = "Launch",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
      }
      return opts
    end,
  },

  -- cargo.nvim: Local Cargo plugin
  {
    "nwiizo/cargo.nvim",
    dir = vim.fn.expand("~/ghq/github.com/nwiizo/cargo.nvim"),
    build = "cargo build --release",
    ft = { "rust", "toml" },
    cmd = { "CargoBuild", "CargoRun", "CargoTest", "CargoCheck", "CargoClippy" },
    opts = { float_window = true, window_width = 0.8, window_height = 0.8 },
    config = true,
  },

  -- marp.nvim: Markdown presentations
  {
    "nwiizo/marp.nvim",
    ft = "markdown",
    config = function()
      require("marp").setup({
        marp_command = "/opt/homebrew/opt/node/bin/node /opt/homebrew/bin/marp",
      })
    end,
  },
}
