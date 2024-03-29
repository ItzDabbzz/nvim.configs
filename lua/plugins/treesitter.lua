return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/playground",
        "nvim-treesitter/nvim-treesitter-context",
        "windwp/nvim-ts-autotag",       -- Auto close html tags
    },
    config = function()
    end,
}