-- Telescope fuzzy finding (all the things)
return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		lazy = true,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "chip/telescope-software-licenses.nvim" },
			{ "xiyaowong/telescope-emoji.nvim" },
			{ "debugloop/telescope-undo.nvim" },
			{ "tsakirist/telescope-lazy.nvim" },
			{ "cljoly/telescope-repo.nvim" },
			{ 'ghassan0/telescope-glyph.nvim' },
			-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
			{ "OliverChao/telescope-picker-list.nvim" },
			{
				"agoodshort/telescope-git-submodules.nvim",
				dependencies = "akinsho/toggleterm.nvim",
			},
			{ "nvim-telescope/telescope-dap.nvim" },
			{ "HUAHUAI23/telescope-dapzzzz" },
			{
				"benfowler/telescope-luasnip.nvim",
				module = "telescope._extensions.luasnip"
			},
			{ "lpoto/telescope-docker.nvim" },
			{ "nvim-telescope/telescope-project.nvim", },
			{ "nvim-telescope/telescope-file-browser.nvim", },
		},
		config = function()
			local icons = require("helpers.icons")
			local actions = require("telescope.actions")

			require("telescope").setup({
				defaults = {
					prompt_prefix = icons.ui.Telescope .. " ",
					selection_caret = icons.ui.Forward .. " ",
					entry_prefix = "  ",
					initial_mode = "insert",
					selection_strategy = "reset",
					sorting_strategy = nil,
					layout_strategy = nil,
					layout_config = {},
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--glob=!.git/",
					},
					mappings = {
						i = {
							["<C-n>"] = actions.move_selection_next,
							["<C-p>"] = actions.move_selection_previous,
							["<C-c>"] = actions.close,
							["<C-j>"] = actions.cycle_history_next,
							["<C-k>"] = actions.cycle_history_prev,
							["<C-q>"] = function(...)
								actions.smart_send_to_qflist(...)
								actions.open_qflist(...)
							end,
							["<CR>"] = actions.select_default,
						},
						n = {
							["<C-n>"] = actions.move_selection_next,
							["<C-p>"] = actions.move_selection_previous,
							["<C-q>"] = function(...)
								actions.smart_send_to_qflist(...)
								actions.open_qflist(...)
							end,
						},
					},
					file_ignore_patterns = {},
					path_display = { "smart" },
					winblend = 0,
					border = {},
					borderchars = nil,
					color_devicons = true,
					set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
				},
				pickers = {
					find_files = {
						hidden = true,
					},
					live_grep = {
						--@usage don't include the filename in the search results
						only_sort_text = true,
					},
					grep_string = {
						only_sort_text = true,
					},
					buffers = {
						initial_mode = "normal",
						mappings = {
							i = {
								["<C-d>"] = actions.delete_buffer,
							},
							n = {
								["dd"] = actions.delete_buffer,
							},
						},
					},
					planets = {
						show_pluto = true,
						show_moon = true,
					},
					git_files = {
						hidden = true,
						show_untracked = true,
					},
					colorscheme = {
						enable_preview = true,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					glyph = {
						action = function(glyph)
							vim.fn.setreg("*", glyph.value)
							print([[Press p or "*p to paste this glyph]] .. glyph.value)
						end,
					},
					picker_list = {
						opts = {
							project = { display_type = "full" },
							emoji = require("telescope.themes").get_dropdown({}),
							luasnip = require("telescope.themes").get_dropdown({}),
							notify = require("telescope.themes").get_dropdown({}),
						},
						excluded_pickers = { "fzf", "fd" },
						user_pickers = {},
					},
					git_submodules = {
						git_cmd = "lazygit",
						previewer = true,
						terminal_id = 9,
						terminal_display_name = "Lazygit",
						diffview_keymap = "<C-d>",
					},
					repo = {
						list = {
							search_dirs = {
								"C:\\Users\\Davin\\OneDrive\\Desktop\\Projects",
								"Z:\\Scratch",
								"H:\\Development",
							},
						},
					},
					file_browser = {
						hijack_netrw = true,
					},
				},
			})

			-- Enable telescope fzf native, if installed
			pcall(require("telescope").load_extension"fzf")
			pcall(require("telescope").load_extension("software-licenses"))
			pcall(require("telescope").load_extension("emoji"))
			pcall(require("telescope").load_extension("lazy"))
			pcall(require("telescope").load_extension("repo"))
			pcall(require("telescope").load_extension("glyph"))
			pcall(require("telescope").load_extension("picker_list"))
			pcall(require("telescope").load_extension("undo"))
			pcall(require("telescope").load_extension("git_submodules"))
			pcall(require('telescope').load_extension('dap'))
			pcall(require("telescope").load_extension("i23"))
			pcall(require('telescope').load_extension('luasnip'))
			pcall(require("telescope").load_extension("docker"))
			pcall(require'telescope'.load_extension('project'))
			pcall(require("telescope").load_extension("file_browser"))

			--local map = require("helpers.keys").map
			--map("n", "<leader>fr", require("telescope.builtin").oldfiles, "Recently opened")
			--map("n", "<leader><space>", require("telescope.builtin").buffers, "Open buffers")
			--map("n", "<leader>/", function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			--	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			--		winblend = 10,
			--		previewer = false,
			--	}))
			--end, "Search in current buffer")
			--map("n", "<leader>slf", "<cmd>Telescope software-licenses find<CR>", "Find Software Licenses Via Telescope")
			--map("n", "<leader>se", "<cmd>Telescope emoji<CR>", "Find Emoji Via Telescope")
			--map("n", "<leader>sf", require("telescope.builtin").find_files, "Files")
			--map("n", "<leader>sh", require("telescope.builtin").help_tags, "Help")
			--map("n", "<leader>sw", require("telescope.builtin").grep_string, "Current word")
			--map("n", "<leader>sg", require("telescope.builtin").live_grep, "Grep")
			--map("n", "<leader>sd", require("telescope.builtin").diagnostics, "Diagnostics")
			--map("n", "<C-p>", require("telescope.builtin").keymaps, "Search keymaps")
			--map("n", "<leader>su", "<CMD>Telescope undo<CR>", "Telescope Undo")
		end,
	},
}
