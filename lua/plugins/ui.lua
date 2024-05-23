return {
	{
		"folke/noice.nvim",
		branch = "main",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			--"rcarriga/nvim-notify"
			{
				"rcarriga/nvim-notify",
				keys = {
					{
						"<leader>un",
						function()
							require("notify").dismiss({ silent = true, pending = true })
						end,
						desc = "Dismiss all Notifications",
					},
				},
				opts = {},
			},
		},
        -- stylua: ignore
        keys = {
            { "<C-Enter>",  function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                 desc = "Redirect Cmdline" },
            { "<Leader>nl", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
            { "<Leader>nh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
            { "<Leader>na", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
            { "<Leader>nd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
            { "<C-F>",      function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,              expr = true,              desc = "Scroll forward",  mode = { "i", "n", "s" } },
            { "<C-B>",      function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,              expr = true,              desc = "Scroll backward", mode = { "i", "n", "s" } },
        },
		init = function()
			vim.opt.cmdheight = 0
		end,
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					progress = {
						enabled = false,
					},
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = false, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = true, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = true, -- add a border to hover docs and signature help
				},
				views = {
					cmdline_popup = {
						position = {
							row = 5,
							col = "50%",
						},
						size = {
							width = 60,
							height = "auto",
						},
					},
					popupmenu = {
						relative = "editor",
						position = {
							row = 8,
							col = "50%",
						},
						size = {
							width = 60,
							height = 10,
						},
						border = {
							style = "rounded",
							padding = { 0, 1 },
						},
						win_options = {
							winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
						},
					},
				},
			})
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "User LazyFile",
		config = function()
			-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
			--vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
			--vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

			local handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (" 󰁂 %d "):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end

			require("ufo").setup({
				fold_virt_text_handler = handler,
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,
			})
		end,
	},

	-- Display search info after match results
	{
		"kevinhwang91/nvim-hlslens",
		event = "CmdlineEnter",
		keys = {
			{
				"n",
				[[<Cmd>execute("normal! " . v:count1 . "Nn"[v:searchforward])<CR><Cmd>lua require("hlslens").start()<CR>]],
				mode = { "n", "x" },
				desc = "Repeat last search in forward direction",
			},
			{
				"N",
				[[<Cmd>execute("normal! " . v:count1 . "nN"[v:searchforward])<CR><Cmd>lua require("hlslens").start()<CR>]],
				mode = { "n", "x" },
				desc = "Repeat last search in backward direction",
			},
			{
				"*",
				[[*<Cmd>lua require("hlslens").start()<CR>]],
				desc = "Search forward for nearest word (match word)",
			},
			{
				"#",
				[[#<Cmd>lua require("hlslens").start()<CR>]],
				desc = "Search forward for nearest word (match word)",
			},
			{
				"g*",
				[[g*<Cmd>lua require("hlslens").start()<CR>]],
				mode = { "n", "x" },
				desc = "Search forward for nearest word",
			},
			{
				"g#",
				[[g#<Cmd>lua require("hlslens").start()<CR>]],
				mode = { "n", "x" },
				desc = "Search backward for nearest word",
			},
		},
		opts = {
			calm_down = false, -- enable this if you want to execute :nohl automatically
			enable_incsearch = false,
			override_lens = function(render, posList, nearest, idx, _)
				--                           🠇 This is \u00A0 since ascii space will disappear in vscode
				local text = nearest and ("%s [%d/%d]"):format(vim.fn.getreg("/"), idx, #posList) or ""
				local chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
				local lnum, col = unpack(posList[idx])
				render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
			end,
		},
	},
	{ "wakatime/vim-wakatime", lazy = false },
	-- Highlight matched bracket
	{
		"monkoose/matchparen.nvim",
		event = "User LazyFile",
		opts = {},
	},
	"airblade/vim-rooter", -- Set working directory to project root
	{
		"uga-rosa/ccc.nvim", -- Colorize color codes
		event = "User LazyFile",
	},
	-- {
	--     'akinsho/toggleterm.nvim',
	--     branch = "main",
	--     version = "*",
	--     cmd = {
	--         "ToggleTerm",
	--         "TermExec",
	--         "ToggleTermToggleAll",
	--         "ToggleTermSendCurrentLine",
	--         "ToggleTermSendVisualLines",
	--         "ToggleTermSendVisualSelection",
	--     },
	--     opts = { --[[ things you want to change go here]] }
	-- },
	-- Move stuff with <M-j> and <M-k> in both normal and visual mode
	{
		"echasnovski/mini.move",
		config = function()
			require("mini.move").setup()
		end,
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
		"folke/neodev.nvim",
		opts = {},
		config = function()
			require("neodev").setup({
				library = { plugins = { "nvim-dap-ui" }, types = true },
			})
		end,
	},
	{
		"folke/trouble.nvim",
		branch = "dev", -- IMPORTANT!
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
					icon = require("helpers.icons").diagnostics.Bug .. " F", -- icon used for the sign, and in search results
					color = "error", -- can be a hex color, or a named color (see below)
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
					-- signs = false, -- configure signs for some keywords individually
				},
				TODO = { icon = require("helpers.icons").ui.Note .. " T", color = "info" },
				HACK = { icon = require("helpers.icons").ui.Fire .. " H", color = "warning" },
				WARN = {
					icon = require("helpers.icons").diagnostics.Warning .. " W",
					color = "warning",
					alt = { "WARNING", "XXX" },
				},
				PERF = {
					icon = require("helpers.icons").diagnostics.BoldQuestion .. " P",
					alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
				},
				NOTE = { icon = require("helpers.icons").diagnostics.Hint .. " N", color = "hint", alt = { "INFO" } },
				TEST = {
					icon = require("helpers.icons").diagnostics.BoldHint .. " ",
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
	{
		-- TODO: Set this up
		"RRethy/vim-illuminate",
		event = "User FileOpened",
		config = function(_, opts)
			require("illuminate").configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map("]]", "next", buffer)
					map("[[", "prev", buffer)
				end,
			})
		end,
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
	{ "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
}
