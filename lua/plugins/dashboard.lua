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
          { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
          {
            icon = icons.ui.Files,
            icon_hl = '@variable',
            desc = 'Files',
            group = 'Label',
            action = 'Telescope find_files',
            key = 'f',
          },
          {
            icon = icons.ui.Home,
            desc = 'Apps',
            group = 'DiagnosticHint',
            action = 'Telescope app',
            key = 'a',
          },
          {
            icon = icons.ui.Dotfiles,
            desc = 'dotfiles',
            group = 'Number',
            action = 'Telescope dotfiles',
            key = 'd',
          },
        },
      }
    }
  end,
  dependencies = { {'nvim-tree/nvim-web-devicons'}}}
