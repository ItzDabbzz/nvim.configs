-- Declare a global function to retrieve the current directory
-- function _G.get_oil_winbar()
-- 	local dir = require("oil").get_current_dir()
-- 	if dir then
-- 		return vim.fn.fnamemodify(dir, ":~")
-- 	else
-- 		-- If there is no current directory (e.g. over ssh), just show the buffer name
-- 		return vim.api.nvim_buf_get_name(0)
-- 	end
-- end

vim.cmd.colorscheme("catppuccin")

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

local map = require("utils.keybinds").map

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

-- helper function to parse output
local function parse_output(proc)
	local result = proc:wait()
	local ret = {}
	if result.code == 0 then
		for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
			-- Remove trailing slash
			line = line:gsub("/$", "")
			ret[line] = true
		end
	end
	return ret
end

-- build git status cache
local function new_git_status()
	return setmetatable({}, {
		__index = function(self, key)
			local ignore_proc = vim.system(
				{ "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
				{
					cwd = key,
					text = true,
				}
			)
			local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
				cwd = key,
				text = true,
			})
			local ret = {
				ignored = parse_output(ignore_proc),
				tracked = parse_output(tracked_proc),
			}

			rawset(self, key, ret)
			return ret
		end,
	})
end

-- require("config.hydra")

-- local git_status = new_git_status()

-- Clear git status cache on refresh
-- local refresh = require("oil.actions").refresh
-- local orig_refresh = refresh.callback
-- refresh.callback = function(...)
-- 	git_status = new_git_status()
-- 	orig_refresh(...)
-- end

-- require("oil").setup({
-- 	default_file_explorer = true,
-- 	columns = {
-- 		"icon",
-- 		"permissions",
-- 		"size",
-- 		"mtime",
-- 	},
-- 	-- Buffer-local options to use for oil buffers
-- 	buf_options = {
-- 		buflisted = false,
-- 		bufhidden = "hide",
-- 	},
-- 	-- Window-local options to use for oil buffers
-- 	win_options = {
-- 		wrap = false,
-- 		signcolumn = "no",
-- 		cursorcolumn = false,
-- 		foldcolumn = "0",
-- 		spell = false,
-- 		list = false,
-- 		conceallevel = 3,
-- 		concealcursor = "nvic",
-- 		winbar = "%!v:lua.get_oil_winbar()",
-- 	},
-- 	-- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
-- 	delete_to_trash = false,
-- 	-- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
-- 	skip_confirm_for_simple_edits = false,
-- 	-- Selecting a new/moved/renamed file or directory will prompt you to save changes first
-- 	-- (:help prompt_save_on_select_new_entry)
-- 	prompt_save_on_select_new_entry = true,
-- 	-- Oil will automatically delete hidden buffers after this delay
-- 	-- You can set the delay to false to disable cleanup entirely
-- 	-- Note that the cleanup process only starts when none of the oil buffers are currently displayed
-- 	cleanup_delay_ms = 2000,
-- 	lsp_file_methods = {
-- 		-- Enable or disable LSP file operations
-- 		enabled = true,
-- 		-- Time to wait for LSP file operations to complete before skipping
-- 		timeout_ms = 1000,
-- 		-- Set to true to autosave buffers that are updated with LSP willRenameFiles
-- 		-- Set to "unmodified" to only save unmodified buffers
-- 		autosave_changes = false,
-- 	},
-- 	-- Constrain the cursor to the editable parts of the oil buffer
-- 	-- Set to `false` to disable, or "name" to keep it on the file names
-- 	constrain_cursor = "editable",
-- 	-- Set to true to watch the filesystem for changes and reload oil
-- 	watch_for_changes = false,
-- 	-- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
-- 	-- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
-- 	-- Additionally, if it is a string that matches "actions.<name>",
-- 	-- it will use the mapping at require("oil.actions").<name>
-- 	-- Set to `false` to remove a keymap
-- 	-- See :help oil-actions for a list of all available actions
-- 	keymaps = {
-- 		["g?"] = "actions.show_help",
-- 		["<CR>"] = "actions.select",
-- 		["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
-- 		["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
-- 		["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
-- 		["<C-p>"] = "actions.preview",
-- 		["<C-c>"] = "actions.close",
-- 		["<C-l>"] = "actions.refresh",
-- 		["-"] = "actions.parent",
-- 		["_"] = "actions.open_cwd",
-- 		["`"] = "actions.cd",
-- 		["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
-- 		["gs"] = "actions.change_sort",
-- 		["gx"] = "actions.open_external",
-- 		["g."] = "actions.toggle_hidden",
-- 		["g\\"] = "actions.toggle_trash",
-- 	},
-- 	-- Set to false to disable all of the above keymaps
-- 	use_default_keymaps = true,
-- 	view_options = {
-- 		-- Show files and directories that start with "."
-- 		show_hidden = false,
-- 		-- This function defines what is considered a "hidden" file
-- 		is_hidden_file = function(name, bufnr)
-- 			local dir = require("oil").get_current_dir(bufnr)
-- 			local is_dotfile = vim.startswith(name, ".") and name ~= ".."
-- 			-- if no local directory (e.g. for ssh connections), just hide dotfiles
-- 			if not dir then
-- 				return is_dotfile
-- 			end
-- 			-- dotfiles are considered hidden unless tracked
-- 			if is_dotfile then
-- 				return not git_status[dir].tracked[name]
-- 			else
-- 				-- Check if file is gitignored
-- 				return git_status[dir].ignored[name]
-- 			end
-- 		end,
-- 		-- This function defines what will never be shown, even when `show_hidden` is set
-- 		is_always_hidden = function(name, bufnr)
-- 			return false
-- 		end,
-- 		-- Sort file names in a more intuitive order for humans. Is less performant,
-- 		-- so you may want to set to false if you work with large directories.
-- 		natural_order = true,
-- 		-- Sort file and directory names case insensitive
-- 		case_insensitive = false,
-- 		sort = {
-- 			-- sort order can be "asc" or "desc"
-- 			-- see :help oil-columns to see which columns are sortable
-- 			{ "type", "asc" },
-- 			{ "name", "asc" },
-- 		},
-- 	},
-- 	-- Extra arguments to pass to SCP when moving/copying files over SSH
-- 	extra_scp_args = {},
-- 	-- EXPERIMENTAL support for performing file operations with git
-- 	git = {
-- 		-- Return true to automatically git add/mv/rm files
-- 		add = function(path)
-- 			return false
-- 		end,
-- 		mv = function(src_path, dest_path)
-- 			return false
-- 		end,
-- 		rm = function(path)
-- 			return false
-- 		end,
-- 	},
-- 	-- Configuration for the floating window in oil.open_float
-- 	float = {
-- 		-- Padding around the floating window
-- 		padding = 2,
-- 		max_width = 0,
-- 		max_height = 0,
-- 		border = "rounded",
-- 		win_options = {
-- 			winblend = 0,
-- 		},
-- 		-- preview_split: Split direction: "auto", "left", "right", "above", "below".
-- 		preview_split = "auto",
-- 		-- This is the config that will be passed to nvim_open_win.
-- 		-- Change values here to customize the layout
-- 		override = function(conf)
-- 			return conf
-- 		end,
-- 	},
-- 	-- Configuration for the actions floating preview window
-- 	preview = {
-- 		-- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
-- 		-- min_width and max_width can be a single value or a list of mixed integer/float types.
-- 		-- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
-- 		max_width = 0.9,
-- 		-- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
-- 		min_width = { 40, 0.4 },
-- 		-- optionally define an integer/float for the exact width of the preview window
-- 		width = nil,
-- 		-- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
-- 		-- min_height and max_height can be a single value or a list of mixed integer/float types.
-- 		-- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
-- 		max_height = 0.9,
-- 		-- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
-- 		min_height = { 5, 0.1 },
-- 		-- optionally define an integer/float for the exact height of the preview window
-- 		height = nil,
-- 		border = "rounded",
-- 		win_options = {
-- 			winblend = 0,
-- 		},
-- 		-- Whether the preview window is automatically updated when the cursor is moved
-- 		update_on_cursor_moved = true,
-- 	},
-- 	-- Configuration for the floating progress window
-- 	progress = {
-- 		max_width = 0.9,
-- 		min_width = { 40, 0.4 },
-- 		width = nil,
-- 		max_height = { 10, 0.9 },
-- 		min_height = { 5, 0.1 },
-- 		height = nil,
-- 		border = "rounded",
-- 		minimized_border = "none",
-- 		win_options = {
-- 			winblend = 0,
-- 		},
-- 	},
-- 	-- Configuration for the floating SSH window
-- 	ssh = {
-- 		border = "rounded",
-- 	},
-- 	-- Configuration for the floating keymaps help window
-- 	keymaps_help = {
-- 		border = "rounded",
-- 	},
-- })

-- The setup config table shows all available config options with their default values:
require("neocord").setup({
	-- General options
	logo = "auto", -- "auto" or url
	logo_tooltip = "NeoVim >>>>>> VSC", -- nil or string
	main_image = "language", -- "language" or "logo"
	--client_id           = "1157438221865717891",      -- Use your own Discord application client id (not recommended)
	log_level = "info", -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
	debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
	blacklist = {}, -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
	file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
	show_time = true, -- Show the timer
	global_timer = false, -- if set true, timer won't update when any event are triggered

	-- Rich Presence text options
	editing_text = "Editing %s", -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
	file_explorer_text = "Browsing %s", -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
	git_commit_text = "Committing changes", -- Format string rendered when committing changes in git (either string or function(filename: string): string)
	plugin_manager_text = "Managing plugins", -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
	reading_text = "Reading %s", -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
	workspace_text = "Working on %s", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
	line_number_text = "Line %s out of %s", -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
	terminal_text = "Using Terminal", -- Format string rendered when in terminal mode.
})

local VIEW_WIDTH_FIXED = 35
local view_width_max = VIEW_WIDTH_FIXED

local function toggle_width_adaptive()
	if view_width_max == -1 then
		view_width_max = VIEW_WIDTH_FIXED
	else
		view_width_max = -1
	end
end

local function get_view_width_max()
	return view_width_max
end
map("n", "A", toggle_width_adaptive, "Toggle Adaptive Width")
local function on_attach(bufnr)
	local api = require("nvim-tree.api")
	local FloatPreview = require("float-preview")
	local opts = { buffer = bufnr }
	api.config.mappings.default_on_attach(bufnr)
	-- function for left to assign to keybindings
	local lefty = function()
		local node_at_cursor = api.tree.get_node_under_cursor()
		-- if it's a node and it's open, close
		if node_at_cursor.nodes and node_at_cursor.open then
			api.node.open.edit()
		-- else left jumps up to parent
		else
			api.node.navigate.parent()
		end
	end
	-- function for right to assign to keybindings
	local righty = function()
		local node_at_cursor = api.tree.get_node_under_cursor()
		-- if it's a closed node, open it
		if node_at_cursor.nodes and not node_at_cursor.open then
			api.node.open.edit()
		end
	end
	vim.keymap.set("n", "h", lefty, opts)
	vim.keymap.set("n", "<Left>", lefty, opts)
	vim.keymap.set("n", "<Right>", righty, opts)
	vim.keymap.set("n", "l", righty, opts)

	FloatPreview.attach_nvimtree(bufnr)
end

require("nvim-tree").setup({
	view = {
		width = {
			min = 30,
			max = get_view_width_max,
		},
	},
	actions = {
		open_file = {
			resize_window = false, -- don't resize window when opening file
		},
	},
	on_attach = on_attach,
})

local view = require("nvim-tree.view")
local api = require("nvim-tree.api")
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- save nvim-tree window width on WinResized event
augroup("save_nvim_tree_width", { clear = true })
autocmd("WinResized", {
	group = "save_nvim_tree_width",
	pattern = "*",
	callback = function()
		local filetree_winnr = view.get_winnr()
		if filetree_winnr ~= nil and vim.tbl_contains(vim.v.event["windows"], filetree_winnr) then
			vim.t["filetree_width"] = vim.api.nvim_win_get_width(filetree_winnr)
		end
	end,
})

-- restore window size when openning nvim-tree
api.events.subscribe(api.events.Event.TreeOpen, function()
	if vim.t["filetree_width"] ~= nil then
		view.resize(vim.t["filetree_width"])
	end
end)

--- Automatically open a file upon creation
api.events.subscribe(api.events.Event.FileCreated, function(file)
	vim.cmd("edit " .. vim.fn.fnameescape(file.fname))
end)

vim.keymap.set("n", "<leader>e", function()
	api.tree.find_file({ open = true, focus = true })
end)

autocmd({ "BufEnter", "QuitPre" }, {
	nested = false,
	callback = function(e)
		local tree = require("nvim-tree.api").tree

		-- Nothing to do if tree is not opened
		if not tree.is_visible() then
			return
		end

		-- How many focusable windows do we have? (excluding e.g. incline status window)
		local winCount = 0
		for _, winId in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_get_config(winId).focusable then
				winCount = winCount + 1
			end
		end

		-- We want to quit and only one window besides tree is left
		if e.event == "QuitPre" and winCount == 2 then
			vim.api.nvim_cmd({ cmd = "qall" }, {})
		end

		-- :bd was probably issued an only tree window is left
		-- Behave as if tree was closed (see `:h :bd`)
		if e.event == "BufEnter" and winCount == 1 then
			-- Required to avoid "Vim:E444: Cannot close last window"
			vim.defer_fn(function()
				-- close nvim-tree: will go to the last buffer used before closing
				tree.toggle({ find_file = true, focus = true })
				-- re-open nivm-tree
				tree.toggle({ find_file = true, focus = false })
			end, 10)
		end
	end,
})
