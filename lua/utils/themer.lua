_T = {}
_T.materialTheme = {}
_T.nightfallTheme = {}
_T.nordicTheme = {}

_T.set_theme = function(theme)
    vim.cmd("colorscheme " .. theme)
end

_T.nordicTheme.Toggle = function()
    _T.set_theme('nordic')
end

_T.nordicTheme.Setup = function()
    require 'nordic' .setup {
        -- This callback can be used to override the colors used in the palette.
        on_palette = function(palette) return palette end,
        -- Enable bold keywords.
        bold_keywords = false,
        -- Enable italic comments.
        italic_comments = true,
        -- Enable general editor background transparency.
        transparent_bg = false,
        -- Enable brighter float border.
        bright_border = false,
        -- Reduce the overall amount of blue in the theme (diverges from base Nord).
        reduced_blue = true,
        -- Swap the dark background with the normal one.
        swap_backgrounds = false,
        -- Override the styling of any highlight group.
        override = {},
        -- Cursorline options.  Also includes visual/selection.
        cursorline = {
            -- Bold font in cursorline.
            bold = false,
            -- Bold cursorline number.
            bold_number = true,
            -- Available styles: 'dark', 'light'.
            theme = 'dark',
            -- Blending the cursorline bg with the buffer bg.
            blend = 0.85,
        },
        noice = {
            -- Available styles: `classic`, `flat`.
            style = 'classic',
        },
        telescope = {
            -- Available styles: `classic`, `flat`.
            style = 'flat',
        },
        leap = {
            -- Dims the backdrop when using leap.
            dim_backdrop = false,
        },
        ts_context = {
            -- Enables dark background for treesitter-context window
            dark_background = true,
        }
    }
end

_T.nightfallTheme.Toggle = function()
    _T.set_theme('nightfall')
end

_T.nightfallTheme.Setup = function()
    require('lualine').setup {
        options = {
            theme = "nightfall"
        }
    }
    require("nightfall").setup({
        compile_path = vim.fn.stdpath("cache") .. "/nightfall",
        transparent = false,
        terminal_colors = true,
        dim_inactive = false,
        styles = {
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
            numbers = {},
            conditionals = {},
            constants = {},
            operators = {},
            strings = {},
            types = {},
            booleans = {},
            loops = {},
        },
        default_integrations = true,
        integrations = {
            lazy = { enabled = true },
            telescope = { enabled = true, style = "bordered" },
            illuminate = { enabled = true },
            treesitter = { enabled = true, context = true },
            lspconfig = { enabled = true },
            flash = { enabled = false },
        },
    })
end

_T.materialTheme.Toggle = function()
    _T.set_theme('material')
end

_T.materialTheme.Setup = function()
    require('lualine').setup({
        options = {
            theme = 'material-stealth'
        }
    })
    require('material').setup({
        contrast = {
            terminal = false,            -- Enable contrast for the built-in terminal
            sidebars = false,            -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
            floating_windows = false,    -- Enable contrast for floating windows
            cursor_line = false,         -- Enable darker background for the cursor line
            lsp_virtual_text = false,    -- Enable contrasted background for lsp virtual text
            non_current_windows = false, -- Enable contrasted background for non-current windows
            filetypes = {},              -- Specify which filetypes get the contrasted (darker) background
        },

        styles = { -- Give comments style such as bold, italic, underline etc.
            comments = { --[[ italic = true ]] },
            strings = { --[[ bold = true ]] },
            keywords = { --[[ underline = true ]] },
            functions = { --[[ bold = true, undercurl = true ]] },
            variables = {},
            operators = {},
            types = {},
        },

        plugins = { -- Uncomment the plugins that you use to highlight them
            -- Available plugins:
            -- "coc",
            -- "colorful-winsep",
            "dap",
            "dashboard",
            -- "eyeliner",
            "fidget",
            -- "flash",
            "gitsigns",
            "harpoon",
            -- "hop",
            -- "illuminate",
            -- "indent-blankline",
            -- "lspsaga",
            -- "mini",
            -- "neogit",
            -- "neotest",
            "neo-tree",
            -- "neorg",
            -- "noice",
            -- "nvim-cmp",
            -- "nvim-navic",
            -- "nvim-tree",
            -- "nvim-web-devicons",
            "rainbow-delimiters",
            -- "sneak",
            "telescope",
            "trouble",
            "which-key",
            "nvim-notify",
        },

        disable = {
            colored_cursor = false, -- Disable the colored cursor
            borders = false,        -- Disable borders between verticaly split windows
            background = false,     -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
            term_colors = false,    -- Prevent the theme from setting terminal colors
            eob_lines = false       -- Hide the end-of-buffer lines
        },

        high_visibility = {
            lighter = false, -- Enable higher contrast text for lighter style
            darker = false   -- Enable higher contrast text for darker style
        },

        lualine_style = "stealth", -- Lualine style ( can be 'stealth' or 'default' )

        async_loading = true,      -- Load parts of the theme asyncronously for faster startup (turned on by default)

        custom_colors = nil,       -- If you want to override the default colors, set this to a function

        custom_highlights = {},    -- Overwrite highlights with your own
    })
end

_T.materialTheme.findStyle = function()
    require('material.functions').find_style()
end

_T.materialTheme.ToggleStyle = function()
    require('material.functions').toggle_style()
end

_T.materialTheme.ToggleEOB = function()
    require('material.functions').toggle_eob()
end

return _T
