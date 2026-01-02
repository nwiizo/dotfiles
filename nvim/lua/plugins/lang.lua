-- Language-specific plugins: Rust, Marp
return {
  -- crates.nvim: Cargo.toml dependency management
  {
    "saecki/crates.nvim",
    tag = "stable",
    ft = { "toml" },
    config = function()
      require("crates").setup()
    end,
  },

  -- rustaceanvim: Enhanced Rust support
  { "mrcjkb/rustaceanvim", version = "^5", lazy = false },

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
