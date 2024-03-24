-- Handle plugins with lazy.nvim
require("core.lazy")

-- General Neovim keymaps
require("core.keymaps")

-- Other options
require("core.options")

-- Commander Setup

require("core.commander-setup")

local opt = vim.opt

--Set highlight on search
opt.hlsearch = false

--Make line numbers default
opt.number = true
opt.relativenumber = true

opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.shiftround = true

--Enable mouse mode
--vim.o.mouse = 'a'
opt.mouse = "a"
opt.scrolloff = 8
opt.sidescrolloff = 10

opt.splitright = true
opt.splitbelow = true

opt.pumheight = 12

--Enable break indent
--vim.o.breakindent = true
opt.breakindent = true

--Save undo history
--vim.opt.undofile = true
opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
--vim.o.ignorecase = true
--vim.o.smartcase = true
opt.ignorecase = true
opt.smartcase = true

-- Keep signcolumn on by default
--vim.wo.signcolumn = 'yes'
opt.signcolumn = 'yes'

-- Decrease update time
--vim.o.updatetime = 250
opt.updatetime = 250

-- Set completeopt to have a better completion experience
opt.completeopt = 'menu,menuone,noinsert,noselect'
opt.wildmode = "longest:full,full"

opt.mousescroll = "ver:1,hor:3"
opt.cursorline = true
--Set colorscheme (order is important here)
opt.termguicolors = true
opt.showmode = false
opt.wrap = false
opt.ttimeoutlen = 0
opt.conceallevel = 2

vim.cmd.colorscheme 'catppuccin'

vim.diagnostic.config({
    update_in_insert = false
})

local function list(items, sep)
  return table.concat(items, sep or ",")
end

opt.fillchars = list {
  -- "vert:▏",
  "vert:│",
  "diff:╱",
  "foldclose:",
  "foldopen:",
  "fold: ",
  "msgsep:─",
}

opt.guicursor:append("a:blinkwait100-blinkoff700-blinkon700")
vim.cmd([[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]])

vim.diagnostic.config({
  virtual_text = false,
})

require("scrollbar").setup()

-- This module contains a number of default definitions
local rainbow_delimiters = require 'rainbow-delimiters'

---@type rainbow_delimiters.config
vim.g.rainbow_delimiters = {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
    priority = {
        [''] = 110,
        lua = 210,
    },
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
    },
}
require('nvim-ts-autotag').setup()

-- Setup Toggleterm Powershell config
local powershell_options = {
    shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
    shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
}

for option, value in pairs(powershell_options) do
    opt[option] = value
end

require("toggleterm").setup {}

-- Setup Astro LSP config
vim.filetype.add({
    extension = {
        astro = "astro",
        mdx = "mdx",
    }
})

vim.treesitter.language.register("markdown", "mdx")

require("nvim-web-devicons").setup({
    strict = true,
    override_by_extension = {
        astro = {
            icon = "",
            color = "#EF8547",
            name = "astro",
        },
    },
})

-- Install gotmpl parser for go and nvim-treesitter
local parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
parser_config.gotmpl = {
  install_info = {
    url = "https://github.com/ngalaiko/tree-sitter-go-template",
    files = {"src/parser.c"}
  },
  filetype = "gotmpl",
  used_by = {"gohtmltmpl", "gotexttmpl", "gotmpl", "yaml"}
}

-- Open trouble ui
require("trouble").open()