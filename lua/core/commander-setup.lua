local commander = require("commander")

commander.add({
    {
        desc = "Search inside current buffer",
        cmd = "<CMD>Telescope current_buffer_fuzzy_find<CR>",
        keys = { "n", "<leader>/" },
    },
    {
        desc = "Find Files - Telescope",
        cmd = "<CMD>Telescope find_files<CR>",
        keys = { "n", "<leader>sf" },
    },
    {
        desc = "Telescope Help",
        cmd = "<CMD>Telescope help_tags<CR>",
        keys = { "n", "<leader>sh" },
    },
    {
        -- If keys are not provided, no keymaps will be displayed nor set
        desc = "Find hidden files",
        cmd = "<CMD>Telescope find_files hidden=true<CR>",
    },
    {
        desc = "Live Grep - Telescope",
        cmd = "<CMD>Telescope live_grep<CR>",
    },
    {
        desc = "Open Buffers - Telescope",
        cmd = "<CMD>Telescope buffers<CR>",
        keys = { "n", "<leader><space>" },
    },
    {
        desc = "Recently Opened Files - Telescope",
        cmd = "<CMD>Telescope oldfiles<CR>",
        keys = { "n", "<leader>fr" },
    },
    {
        desc = "Write File",
        cmd = "<CMD>w<CR>",
        keys = { "n", "<leader>fw" }
    },
    {
        desc = "Write All Files",
        cmd = "<cmd>wa<cr>",
        keys = { "n", "<leader>fa" }
    },
    {
        desc = "Quit",
        cmd = "<cmd>q<cr>",
        keys = { "n", "<leader>qq" }
    },
    {
        desc = "Quit All",
        cmd = "<cmd>qa!<cr>",
        keys = { "n", "<leader>qa" }
    },
    {
        desc = "Close Window",
        cmd = "<cmd>close<cr>",
        keys = { "n", "<leader>dw" }
    },
    {
        desc = "Go to beginning of line",
        cmd = "^",
        keys = { "n", "<M-h>" }
    },
    {
        desc = "Go to end of line",
        cmd = "$",
        keys = { "n", "<M-l>" }
    },
    {
        desc = "Clear Highlights",
        cmd = "<CMD>nohl<CR>",
        keys = { "n", "<leader>ur" }
    },
    {
        desc = "Markdown Preview",
        cmd = "<CMD>MarkdownPreview<CR>",
        keys = { "n", "<leader>mdp" }
    },
    {
        desc = "Markdown Preview Stop",
        cmd = "<CMD>MarkdownPreviewStop<CR>",
        keys = { "n", "<leader>mdps" }
    },
    {
        desc = "Color Picker",
        cmd = "<CMD>Colortils picker<CR>",
        keys = { "n", "<leader>cp" }
    },
    --{
    --    desc = "Rename Symbol",
    --    keys = { "n", "<leader>lr" }
    --},
    --{
    --    desc = "Code Action",
    --    keys = { "n", "<leader>la" }
    --},
    --{
    --    desc = "Type Definition",
    --    keys = { "n", "<leader>ld" }
    --},
    --{
    --    desc = "Document Symbols",
    --    keys = { "n", "<leader>ls" }
    --},
})
