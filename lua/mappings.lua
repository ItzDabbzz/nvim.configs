require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>fs", function() require('search').open() end, { desc = "Search - Telescope" })

-- Better window navigation
map("n", "<C-h>", "<C-w><C-h>", { desc = "Navigate windows to the left" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Navigate windows down" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Navigate windows up" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Navigate windows to the right" })

-- Move with shift-arrows
map("n", "<S-Left>", "<C-w><S-h>", { desc = "Move window to the left" })
map("n", "<S-Down>", "<C-w><S-j>", { desc = "Move window down" })
map("n", "<S-Up>", "<C-w><S-k>", { desc = "Move window up" })
map("n", "<S-Right>", "<C-w><S-l>", { desc = "Move window to the right"} )

-- Resize with arrows
map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Left>", ":vertical resize +2<CR>")
map("n", "<C-Right>", ":vertical resize -2<CR>")

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

map("n", "<leader>s", "<cmd>w<cr>", { desc = "Save File" })
map("n", "<leader>S", "<cmd>wa<cr>", { desc = "Save all Files" })

map("n", "<leader>li", "<cmd>Lazy install<cr>", { desc = "Install - Lazy" })
map("n", "<leader>ls", "<cmd>Lazy sync<cr>", { desc = "Sync - Lazy" })
map("n", "<leader>lc", "<cmd>Lazy clear<cr>", { desc = "Clear - Lazy" })
map("n", "<leader>lC", "<cmd>Lazy clean<cr>", { desc = "Clean - Lazy" })
map("n", "<leader>lu", "<cmd>Lazy update<cr>", { desc = "Update - Lazy" })
map("n", "<leader>lp", "<cmd>Lazy profile<cr>", { desc = "Profile - Lazy" })
map("n", "<leader>ll", "<cmd>Lazy log<cr>", { desc = "Log - Lazy" })
map("n", "<leader>ld", "<cmd>Lazy debug<cr>", { desc = "Debug - Lazy" })

map("n", "<leader>du", "<cmd>DBUI<cr>", { desc = "dadbod UI"})
map("n", "<leader>dt", "<cmd>DBUIToggle<cr>", { desc = "dadbod UI Toggle" })

map("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>qa", "<cmd>qa!<cr>", { desc = "Quit All" })
--map("n", "<leader>", "<cmd><cr>", { desc = "" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
