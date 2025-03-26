return {
    {
        "https://github.com/ryoppippi/nvim-pnpm-catalog-lens",
        lazy = false, -- designed to be lazy loaded
    },
    {
        "lukahartwig/pnpm.nvim",
        config = function()
            local telescope = require "telescope"
            vim.keymap.set("n", "<leader>fw", telescope.extensions.pnpm.workspace, {})
            telescope.load_extension "pnpm"
        end,
    },
    {
        'BibekBhusal0/nvim-shadcn',
        opts = require "configs.shadcn",
        cmd = { 'ShadcnAdd' },
        keys = {
            { '<leader>sa', ':ShadcnAdd<CR>', desc = 'Add shadcn component' },
        }
    }
}
