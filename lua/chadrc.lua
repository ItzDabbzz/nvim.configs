-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
    theme = "catppuccin",
    transparency = true,
    theme_toggle = { "poimandres", "catppuccin", "sweetpastel", "vscode_dark" },
    integrations = {
        "bufferline",
        "dap",
        "devicons",
        "diffview",
        "git",
        "git-conflict",
        "nvimtree",
        "syntax",
        "tbline",
        "telescope",
        "todo",
        "treesitter",
        "trouble",
    },
    -- hl_override = {
    -- 	Comment = { italic = true },
    -- 	["@comment"] = { italic = true },
    -- },
}
M.colorify = {
    enabled = true,
    mode = "virtual", -- fg, bg, virtual
    virt_text = "󱓻 ",
    highlight = { hex = true, lspvars = true },
}
local status = require("nvim-spotify").status

status:start()
-- M.nvdash = { load_on_startup = true }
M.ui = {
    cmp = {
        abbr_maxwidth = 80,
    },
    telescope = { style = "bordered" },
    statusline = {
        enabled = true,
        theme = "vscode_colored",
        order = { "mode", "file", "git", "status", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cursor", "cwd" },
        modules = {
            status = status.listen,
        },
    },
    tabufline = {
        lazyload = false,
    },
}

return M
