local colorscheme = require("helpers.colorscheme")
vim.cmd.colorscheme(colorscheme)

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vip, opt.termguicolors = true
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }
vim.g.markdown_recommended_style = 0
vim.opt.foldcolumn = "1" -- '0' is not bad
vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.background = "dark"
vim.opt.cmdwinheight = 10
vim.opt.cmdheight = 2
vim.opt.breakat = [[\ \	;:,!?]]
vim.opt.expandtab = true
vim.opt.history = 2500
vim.opt.incsearch = true
vim.opt.list = true
-- wrap long lines at a character in `breakat`
vim.opt.linebreak = true

--wrapped line will continue visually indented
vim.opt.breakindent = true
-- Wrap-broken line prefix
vim.opt.showbreak = [[↪ ]]
-- Automatically enable mouse usage
vim.opt.mouse = "a"
-- enable mouse move event
vim.opt.mousemoveevent = false
vim.opt.mousemodel = "extend"
vim.opt.mousescroll = "ver:1,hor:3"
-- don't give |ins-completion-menu| messages.
vim.opt.shortmess:append({ c = true, W = true, I = true })
-- Show the line number relative to the line with the cursor in front of each line.
vim.opt.relativenumber = false
-- Show line numbers
vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.showmode = false
-- Highlight matching brace
vim.opt.showmatch = true
vim.opt.smartindent = true
--Set 'tabstop' and 'shiftwidth' to whatever you prefer and use 'expandtab'.
--This way you will always insert spaces.  The formatting will never be messed up when 'tabstop' is changed.
--Number of spaces that a <Tab> in the file counts for
vim.opt.tabstop = 4
-- Number of auto-indent spaces
vim.opt.shiftwidth = 4
-- Number of spaces per Tab
-- When 'softtabstop' is negative, the value of 'shiftwidth' is used.
vim.opt.softtabstop = 4
-- always expands tab to spaces. It is good when peers use different editor.
vim.opt.expandtab = true
vim.opt.termguicolors = true
-- Time in milliseconds to wait for a mapped sequence to complete.
vim.opt.timeoutlen = 500
vim.opt.ttyfast = true
vim.opt.title = true
-- saves undo history to an undo file when writing a buffer to a file, and restores undo
-- history from the same file on buffer read.
vim.opt.undofile = true
-- Maximum number of changes that can be undone.
vim.opt.undolevels = 10000
-- vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
vim.opt.splitkeep = "screen"
-- open new split panes to right and below
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.smoothscroll = true
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.virtualedit = "block"
-- You will have bad experience for diagnostic messages when it's default 4000.
vim.opt.updatetime = 100
-- always merge sign column and number column into one
vim.opt.signcolumn = "yes"

-- Don't let autocomplete affect usual typing habits
vim.opt_global.completeopt = { "menu", "menuone", "noselect" }
vim.opt.conceallevel = 3 -- Hide * markup for bold and italic
vim.opt.concealcursor = "nc" --Sets the modes in which text in the cursor line can also be concealed.

vim.opt.cursorline = true -- Enable highlighting of the current line

vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.listchars = { tab = [[→→]], trail = "•", extends = "»", precedes = "«" }

-- make diff mode always open in vertical split
vim.opt_global.diffopt:append({ "vertical" })

-- Use visual bell (no beeping)
vim.opt.visualbell = true

-- Always case-insensitive
vim.opt.ignorecase = true

-- Enable smart-case search
vim.opt.smartcase = true

-- case insensitive auto completion
vim.opt.wildignorecase = true

local map = require("helpers.keys").map

-- Blazingly fast way out of insert mode
map("i", "jk", "<esc>")

-- Diagnostic keymaps
map("n", "bx", vim.diagnostic.open_float, "Show diagnostics under cursor")

-- Easier access to beginning and end of lines
map("n", "<M-h>", "^", "Go to beginning of line")
map("n", "<M-l>", "$", "Go to end of line")

-- Better window navigation
map("n", "<C-h>", "<C-w><C-h>", "Navigate windows to the left")
map("n", "<C-j>", "<C-w><C-j>", "Navigate windows down")
map("n", "<C-k>", "<C-w><C-k>", "Navigate windows up")
map("n", "<C-l>", "<C-w><C-l>", "Navigate windows to the right")

-- Move with shift-arrows
map("n", "<S-Left>", "<C-w><S-h>", "Move window to the left")
map("n", "<S-Down>", "<C-w><S-j>", "Move window down")
map("n", "<S-Up>", "<C-w><S-k>", "Move window up")
map("n", "<S-Right>", "<C-w><S-l>", "Move window to the right")

-- Resize with arrows
map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Left>", ":vertical resize +2<CR>")
map("n", "<C-Right>", ":vertical resize -2<CR>")

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

vim.api.nvim_set_keymap("i", "<F2>", '<cmd>lua require("renamer").rename()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap(
	"n",
	"<leader>rn",
	'<cmd>lua require("renamer").rename()<cr>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"v",
	"<leader>rn",
	'<cmd>lua require("renamer").rename()<cr>',
	{ noremap = true, silent = true }
)

vim.diagnostic.config({
	update_in_insert = false,
})

vim.opt.clipboard = "unnamedplus"

if vim.fn.has("wsl") == 1 then
	vim.g.clipboard = {
		name = "win32yank-wsl",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --lf",
			["*"] = "win32yank.exe -o --lf",
		},
		cache_enabled = 0,
	}
end

-- Setup Toggleterm Powershell config
local powershell_options = {
	shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
	shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
	shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
	shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
	shellquote = "",
	shellxquote = "",
}

for option, value in pairs(powershell_options) do
	vim.opt[option] = value
end

require("toggleterm").setup({})
require("scrollbar").setup()
require("nvim-tree.lua").setup({})

vim.opt.guicursor:append("a:blinkwait100-blinkoff700-blinkon700-blinkwait500")
vim.cmd([[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]])

-- This module contains a number of default definitions
local rainbow_delimiters = require("rainbow-delimiters")

---@type rainbow_delimiters.config
vim.g.rainbow_delimiters = {
	strategy = {
		[""] = rainbow_delimiters.strategy["global"],
		vim = rainbow_delimiters.strategy["local"],
	},
	query = {
		[""] = "rainbow-delimiters",
		lua = "rainbow-blocks",
	},
	priority = {
		[""] = 110,
		lua = 210,
	},
	highlight = {
		"RainbowDelimiterRed",
		"RainbowDelimiterYellow",
		"RainbowDelimiterBlue",
		"RainbowDelimiterOrange",
		"RainbowDelimiterGreen",
		"RainbowDelimiterViolet",
		"RainbowDelimiterCyan",
	},
}

local ColorInput = require("ccc.input")
local convert = require("ccc.utils.convert")

local RgbHslCmykInput = setmetatable({
	name = "RGB/HSL/CMYK",
	max = { 1, 1, 1, 360, 1, 1, 1, 1, 1, 1 },
	min = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	delta = { 1 / 255, 1 / 255, 1 / 255, 1, 0.01, 0.01, 0.005, 0.005, 0.005, 0.005 },
	bar_name = { "R", "G", "B", "H", "S", "L", "C", "M", "Y", "K" },
}, { __index = ColorInput })

function RgbHslCmykInput.format(n, i)
	if i <= 3 then
		-- RGB
		n = n * 255
	elseif i == 5 or i == 6 then
		-- S or L of HSL
		n = n * 100
	elseif i >= 7 then
		-- CMYK
		return ("%5.1f%%"):format(math.floor(n * 200) / 2)
	end
	return ("%6d"):format(n)
end

function RgbHslCmykInput.from_rgb(RGB)
	local HSL = convert.rgb2hsl(RGB)
	local CMYK = convert.rgb2cmyk(RGB)
	local R, G, B = unpack(RGB)
	local H, S, L = unpack(HSL)
	local C, M, Y, K = unpack(CMYK)
	return { R, G, B, H, S, L, C, M, Y, K }
end

function RgbHslCmykInput.to_rgb(value)
	return { value[1], value[2], value[3] }
end

function RgbHslCmykInput:_set_rgb(RGB)
	self.value[1] = RGB[1]
	self.value[2] = RGB[2]
	self.value[3] = RGB[3]
end

function RgbHslCmykInput:_set_hsl(HSL)
	self.value[4] = HSL[1]
	self.value[5] = HSL[2]
	self.value[6] = HSL[3]
end

function RgbHslCmykInput:_set_cmyk(CMYK)
	self.value[7] = CMYK[1]
	self.value[8] = CMYK[2]
	self.value[9] = CMYK[3]
	self.value[10] = CMYK[4]
end

function RgbHslCmykInput:callback(index, new_value)
	self.value[index] = new_value
	local v = self.value
	if index <= 3 then
		local RGB = { v[1], v[2], v[3] }
		local HSL = convert.rgb2hsl(RGB)
		local CMYK = convert.rgb2cmyk(RGB)
		self:_set_hsl(HSL)
		self:_set_cmyk(CMYK)
	elseif index <= 6 then
		local HSL = { v[4], v[5], v[6] }
		local RGB = convert.hsl2rgb(HSL)
		local CMYK = convert.rgb2cmyk(RGB)
		self:_set_rgb(RGB)
		self:_set_cmyk(CMYK)
	else
		local CMYK = { v[7], v[8], v[9], v[10] }
		local RGB = convert.cmyk2rgb(CMYK)
		local HSL = convert.rgb2hsl(RGB)
		self:_set_rgb(RGB)
		self:_set_hsl(HSL)
	end
end

local ccc = require("ccc")
ccc.setup({
	inputs = {
		RgbHslCmykInput,
	},
})
