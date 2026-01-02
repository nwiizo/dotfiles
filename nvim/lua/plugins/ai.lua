-- AI Integration plugins: Copilot, CopilotChat, Avante, ClaudeCode
return {
  -- Copilot: Inline completions
  {
    "zbirenbaum/copilot.lua",
    lazy = false,
    priority = 1000,
    config = function()
      require("copilot").setup {
        suggestion = { enabled = false }, -- Use copilot-cmp instead
        panel = { enabled = false },
        filetypes = { yaml = true, markdown = true, gitcommit = true, ["*"] = true },
      }
    end,
  },

  -- Copilot-cmp: Copilot as completion source
  {
    "zbirenbaum/copilot-cmp",
    event = { "BufRead" },
    dependencies = { "copilot.lua", "nvim-cmp" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- CopilotChat: AI chat with Claude model
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = "VeryLazy",
    branch = "main",
    dependencies = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim" },
    opts = {
      model = "claude-sonnet-4",
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

  -- Avante: Cursor-like IDE experience with AI
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      provider = "copilot",
      mode = "agentic",
      providers = {
        copilot = {
          endpoint = "https://api.githubcopilot.com",
          model = "claude-sonnet-4",
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
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
  },

  -- Claude Code: Direct Claude integration (terminal)
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>c", nil, desc = "AI/Claude Code" },
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>cs",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
