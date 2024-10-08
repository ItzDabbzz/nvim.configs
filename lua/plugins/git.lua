-- Git related plugins
return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
		event = "User FileOpened",
		cmd = "Gitsigns",
		config = function()
			local icons = require("utils.icons")
			require('gitsigns').setup({
				signs                        = {
					add          = { text = icons.git.LineAdded },
					change       = { text = icons.git.LineModified },
					delete       = { text = icons.git.LineRemoved },
					topdelete    = { text = icons.git.FileDeleted },
					changedelete = { text = icons.git.FileRemoved },
					untracked    = { text = icons.git.FileUntracked },
				},
				signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir                 = {
					follow_files = true
				},
				auto_attach                  = true,
				attach_to_untracked          = false,
				current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts      = {
					virt_text = true,
					virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
					virt_text_priority = 100,
				},
				current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
				sign_priority                = 6,
				update_debounce              = 100,
				status_formatter             = nil, -- Use default
				max_file_length              = 40000, -- Disable if file is longer than this (in lines)
				preview_config               = {
					-- Options passed to nvim_open_win
					border = 'single',
					style = 'minimal',
					relative = 'cursor',
					row = 0,
					col = 1
				},
				yadm                         = {
					enable = false
				},
			})
			require("scrollbar.handlers.gitsigns").setup()
		end
	},
	{
		"akinsho/git-conflict.nvim",
		config = function()
			require("git-conflict").setup({
				default_mappings = false,
			})
		end,
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"f-person/git-blame.nvim",
		-- load the plugin at startup
		event = "VeryLazy",
		-- Because of the keys part, you will be lazy loading this plugin.
		-- The plugin wil only load once one of the keys is used.
		-- If you want to load the plugin at startup, add something like event = "VeryLazy",
		-- or lazy = false. One of both options will work.
		opts = {
			-- your configuration comes here
			-- for example
			enabled = true,  -- if you want to enable the plugin
			message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
			date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
			virtual_text_column = 1,  -- virtual text start column, check Start virtual text at column section for more options
		},
	 
	}
}
