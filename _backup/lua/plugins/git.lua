-- Git related plugins
return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
		event = "User FileOpened",
		cmd = "Gitsigns",
		config = function()
			local icons = require("helpers.icons")
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
	}
}
