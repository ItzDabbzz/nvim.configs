return {

    {
        "sindrets/diffview.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            dofile(vim.g.base46_cache .. "diffview")
            require("diffview").setup()
        end,
        cmd = {
            "DiffviewOpen",
            "DiffviewClose",
            "DiffviewLog",
            "DiffviewRefresh",
        },
        default_args = {
            DiffviewOpen = { "--imply-local" },
        },
    },
    {
        "dinhhuy258/git.nvim",
        config = function()
            require("git").setup {
                default_mappings = true, -- NOTE: `quit_blame` and `blame_commit` are still merged to the keymaps even if `default_mappings = false`

                keymaps = {
                    -- Open blame window
                    blame = "<Leader>gb",
                    -- Close blame window
                    quit_blame = "q",
                    -- Open blame commit
                    blame_commit = "<CR>",
                    -- Quit blame commit
                    quit_blame_commit = "q",
                    -- Open file/folder in git repository
                    browse = "<Leader>go",
                    -- Open pull request of the current branch
                    open_pull_request = "<Leader>gp",
                    -- Create a pull request with the target branch is set in the `target_branch` option
                    create_pull_request = "<Leader>gn",
                    -- Opens a new diff that compares against the current index
                    diff = "<Leader>gd",
                    -- Close git diff
                    diff_close = "<Leader>gD",
                    -- Revert to the specific commit
                    revert = "<Leader>gr",
                    -- Revert the current file to the specific commit
                    revert_file = "<Leader>gR",
                },
                -- Default target branch when create a pull request
                target_branch = "master",
                -- Enable winbar in all windows created by this plugin
                winbar = false,
            }
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup {
                signs = {
                    add = { text = "┃" },
                    change = { text = "┃" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked = { text = "┆" },
                },
                signs_staged = {
                    add = { text = "┃" },
                    change = { text = "┃" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked = { text = "┆" },
                },
                signs_staged_enable = true,
                signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
                numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
                linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
                word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
                watch_gitdir = {
                    follow_files = true,
                },
                auto_attach = true,
                attach_to_untracked = false,
                current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                    delay = 1000,
                    ignore_whitespace = false,
                    virt_text_priority = 100,
                    use_focus = true,
                },
                current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil, -- Use default
                max_file_length = 40000, -- Disable if file is longer than this (in lines)
                preview_config = {
                    -- Options passed to nvim_open_win
                    border = "single",
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
            }
        end,
    },
    {
        "NeogitOrg/neogit",
        cmd = {
            "Neogit",
            "NeogitCommit",
            "NeogitLogCurrent",
            "NeogitResetState",
        },
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "sindrets/diffview.nvim", -- optional - Diff integration
            "nvim-telescope/telescope.nvim", -- optional
        },
        config = true,
    },

    {
        "kdheepak/lazygit.nvim",
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
            { "<leader>gl", "<cmd>LazyGit<cr>", desc = "LazyGit", noremap = true, silent = true },
        },
    },

    {
        "akinsho/git-conflict.nvim",
        version = "*",
        event = "VeryLazy",
        config = function()
            dofile(vim.g.base46_cache .. "git-conflict")
            require("git-conflict").setup {
                default_mappings = true,
            }
        end,
    },

    {
        "tpope/vim-fugitive",
        lazy = false,
    },

    { "tpope/vim-rhubarb", lazy = false },

    {
        "pwntester/octo.nvim",
        cmd = { "Octo" },
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telecope/telescope.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("octo").setup {
                use_local_fs = false, -- use local files on right side of reviews
                enable_builtin = false, -- shows a list of builtin actions when no action is provided
                default_remote = { "upstream", "origin" }, -- order to try remotes
                default_merge_method = "commit", -- default merge method which should be used when calling `Octo pr merge`, could be `commit`, `rebase` or `squash`
                ssh_aliases = {}, -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
                picker = "telescope", -- or "fzf-lua"
                picker_config = {
                    use_emojis = false, -- only used by "fzf-lua" picker for now
                    mappings = { -- mappings for the pickers
                        open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
                        copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
                        checkout_pr = { lhs = "<C-o>", desc = "checkout pull request" },
                        merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
                    },
                },
                comment_icon = "▎", -- comment marker
                outdated_icon = "󰅒 ", -- outdated indicator
                resolved_icon = " ", -- resolved indicator
                reaction_viewer_hint_icon = " ", -- marker for user reactions
                users = "search", -- Users for assignees or reviewers. Values: "search" | "mentionable" | "assignable"
                user_icon = " ", -- user icon
                timeline_marker = " ", -- timeline marker
                timeline_indent = "2", -- timeline indentation
                right_bubble_delimiter = "", -- bubble delimiter
                left_bubble_delimiter = "", -- bubble delimiter
                github_hostname = "", -- GitHub Enterprise host
                snippet_context_lines = 4, -- number or lines around commented lines
                gh_cmd = "gh", -- Command to use when calling Github CLI
                gh_env = {}, -- extra environment variables to pass on to GitHub CLI, can be a table or function returning a table
                timeout = 5000, -- timeout for requests between the remote server
                default_to_projects_v2 = false, -- use projects v2 for the `Octo card ...` command by default. Both legacy and v2 commands are available under `Octo cardlegacy ...` and `Octo cardv2 ...` respectively.
                ui = {
                    use_signcolumn = false, -- show "modified" marks on the sign column
                    use_signstatus = true, -- show "modified" marks on the status column
                },
                issues = {
                    order_by = { -- criteria to sort results of `Octo issue list`
                        field = "CREATED_AT", -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
                        direction = "DESC", -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
                    },
                },
                reviews = {
                    auto_show_threads = true, -- automatically show comment threads on cursor move
                },
                pull_requests = {
                    order_by = { -- criteria to sort the results of `Octo pr list`
                        field = "CREATED_AT", -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
                        direction = "DESC", -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
                    },
                    always_select_remote_on_create = false, -- always give prompt to select base remote repo when creating PRs
                },
                file_panel = {
                    size = 10, -- changed files panel rows
                    use_icons = true, -- use web-devicons in file panel (if false, nvim-web-devicons does not need to be installed)
                },
                colors = { -- used for highlight groups (see Colors section below)
                    white = "#ffffff",
                    grey = "#2A354C",
                    black = "#000000",
                    red = "#fdb8c0",
                    dark_red = "#da3633",
                    green = "#acf2bd",
                    dark_green = "#238636",
                    yellow = "#d3c846",
                    dark_yellow = "#735c0f",
                    blue = "#58A6FF",
                    dark_blue = "#0366d6",
                    purple = "#6f42c1",
                },
                mappings_disable_default = false, -- disable default mappings if true, but will still adapt user mappings
                mappings = {
                    issue = {
                        close_issue = { lhs = "<leader>ic", desc = "close issue" },
                        reopen_issue = { lhs = "<leader>io", desc = "reopen issue" },
                        list_issues = { lhs = "<leader>il", desc = "list open issues on same repo" },
                        reload = { lhs = "<C-r>", desc = "reload issue" },
                        open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
                        copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
                        add_assignee = { lhs = "<leader>aa", desc = "add assignee" },
                        remove_assignee = { lhs = "<leader>ad", desc = "remove assignee" },
                        create_label = { lhs = "<leader>lc", desc = "create label" },
                        add_label = { lhs = "<leader>la", desc = "add label" },
                        remove_label = { lhs = "<leader>ld", desc = "remove label" },
                        goto_issue = { lhs = "<leader>gi", desc = "navigate to a local repo issue" },
                        add_comment = { lhs = "<leader>ca", desc = "add comment" },
                        delete_comment = { lhs = "<leader>cd", desc = "delete comment" },
                        next_comment = { lhs = "]c", desc = "go to next comment" },
                        prev_comment = { lhs = "[c", desc = "go to previous comment" },
                        react_hooray = { lhs = "<leader>rp", desc = "add/remove 🎉 reaction" },
                        react_heart = { lhs = "<leader>rh", desc = "add/remove ❤️ reaction" },
                        react_eyes = { lhs = "<leader>re", desc = "add/remove 👀 reaction" },
                        react_thumbs_up = { lhs = "<leader>r+", desc = "add/remove 👍 reaction" },
                        react_thumbs_down = { lhs = "<leader>r-", desc = "add/remove 👎 reaction" },
                        react_rocket = { lhs = "<leader>rr", desc = "add/remove 🚀 reaction" },
                        react_laugh = { lhs = "<leader>rl", desc = "add/remove 😄 reaction" },
                        react_confused = { lhs = "<leader>rc", desc = "add/remove 😕 reaction" },
                    },
                    pull_request = {
                        checkout_pr = { lhs = "<leader>po", desc = "checkout PR" },
                        merge_pr = { lhs = "<leader>pm", desc = "merge commit PR" },
                        squash_and_merge_pr = { lhs = "<leader>psm", desc = "squash and merge PR" },
                        rebase_and_merge_pr = { lhs = "<leader>prm", desc = "rebase and merge PR" },
                        list_commits = { lhs = "<leader>pc", desc = "list PR commits" },
                        list_changed_files = { lhs = "<leader>pf", desc = "list PR changed files" },
                        show_pr_diff = { lhs = "<leader>pd", desc = "show PR diff" },
                        add_reviewer = { lhs = "<leader>va", desc = "add reviewer" },
                        remove_reviewer = { lhs = "<leader>vd", desc = "remove reviewer request" },
                        close_issue = { lhs = "<leader>ic", desc = "close PR" },
                        reopen_issue = { lhs = "<leader>io", desc = "reopen PR" },
                        list_issues = { lhs = "<leader>il", desc = "list open issues on same repo" },
                        reload = { lhs = "<C-r>", desc = "reload PR" },
                        open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
                        copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
                        goto_file = { lhs = "gf", desc = "go to file" },
                        add_assignee = { lhs = "<leader>aa", desc = "add assignee" },
                        remove_assignee = { lhs = "<leader>ad", desc = "remove assignee" },
                        create_label = { lhs = "<leader>lc", desc = "create label" },
                        add_label = { lhs = "<leader>la", desc = "add label" },
                        remove_label = { lhs = "<leader>ld", desc = "remove label" },
                        goto_issue = { lhs = "<leader>gi", desc = "navigate to a local repo issue" },
                        add_comment = { lhs = "<leader>ca", desc = "add comment" },
                        delete_comment = { lhs = "<leader>cd", desc = "delete comment" },
                        next_comment = { lhs = "]c", desc = "go to next comment" },
                        prev_comment = { lhs = "[c", desc = "go to previous comment" },
                        react_hooray = { lhs = "<leader>rp", desc = "add/remove 🎉 reaction" },
                        react_heart = { lhs = "<leader>rh", desc = "add/remove ❤️ reaction" },
                        react_eyes = { lhs = "<leader>re", desc = "add/remove 👀 reaction" },
                        react_thumbs_up = { lhs = "<leader>r+", desc = "add/remove 👍 reaction" },
                        react_thumbs_down = { lhs = "<leader>r-", desc = "add/remove 👎 reaction" },
                        react_rocket = { lhs = "<leader>rr", desc = "add/remove 🚀 reaction" },
                        react_laugh = { lhs = "<leader>rl", desc = "add/remove 😄 reaction" },
                        react_confused = { lhs = "<leader>rc", desc = "add/remove 😕 reaction" },
                        review_start = { lhs = "<leader>vs", desc = "start a review for the current PR" },
                        review_resume = { lhs = "<leader>vr", desc = "resume a pending review for the current PR" },
                    },
                    review_thread = {
                        goto_issue = { lhs = "<leader>gi", desc = "navigate to a local repo issue" },
                        add_comment = { lhs = "<leader>ca", desc = "add comment" },
                        add_suggestion = { lhs = "<leader>sa", desc = "add suggestion" },
                        delete_comment = { lhs = "<leader>cd", desc = "delete comment" },
                        next_comment = { lhs = "]c", desc = "go to next comment" },
                        prev_comment = { lhs = "[c", desc = "go to previous comment" },
                        select_next_entry = { lhs = "]q", desc = "move to next changed file" },
                        select_prev_entry = { lhs = "[q", desc = "move to previous changed file" },
                        select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
                        select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
                        close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
                        react_hooray = { lhs = "<leader>rp", desc = "add/remove 🎉 reaction" },
                        react_heart = { lhs = "<leader>rh", desc = "add/remove ❤️ reaction" },
                        react_eyes = { lhs = "<leader>re", desc = "add/remove 👀 reaction" },
                        react_thumbs_up = { lhs = "<leader>r+", desc = "add/remove 👍 reaction" },
                        react_thumbs_down = { lhs = "<leader>r-", desc = "add/remove 👎 reaction" },
                        react_rocket = { lhs = "<leader>rr", desc = "add/remove 🚀 reaction" },
                        react_laugh = { lhs = "<leader>rl", desc = "add/remove 😄 reaction" },
                        react_confused = { lhs = "<leader>rc", desc = "add/remove 😕 reaction" },
                    },
                    submit_win = {
                        approve_review = { lhs = "<C-A>", desc = "approve review" },
                        comment_review = { lhs = "<C-m>", desc = "comment review" },
                        request_changes = { lhs = "<C-r>", desc = "request changes review" },
                        close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
                    },
                    review_diff = {
                        submit_review = { lhs = "<leader>vs", desc = "submit review" },
                        discard_review = { lhs = "<leader>vd", desc = "discard review" },
                        add_review_comment = { lhs = "<leader>ca", desc = "add a new review comment" },
                        add_review_suggestion = { lhs = "<leader>sa", desc = "add a new review suggestion" },
                        focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
                        toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
                        next_thread = { lhs = "]t", desc = "move to next thread" },
                        prev_thread = { lhs = "[t", desc = "move to previous thread" },
                        select_next_entry = { lhs = "]q", desc = "move to next changed file" },
                        select_prev_entry = { lhs = "[q", desc = "move to previous changed file" },
                        select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
                        select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
                        close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
                        toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
                        goto_file = { lhs = "gf", desc = "go to file" },
                    },
                    file_panel = {
                        submit_review = { lhs = "<leader>vs", desc = "submit review" },
                        discard_review = { lhs = "<leader>vd", desc = "discard review" },
                        next_entry = { lhs = "j", desc = "move to next changed file" },
                        prev_entry = { lhs = "k", desc = "move to previous changed file" },
                        select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
                        refresh_files = { lhs = "R", desc = "refresh changed files panel" },
                        focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
                        toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
                        select_next_entry = { lhs = "]q", desc = "move to next changed file" },
                        select_prev_entry = { lhs = "[q", desc = "move to previous changed file" },
                        select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
                        select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
                        close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
                        toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
                    },
                },
            }
        end,
    },
}
