-- AI Integration plugins
-- LazyVim manages: copilot, copilot-chat (via extras)
local function codex_changes()
  local status = require("codex").status()
  local cwd = status.cwd or status.resolved_cwd
  if not cwd then
    vim.notify("Codex: cannot determine which directory to review", vim.log.levels.WARN)
    return
  end
  -- Use the session's project even when invoked from its terminal or another tab.
  vim.cmd.CodeDiff({ args = { "--repo", cwd } })
end

local function codex_review()
  local codex = require("codex")
  local prompt = "Review the uncommitted changes in this project. Inspect the diff, identify bugs and regressions, "
    .. "and report findings with file paths and line numbers. Do not modify files."
  if codex.status().running then
    codex.follow_up(prompt)
  else
    codex.ask(prompt)
  end
end

local function codex_actions()
  local codex = require("codex")
  local running = codex.status().running
  local actions = {
    {
      label = running and "Write a follow-up (same conversation, Ctrl-S to send)"
        or "Write a request about the current file",
      run = running and codex.follow_up or codex.ask,
    },
    { label = "Open the conversation", run = codex.open },
    { label = "Review changes (CodeDiff, q to return)", run = codex_changes },
    { label = "Write a review request for the changes", run = codex_review },
    { label = "Back to editing (conversation keeps running)", run = codex.close },
    {
      label = "Show connection status",
      run = function()
        vim.cmd.CodexStatus()
      end,
    },
    {
      label = "Show answer-window controls",
      run = function()
        vim.notify(
          "Type and press Enter: follow-up request\nEsc Esc: scroll or select the answer, y copies / i: back to input\n"
            .. "Alt-a: actions / Alt-d: review changes / Alt-q: back to editing\n"
            .. "While a turn is running, follow the Codex window prompts to interrupt or approve.",
          vim.log.levels.INFO,
          { title = "Codex controls" }
        )
      end,
    },
  }
  vim.ui.select(actions, {
    prompt = "Codex: next action",
    format_item = function(action)
      return action.label
    end,
  }, function(action)
    if action then
      action.run()
    end
  end)
end

return {
  -- copilot.lua: inline suggestions everywhere. vim.g.ai_cmp = false (options.lua)
  -- makes LazyVim enable suggestions and keep copilot out of the blink menu.
  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = {
        ["*"] = true,
        help = false,
        gitrebase = false,
      },
      suggestion = {
        keymap = {
          accept = "<M-l>",
          accept_word = "<M-k>",
          accept_line = "<M-j>",
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
      model = "claude-opus-5",
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
      -- LazyVim copilot-chat extra binds <leader>aa (toggle) and <leader>ax (reset).
      -- Avante owns <leader>aa and Codex owns <leader>ax; open with <leader>ao, reset with <leader>ar.
      -- <leader>aq (Quick Chat) and <leader>ap (prompts) stay on LazyVim defaults; q closes the window.
      { "<leader>aa", false, mode = { "n", "x" } },
      { "<leader>ax", false, mode = { "n", "x" } },
      { "<leader>ao", "<cmd>CopilotChatOpen<cr>", desc = "Open Chat" },
      { "<leader>ar", "<cmd>CopilotChatReset<cr>", desc = "Reset Chat" },
      { "<leader>am", "<cmd>CopilotChatModels<cr>", desc = "Select Model" },
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
      -- Show Avante actions alongside Codex's selection hints.
      selection = { hint_display = "immediate" },
      providers = {
        copilot = {
          endpoint = "https://api.githubcopilot.com",
          model = "claude-opus-5",
          timeout = 30000,
        },
      },
      acp_providers = {
        ["codex"] = {
          command = "codex-acp",
          args = { "-c", 'forced_login_method="chatgpt"', "-c", 'model="gpt-6-astra"' },
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
            ANTHROPIC_MODEL = "best",
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
      -- Provider switches use free digit keys so they stay at two keys after <leader>.
      { "<leader>a1", "<cmd>AvanteSwitchProvider codex<cr>", desc = "Avante: Codex ACP" },
      { "<leader>a2", "<cmd>AvanteSwitchProvider claude-code<cr>", desc = "Avante: Claude Code ACP" },
      { "<leader>a3", "<cmd>AvanteSwitchProvider copilot<cr>", desc = "Avante: Copilot" },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
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
        "copilot-chat",
      },
    },
    ft = { "markdown", "Avante", "copilot-chat" },
  },

  -- Signalbox: attention-first control surface for persistent Herdr agents.
  {
    "nwiizo/signalbox.nvim",
    dir = vim.fn.expand("~/ghq/github.com/nwiizo/signalbox.nvim"),
    event = "VeryLazy",
    cmd = {
      "Signalbox",
      "SignalboxRefresh",
      "SignalboxUpdateAll",
      "SignalboxStart",
      "SignalboxResume",
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
  -- <leader>ax stays as the AI-group toggle; the Codex actions get their own
  -- <leader>o group so every chord stays at two keys after <leader>.
  {
    "nwiizo/codex.nvim",
    dir = vim.fn.expand("~/ghq/github.com/nwiizo/codex.nvim"),
    event = "VeryLazy",
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
      "CodexAsk",
      "CodexAskVisual",
      "CodexFollowUp",
      "CodexEdit",
      "CodexActions",
      "CodexChanges",
      "CodexSend",
      "CodexSendVisual",
      "CodexAddVisual",
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
      cmd = { "codex", "-c", 'model="gpt-6-astra"' },
      app_server = { cmd = { "codex", "-c", 'model="gpt-6-astra"', "app-server" } },
      cwd = "root",
      focus_after_send = true,
      selection = {
        enabled = true,
        hint = true,
        keymaps = { ask = "<leader>oa", edit = "<leader>oe" },
      },
      terminal = {
        split_side = "right",
        split_width_percentage = 0.4,
        normal_mode_keys = { "<Esc><Esc>" },
        window_navigation = {
          left = "<M-h>",
          down = "<M-j>",
          up = "<M-k>",
          right = "<M-l>",
        },
      },
    },
    config = function(_, opts)
      local codex = require("codex").setup(opts)
      vim.api.nvim_create_user_command("CodexActions", codex_actions, { desc = "Choose the next Codex action" })
      vim.api.nvim_create_user_command("CodexChanges", codex_changes, { desc = "Review the Codex project's changes" })
      local function decorate(status)
        if status.backend ~= "terminal" or not status.bufnr or not vim.api.nvim_buf_is_valid(status.bufnr) then
          return
        end
        for _, binding in ipairs({
          { "<M-a>", "CodexActions", "Codex actions" },
          { "<M-d>", "CodexChanges", "Review project changes" },
          { "<M-q>", "CodexClose", "Hide Codex and return to editor" },
        }) do
          vim.keymap.set("t", binding[1], "<C-\\><C-n><Cmd>" .. binding[2] .. "<CR>", {
            buf = status.bufnr,
            desc = binding[3],
          })
          vim.keymap.set("n", binding[1], "<Cmd>" .. binding[2] .. "<CR>", {
            buf = status.bufnr,
            desc = binding[3],
          })
        end
        for _, win in ipairs(vim.fn.win_findbuf(status.bufnr)) do
          vim.wo[win].winbar = "Codex  Alt-a Actions  Alt-d Diff  Alt-q Hide"
        end
      end
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("nwiizo_codex_workflow", { clear = true }),
        pattern = { "CodexStarted", "CodexOpened" },
        callback = function(event)
          decorate(event.data)
        end,
      })
      decorate(codex.status())
    end,
    keys = {
      { "<leader>ax", "<cmd>CodexFocus<cr>", desc = "Focus or hide Codex" },
      { "<leader>oo", "<cmd>CodexFocus<cr>", desc = "Focus or hide Codex" },
      { "<leader>op", "<cmd>CodexPrompt<cr>", desc = "Prompt Codex" },
      { "<leader>om", "<cmd>CodexActions<cr>", desc = "Codex: Next action" },
      { "<leader>ou", "<cmd>CodexFollowUp<cr>", desc = "Codex: Follow up in this conversation" },
      { "<leader>od", "<cmd>CodexChanges<cr>", desc = "Codex: Review project changes" },
      { "<leader>oh", "<cmd>CodexClose<cr>", desc = "Codex: Hide and return to editor" },
      -- Visual Ask/Edit mappings and their hints are installed by selection.keymaps.
      { "<leader>oa", "<cmd>CodexAsk<cr>", desc = "Codex: Ask with file context" },
      { "<leader>os", "<cmd>CodexSend<cr>", desc = "Send current line" },
      { "<leader>os", ":<C-U>CodexSendVisual<CR>", mode = "x", desc = "Send selection" },
      { "<leader>ob", "<cmd>CodexAdd<cr>", desc = "Add current buffer (@path)" },
      { "<leader>ob", ":<C-U>CodexAddVisual<CR>", mode = "x", desc = "Add selection without sending" },
      { "<leader>ot", "<cmd>CodexTreeAdd<cr>", desc = "Add file from tree", ft = "oil" },
      { "<leader>or", "<cmd>CodexResume<cr>", desc = "Resume session" },
      { "<leader>oc", "<cmd>CodexContinue<cr>", desc = "Continue last session" },
      { "<leader>of", "<cmd>CodexFork<cr>", desc = "Fork session" },
      { "<leader>oR", codex_review, desc = "Codex: Compose a review request" },
      { "<leader>oS", "<cmd>CodexStatus<cr>", desc = "Status" },
      { "<leader>oq", "<cmd>CodexStop<cr>", desc = "Stop Codex" },
    },
  },

  -- Claude Code: Primary AI integration (terminal)
  {
    "coder/claudecode.nvim",
    event = "VeryLazy",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      env = { ANTHROPIC_MODEL = "best" },
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
        ft = "oil",
      },
      { "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
