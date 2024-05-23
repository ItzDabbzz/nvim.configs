return {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
        local icons = require("helpers.icons")

        require('dashboard').setup {
            -- config
            theme = 'hyper',
            config = {
                week_header = {
                    enable = true,
                },
                shortcut = {
                    { desc = '󰊳  Update', group = '@property', action = 'Lazy update', key = 'u' },
                    { icon = icons.ui.Folder, desc = ' Mason', group = '@property', action = 'Mason', key = 'm' },
                    {
                        icon = icons.ui.Files,
                        icon_hl = '@variable',
                        desc = ' Files',
                        group = 'Label',
                        action = 'Telescope find_files',
                        key = 'f',
                    },
                    {
                        icon = icons.ui.Note,
                        desc = ' Zoxide',
                        group = 'DiagnosticHint',
                        action = 'Telescope zoxide list',
                        key = 'a',
                    },
                    {
                        icon = icons.ui.Dotfiles,
                        desc = ' dotfiles',
                        group = 'Number',
                        action = 'Telescope dotfiles',
                        key = 'd',
                    },
                    {
                        icon = icons.ui.History,
                        desc = " Restore Session",
                        group = 'Label',
                        action = "lua require('persistence').load()",
                        key = 's'
                    },
                },
            }
        }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } }
}
