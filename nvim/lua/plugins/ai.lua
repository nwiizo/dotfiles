-- AI Integration plugins
-- LazyVim manages: copilot, copilot-chat (via extras)
return {
  -- copilot.lua: Enable broadly + inline suggestions
  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = {
        ["*"] = true,
        help = false,
        gitrebase = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-l>",
          accept_word = "<M-k>",
          accept_line = "<M-j>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = true },
    },
  },

  -- CopilotChat: Override model and layout
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      model = "claude-opus-4.8",
      debug = false,
      instruction_files = {
        ".github/copilot-instructions.md",
        "AGENTS.md",
        "CLAUDE.md",
      },
      window = { layout = "vertical", width = 0.35 },
      mappings = { close = { normal = "q", insert = "<C-c>" } },
      prompts = {
        ReviewStaged = {
          prompt = "Review the staged diff. Lead with bugs, security issues, regressions, and missing tests. Cite file paths and keep the response terse.",
          system_prompt = "COPILOT_REVIEW",
          resources = { "gitdiff:staged" },
        },
        ReviewUnstaged = {
          prompt = "Review the unstaged diff. Lead with bugs, security issues, regressions, and missing tests. Cite file paths and keep the response terse.",
          system_prompt = "COPILOT_REVIEW",
          resources = { "gitdiff:unstaged" },
        },
        Workspace = {
          prompt = "Use the available workspace tools to answer. Inspect files before making claims, prefer ripgrep-style search, and do not guess about file contents.",
          tools = "copilot",
          sticky = {
            "#buffer:visible",
            "@copilot",
          },
        },
      },
    },
    keys = {
      -- LazyVim copilot-chat extra binds <leader>ax to Reset; we want it
      -- on codex instead. CopilotChatReset is reachable via <leader>ar.
      { "<leader>ax", false },
      { "<leader>ao", "<cmd>CopilotChatOpen<cr>", desc = "Open Chat" },
      { "<leader>aq", "<cmd>CopilotChatClose<cr>", desc = "Close Chat" },
      { "<leader>ar", "<cmd>CopilotChatReset<cr>", desc = "Reset Chat" },
      { "<leader>am", "<cmd>CopilotChatModels<cr>", desc = "Select Model" },
      { "<leader>aP", "<cmd>CopilotChatPrompts<cr>", desc = "Prompt Library" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "Explain Code", mode = { "n", "v" } },
      { "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "Fix Code", mode = { "n", "v" } },
      { "<leader>aO", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize Code", mode = { "n", "v" } },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "Generate Tests", mode = { "n", "v" } },
      { "<leader>ad", "<cmd>CopilotChatDocs<cr>", desc = "Generate Docs", mode = { "n", "v" } },
      { "<leader>aR", "<cmd>CopilotChatReview<cr>", desc = "Review Code", mode = { "n", "v" } },
      { "<leader>ag", "<cmd>CopilotChatReviewStaged<cr>", desc = "Review Staged Diff" },
      { "<leader>aG", "<cmd>CopilotChatReviewUnstaged<cr>", desc = "Review Unstaged Diff" },
      { "<leader>aW", "<cmd>CopilotChatWorkspace<cr>", desc = "Workspace Chat" },
    },
  },

  -- Avante: Cursor-like IDE experience
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
      instructions_file = "CLAUDE.md",
      provider = "codex",
      mode = "agentic",
      input = { provider = "snacks" },
      selector = { provider = "snacks" },
      providers = {
        copilot = {
          endpoint = "https://api.githubcopilot.com",
          model = "claude-opus-4.8",
          timeout = 30000,
        },
      },
      acp_providers = {
        ["codex"] = {
          command = "codex-acp",
          args = { "-c", 'forced_login_method="chatgpt"' },
          env = {
            NODE_NO_WARNINGS = "1",
            HOME = os.getenv("HOME"),
            PATH = os.getenv("PATH"),
          },
        },
        ["claude-code"] = {
          command = "claude-agent-acp",
          args = {},
          env = {
            NODE_NO_WARNINGS = "1",
            ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE = vim.fn.exepath("claude"),
            ACP_PERMISSION_MODE = "bypassPermissions",
          },
        },
      },
      mappings = {
        ask = "<leader>aa",
        edit = "<leader>aE",
        refresh = "<leader>aS",
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        auto_approve_tool_permissions = false,
      },
      windows = { position = "right", width = 35 },
    },
    keys = {
      { "<leader>aVc", "<cmd>AvanteSwitchProvider codex<cr>", desc = "Avante: Codex ACP" },
      { "<leader>aVl", "<cmd>AvanteSwitchProvider claude-code<cr>", desc = "Avante: Claude Code ACP" },
      { "<leader>aVp", "<cmd>AvanteSwitchProvider copilot<cr>", desc = "Avante: Copilot" },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      { "HakonHarnes/img-clip.nvim", event = "VeryLazy", opts = {} },
    },
  },

  -- render-markdown: pretty-print markdown output from AI plugins
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = {
        "markdown",
        "Avante",
        "codecompanion",
        "copilot-chat",
      },
    },
    ft = { "markdown", "Avante", "codecompanion", "copilot-chat" },
  },

  -- CodeCompanion: Vim-native AI chat & editing
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      strategies = {
        chat = { adapter = "copilot" },
        inline = { adapter = "copilot" },
      },
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = { model = { default = "claude-sonnet-4-20250514" } },
          })
        end,
      },
      display = {
        chat = { window = { layout = "vertical", width = 0.35 } },
        diff = { provider = "mini_diff" },
      },
    },
    keys = {
      { "<leader>aC", "<cmd>CodeCompanionChat Toggle<cr>", desc = "CodeCompanion Chat", mode = { "n", "v" } },
      { "<leader>ai", "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanion Actions", mode = { "n", "v" } },
      { "<leader>ap", "<cmd>CodeCompanion<cr>", desc = "CodeCompanion Inline", mode = { "n", "v" } },
    },
  },

  -- Signalbox: attention-first control surface for persistent Herdr agents.
  {
    "nwiizo/signalbox.nvim",
    dir = vim.fn.expand("~/ghq/github.com/nwiizo/signalbox.nvim"),
    event = "VeryLazy",
    cmd = {
      "Signalbox",
      "SignalboxRefresh",
      "SignalboxStart",
      "SignalboxAttach",
      "SignalboxPrompt",
      "SignalboxRename",
      "SignalboxSendVisual",
      "SignalboxSendFile",
      "SignalboxSendDiagnostics",
      "SignalboxHealth",
    },
    opts = {
      board = {
        width = 0.9,
        height = 0.9,
        preview = true,
        preview_ratio = 0.58,
        preview_lines = 80,
      },
      terminal = {
        side = "right",
        width = 0.4,
        auto_insert = true,
        return_key = "<C-g>",
      },
    },
    keys = {
      { "<C-g>", "<cmd>Signalbox<cr>", mode = { "n", "t" }, desc = "Agent Signalbox" },
    },
  },

  -- Codex (OpenAI Codex CLI): terminal and app-server Neovim integration.
  {
    "nwiizo/codex.nvim",
    dir = vim.fn.expand("~/ghq/github.com/nwiizo/codex.nvim"),
    cmd = {
      "Codex",
      "CodexOpen",
      "CodexClose",
      "CodexFocus",
      "CodexStop",
      "CodexResume",
      "CodexContinue",
      "CodexFork",
      "CodexReview",
      "CodexImage",
      "CodexPrompt",
      "CodexSend",
      "CodexSendVisual",
      "CodexAdd",
      "CodexTreeAdd",
      "CodexSendText",
      "CodexDiff",
      "CodexInterrupt",
      "CodexStatus",
      "CodexHealth",
    },
    opts = {
      backend = "terminal",
      cwd = "root",
      focus_after_send = true,
      terminal = {
        split_side = "right",
        split_width_percentage = 0.4,
        window_navigation = {
          left = "<M-h>",
          down = "<M-j>",
          up = "<M-k>",
          right = "<M-l>",
        },
      },
    },
    keys = {
      { "<leader>ax", "<cmd>CodexFocus<cr>", desc = "Focus or hide Codex" },
    },
  },

  -- Claude Code: Primary AI integration (terminal)
  {
    "coder/claudecode.nvim",
    event = "VeryLazy",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      focus_after_send = true,
      terminal = {
        split_side = "right",
        split_width_percentage = 0.4,
      },
    },
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>aF", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>au", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aK", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>aM", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>aT",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file from tree",
        ft = { "NvimTree", "neo-tree", "oil" },
      },
      { "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
