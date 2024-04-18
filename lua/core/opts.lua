local function list(items, sep)
    return table.concat(items, sep or ",")
end

local opts = {
	-- automatically write file if changed
	autowrite = true,
	-- used for highlight colors
	background = "dark",
	-- keep backup file after overwriting a file
	backup = false,
	-- how backspace works at the start of a line
	backspace = "indent,eol,start",
	-- characters that may cause a line break
	breakat = [[\ \	;:,!?]],
	-- wrapped line repeats indent
	breakindent = true,
	-- number of lines to use for the command-line
	cmdheight = 1,
	-- height of the command-line window
	cmdwinheight = 5,
	-- columns to highlight
	colorcolumn = "110",
	-- specify how Insert mode completion works
	complete = ".,w,b,k",
	-- options for Insert mode completion
	completeopt = 'menu,menuone,noinsert,noselect',
	-- wheather concealable text is hidden in cursor line
	concealcursor = "niv",
	-- wheather conealable text is shown or hidden
	conceallevel = 2,
	-- highlight the screen line of the cursor
	cursorline = true,
	-- options for using diff mode
	diffopt = "filler,iwhite,internal,algorithm:patience",
	-- list of flags for how to display text
	display = "lastline",
	-- windows are automatically made the same size
	equalalways = false,
	-- file encoding for multibyte text
	fileencoding = "utf-8",
    -- options for 'filetype'
    fillchars = list {
        -- "vert:▏",
        "vert:│",
        "diff:╱",
        "foldclose:",
        "foldopen:",
        "fold: ",
        "msgsep:─",
    },
	-- set to display all folds open
	foldenable = true,
	-- close folds with a level higher than this
	foldlevel = 99,
	-- 'foldlevel' when starting to edit a file
	foldlevelstart = 99,
    -- 0 is not bad
    foldcolumn = '1',
	-- format of 'grepprg' output
	grepformat = "%f:%l:%m,%m\\ %f\\ match%ts,%f",
	-- program to use fro ":grep"
	grepprg = 'rg --hidden --vimgrep --smart-case --glob "!{.git,node_modules,*~}/*" --',
	-- minimum height of a new help window
	helpheight = 12,
	-- highlight matches with last search pattern
	hlsearch = false,
	-- number of lines to use for command history
	history = 4000,
	-- ignore case in search patterns
	ignorecase = true,
	-- highlight match while typing search pattern
	incsearch = true,
	-- adjust case of match for keyword completion
	infercase = true,
	-- ?
	inccommand = "nosplit",
	-- specifies how jumping is done
	jumpoptions = "stack",
	-- ?
	laststatus = 3,
	-- wrap long lines at a blank
	linebreak = true,
	-- show <Tabl> and <EOL>
	list = true,
	-- Characters for displaing in list mode
	listchars = "tab:┊ ,nbsp:+,trail:·,extends:→,precedes:←",
	-- enable the use of mouse clicks
	mouse = "a",
	-- change meaning of mouse buttons
	mousemodel = "extend",
	-- amount to scroll by when scrolling with a scroll wheel
	mousescroll = "ver:1,hor:3",
	-- print the line number in front of each line
	number = true,
	-- number of colums used for each line number
	numberwidth = 4,
	-- height of the preview window
	previewheight = 12,
	-- ?
	pumblend = 10,
	-- ?
	pumheight = 12,
	-- timeout for 'hlsearch' and :match highlighting
	redrawtime = 50,
	-- show realative line number in front of each line
	relativenumber = false,
	-- show cursor line and column in the status line
	ruler = false,
	-- options for :mksessions
	sessionoptions = "curdir,help,tabpages,winsize",
	--round indent to multiple of shiftwidth
	shiftround = true,
	-- number of spaces to use for (auto)indent step
	shiftwidth = 4,
	-- String to use at the start of wrapped lines
	showbreak = "󱞩",
	-- show (partial) command somwhere
	showcmd = true,
	-- where to show the command
	showcmdloc = "statusline",
	-- briefly jump to matching bracket if insert one
	showmatch = true,
	-- message on status line to show current mode
	showmode = false,
	-- tells when the tab pages line is displayed
	showtabline = 1,
	-- minimum number of columns to scroll horizontally
	sidescrolloff = 10,
	-- when and how to display the sign column
	signcolumn = 'yes',
	-- no ignore case when pattern has uppercase
	smartcase = true,
	-- smart autoindenting for C programs
	smartindent = true,
	-- new window from split is below the current one
	splitbelow = true,
	-- determines scroll behaviour for split windows
	splitkeep = "screen",
	-- new window is put right of the current one
	splitright = true,
	-- commands move cursor to first non-blank in line
	startofline = false,
	-- number of spaces that <Tab> in file uses
	tabstop = 4,
	-- 
	termguicolors = true,
	-- max width of text that is being inserted
	textwidth = 160,
	-- time out on mappins and keycodes
	timeout = true,
	-- time out time in milliseconds
	timeoutlen = 500,
	-- let vim set window title
	title = true,
	-- 
	ttyfast = true,
	-- save undo info in a file
	undofile = true,
	-- after this many milliseconds flush swap file
	updatetime = 250,
	-- specifies what to save for :mkview
	viewoptions = "folds,cursor,curdir,slash,unix",
	-- allows specified keys to cross line boundaries
	whichwrap = "h,l,<,>,[,],~",
	-- files matching these patterns are not completed
	wildignore = ".git/**,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**",
	-- ignore case when completing file names and directories
	wildignorecase = true,
	-- mode for 'wildchar' command-line expansion
	wildmode = "longest:full,full",
	-- ?
	--winblend = 10,
	-- min number of columns for any window
	winminwidth = 10,
	-- min number of columns for current window
	winwidth = 30,
	-- long lines wrap and continue on the next line
	wrap = false,
	-- searches wrap around the end of the file
	wrapscan = true,
	-- make a backup before overwriting a file
	writebackup = false
}

-- Set options from table
for opt, val in pairs(opts) do
	vim.opt[opt] = val
end


vim.opt.guicursor:append("a:blinkwait100-blinkoff700-blinkon700")
vim.cmd([[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]])

-- Set other options
local colorscheme = require("helpers.colorscheme")
vim.cmd.colorscheme(colorscheme)

vim.diagnostic.config({
    update_in_insert = false
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