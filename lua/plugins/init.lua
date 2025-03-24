local tu = require "utils.telescope"
local icons = require "utils.icons"
return {
    {
        "vhyrro/luarocks.nvim",
        priority = 1001, -- this plugin needs to run before anything else
        opts = {
            rocks = { "magick" },
        },
    },
    {
        "3rd/image.nvim",
        dependencies = { "luarocks.nvim" },
        opts = {},
    },
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
            },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "crispgm/telescope-heading.nvim" },
            {
                "jvgrootveld/telescope-zoxide",
            },
            { "FabianWirth/search.nvim" },
            { "debugloop/telescope-undo.nvim" },
            {
                "olimorris/persisted.nvim",
                event = "BufReadPre", -- Ensure the plugin loads only when a buffer has been loaded
                opts = {
                    autostart = true, -- Automatically start the plugin on load?

                    -- Function to determine if a session should be saved
                    ---@type fun(): boolean
                    should_save = function()
                        return true
                    end,

                    save_dir = vim.fn.expand(vim.fn.stdpath "data" .. "/sessions/"), -- Directory where session files are saved

                    follow_cwd = true, -- Change the session file to match any change in the cwd?
                    use_git_branch = false, -- Include the git branch in the session file name?
                    autoload = false, -- Automatically load the session for the cwd on Neovim startup?

                    -- Function to run when `autoload = true` but there is no session to load
                    ---@type fun(): any
                    on_autoload_no_session = function() end,

                    allowed_dirs = {}, -- Table of dirs that the plugin will start and autoload from
                    ignored_dirs = {}, -- Table of dirs that are ignored for starting and autoloading

                    telescope = {
                        icons = { -- icons displayed in the Telescope picker
                            selected = " ",
                            dir = "  ",
                            branch = " ",
                        },
                    },
                },
            },
        },
        opts = function(_, conf)
            local t = require "telescope"
            local builtin = require "telescope.builtin"

            local map = vim.keymap.set
            map("n", "<leader>cvt", function()
                t.extensions.vstask.tasks()
            end, { desc = "VSCode Tasks List" })

            map("n", "<leader>cvi", function()
                t.extensions.vstask.inputs()
            end, { desc = "VSCode Inputs" })

            map("n", "<leader>cvj", function()
                t.extensions.vstask.jobs()
            end, { desc = "VSCode Jobs List" })

            map("n", "<leader>cvh", function()
                t.extensions.vstask.history()
            end, { desc = "VSCode History" })

            map("n", "<leader>cvc", function()
                t.extensions.vstask.close()
            end, { desc = "VSCode Close Runner" })

            map("n", "<leader>cvr", function()
                t.extensions.vstask.run()
            end, { desc = "VSCode Run" })
            conf.defaults.color_devicons = true
            conf.defaults.set_env = { ["COLORTERM"] = "truecolor" }
            conf.defaults.prompt_prefix = icons.ui.Telescope .. " "
            conf.defaults.election_caret = icons.ui.Forward .. " "

            conf.defaults.mappings.i = {
                ["<C-j>"] = require("telescope.actions").move_selection_next,
                ["<Esc>"] = require("telescope.actions").close,
            }
            conf.defaults.extensions = {
                zoxide = {},
                heading = {
                    treesitter = true,
                },
                neoclip = {},
                undo = {},
            }
            -- or
            -- table.insert(conf.defaults.mappings.i, your table)
            require("search").setup {
                initial_tab = 1,
                append_tabs = {
                    {
                        name = "All Files",
                        tele_func = builtin.find_files,
                        tele_opts = { no_ignore = true, hidden = true },
                    },
                },
                collections = {
                    -- Here the "git" collection is defined. It follows the same configuraton layout as tabs.
                    git = {
                        initial_tab = 1, -- Git branches
                        tabs = {
                            { name = "Branches", tele_func = builtin.git_branches },
                            { name = "Commits", tele_func = builtin.git_commits },
                            { name = "Stashes", tele_func = builtin.git_stash },
                        },
                    },
                },
            }

            tu.load_extension_after_telescope_is_loaded "neoclip"
            tu.load_extension_after_telescope_is_loaded "vstask"
            tu.load_extension_after_telescope_is_loaded "undo"
            tu.load_extension_after_telescope_is_loaded "persisted"
            tu.load_extension_after_telescope_is_loaded "zoxide"
            require "configs.telescope"
            return conf
        end,
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
}
