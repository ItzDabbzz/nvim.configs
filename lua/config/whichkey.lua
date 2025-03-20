local wk = require("which-key")
local icons = require("utils.icons")
wk.setup({
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings
		-- add to the list of user presets
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = false, -- adds help for motions
			text_objects = false, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	operators = {
		gc = "Comments",
		d = "Delete",
		c = "Change",
		y = "Yank",
		["g~"] = "Toggle Case",
		["gu"] = "Lowercase",
		["gU"] = "Uppercase",
		["zf"] = "Create Fold",
		["!"] = "Filter Through External Program",
		["v"] = "Visual Character Mode",
	},
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = icons.ui.DoubleChevronRight,
		separator = icons.ui.BoldArrowRight,
		group = icons.ui.Plus,
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "single", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	show_keys = true, -- show the currently pressed key and its label as a message in the command line
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
	-- disable the WhichKey popup for certain buf types and file types.
	-- Disabled by default for Telescope
	disable = {
		buftypes = {},
		filetypes = { "TelescopePrompt" },
	},
})
local buffers = require("utils.buffers")
local dap = require("dap")
local ui = require("dapui")
local function dap_start_debugging()
	dap.continue({})
	vim.cmd("tabedit %")
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>", false, true, true), "n", false)
	ui.toggle({})
end
local function dap_clear_breakpoints()
	dap.clear_breakpoints()
	require("notify")("Breakpoints cleared", "warn")
end
local function dap_end_debug()
	dap.clear_breakpoints()
	ui.toggle({})
	dap.terminate({}, { terminateDebuggee = true }, function()
		vim.cmd.bd()
		f.resize_vertical_splits()
		require("notify")("Debugger session ended", "warn")
	end)
end
function find_directory_and_focus()
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local function open_nvim_tree(prompt_bufnr, _)
		actions.select_default:replace(function()
			local api = require("nvim-tree.api")

			actions.close(prompt_bufnr)
			local selection = action_state.get_selected_entry()
			api.tree.open()
			api.tree.find_file(selection.cwd .. "/" .. selection.value)
		end)
		return true
	end

	require("telescope.builtin").find_files({
		find_command = { "fd", "--type", "directory", "--hidden", "--exclude", ".git/*" },
		attach_mappings = open_nvim_tree,
	})
end
local tm = require("utils.termmanager")
local tu = require("utils.treeutils")
wk.register({
	["<leader>"] = {
		h = {
			a = { "Harboon List Add" },
			o = { "Harboon List Open" },
			["1"] = { "Harboon List 1" },
			["2"] = { "Harboon List 2" },
			["3"] = { "Harboon List 3" },
			["4"] = { "Harboon List 4" },
			["5"] = { "Harboon List 5" },
		},
		d = {
			name = "Dap",
			t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
			b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
			c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
			C = { dap_clear_breakpoints, "Clear Breakpoints" },
			R = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
			d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
			g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
			i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
			I = { "<CMD>lua require'dap.ui.widgets' .hover()<CR>", "Info" },
			o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
			u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
			p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
			r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
			s = { dap_start_debugging, "Start" },
			q = { dap_end_debug, "Quit" },
			U = { "<cmd>lua require'dapui'.toggle({reset = true})<cr>", "Toggle UI" },
		},
		b = {
			name = "Delete/Close/Buffers",
			a = { buffers.delete_this, "Current buffer" },
			o = { buffers.delete_others, "Other buffers" },
			d = { buffers.delete_all, "All buffers" },
			w = { "<CMD>close<CR>", "Window" },
		},
		f = {
			name = "Files",
			w = { "<CMD>w<CR>", "Write" },
			W = { "<CMD>wa<CR>", "Write all" },
			f = { tu.launch_find_files, "Find Files" },
			F = { tu.launch_live_grep, "Live Grep Files" },
			g = { find_directory_and_focus, "Find Directory And Focus" },
		},
		g = {
			name = "Git",
			a = { "<CMD>git add %<CR>", "Stage the current file" },
			B = { "<CMD>Git blame<CR>", "Git Blame" },
			b = { "<CMD>Telescope git_branches<CR>", "Git Branches" },
			c = { "<CMD>Telescope git_commits<CR>", "Git Commits (Repository)" },
			C = { "<CMD>Telescope git_bcommits<CR>", "Git Commits (Current File)" },
			S = { "<CMD>Telescope git_status<CR>", "Git Status" },
			z = {
				name = "Git-Conflict.nvim",
				o = { "<Plug>(git-conflict-ours)", "Ours" },
				t = { "<Plug>(git-conflict-theirs)", "Theirs" },
				b = { "<Plug>(git-conflict-both)", "Both" },
				n = { "<Plug>(git-conflict-next-conflict)", "Next Conflict" },
				p = { "<Plug>(git-conflict-prev-conflict)", "Prev Conflict" },
				l = { "<Plug>(git-conflict-none)", "None" },
			},
			p = { "<CMD>Git push<CR>", "Git Push" },
			s = {
				name = "Git-Signs",
				j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
				k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
				l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
				p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
				r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
				R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
				s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
				u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
				o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
				b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
				c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
				C = { "<cmd>Telescope git_bcommits<cr>", "Checkout commit(for current file)" },
				d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Git Diff" },
				z = { "<CMD>Gitsigns toggle_signs<CR>", "Toggle Signs" },
				h = { "<CMD>Gitsigns toggle_linehl<CR>", "Toggle Line Highlight" },
				H = { "<CMD>Gitsigns toggle_numhl<CR>", "Toggle Number Highlight" },
				x = { "<CMD>Gitsigns toggle_deleted<CR>", "Toggle Deleted" },
				t = { "<CMD>Gitsigns toggle_current_line_blame<CR>", "Toggle Count" },
				w = { "<CMD>Gitsigns toggle_word_diff<CR>", "Toggle Word Diff" },
			},
		},
		l = {
			name = "LSP",
			a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
			d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
			w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
			f = { "<cmd>lua require('lvim.lsp.utils').format()<cr>", "Format" },
			i = { "<cmd>LspInfo<cr>", "Info" },
			I = { "<cmd>Mason<cr>", "Mason Info" },
			j = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
			k = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
			l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
			o = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Open Float" },
			q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
			r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
			s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
			S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
			e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
		},
		p = {
			name = "Plugins",
			L = { "<CMD>Telescope lazy<CR>", "Installed Plugin List" },
			i = { "<cmd>Lazy install<cr>", "Install" },
			s = { "<cmd>Lazy sync<cr>", "Sync" },
			S = { "<cmd>Lazy clear<cr>", "Status" },
			c = { "<cmd>Lazy clean<cr>", "Clean" },
			u = { "<cmd>Lazy update<cr>", "Update" },
			p = { "<cmd>Lazy profile<cr>", "Profile" },
			l = { "<cmd>Lazy log<cr>", "Log" },
			d = { "<cmd>Lazy debug<cr>", "Debug" },
		},
		P = {
			name = "Projects",
			o = { [[:lua require("telescope").extensions.project.project{}<CR>]], "Open Projects" },
			b = { "<CMD>Telescope file_browser<CR>", "File Browser" },
			B = { "<CMD>Telescope file_browser path=%:p:h select_buffer=true<CR>", "Buffer File Browser" },
		},
		q = {
			name = "Quit",
			q = { "<CMD>q<CR>", "Quit" },
			a = { "<CMD>qa!<CR>", "Quit all" },
		},
		s = {
			name = "Search",
			["/"] = {
				function()
					-- You can pass additional configuration to telescope to change theme, layout, etc.
					require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
					}))
				end,
				"Current Buffer Search",
			},
			b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
			c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
			f = { "<cmd>Telescope find_files<cr>", "Find File" },
			h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
			H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
			M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
			r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
			R = { "<cmd>Telescope registers<cr>", "Registers" },
			t = { "<cmd>Telescope live_grep<cr>", "Text" },
			k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
			C = { "<cmd>Telescope commands<cr>", "Commands" },
			l = { "<cmd>Telescope resume<cr>", "Resume last search" },
			p = {
				"<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
				"Colorscheme with Preview",
			},
			e = { "<CMD>Telescope emoji<CR>", "Find Emojis" },
			L = { "<CMD>Telescope software-licenses find<CR>", "Software Licenses" },
			n = { "<CMD>Telescope notify<CR>", "Notifications" },
			u = { "<CMD>Telescope undo<CR>", "Telescope Undo" },
			y = { "<CMD>Telescope yank_history<CR>", "Telescope Yanky History" },
		},
		S = {
			name = "Snippets",
			a = {
				function()
					require("scissors").addNewSnippet()
				end,
				"Add New Snippet",
			},
			e = {
				function()
					require("scissors").editSnippet()
				end,
				"Edit Snippet",
			},
		},
		T = {
			f = { "<Cmd>ToggleTerm direction=float<CR>", "ToggleTerm float" },
			h = { "<Cmd>ToggleTerm size=10 direction=horizontal<CR>", "ToggleTerm horizontal split" },
			v = { "<Cmd>ToggleTerm size=80 direction=vertical<CR>", "ToggleTerm vertical split" },
			t = { '<Cmd>execute v:count . "ToggleTerm"<CR>', "Toggle Terminal" },
			n = {
				function()
					tm.toggle_term_cmd("node")
				end,
				"ToggleTerm Node",
			},
			p = {
				function()
					tm.toggle_term_cmd("python")
				end,
				"ToggleTerm Python",
			},
			g = {
				function()
					tm.toggle_term_cmd("gdu")
				end,
				"ToggleTerm GDU",
			},
			b = {
				function()
					tm.toggle_term_cmd("btm")
				end,
				"ToggleTerm Btm",
			},
		},
		t = {
			name = "Tools",
			F = {
				function()
					require("ufo").openAllfolds()
				end,
				"Open all folds",
			},
			C = {
				function()
					require("ufo").closeAllFolds()
				end,
				"Close all folds",
			},
			T = { ":TSConfigInfo<cr>", "Treesitter Info" },
			t = { "Toggle Horizontal Terminal" },
			v = { "Toggle Vertical Terminal" },
			f = { "Toggle Floating Terminal" },
			g = { "Toggle lazygit Terminal" },
			d = { "Toggle lazydocker Terminal" },
			c = {
				name = "ChatGPT",
				c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
				e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
				g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
				t = { "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
				k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
				d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
				a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
				o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
				s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
				f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
				x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
				r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
				l = {
					"<cmd>ChatGPTRun code_readability_analysis<CR>",
					"Code Readability Analysis",
					mode = { "n", "v" },
				},
			},
		},
		u = {
			name = "UI",
			h = { "<CMD>nohlsearch<CR>", "No highlight" },
			t = { "<CMD>UndotreeToggle<CR>", "Toggle undo tree" },
			-- e = { "<CMD>Oil<CR>", "Toggle Oil" },
			r = { "<CMD>NvimTreeOpen<CR>", "Open Nvim Tree" },
			m = {
				function()
					if vim.o.background == "dark" then
						vim.o.background = "light"
					else
						vim.o.background = "dark"
					end
				end,
				"Toggle light/dark mode",
			},
		},
		y = {
			y = { "<Plug>(YankyYank)", "Yanky Text", mode = { "n", "x" } },
			Y = { "<Plug>(YankyYank)$", "Yanky Text After Cursor", mode = { "n", "x" } },
			p = { "<Plug>(YankyPutAfter)", "Put Yanked Text After Cursor" },
			P = { "<Plug>(YankyPutBefore)", "Put Yanked Text Before Cursor" },
		},
	},
})
