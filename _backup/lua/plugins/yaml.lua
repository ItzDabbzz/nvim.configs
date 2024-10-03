return {
    {
        "someone-stole-my-name/yaml-companion.nvim",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
        },
        lazy = true,
        config = function()
          require("telescope").load_extension("yaml_schema")
        end,
    }
}