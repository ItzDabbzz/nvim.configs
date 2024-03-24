-- See current buffers at the top of the editor
return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {},
		config = function()
			local bufferline = require("bufferline")

			bufferline.setup({
				options = {
					mode = "buffers",
					themable = true,
					indicator = {
						icon = '▎', -- this should be omitted if indicator style is not 'icon'
						style = 'icon',
					},
					buffer_close_icon = '󰅖',
					modified_icon = '●',
					close_icon = '',
					left_trunc_marker = '',
					right_trunc_marker = '',
					diagnostics = "nvim_lsp",
					diagnostics_update_in_insert = false,
					-- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
					diagnostics_indicator = function(count, level, diagnostics_dict, context)
						return "("..count..")"
					end,
					offsets = {
						{
							filetype = "neo-tree",
							text = "File Explorer" ,
							text_align = "center",
							separator = true
						}
					},
					color_icons = true,
					show_buffer_icons = true,
					show_buffer_close_icons = true,
					show_close_icon = true,
					show_tab_indicators = true,

				}
			})
		end
	},
}
