return {
    {
        -- https://github.com/mfussenegger/nvim-dap
        'mfussenegger/nvim-dap',
    },
    { 
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
            "jay-babu/mason-nvim-dap.nvim",
        }
    },
    {
        -- https://github.com/theHamsta/nvim-dap-virtual-text
        'theHamsta/nvim-dap-virtual-text',
        opts = require "configs.dap_virtual_text",
    }
}