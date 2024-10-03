-- Fancier statusline
return {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    config = function()
        local colorscheme = require("helpers.colorscheme")
        local lualine_theme = colorscheme == "default" and "auto" or colorscheme
        local colors = {
            blue     = '#89b4fa',
            cyan     = '#94e2d5',
            black    = '#11111b',
            darkgray = '#181825',
            white    = '#cdd6f4',
            red      = '#f38ba8',
            violet   = '#cba6f7',
            grey     = '#45475a',
        }

        local bubbles_theme = {
            normal = {
                a = { fg = colors.darkgray, bg = colors.violet },
                b = { fg = colors.white, bg = colors.grey },
                c = { fg = colors.white },
            },

            insert = { a = { fg = colors.darkgray, bg = colors.blue } },
            visual = { a = { fg = colors.darkgray, bg = colors.cyan } },
            replace = { a = { fg = colors.darkgray, bg = colors.red } },

            inactive = {
                a = { fg = colors.white, bg = colors.darkgray },
                b = { fg = colors.white, bg = colors.darkgray },
                c = { fg = colors.white },
            },
        }
        
        -- local trouble = require("trouble")
        -- local symbols = trouble.statusline({
        --   mode = "lsp_document_symbols",
        --   groups = {},
        --   title = false,
        --   filter = { range = true },
        --   format = "{kind_icon}{symbol.name:Normal}",
        -- })
        -- table.insert(opts.sections.lualine_c, {
        --   symbols.get,
        --   cond = symbols.has,
        -- })

        local opts = {
            options = {
                theme = bubbles_theme,
                component_separators = '',
                section_separators = { left = '', right = '' },
            },
            sections = {
                lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2, icon = "" } },
                lualine_b = { 'branch' },
                lualine_c = {
                    'filename',
                    '%=', --[[ add your center compoentnts here in place of this comment ]]
                    'diff',
                    'diagnostics',
                    "os.date('%a %b %d | %I:%M')",
                    "require'lsp-status'.status()",
                },
                lualine_x = {},
                lualine_y = { 'filetype', 'fileformat', 'encoding', 'progress' },
                lualine_z = {
                    { " %c  %l:%L", type = "stl", separator = { right = '' }, left_padding = 2 }
                },
            },
            inactive_sections = {
                lualine_a = { 'filename' },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { 'location' },
            },
            tabline = {},
            extensions = {
                'lazy',
                'mason',
                'neo-tree',
                'nvim-dap-ui',
                'toggleterm',
                'trouble'
            },
        }

        require('lualine').setup(opts)
    end,
}
