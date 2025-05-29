return {
    {
        "stevearc/overseer.nvim",
        opts = {},
        init = function()
            require("overseer").setup {
                templates = { "builtin", "user.cpp_build" },
            }
        end,
    },
}
