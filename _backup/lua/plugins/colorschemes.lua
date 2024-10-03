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
}