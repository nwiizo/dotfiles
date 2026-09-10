-- Git integration plugins
-- LazyVim manages: gitsigns.nvim
return {
  -- gitsigns: Override signs and add two-key <leader>h* hunk shortcuts.
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      local prev_on_attach = opts.on_attach
      opts.signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      }
      opts.current_line_blame_opts = { delay = 500 }
      opts.on_attach = function(bufnr)
        if prev_on_attach then
          prev_on_attach(bufnr)
        end
        -- Two-key hunk shortcuts; LazyVim's <leader>gh* group stays available.
        local gs = package.loaded.gitsigns
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "<leader>hs", gs.stage_hunk, "Stage/Unstage Hunk")
        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage/Unstage Hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
        map("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset Hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>hp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle Line Blame")
        map("n", "<leader>hd", gs.diffthis, "Diff This")
      end
      return opts
    end,
  },

  -- CodeDiff: Live review while agents keep changing the working tree.
  {
    "esmuellert/codediff.nvim",
    version = "*",
    cmd = "CodeDiff",
    opts = {},
    keys = {
      { "<leader>gR", "<cmd>CodeDiff<cr>", desc = "Review Changes (CodeDiff)" },
      { "<leader>gV", "<cmd>CodeDiff --staged<cr>", desc = "Review Staged Changes (CodeDiff)" },
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
      -- <leader>gh is LazyVim's gitsigns hunk group, so file history lives on <leader>gF.
      { "<leader>gF", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
      { "<leader>gm", "<cmd>DiffviewOpen main...HEAD<cr>", desc = "Diff vs main branch" },
      { "<leader>gM", "<cmd>DiffviewOpen master...HEAD<cr>", desc = "Diff vs master branch" },
      { "<leader>gs", "<cmd>DiffviewOpen --staged<cr>", desc = "Staged changes" },
      { "<leader>gt", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle file panel" },
    },
    config = function()
      local actions = require("diffview.actions")
      require("diffview").setup({
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
            { "n", "<leader>co", actions.conflict_choose("ours"), { desc = "Choose ours" } },
            { "n", "<leader>ct", actions.conflict_choose("theirs"), { desc = "Choose theirs" } },
            { "n", "<leader>cb", actions.conflict_choose("base"), { desc = "Choose base" } },
            { "n", "dx", actions.conflict_choose("none"), { desc = "Delete conflict" } },
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
            { "n", "g?", actions.help("file_panel"), { desc = "Help" } },
          },
        },
      })
    end,
  },
}
