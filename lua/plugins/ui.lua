return {
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        config = function()
            dofile(vim.g.base46_cache .. "trouble")
            require("trouble").setup()
        end,
    },
    {
        "folke/snacks.nvim",
        ---@type snacks.Config
        opts = {
            ---@class snacks.notifier.Config
            ---@field enabled? boolean
            ---@field keep? fun(notif: snacks.notifier.Notif): boolean # global keep function
            ---@field filter? fun(notif: snacks.notifier.Notif): boolean # filter our unwanted notifications (return false to hide)
            notifier = {
                timeout = 3000, -- default timeout in ms
                width = { min = 40, max = 0.4 },
                height = { min = 1, max = 0.6 },
                -- editor margin to keep free. tabline and statusline are taken into account automatically
                margin = { top = 0, right = 1, bottom = 0 },
                padding = true, -- add 1 cell of left/right padding to the notification window
                sort = { "level", "added" }, -- sort by level and time
                -- minimum log level to display. TRACE is the lowest
                -- all notifications are stored in history
                level = vim.log.levels.TRACE,
                icons = {
                    error = " ",
                    warn = " ",
                    info = " ",
                    debug = " ",
                    trace = " ",
                },
                keep = function(notif)
                    return vim.fn.getcmdpos() > 0
                end,
                ---@type snacks.notifier.style
                style = "compact",
                top_down = true, -- place notifications from top to bottom
                date_format = "%R", -- time format for notifications
                -- format for footer when more lines are available
                -- `%d` is replaced with the number of lines.
                -- only works for styles with a border
                ---@type string|boolean
                more_format = " ↓ %d lines ",
                refresh = 50, -- refresh at most every 50ms
            },
        },
    },
    {
        "otavioschwanck/arrow.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            -- or if using `mini.icons`
            -- { "echasnovski/mini.icons" },
        },
        opts = {
            show_icons = true,
            always_show_path = false,
            separate_by_branch = false, -- Bookmarks will be separated by git branch
            hide_handbook = false, -- set to true to hide the shortcuts on menu.
            hide_buffer_handbook = false, --set to true to hide shortcuts on buffer menu
            save_path = function()
                return vim.fn.stdpath "cache" .. "/arrow"
            end,
            mappings = {
                edit = "e",
                delete_mode = "d",
                clear_all_items = "C",
                toggle = "s", -- used as save if separate_save_and_remove is true
                open_vertical = "v",
                open_horizontal = "-",
                quit = "q",
                remove = "x", -- only used if separate_save_and_remove is true
                next_item = "]",
                prev_item = "[",
            },
            custom_actions = {
                open = function(target_file_name, current_file_name) end, -- target_file_name = file selected to be open, current_file_name = filename from where this was called
                split_vertical = function(target_file_name, current_file_name) end,
                split_horizontal = function(target_file_name, current_file_name) end,
            },
            window = { -- controls the appearance and position of an arrow window (see nvim_open_win() for all options)
                width = "auto",
                height = "auto",
                row = "auto",
                col = "auto",
                border = "double",
            },
            per_buffer_config = {
                lines = 4, -- Number of lines showed on preview.
                sort_automatically = true, -- Auto sort buffer marks.
                satellite = { -- default to nil, display arrow index in scrollbar at every update
                    enable = false,
                    overlap = true,
                    priority = 1000,
                },
                zindex = 10, --default 50
                treesitter_context = nil, -- it can be { line_shift_down = 2 }, currently not usable, for detail see https://github.com/otavioschwanck/arrow.nvim/pull/43#issue-2236320268
            },
            separate_save_and_remove = false, -- if true, will remove the toggle and create the save/remove keymaps.
            leader_key = ";",
            save_key = "cwd", -- what will be used as root to save the bookmarks. Can be also `git_root` and `git_root_bare`.
            global_bookmarks = false, -- if true, arrow will save files globally (ignores separate_by_branch)
            index_keys = "123456789zxcbnmZXVBNM,afghjklAFGHJKLwrtyuiopWRTYUIOP", -- keys mapped to bookmark index, i.e. 1st bookmark will be accessible by 1, and 12th - by c
            full_path_list = { "update_stuff" }, -- filenames on this list will ALWAYS show the file path too.
            buffer_leader_key = "m", -- Per Buffer Mappings
        },
    },
}
