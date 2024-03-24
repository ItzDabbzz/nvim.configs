-- Telescope fuzzy finding (all the things)
return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"chip/telescope-software-licenses.nvim",
			"xiyaowong/telescope-emoji.nvim",
			"debugloop/telescope-undo.nvim",
			"tsakirist/telescope-lazy.nvim",
			-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-d>"] = false,
						},
					},
				},
			})

			-- Enable telescope fzf native, if installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "software-licenses")
			pcall(require("telescope").load_extension, "emoji")
			pcall(require("telescope").load_extension, "undo")
			pcall(require("telescope").load_extension "lazy")

			local map = require("helpers.keys").map
			map("n", "<leader>fr", require("telescope.builtin").oldfiles, "Recently opened")
			map("n", "<leader><space>", require("telescope.builtin").buffers, "Open buffers")
			map("n", "<leader>/", function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, "Search in current buffer")
			map("n", "<leader>tslf", "<cmd>Telescope software-licenses find<CR>", "Find Software Licenses Via Telescope")
			map("n", "<leader>tef", "<cmd>Telescope emoji<CR>", "Find Emoji Via Telescope")
			map("n", "<leader>sf", require("telescope.builtin").find_files, "Files")
			map("n", "<leader>sh", require("telescope.builtin").help_tags, "Help")
			map("n", "<leader>sw", require("telescope.builtin").grep_string, "Current word")
			map("n", "<leader>sg", require("telescope.builtin").live_grep, "Grep")
			map("n", "<leader>sd", require("telescope.builtin").diagnostics, "Diagnostics")
			map("n", "<C-p>", require("telescope.builtin").keymaps, "Search keymaps")
			map("n", "<leader>u", "<CMD>Telescope undo<CR>", "Telescope Undo")
		end,
	},
}
