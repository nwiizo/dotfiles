-- Language-specific plugins: Rust, Marp, DAP
return {
  -- crates.nvim: Cargo.toml dependency management (2026 enhanced)
  {
    "saecki/crates.nvim",
    tag = "stable",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local crates = require "crates"
      crates.setup {
        completion = {
          cmp = { enabled = true },
          crates = {
            enabled = true,
            max_results = 8,
            min_chars = 3,
          },
        },
        lsp = {
          enabled = true,
          on_attach = function(_, bufnr)
            local opts = { silent = true, buffer = bufnr }
            vim.keymap.set("n", "<leader>ct", crates.toggle, vim.tbl_extend("force", opts, { desc = "Toggle crates" }))
            vim.keymap.set("n", "<leader>cr", crates.reload, vim.tbl_extend("force", opts, { desc = "Reload crates" }))
            vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, vim.tbl_extend("force", opts, { desc = "Show versions" }))
            vim.keymap.set("n", "<leader>cf", crates.show_features_popup, vim.tbl_extend("force", opts, { desc = "Show features" }))
            vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, vim.tbl_extend("force", opts, { desc = "Show dependencies" }))
            vim.keymap.set("n", "<leader>cu", crates.update_crate, vim.tbl_extend("force", opts, { desc = "Update crate" }))
            vim.keymap.set("v", "<leader>cu", crates.update_crates, vim.tbl_extend("force", opts, { desc = "Update crates" }))
            vim.keymap.set("n", "<leader>cU", crates.upgrade_crate, vim.tbl_extend("force", opts, { desc = "Upgrade crate" }))
            vim.keymap.set("v", "<leader>cU", crates.upgrade_crates, vim.tbl_extend("force", opts, { desc = "Upgrade crates" }))
            vim.keymap.set("n", "<leader>cA", crates.upgrade_all_crates, vim.tbl_extend("force", opts, { desc = "Upgrade all crates" }))
            vim.keymap.set("n", "<leader>cH", crates.open_homepage, vim.tbl_extend("force", opts, { desc = "Open homepage" }))
            vim.keymap.set("n", "<leader>cR", crates.open_repository, vim.tbl_extend("force", opts, { desc = "Open repository" }))
            vim.keymap.set("n", "<leader>cD", crates.open_documentation, vim.tbl_extend("force", opts, { desc = "Open docs.rs" }))
            vim.keymap.set("n", "<leader>cC", crates.open_crates_io, vim.tbl_extend("force", opts, { desc = "Open crates.io" }))
          end,
          actions = true,
          completion = true,
          hover = true,
        },
        popup = {
          border = "rounded",
          show_version_date = true,
          max_height = 30,
          min_width = 20,
        },
      }
    end,
  },

  -- rustaceanvim: Enhanced Rust support
  {
    "mrcjkb/rustaceanvim",
    version = "^7",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        tools = {
          float_win_config = {
            border = "rounded",
            auto_focus = true,
          },
          code_actions = { ui_select_fallback = true },
          rustc = { edition = "2024" },
        },
        server = {
          on_attach = function(_, bufnr)
            local opts = { silent = true, buffer = bufnr }
            -- Rust-specific keymaps
            vim.keymap.set("n", "<leader>ra", function() vim.cmd.RustLsp "codeAction" end, vim.tbl_extend("force", opts, { desc = "Rust code action" }))
            vim.keymap.set("n", "<leader>rd", function() vim.cmd.RustLsp "debuggables" end, vim.tbl_extend("force", opts, { desc = "Rust debuggables" }))
            vim.keymap.set("n", "<leader>rr", function() vim.cmd.RustLsp "runnables" end, vim.tbl_extend("force", opts, { desc = "Rust runnables" }))
            vim.keymap.set("n", "<leader>rR", function() vim.cmd.RustLsp { "runnables", bang = true } end, vim.tbl_extend("force", opts, { desc = "Rerun last runnable" }))
            vim.keymap.set("n", "<leader>rt", function() vim.cmd.RustLsp "testables" end, vim.tbl_extend("force", opts, { desc = "Rust testables" }))
            vim.keymap.set("n", "<leader>rT", function() vim.cmd.RustLsp { "testables", bang = true } end, vim.tbl_extend("force", opts, { desc = "Rerun last test" }))
            vim.keymap.set("n", "<leader>rm", function() vim.cmd.RustLsp "expandMacro" end, vim.tbl_extend("force", opts, { desc = "Expand macro" }))
            vim.keymap.set("n", "<leader>rc", function() vim.cmd.RustLsp "openCargo" end, vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))
            vim.keymap.set("n", "<leader>rp", function() vim.cmd.RustLsp "parentModule" end, vim.tbl_extend("force", opts, { desc = "Parent module" }))
            vim.keymap.set("n", "<leader>rj", function() vim.cmd.RustLsp "joinLines" end, vim.tbl_extend("force", opts, { desc = "Join lines" }))
            vim.keymap.set("n", "<leader>rs", function() vim.cmd.RustLsp "ssr" end, vim.tbl_extend("force", opts, { desc = "Structural search replace" }))
            vim.keymap.set("n", "<leader>re", function() vim.cmd.RustLsp "explainError" end, vim.tbl_extend("force", opts, { desc = "Explain error" }))
            vim.keymap.set("n", "<leader>rD", function() vim.cmd.RustLsp "renderDiagnostic" end, vim.tbl_extend("force", opts, { desc = "Render diagnostic" }))
            vim.keymap.set("n", "<leader>rv", function() vim.cmd.RustLsp { "view", "hir" } end, vim.tbl_extend("force", opts, { desc = "View HIR" }))
            vim.keymap.set("n", "<leader>rV", function() vim.cmd.RustLsp { "view", "mir" } end, vim.tbl_extend("force", opts, { desc = "View MIR" }))
            vim.keymap.set("n", "K", function() vim.cmd.RustLsp { "hover", "actions" } end, vim.tbl_extend("force", opts, { desc = "Rust hover actions" }))
            vim.keymap.set("n", "J", function() vim.cmd.RustLsp "joinLines" end, vim.tbl_extend("force", opts, { desc = "Rust join lines" }))
          end,
          default_settings = {
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
              procMacro = {
                enable = true,
                attributes = { enable = true },
              },
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
              diagnostics = {
                enable = true,
                experimental = { enable = true },
                styleLints = { enable = true },
              },
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
              typing = {
                autoClosingAngleBrackets = { enable = true },
              },
              workspace = {
                symbol = { search = { kind = "all_symbols" } },
              },
              files = {
                excludeDirs = { ".git", "node_modules", ".direnv", "target/debug/build" },
              },
            },
          },
        },
        dap = {
          autoload_configurations = true,
        },
      }
    end,
  },

  -- nvim-dap: Debug Adapter Protocol (2026)
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ") end, desc = "Conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      -- DAP UI setup
      dapui.setup {
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
      }

      -- Virtual text for debugging
      require("nvim-dap-virtual-text").setup {
        enabled = true,
        commented = true,
      }

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Rust/LLDB adapter configuration
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

      -- Signs
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })
    end,
  },

  -- neotest: Structured test runner UI
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "rouge8/neotest-rust",
    },
    keys = {
      { "<leader>Tr", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand "%") end, desc = "Run file tests" },
      { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
      { "<leader>To", function() require("neotest").output.open { enter_on_open = true } end, desc = "Show test output" },
      { "<leader>Tp", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
      { "<leader>Td", function() require("neotest").run.run { strategy = "dap" } end, desc = "Debug nearest test" },
      { "[T", function() require("neotest").jump.prev { status = "failed" } end, desc = "Prev failed test" },
      { "]T", function() require("neotest").jump.next { status = "failed" } end, desc = "Next failed test" },
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-rust" {
            args = { "--no-capture" },
            dap_adapter = "lldb",
          },
        },
        status = { virtual_text = true },
        output = { open_on_run = true },
        quickfix = { open = function() require("trouble").open { mode = "quickfix", focus = false } end },
      }
    end,
  },

  -- cargo.nvim: Local Cargo plugin
  {
    "nwiizo/cargo.nvim",
    dir = vim.fn.expand "~/ghq/github.com/nwiizo/cargo.nvim",
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
      require("marp").setup {
        marp_command = "/opt/homebrew/opt/node/bin/node /opt/homebrew/bin/marp",
      }
    end,
  },
}
