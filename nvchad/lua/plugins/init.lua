return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
     "neovim/nvim-lspconfig",
     config = function()
       require("nvchad.configs.lspconfig").defaults()
       require "configs.lspconfig"
     end,
   },
  --
  {
   	"williamboman/mason.nvim",
   	opts = {
   		ensure_installed = {
   			"lua-language-server", "stylua",
   			"html-lsp", "css-lsp" , "prettier",
        "lua-language-server","stylua",
        "css-lsp","html-lsp","typescript-language-server","deno","emmet-ls","json-lsp",
        "shfmt","shellcheck",
        "goimports","gopls",
   		},
   	},
   },
  -- tree 
  {
   	"nvim-treesitter/nvim-treesitter",
   	opts = {
   		ensure_installed = {
   			"vim", "lua", "vimdoc",
        "html", "css","Markdown"
   		},
   	},
  },
  --#copilot.lua + copilot.cmp
  {
		"zbirenbaum/copilot.lua",
		event = { "InsertEnter" },
    cmd = "Copilot",
		config = function()
			vim.defer_fn(function()
				require("copilot").setup({
					suggestion = { enabled = false },
					panel = { enabled = false },
					server_opts_overrides = {
						trace = "verbose",
						settings = {
							advanced = {
								listCount = 10, -- #completions for panel
								inlineSuggestCount = 3, -- #completions for getCompletions
							},
						},
					},
					filetypes = {
						yaml = true,
						markdown = true,
						help = false,
						gitcommit = true,
						gitrebase = true,
						hgcommit = false,
						svn = false,
						cvs = false,
						["."] = false,
						["*"] = true,
					},
				})
			end, 100)
		end,
	},
  --- 
  {
		"zbirenbaum/copilot-cmp",
		event = { "InsertEnter" },
		after = { "copilot.lua", "nvim-cmp" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},
  -- for copilot chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
  "hrsh7th/nvim-cmp",
  config = function()
    local cmp = require "cmp"

    dofile(vim.g.base46_cache .. "cmp")

    local cmp_ui = require("nvconfig").ui.cmp
    local cmp_style = cmp_ui.style

    local field_arrangement = {
      atom = { "kind", "abbr", "menu" },
      atom_colored = { "kind", "abbr", "menu" },
    }

    local formatting_style = {
      -- default fields order i.e completion word + item.kind + item.kind icons
      fields = field_arrangement[cmp_style] or { "abbr", "kind", "menu" },

      format = function(_, item)
        local icons = require "nvchad.icons.lspkind"
        local icon = (cmp_ui.icons and icons[item.kind]) or ""

        if cmp_style == "atom" or cmp_style == "atom_colored" then
          icon = " " .. icon .. " "
          item.menu = cmp_ui.lspkind_text and "   (" .. item.kind .. ")" or ""
          item.kind = icon
        else
          icon = cmp_ui.lspkind_text and (" " .. icon .. " ") or icon
          item.kind = string.format("%s %s", icon, cmp_ui.lspkind_text and item.kind or "")
        end

        return item
      end,
    }

    local function border(hl_name)
      return {
        { "╭", hl_name },
        { "─", hl_name },
        { "╮", hl_name },
        { "│", hl_name },
        { "╯", hl_name },
        { "─", hl_name },
        { "╰", hl_name },
        { "│", hl_name },
      }
    end

    local options = {
      completion = {
        completeopt = "menu,menuone",
      },

      window = {
        completion = {
          side_padding = (cmp_style ~= "atom" and cmp_style ~= "atom_colored") and 1 or 0,
          winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
          scrollbar = false,
        },
        documentation = {
          border = border "CmpDocBorder",
          winhighlight = "Normal:CmpDoc",
        },
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },

      formatting = formatting_style,

      mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),

        ["<CR>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require("luasnip").expand_or_jumpable() then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require("luasnip").jumpable(-1) then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
          else
            fallback()
          end
        end, { "i", "s" }),
      },
      sources = {
        { name = "copilot", group_index = 1 }, -- Copilotソースを最初のグループに設定
        { name = "nvim_lsp", group_index = 1 },
        { name = "luasnip", group_index = 1 },
        { name = "buffer", group_index = 1 },
        { name = "nvim_lua", group_index = 1 },
        { name = "path", group_index = 1 },
      },
    }

    if cmp_style ~= "atom" and cmp_style ~= "atom_colored" then
      options.window.completion.border = border "CmpBorder"
    end

    cmp.setup(options)
  end,
  },
}
