return {
	-- {
	-- 	"stevearc/oil.nvim",
	-- 	---@module 'oil'
	-- 	---@type oil.SetupOpts
	-- 	opts = {},
	-- 	-- Optional dependencies
	-- 	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- 	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	-- },
	{ "wakatime/vim-wakatime", lazy = false },
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
		dependencies = {
			{
				"JMarkin/nvim-tree.lua-float-preview",
				lazy = true,
				-- default
				opts = {
					-- Whether the float preview is enabled by default. When set to false, it has to be "toggled" on.
					toggled_on = true,
					-- wrap nvimtree commands
					wrap_nvimtree_commands = true,
					-- lines for scroll
					scroll_lines = 20,
					-- window config
					window = {
						style = "minimal",
						relative = "win",
						border = "rounded",
						wrap = false,
					},
					mapping = {
						-- scroll down float buffer
						down = { "<C-d>" },
						-- scroll up float buffer
						up = { "<C-e>", "<C-u>" },
						-- enable/disable float windows
						toggle = { "<C-x>" },
					},
					-- hooks if return false preview doesn't shown
					hooks = {
						pre_open = function(path)
							-- if file > 5 MB or not text -> not preview
							local size = require("float-preview.utils").get_size(path)
							if type(size) ~= "number" then
								return false
							end
							local is_text = require("float-preview.utils").is_text(path)
							return size < 5 and is_text
						end,
						post_open = function(bufnr)
							return true
						end,
					},
				},
			},
		},
	},
	{ "anuvyklack/hydra.nvim", lazy = false },
	"airblade/vim-rooter", -- Set working directory to project root
	-- Highlight matched bracket
	{
		"monkoose/matchparen.nvim",
		event = "User LazyFile",
		opts = {},
	},
	{
		"petertriho/nvim-scrollbar", -- Nice scroll bar with git integration
		event = "User LazyFile",
		opts = {
			hide_if_all_visible = true,
			handle = {
				highlight = "ScrollbarHandle",
			},
			handlers = {
				cursor = true,
				diagnostic = true,
				gitsigns = true, -- Requires gitsigns
				search = true, -- Requires hlslens
			},
			marks = {
				Cursor = { text = "—" },
				Search = { text = { "—", "󰇼" } },
				Error = { text = { "—", "󰇼" } },
				Warn = { text = { "—", "󰇼" } },
				Info = { text = { "—", "󰇼" } },
				Hint = { text = { "—", "󰇼" } },
				Misc = { text = { "—", "󰇼" } },
				GitAdd = { text = "▎" },
				GitChange = { text = "▎" },
				GitDelete = { text = "▁" },
			},
		},
	},
	-- Show context of the current cursor position
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "User LazyFile",
		opts = {
			max_lines = 3,
		},
	},
	-- Highlight different level brackets with different color
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = "User LazyFile",
	},

	{
		"folke/trouble.nvim",
		branch = "main", -- IMPORTANT!
		lazy = true,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
		opts = {}, -- for default options, refer to the configuration section for custom setup.
	},
	{
		"ryanmsnyder/toggleterm-manager.nvim",
		lazy = true,
		dependencies = {
			"akinsho/nvim-toggleterm.lua",
			"nvim-telescope/telescope.nvim",
		},
		config = true,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "User FileOpened",
		opts = {
			keywords = {
				FIX = {
					icon = require("utils.icons").diagnostics.Bug .. " F", -- icon used for the sign, and in search results
					color = "error", -- can be a hex color, or a named color (see below)
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
					-- signs = false, -- configure signs for some keywords individually
				},
				TODO = { icon = require("utils.icons").ui.Note .. " T", color = "info" },
				HACK = { icon = require("utils.icons").ui.Fire .. " H", color = "warning" },
				WARN = {
					icon = require("utils.icons").diagnostics.Warning .. " W",
					color = "warning",
					alt = { "WARNING", "XXX" },
				},
				PERF = {
					icon = require("utils.icons").diagnostics.BoldQuestion .. " P",
					alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
				},
				NOTE = { icon = require("utils.icons").diagnostics.Hint .. " N", color = "hint", alt = { "INFO" } },
				TEST = {
					icon = require("utils.icons").diagnostics.BoldHint .. " ",
					color = "test",
					alt = { "TESTING", "PASSED", "FAILED" },
				},
			},
			gui_style = {
				fg = "NONE", -- The gui style to use for the fg highlight group.
				bg = "BOLD", -- The gui style to use for the bg highlight group.
			},
			merge_keywords = true, -- when true, custom keywords will be merged with the defaults
			-- highlighting of the line conta
		},
	},
	-- Highlight undo/redo change
	{
		"tzachar/highlight-undo.nvim",
		keys = {
			{ "u", desc = "Undo" },
			{ "<C-R>", desc = "Redo" },
			{ "<C-Z>", "<Cmd>normal u<CR>", mode = "i", desc = "Undo" },
		},
		opts = {
			-- Same as highlight on yank
			duration = 150,
			undo = { hlgroup = "Search" },
			redo = { hlgroup = "Search", lhs = "U" },
		},
	},
	-- Better yank/paste
	{
		"gbprod/yanky.nvim",
        -- stylua: ignore
        event = "User FileOpened",
		keys = {
			{
				"<Leader>sy",
				function()
					require("telescope").extensions.yank_history.yank_history({})
				end,
				desc = "Open Yank History",
			},
			{
				"<Leader>sp",
				function()
					require("telescope").extensions.yank_history.yank_history({})
				end,
				desc = "Open Yank History",
			},
			{
				"y",
				"<Plug>(YankyYank)",
				mode = { "n", "x" },
				desc = "Yank Text",
			},
			{
				"Y",
				"<Plug>(YankyYank)$",
				mode = { "n", "x" },
				desc = "Yank Text After Cursor",
			},
			{
				"p",
				"<Plug>(YankyPutAfter)",
				mode = { "n", "x" },
				desc = "Put Yanked Text After Cursor",
			},
			{
				"P",
				"<Plug>(YankyPutBefore)",
				mode = { "n", "x" },
				desc = "Put Yanked Text Before Cursor",
			},
			{
				"gp",
				"<Plug>(YankyPutIndentAfterLinewise)",
				desc = "Put Indented After Cursor (linewise)",
			},
			{
				"gP",
				"<Plug>(YankyPutIndentBeforeLinewise)",
				desc = "Put Indented Before Cursor (linewise)",
			},
			{
				"zp",
				'"0<Plug>(YankyPutAfter)',
				mode = { "n", "x" },
				desc = "Put Last Yanked Text After Cursor",
			},
			{
				"zP",
				'"0<Plug>(YankyPutBefore)',
				mode = { "n", "x" },
				desc = "Put Last Yanked Text Before Cursor",
			},
			{
				"zgp",
				'"0<Plug>(YankyPutIndentAfterLinewise)',
				mode = { "n", "x" },
				desc = "Put Last Yanked Text After Selection",
			},
			{
				"zgP",
				'"0<Plug>(YankyPutIndentBeforeLinewise)',
				mode = { "n", "x" },
				desc = "Put Last Yanked Text Before Selection",
			},
			{
				"[y",
				"<Plug>(YankyCycleForward)",
				desc = "Cycle Forward Through Yank History",
			},
			{
				"]y",
				"<Plug>(YankyCycleBackward)",
				desc = "Cycle Backward Through Yank History",
			},
			{
				"[p",
				"<Plug>(YankyCycleForward)",
				desc = "Cycle Forward Through Yank History",
			},
			{
				"]p",
				"<Plug>(YankyCycleBackward)",
				desc = "Cycle Backward Through Yank History",
			},
		},
		opts = {
			highlight = { timer = 150 },
		},
	},
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		opts = {
			-- configurations go here
		},
		config = function()
			-- triggers CursorHold event faster
			vim.opt.updatetime = 200

			require("barbecue").setup({
				create_autocmd = false, -- prevent barbecue from updating itself automatically
			})

			vim.api.nvim_create_autocmd({
				"WinScrolled", -- or WinResized on NVIM-v0.9 and higher
				"BufWinEnter",
				"CursorHold",
				"InsertLeave",

				-- include this if you have set `show_modified` to `true`
				"BufModifiedSet",
			}, {
				group = vim.api.nvim_create_augroup("barbecue.updater", {}),
				callback = function()
					require("barbecue.ui").update()
				end,
			})
		end,
	},
	{
		"filipdutescu/renamer.nvim",
		branch = "master",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		config = function(_, opts)
			require("renamer").setup(opts)
		end,
	},

	-- active indent guide and indent text objects
	{
		"echasnovski/mini.indentscope",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- symbol = "▏",
			symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},
	-- Move stuff with <M-j> and <M-k> in both normal and visual mode
	{
		"echasnovski/mini.move",
		config = function()
			require("mini.move").setup()
		end,
	},
	{ "MunifTanjim/nui.nvim", lazy = true },
	{
		"uga-rosa/ccc.nvim", -- Colorize color codes
		event = "User LazyFile",
	},
	-- Better `vim.notify()`
	{
		"rcarriga/nvim-notify",
		lazy = true,
		keys = {
			{
				"<leader>un",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "Clear notifications",
			},
		},
		opts = { timeout = 3000 },
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
}
