return {
    
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = true,
        opts = {
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            background = {
                light = "latte",
                dark = "mocha",
            },
            dim_inactive = {
                enabled = true,
            },
            custom_highlights = function(colors)
                return {
                    MatchParen = { italic = true },
                }
            end,
        },
    },
    {
        --[[
            https://github.com/2giosangmitom/nightfall.nvim

        ]]
        "2giosangmitom/nightfall.nvim",
        lazy = false,
        priority = 1000,
        version = "*",
        opts = {},
      },
      {
        --[[
            https://github.com/marko-cerovac/material.nvim
            5 styles: darker, lighter, oceanic, palenight, deep ocean
            --Lua:
            vim.g.material_style = "deep ocean"
        ]]
        "marko-cerovac/material.nvim"
      },
      --[[
        https://github.com/AlexvZyl/nordic.nvim
        
      ]]
      {
        'AlexvZyl/nordic.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require 'nordic' .load()
        end
    }
}