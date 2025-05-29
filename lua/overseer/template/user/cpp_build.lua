local overseer = require "overseer"
return {
    name = "g++ build",
    builder = function()
        -- Full path to current file (see :help expand())
        local file = vim.fn.expand "%:p"
        return {
            cmd = { "g++" },
            args = { file },
            components = { { "on_output_quickfix", open = true }, "default" },
        }
    end,
    desc = "Builds With G++",
    tags = { overseer.TAG.BUILD },
    condition = {
        filetype = { "cpp" },
    },
}
