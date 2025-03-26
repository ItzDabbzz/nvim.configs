return {
    {
        "vhyrro/luarocks.nvim",
        priority = 1001, -- this plugin needs to run before anything else
        opts = {
            rocks = { "magick" },
        },
    },
    --{
    --    "3rd/image.nvim",
    --    dependencies = { "luarocks.nvim" },
    --    opts = {},
    --},
    {
        "stevearc/conform.nvim",
        -- event = 'BufWritePre', -- uncomment for format on save
        opts = require "configs.conform",
    },

    -- These are some examples, uncomment them if you want to see them work!
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "configs.lspconfig"
        end,
    },
    {
        "MagicDuck/grug-far.nvim",
        config = function()
            -- optional setup call to override plugin options
            -- alternatively you can set options with vim.g.grug_far = { ... }
            require("grug-far").setup {
                -- options, see Configuration section below
                -- there are no required options atm
                -- engine = 'ripgrep' is default, but 'astgrep' or 'astgrep-rules' can
                -- be specified
            }
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- Load the wezterm types when the `wezterm` module is required
                -- Needs `justinsgithub/wezterm-types` to be installed
                { path = "wezterm-types", mods = { "wezterm" } },
            },
            -- always enable unless `vim.g.lazydev_enabled = false`
            -- This is the default
            enabled = function(root_dir)
                return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
            end,
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "vim",
                "lua",
                "vimdoc",
                "html",
                "css",
                "javascript",
                "json",
                "markdown",
                "rst",
                "dockerfile",
                "yaml",
                "toml",
                "tsx",
                "typescript",
                "sql",
                "regex",
            },
        },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
        keys = {
            { "<leader>mr", "<cmd>RenderMarkdown enable<cr>", desc = "Render Markdown" },
            { "<leader>ms", "<cmd>RenderMarkdown disable<cr>", desc = "Stop Render" },
            { "<leader>me", "<cmd>RenderMarkdown expand<cr>", desc = "Expand Conceal Margin" },
            { "<leader>mc", "<cmd>RenderMarkdown contract<cr>", desc = "Decrease Conceal Margin" },
        },
        config = function()
            require "configs.rendermarkdown"
        end,
    },
    {
        "mhanberg/output-panel.nvim",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("output_panel").setup {
                max_buffer_size = 5000, -- default
            }
        end,
        cmd = { "OutputPanel" },
        keys = {
            {
                "<leader>lo",
                vim.cmd.OutputPanel,
                mode = "n",
                desc = "Toggle the output panel",
            },
        },
    },
}
