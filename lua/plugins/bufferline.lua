-- See current buffers at the top of the editor
return {
    {
        "akinsho/bufferline.nvim",
        version = "*",
        event = "User LazyFile",
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = {
            { "H",          "<Cmd>BufferLineCyclePrev<CR>",            desc = "Prev Buffer" },
            { "L",          "<Cmd>BufferLineCycleNext<CR>",            desc = "Next Buffer" },
            { "<Leader>`",  "<Cmd>BufferLinePick<CR>",                 desc = "Pick Buffer" },
            { "<Leader>bH", "<Cmd>BufferLineMovePrev<CR>",             desc = "Move Buffer To Prev" },
            { "<Leader>bL", "<Cmd>BufferLineMoveNext<CR>",             desc = "Move Buffer To Next" },
            { "<Leader>bD", "<Cmd>BufferLineSortByDirectory<CR>",      desc = "Sort By Directory" },
            { "<Leader>bE", "<Cmd>BufferLineSortByExtension<CR>",      desc = "Sort By Extensions" },
            { "<Leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle Pin" },
            { "<Leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Unpinned Buffers" },
            { "<Leader>bo", "<Cmd>BufferLineCloseOthers<CR>",          desc = "Delete Other Buffers" },
            { "<Leader>bl", "<Cmd>BufferLineCloseRight<CR>",           desc = "Delete Buffers To The Right" },
            { "<Leader>bh", "<Cmd>BufferLineCloseLeft<CR>",            desc = "Delete Buffers To The Left" },
        },
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
                        return "(" .. count .. ")"
                    end,
                    offsets = {
                        {
                            filetype = "neo-tree",
                            text = "File Explorer",
                            text_align = "center",
                            separator = true,
                            highlight = "Directory"
                        }
                    },
                    color_icons = true,
                    show_buffer_icons = true,
                    show_buffer_close_icons = true,
                    show_close_icon = true,
                    show_tab_indicators = true,
                    always_show_bufferline = true,
                }
            })
        end,
    },
}
