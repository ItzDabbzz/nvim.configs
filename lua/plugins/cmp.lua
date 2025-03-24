return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            {
                -- snippet plugin
                "L3MON4D3/LuaSnip",
                dependencies = "rafamadriz/friendly-snippets",
                opts = { history = true, updateevents = "TextChanged,TextChangedI" },
                config = function(_, opts)
                    require("luasnip").config.set_config(opts)
                    require "nvchad.configs.luasnip"
                end,
            },

            -- autopairing of (){}[] etc
            {
                "windwp/nvim-autopairs",
                opts = {
                    fast_wrap = {},
                    disable_filetype = { "TelescopePrompt", "vim" },
                },
                config = function(_, opts)
                    require("nvim-autopairs").setup(opts)

                    -- setup cmp for autopairs
                    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
                    require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
                end,
            },
            {
                "Exafunction/codeium.nvim",
                dependencies = {
                    "nvim-lua/plenary.nvim",
                },
                config = function()
                    require("codeium").setup {}
                end,
            },
            -- cmp sources plugins
            {
                "saadparwaiz1/cmp_luasnip",
                "hrsh7th/cmp-nvim-lua",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "Yu-Leo/cmp-go-pkgs",
                "amarakon/nvim-cmp-buffer-lines",
                "hrsh7th/cmp-cmdline",
                "dmitmel/cmp-cmdline-history",
                "roginfarrer/cmp-css-variables",
                "SergioRibera/cmp-dotenv",
            },
        },
        opts = function()
            return require "nvchad.configs.cmp"
        end,
    },
    {
        "David-Kunz/cmp-npm",
        dependencies = { "nvim-lua/plenary.nvim" },
        ft = "json",
        config = function()
            require("cmp-npm").setup {
                ignore = {},
                only_semantic_versions = false,
                only_latest_version = false,
            }
        end,
    },
    {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        -- optionally, override the default options:
        config = function()
            require("tailwindcss-colorizer-cmp").setup {
                color_square_width = 2,
            }
        end,
    },
    {
        "cjodo/convert.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        keys = {
            { "<leader>cn", "<cmd>ConvertFindNext<CR>", desc = "Find next convertable unit" },
            { "<leader>cc", "<cmd>ConvertFindCurrent<CR>", desc = "Find convertable unit in current line" },
            -- Add "v" to enable converting a selected region
            { "<leader>ca", "<cmd>ConvertAll<CR>", mode = { "n", "v" }, desc = "Convert all of a specified unit" },
        },
        config = function()
            local convert = require "convert"
            -- defaults
            convert.setup {
                keymaps = {
                    focus_next = { "j", "<Down>", "<Tab>" },
                    focus_prev = { "k", "<Up>", "<S-Tab>" },
                    close = { "<Esc>", "<C-c>", "qq" },
                    submit = { "<CR>", "<Space>" },
                },
                modes = { "color", "size", "numbers" }, -- available conversion modes
            }
        end,
    },
    {
        "someone-stole-my-name/yaml-companion.nvim",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
        },
        config = function()
            require("telescope").load_extension "yaml_schema"
        end,
    },
}
