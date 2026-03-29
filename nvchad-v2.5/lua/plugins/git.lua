-- Git integration plugins: gitsigns, diffview
return {
  -- gitsigns.nvim: Inline Git info
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      current_line_blame = false,
      current_line_blame_opts = { delay = 500, virtual_text_pos = "eol" },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Next Hunk" })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Prev Hunk" })

        -- Actions
        map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
        map("n", "<leader>gb", function()
          gs.blame_line { full = true }
        end, { desc = "Blame Line" })
        map("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Toggle Blame" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
        map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
      end,
    },
  },

  -- diffview.nvim: Git diff visualization
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diff (working tree)" },
      { "<leader>gD", "<cmd>DiffviewOpen HEAD~1<cr>", desc = "Diff vs previous commit" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
      { "<leader>gm", "<cmd>DiffviewOpen main...HEAD<cr>", desc = "Diff vs main branch" },
      { "<leader>gM", "<cmd>DiffviewOpen master...HEAD<cr>", desc = "Diff vs master branch" },
      { "<leader>gs", "<cmd>DiffviewOpen --staged<cr>", desc = "Staged changes" },
      { "<leader>gt", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle file panel" },
    },
    config = function()
      local actions = require "diffview.actions"
      require("diffview").setup {
        enhanced_diff_hl = true,
        use_icons = true,
        view = {
          default = { layout = "diff2_horizontal", winbar_info = true },
          merge_tool = { layout = "diff3_horizontal", disable_diagnostics = true },
          file_history = { layout = "diff2_horizontal", winbar_info = true },
        },
        file_panel = {
          listing_style = "tree",
          tree_options = { flatten_dirs = true },
          win_config = { position = "left", width = 35 },
        },
        keymaps = {
          view = {
            { "n", "<tab>", actions.select_next_entry, { desc = "Next file" } },
            { "n", "<s-tab>", actions.select_prev_entry, { desc = "Prev file" } },
            { "n", "gf", actions.goto_file_edit, { desc = "Open file" } },
            { "n", "[x", actions.prev_conflict, { desc = "Prev conflict" } },
            { "n", "]x", actions.next_conflict, { desc = "Next conflict" } },
            { "n", "<leader>co", actions.conflict_choose "ours", { desc = "Choose ours" } },
            { "n", "<leader>ct", actions.conflict_choose "theirs", { desc = "Choose theirs" } },
            { "n", "<leader>cb", actions.conflict_choose "base", { desc = "Choose base" } },
            { "n", "<leader>ca", actions.conflict_choose "all", { desc = "Choose all" } },
            { "n", "dx", actions.conflict_choose "none", { desc = "Delete conflict" } },
          },
          file_panel = {
            { "n", "j", actions.next_entry, { desc = "Next entry" } },
            { "n", "k", actions.prev_entry, { desc = "Prev entry" } },
            { "n", "<cr>", actions.select_entry, { desc = "Select entry" } },
            { "n", "-", actions.toggle_stage_entry, { desc = "Stage/unstage" } },
            { "n", "s", actions.toggle_stage_entry, { desc = "Stage/unstage" } },
            { "n", "S", actions.stage_all, { desc = "Stage all" } },
            { "n", "U", actions.unstage_all, { desc = "Unstage all" } },
            { "n", "X", actions.restore_entry, { desc = "Restore entry" } },
            { "n", "L", actions.open_commit_log, { desc = "Open commit log" } },
            { "n", "g?", actions.help "file_panel", { desc = "Help" } },
          },
        },
      }
    end,
  },
}
