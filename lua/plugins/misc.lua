-- Miscelaneous fun stuff
return {
	-- Comment with haste
	{
		"numToStr/Comment.nvim",
		opts = {},
		config = function()
			require('Comment').setup()
		end,
	},
	-- Move stuff with <M-j> and <M-k> in both normal and visual mode
	{
		"echasnovski/mini.move",
		config = function()
			require("mini.move").setup()
		end,
	},
	-- Better buffer closing actions. Available via the buffers helper.
	{
		"kazhala/close-buffers.nvim",
		opts = {
			preserve_window_layout = { "this", "nameless" },
		},
	},
	{
		'akinsho/toggleterm.nvim',
		version = "*",
		opts = {--[[ things you want to change go here]]}
	},
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	"tpope/vim-surround", -- Surround stuff with the ys-, cs-, ds- commands
	"airblade/vim-rooter", -- Set working directory to project root
	"NvChad/nvim-colorizer.lua", -- Colorize color codes
	"petertriho/nvim-scrollbar", -- Nice scroll bar with git integration
	"HiPhish/rainbow-delimiters.nvim", -- Rainbow brackets
	"windwp/nvim-ts-autotag", -- Auto close html tags
	{
		"ziontee113/icon-picker.nvim",
		config = function()
			require("icon-picker").setup({ disable_legacy_commands = true })

			local map = require("helpers.keys").map
			map("n", "<Leader><Leader>i", "<cmd>IconPickerNormal<cr>")
			map("n", "<Leader><Leader>y", "<cmd>IconPickerYank<cr>") --> Yank the selected icon into register
			map("i", "<C-i>", "<cmd>IconPickerInsert<cr>")
		end
	},
	{
		'mcauley-penney/visual-whitespace.nvim',
		 config = true
	},
	{ "folke/neodev.nvim", opts = {},
		config = function()
			require("neodev").setup({
				library = { plugins = { "nvim-dap-ui" }, types = true },
			  })
		end
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		},
	},
	{
		"jamestthompson3/nvim-remote-containers",
	},
	{
		"ryanmsnyder/toggleterm-manager.nvim",
		dependencies = {
		  "akinsho/nvim-toggleterm.lua",
		  "nvim-telescope/telescope.nvim",
		  "nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
		},
		config = true,
	  }
}
