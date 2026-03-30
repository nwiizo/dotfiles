-- AI Integration plugins
-- LazyVim manages: copilot, copilot-chat (via extras)
return {
  -- CopilotChat: Override model and layout
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      model = "claude-opus-4.6",
      debug = false,
      window = { layout = "vertical", width = 0.35 },
      mappings = { close = { normal = "q", insert = "<C-c>" } },
    },
    keys = {
      { "<leader>ao", "<cmd>CopilotChatOpen<cr>", desc = "Open Chat" },
      { "<leader>aq", "<cmd>CopilotChatClose<cr>", desc = "Close Chat" },
      { "<leader>ar", "<cmd>CopilotChatReset<cr>", desc = "Reset Chat" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "Explain Code", mode = { "n", "v" } },
      { "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "Fix Code", mode = { "n", "v" } },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "Generate Tests", mode = { "n", "v" } },
      { "<leader>ad", "<cmd>CopilotChatDocs<cr>", desc = "Generate Docs", mode = { "n", "v" } },
      { "<leader>aR", "<cmd>CopilotChatReview<cr>", desc = "Review Code", mode = { "n", "v" } },
    },
  },

  -- Avante: Cursor-like IDE experience
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
      provider = "copilot",
      mode = "agentic",
      providers = {
        copilot = {
          endpoint = "https://api.githubcopilot.com",
          model = "claude-opus-4.6",
          timeout = 30000,
        },
      },
      mappings = {
        ask = "<leader>aa",
        edit = "<leader>ax",
        refresh = "<leader>aS",
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
      },
      windows = { position = "right", width = 35 },
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

  -- render-markdown: Add Avante filetype support
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = { file_types = { "markdown", "Avante" } },
    ft = { "markdown", "Avante" },
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
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "CodeCompanion Chat", mode = { "n", "v" } },
      { "<leader>ai", "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanion Actions", mode = { "n", "v" } },
      { "<leader>ap", "<cmd>CodeCompanion<cr>", desc = "CodeCompanion Inline", mode = { "n", "v" } },
    },
  },

  -- Claude Code: Primary AI integration (terminal)
  -- <leader>cc takes priority over LazyVim's codelens (intentional)
  {
    "coder/claudecode.nvim",
    event = "VeryLazy",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminal = {
        split_side = "right",
        split_width_percentage = 0.4,
      },
    },
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      { "<leader>ct", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file from tree", ft = { "NvimTree", "neo-tree", "oil" } },
      { "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
