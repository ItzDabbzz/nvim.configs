local get_errors = function(bufnr)
    return vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
end
local errors = get_errors(0) -- pass the current buffer; pass nil to get errors for all buffers

vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function()
        errors = get_errors(0)
    end,
})

return {
    {
        "S1M0N38/love2d.nvim",
        cmd = "LoveRun",
        opts = {},
        keys = {
            { "<leader>ll", ft = "lua", desc = "LÖVE" },
            { "<leader>llr", "<cmd>LoveRun<cr>", ft = "lua", desc = "Run LÖVE" },
            { "<leader>lls", "<cmd>LoveStop<cr>", ft = "lua", desc = "Stop LÖVE" },
        },
    },
    {
        "lukebaal/lumberjack.nvim",
        config = function() end,
    },
    {
        "vyfor/cord.nvim",
        build = ":Cord update",
        opts = {
            editor = {
                client = "neovim",
                tooltip = "The Best IDE",
            },
            display = {
                theme = "catppuccin",
                flavor = "dark",
            },
            text = {
                editing = function(opts)
                    return string.format("Editing %s - %s errors", opts.filename, #errors)
                end,
            },
        },
    },
    {
        "KadoBOT/nvim-spotify",
        requires = "nvim-telescope/telescope.nvim",
        config = function()
            local spotify = require "nvim-spotify"

            spotify.setup {
                -- default opts
                status = {
                    update_interval = 10000, -- the interval (ms) to check for what's currently playing
                    format = "%s %t by %a", -- spotify-tui --format argument
                },
            }
        end,
        run = "make",
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
            {
                "nvim-lua/plenary.nvim",
                branch = "master",
            }, -- for curl, log and async functions
        },
        opts = {
            -- See Configuration section for options
        },
        -- See Commands section for default commands if you want to lazy load on them
    },
    {
        "AndrewRadev/switch.vim",
        lazy = true,
        keys = {
            { "gs", ":Switch<cr>", desc = "Switch the opposite meaning of the word" },
            {
                "gS",
                function()
                    vim.fn["switch#Switch"] { definitions = vim.g.variable_style_switch_definitions }
                end,
                desc = "Switch variable naming style",
            },
        },
        config = function()
            local word_antisense_switch = {
                { "true", "false" },
                { "on", "off" },
                { "yes", "no" },
                { "disable", "enable" },
                { "enabled", "disabled" },
                { "success", "failure" },
                { "open", "close" },
                { "in", "out" },
                { "resolve", "reject" },
                { "start", "end" },
                { "before", "after" },
                { "from", "to" },
                { "relative", "absolute" },
                { "up", "down" },
                { "left", "right" },
                { "top", "bottom" },
                { "first", "last" },
                { "next", "prev" },
                { "row", "column" },
                { "dark", "light" },
                { "inferior", "superior" },
                { "lower", "upper" },
                { "selected", "unselected" },
                { "active", "inactive" },
                { "white", "black" },
                { "get", "post" },
                { "forward", "backward" },
                { "odd", "even" },
                { "+", "-" },
                { ">", "<" },
                { "=", "!=" },
                { '"', "'" },
                { "'", '"' },
            }

            local variable_style_switch = {
                {
                    ["\\<[a-z0-9]\\+_\\k\\+\\>"] = {
                        ["_\\(.\\)"] = "\\U\\1",
                    },
                },
                {
                    ["\\<[a-z0-9]\\+[A-Z]\\k\\+\\>"] = {
                        ["\\([A-Z]\\)"] = "_\\l\\1",
                    },
                },
            }

            local function str_title(s)
                return (
                    s:gsub("(%a)([%w_']*)", function(f, r)
                        return f:upper() .. r:lower()
                    end)
                )
            end

            local put_words = vim.deepcopy(word_antisense_switch)

            for _, value in ipairs(word_antisense_switch) do
                local upper_words = { string.upper(value[1]), string.upper(value[2]) }
                local title_words = { str_title(value[1]), str_title(value[2]) }
                table.insert(put_words, upper_words)
                table.insert(put_words, title_words)
            end

            vim.g.switch_custom_definitions = put_words
            vim.g.variable_style_switch_definitions = variable_style_switch
        end,
    },
    {
        "petertriho/nvim-scrollbar", -- Nice scroll bar with git integration
        dependencies = {
            "kevinhwang91/nvim-hlslens",
            "lewis6991/gitsigns.nvim",
            "kevinhwang91/nvim-ufo",
            "kevinhwang91/promise-async",
        },
        opts = {
            hide_if_all_visible = true,
            handle = {
                highlight = "ScrollbarHandle",
            },
            handlers = {
                cursor = true,
                diagnostic = true,
                gitsigns = true, -- Requires gitsigns
                search = true, -- Requires hlslens
            },
            marks = {
                Cursor = { text = "—" },
                Search = { text = { "—", "󰇼" } },
                Error = { text = { "—", "󰇼" } },
                Warn = { text = { "—", "󰇼" } },
                Info = { text = { "—", "󰇼" } },
                Hint = { text = { "—", "󰇼" } },
                Misc = { text = { "—", "󰇼" } },
                GitAdd = { text = "▎" },
                GitChange = { text = "▎" },
                GitDelete = { text = "▁" },
            },
        },
    },
    -- Highlight different level brackets with different color
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = "User LazyFile",
    },
    { "wakatime/vim-wakatime", lazy = false },
    {
        "folke/trouble.nvim",
        branch = "main", -- IMPORTANT!
        lazy = true,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
        opts = {}, -- for default options, refer to the configuration section for custom setup.
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "User FileOpened",
        opts = {
            keywords = {
                FIX = {
                    icon = require("utils.icons").diagnostics.Bug .. " F", -- icon used for the sign, and in search results
                    color = "error", -- can be a hex color, or a named color (see below)
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                    -- signs = false, -- configure signs for some keywords individually
                },
                TODO = { icon = require("utils.icons").ui.Note .. " T", color = "info" },
                HACK = { icon = require("utils.icons").ui.Fire .. " H", color = "warning" },
                WARN = {
                    icon = require("utils.icons").diagnostics.Warning .. " W",
                    color = "warning",
                    alt = { "WARNING", "XXX" },
                },
                PERF = {
                    icon = require("utils.icons").diagnostics.BoldQuestion .. " P",
                    alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
                },
                NOTE = { icon = require("utils.icons").diagnostics.Hint .. " N", color = "hint", alt = { "INFO" } },
                TEST = {
                    icon = require("utils.icons").diagnostics.BoldHint .. " ",
                    color = "test",
                    alt = { "TESTING", "PASSED", "FAILED" },
                },
            },
            gui_style = {
                fg = "NONE", -- The gui style to use for the fg highlight group.
                bg = "BOLD", -- The gui style to use for the bg highlight group.
            },
            merge_keywords = true, -- when true, custom keywords will be merged with the defaults
            -- highlighting of the line conta
        },
    },
}
