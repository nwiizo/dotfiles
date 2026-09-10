-- Completion: blink.cmp (LazyVim default)
-- LazyVim manages blink.cmp with copilot source automatically via extras.
-- Window borders follow vim.o.winborder and ghost text follows vim.g.ai_cmp.
-- <Tab> is left unset so LazyVim maps it to snippet_forward + ai_accept (copilot).
return {
  -- blink.cmp: Override for custom keymaps
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-f>"] = { "scroll_documentation_up", "fallback" },
      },
    },
  },
}
