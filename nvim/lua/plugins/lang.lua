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

  -- rustaceanvim: Enhanced Rust support (2026 config)
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = { replace_builtin_hover = false },
          float_win_config = { border = "rounded" },
          inlay_hints = { auto = true },
          code_actions = { ui_select_fallback = true },
        },
        server = {
          on_attach = function(_, bufnr)
            local opts = { silent = true, buffer = bufnr }
            -- Rust-specific keymaps
            vim.keymap.set("n", "<leader>ra", function() vim.cmd.RustLsp "codeAction" end, vim.tbl_extend("force", opts, { desc = "Rust code action" }))
            vim.keymap.set("n", "<leader>rd", function() vim.cmd.RustLsp "debuggables" end, vim.tbl_extend("force", opts, { desc = "Rust debuggables" }))
            vim.keymap.set("n", "<leader>rr", function() vim.cmd.RustLsp "runnables" end, vim.tbl_extend("force", opts, { desc = "Rust runnables" }))
            vim.keymap.set("n", "<leader>rt", function() vim.cmd.RustLsp "testables" end, vim.tbl_extend("force", opts, { desc = "Rust testables" }))
            vim.keymap.set("n", "<leader>rm", function() vim.cmd.RustLsp "expandMacro" end, vim.tbl_extend("force", opts, { desc = "Expand macro" }))
            vim.keymap.set("n", "<leader>rc", function() vim.cmd.RustLsp "openCargo" end, vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))
            vim.keymap.set("n", "<leader>rp", function() vim.cmd.RustLsp "parentModule" end, vim.tbl_extend("force", opts, { desc = "Parent module" }))
            vim.keymap.set("n", "<leader>rj", function() vim.cmd.RustLsp "joinLines" end, vim.tbl_extend("force", opts, { desc = "Join lines" }))
            vim.keymap.set("n", "<leader>rs", function() vim.cmd.RustLsp "ssr" end, vim.tbl_extend("force", opts, { desc = "Structural search replace" }))
            vim.keymap.set("n", "<leader>re", function() vim.cmd.RustLsp "explainError" end, vim.tbl_extend("force", opts, { desc = "Explain error" }))
            vim.keymap.set("n", "<leader>rD", function() vim.cmd.RustLsp "renderDiagnostic" end, vim.tbl_extend("force", opts, { desc = "Render diagnostic" }))
            vim.keymap.set("n", "K", function() vim.cmd.RustLsp { "hover", "actions" } end, vim.tbl_extend("force", opts, { desc = "Rust hover actions" }))
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
            },
          },
        },
        dap = {
          adapter = {
            type = "executable",
            command = "lldb-dap",
            name = "rt_lldb",
          },
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
