return {{
    "Exafunction/codeium.nvim",
    dependencies = {"nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp"},
    config = function()
        require("codeium").setup({})
    end
}, {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {{"github/copilot.vim"}, -- or zbirenbaum/copilot.lua
    {
        "nvim-lua/plenary.nvim",
        branch = "master"
    } -- for curl, log and async functions
    },
    opts = {
        -- See Configuration section for options
    }
    -- See Commands section for default commands if you want to lazy load on them
}}
