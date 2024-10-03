-- See current buffers at the top of the editor
return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		event = "User LazyFile",
		dependencies = "nvim-tree/nvim-web-devicons",
		keys = {
			{ "H", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
			{ "L", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
			{ "<Leader>`", "<Cmd>BufferLinePick<CR>", desc = "Pick Buffer" },
			{ "<Leader>bH", "<Cmd>BufferLineMovePrev<CR>", desc = "Move Buffer To Prev" },
			{ "<Leader>bL", "<Cmd>BufferLineMoveNext<CR>", desc = "Move Buffer To Next" },
			{ "<Leader>bD", "<Cmd>BufferLineSortByDirectory<CR>", desc = "Sort By Directory" },
			{ "<Leader>bE", "<Cmd>BufferLineSortByExtension<CR>", desc = "Sort By Extensions" },
			{ "<Leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
			{ "<Leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Unpinned Buffers" },
			{ "<Leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
			{ "<Leader>bl", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers To The Right" },
			{ "<Leader>bh", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers To The Left" },
		},
		config = function()
			local bufferline = require("bufferline")

			bufferline.setup({
				options = {
					numbers = function(opts)
						return string.format("%s|%s", opts.id, opts.raise(opts.ordinal))
					end,
					max_name_length = 18,
					max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
					tab_size = 18,
					mode = "buffers",
					themable = true,
					indicator = {
						icon = "▎", -- this should be omitted if indicator style is not 'icon'
						style = "icon",
					},
					buffer_close_icon = "󰅖",
					modified_icon = "●",
					close_icon = "",
					left_trunc_marker = "",
					right_trunc_marker = "",
					diagnostics = "nvim_lsp",
					diagnostics_update_in_insert = false,
					--- count is an integer representing total count of errors
					--- level is a string "error" | "warning"
					--- diagnostics_dict is a dictionary from error level ("error", "warning" or "info")to number of errors for each level.
					--- this should return a string
					--- Don't get too fancy as this function will be executed a lot
					diagnostics_indicator = function(count, level, diagnostics_dict, context)
						_ = context
						_ = diagnostics_dict
						local icon = level:match("error") and " " or (level:match("warning") and " " or "")
						return " " .. icon .. count
					end,
					offsets = {
						{
							filetype = "neo-tree",
							text = "File Explorer",
							text_align = "center",
							separator = true,
							highlight = "Directory",
						},
					},
					color_icons = true,
					show_buffer_icons = true,
					show_buffer_close_icons = true,
					show_close_icon = true,
					show_tab_indicators = true,
					separator_style = "slant", --| "thick" | "thin" | { 'any', 'any' },
					enforce_regular_tabs = false, --| true,
					always_show_bufferline = true,
					hover = {
						enabled = true,
						delay = 200,
						reveal = { "close" },
					},

					groups = {
						options = {
							toggle_hidden_on_enter = true, -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
						},
						items = {
							{
								name = "Tests", -- Mandatory
								highlight = { underline = true, sp = "blue" }, -- Optional
								priority = 2, -- determines where it will appear relative to other groups (Optional)
								icon = "", -- Optional
								matcher = function(buf) -- Mandatory
									return buf.name:match("%_test") or buf.name:match("%_spec")
								end,
							},
							{
								name = "Docs",
								highlight = { undercurl = true, sp = "green" },
								auto_close = false, -- whether or not close this group if it doesn't contain the current buffer
								matcher = function(buf)
									return buf.name:match("%.md") or buf.name:match("%.txt")
								end,
								separator = { -- Optional
									-- style = require('bufferline.groups').separator.tab
								},
							},
						},
					},
				},
			})
		end,
	},
}
