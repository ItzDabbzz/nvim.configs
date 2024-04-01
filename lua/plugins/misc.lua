return {
    -- Undo tree
    {
        "mbbill/undotree",
    },
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
        branch = "main",
        version = "*",
        cmd = {
          "ToggleTerm",
          "TermExec",
          "ToggleTermToggleAll",
          "ToggleTermSendCurrentLine",
          "ToggleTermSendVisualLines",
          "ToggleTermSendVisualSelection",
        },
        opts = { --[[ things you want to change go here]] }
    },
    "airblade/vim-rooter",          -- Set working directory to project root
    "NvChad/nvim-colorizer.lua",    -- Colorize color codes
    "petertriho/nvim-scrollbar",    -- Nice scroll bar with git integration
    "HiPhish/rainbow-delimiters.nvim", -- Rainbow brackets
    "tpope/vim-sleuth",             -- Detect tabstop and shiftwidth automatically
    "tpope/vim-surround",           -- Surround stuff with the ys-, cs-, ds- commands
    "airblade/vim-rooter",          -- Set working directory to project root
    {
        "folke/neodev.nvim",
        opts = {},
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
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            keywords = {
                FIX = {
                    icon = require("helpers.icons").diagnostics.Bug .. " ", -- icon used for the sign, and in search results
                    color = "error", -- can be a hex color, or a named color (see below)
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                    -- signs = false, -- configure signs for some keywords individually
                },
                TODO = { icon = require("helpers.icons").ui.Note .. " ", color = "info" },
                HACK = { icon = require("helpers.icons").ui.Fire .. " ", color = "warning" },
                WARN = { icon = require("helpers.icons").diagnostics.Warning .. " ", color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { icon = require("helpers.icons").diagnostics.BoldQuestion .. " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = require("helpers.icons").diagnostics.Hint .. " ", color = "hint", alt = { "INFO" } },
                TEST = { icon = require("helpers.icons").diagnostics.BoldHint .. " ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            },
            gui_style = {
                fg = "NONE", -- The gui style to use for the fg highlight group.
                bg = "BOLD", -- The gui style to use for the bg highlight group.
            },
            merge_keywords = true, -- when true, custom keywords will be merged with the defaults
            -- highlighting of the line containing the todo comment
            -- * before: highlights before the keyword (typically comment characters)
            -- * keyword: highlights of the keyword
            -- * after: highlights after the keyword (todo text)
            highlight = {
                multiline = true,    -- enable multine todo comments
                multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
                multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
                before = "",         -- "fg" or "bg" or empty
                keyword = "wide",    -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
                after = "fg",        -- "fg" or "bg" or empty
                pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
                comments_only = true, -- uses treesitter to match keywords in comments only
                max_line_len = 400,  -- ignore lines longer than this
                exclude = {},        -- list of file types to exclude highlighting
            },
            -- list of named colors where we try to extract the guifg from the
            -- list of highlight groups or use the hex color if hl not found as a fallback
            colors = {
                error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
                warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                info = { "DiagnosticInfo", "#2563EB" },
                hint = { "DiagnosticHint", "#10B981" },
                default = { "Identifier", "#7C3AED" },
                test = { "Identifier", "#FF00FF" }
            },
        }
    },
    { -- TODO: Set this up
        "RRethy/vim-illuminate",
        event = "User FileOpened",
        config = function()

        end,
    },
    {
        "ajeetdsouza/zoxide"
    },
    { 'wakatime/vim-wakatime', lazy = false }
}
