local t = require('telescope')
local map = vim.keymap.set

map("n", "<leader>cd", "<cmd>Telescope zoxide<cr>", { desc = "Zoxide List - Telescope" })
map("n", "<leader>cb", function()
  require("tiny-code-action").code_action()
end, { desc = "Code Action - Telescope", noremap = true, silent = true })

map("n", "<leader>u", "<cmd>Telescope undo<cr>", { desc = "Undo List - Telescope" })
map("n", "<leader>ty", "<cmd>Telescope yaml_schema<cr>", { desc = "YAML Schema - Telescope" })
--map("n", "<leader>cp", t.extensions.neoclip.default(), { desc = "Clipboard - Telescope"})
