local t = require('telescope')
local builtin = require("telescope.builtin")
local map = vim.keymap.set

map("n", "<leader>fo", "<cmd>Telescope zoxide<cr>", { desc = "Zoxide List - Telescope" })
map("n", "<leader>fa", function()
  require("tiny-code-action").code_action()
end, { desc = "Code Action - Telescope", noremap = true, silent = true })

map("n", "<leader>fu", "<cmd>Telescope undo<cr>", { desc = "Undo List - Telescope" })
map("n", "<leader>fy", "<cmd>Telescope yaml_schema<cr>", { desc = "YAML Schema - Telescope" })

map("n", "<space>fd", function()
	builtin.find_files({ cwd = vim.fn.stdpath("data") })
end,  { desc = "Search Neovim Data" })

map("n", "<space>fn", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end,  { desc = "Search Neovim Config" })


map("n", "<space>fb", builtin.buffers,  { desc = "Search Buffers" })
map("n", "<space>ff", builtin.find_files,  { desc = "Search Files" })
map("n", "<space>fg", builtin.live_grep,  { desc = "Live Grep" })
map("n", "<space>fr", builtin.oldfiles,  { desc = "Recent Files" })
map("n", "<space>fh", builtin.help_tags,  { desc = "Search Help" })
map("n", "<space>fs", builtin.grep_string,  { desc = "Search Grep String" })
--map("n", "<leader>cp", t.extensions.neoclip.default(), { desc = "Clipboard - Telescope"})
