return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-neotest/nvim-nio",
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "nvim-telescope/telescope-dap.nvim",
        "mxsdev/nvim-dap-vscode-js",
        "leoluz/nvim-dap-go",
    },
    config = function()
        local dap = require "dap"
        local ui = require "dapui"

        require("dapui").setup()
        require("dap-go").setup()
        require("nvim-dap-virtual-text").setup {
            -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
            display_callback = function(variable)
                local name = string.lower(variable.name)
                local value = string.lower(variable.value)
                if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
                    return "*****"
                end

                if #variable.value > 15 then
                    return " " .. string.sub(variable.value, 1, 15) .. "... "
                end

                return " " .. variable.value
            end,
        }

        local keys = require("helpers.keys")
        keys.map("n", "<leader>db", dap.toggle_breakpoint)
        keys.map("n", "<leader>dC", dap.run_to_cursor)
        keys.map("n", "<leader>dc", dap.continue)
        keys.map("n", "<leader>dz", dap.step_over)
        keys.map("n", "<leader>dx", dap.step_into)
        keys.map("n", "<leader>dc", dap.step_out)
        keys.map("n", "<leader>dv", dap.step_back)
        keys.map("n", "<leader>dr", dap.restart)
        keys.map("n", "<leader>d?", function()
            require("dapui").eval(nil, { enter = true })
        end)

        dap.listeners.before.attach.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            ui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            ui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            ui.close()
        end
    end,
}
