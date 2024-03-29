-- Nicer filetree than NetRW
return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim",
			"mrbjarksen/neo-tree-diagnostics.nvim"
		},
		config = function()
			-- If you want icons for diagnostic errors, you'll need to define them somewhere:
			vim.fn.sign_define("DiagnosticSignError",
				{ text = " ", texthl = "DiagnosticSignError" })
			vim.fn.sign_define("DiagnosticSignWarn",
				{ text = " ", texthl = "DiagnosticSignWarn" })
			vim.fn.sign_define("DiagnosticSignInfo",
				{ text = " ", texthl = "DiagnosticSignInfo" })
			vim.fn.sign_define("DiagnosticSignHint",
				{ text = "󰌵", texthl = "DiagnosticSignHint" })

			local function getTelescopeOpts(state, path)
				return {
					cwd = path,
					search_dirs = { path },
					attach_mappings = function(prompt_bufnr, map)
						local actions = require "telescope.actions"
						actions.select_default:replace(function()
							actions.close(prompt_bufnr)
							local action_state = require "telescope.actions.state"
							local selection = action_state.get_selected_entry()
							local filename = selection.filename
							if (filename == nil) then
								filename = selection[1]
							end
							-- any way to open the file without triggering auto-close event of neo-tree?
							require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
						end)
						return true
					end
				}
			end

			local icons = require("helpers.icons")

			require("neo-tree").setup({
				sources = {
					"filesystem",
					"buffers",
					"git_status",
					"diagnostics",
					-- "document_symbols",
				},
				add_blank_line_at_top = true, -- Add a blank line at the top of the tree.
				close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
				popup_border_style = "rounded",
				enable_git_status = true,
				enable_diagnostics = true,
				enable_modified_markers = true,                                -- Show markers for files with unsaved changes.
				enable_opened_markers = true,                                  -- Enable tracking of opened files. Required for `components.name.highlight_opened_files`
				enable_refresh_on_write = true,                                -- Refresh the tree when a file is written. Only used if `use_libuv_file_watcher` is false.
				neo_tree_popup_input_ready = true,
				enable_normal_mode_for_inputs = false,                         -- Enable normal mode for input dialogs.
				open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" }, -- when opening files, do not use windows containing these filetypes or buftypes
				sort_case_insensitive = true,                                  -- used when sorting files and directories in the tree
				default_component_configs = {
					container = {
						enable_character_fade = true
					},
					indent = {
						indent_size = 2,
						padding = 1, -- extra padding on left hand side
						-- indent guides
						with_markers = true,
						indent_marker = "│",
						last_indent_marker = "└",
						highlight = "NeoTreeIndentMarker",
						-- expander config, needed for nesting files
						with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
						expander_collapsed = icons.ui.Folder,
						expander_expanded = icons.ui.FolderOpen,
						expander_highlight = "NeoTreeExpander",
					},
					icon = {
						folder_closed = icons.ui.Folder,
						folder_open = icons.ui.FolderOpen,
						folder_empty = icons.ui.EmptyFolder,
						folder_empty_open = icons.ui.EmptyFolderOpen,
						-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
						-- then these will never be used.
						default = "*",
						highlight = "NeoTreeFileIcon"
					},
					modified = {
						symbol = icons.ui.Plus,
						highlight = "NeoTreeModified",
					},
					name = {
						trailing_slash = false,
						highlight_opened_files = true,
						use_git_status_colors = true,
						highlight = "NeoTreeFileName",
					},
					git_status = {
						symbols = {
							-- Change type
							--added     = icons.git.LineAdded, -- or "✚", but this is redundant info if you use git_status_colors on the name
							--modified  = icons.git.FileModified, -- or "", but this is redundant info if you use git_status_colors on the name
							deleted   = icons.git.FileDeleted, -- this can only be used in the git_status source
							renamed   = icons.git.FileRenamed, -- this can only be used in the git_status source
							-- Status type
							untracked = icons.git.FileUntracked,
							ignored   = icons.git.FileIgnored,
							unstaged  = icons.git.FileUnstaged,
							staged    = icons.git.FileStaged,
							conflict  = icons.git.Conflict,
						},
						align = "right",
					},
					-- If you don't want to use these columns, you can set `enabled = false` for each of them individually
					file_size = {
						enabled = true,
						required_width = 40, -- min width of window required to show this column
					},
					type = {
						enabled = false,
						required_width = 45, -- min width of window required to show this column
					},
					last_modified = {
						enabled = false,
						required_width = 60, -- min width of window required to show this column
					},
					created = {
						enabled = false,
						required_width = 60, -- min width of window required to show this column
					},
					symlink_target = {
						enabled = false,
					},
				},
				-- A list of functions, each representing a global custom command
				-- that will be available in all sources (if not overridden in `opts[source_name].commands`)
				-- see `:h neo-tree-custom-commands-global`
				commands = {
					system_open = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						-- Without removing the file from the path, it opens in code.exe instead of explorer.exe
						local p
						local lastSlashIndex = path:match("^.+()\\[^\\]*$") -- Match the last slash and everything before it
						if lastSlashIndex then
							p = path:sub(1, lastSlashIndex - 1) -- Extract substring before the last slash
						else
							p = path                      -- If no slash found, return original path
						end
						vim.cmd("silent !start explorer " .. p)
					end,
					telescope_find = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						require('telescope.builtin').find_files(getTelescopeOpts(state, path))
					end,
					telescope_grep = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						require('telescope.builtin').live_grep(getTelescopeOpts(state, path))
					end,
				},
				window = {
					position = "left",
					width = 45,
					mapping_options = {
						noremap = true,
						nowait = true,
					},
					mappings = {
						["<space>"] = {
							"toggle_node",
							nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
						},
						["<2-LeftMouse>"] = "open",
						["<cr>"] = "open",
						["<esc>"] = "cancel", -- close preview or floating neo-tree window
						["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
						-- Read `# Preview Mode` for more information
						["l"] = "focus_preview",
						["S"] = "open_split",
						["s"] = "open_vsplit",
						["t"] = "open_tabnew",
						["w"] = "open_with_window_picker",
						["C"] = "close_node",
						["z"] = "close_all_nodes",
						["a"] = {
							"add",
							-- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
							-- some commands may take optional config options, see `:h neo-tree-mappings` for details
							config = {
								show_path = "none" -- "none", "relative", "absolute"
							}
						},
						["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
						["d"] = "delete",
						["r"] = "rename",
						["y"] = "copy_to_clipboard",
						["x"] = "cut_to_clipboard",
						["p"] = "paste_from_clipboard",
						["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
						-- ["c"] = {
						--  "copy",
						--  config = {
						--    show_path = "none" -- "none", "relative", "absolute"
						--  }
						--}
						["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
						["q"] = "close_window",
						["R"] = "refresh",
						["?"] = "show_help",
						["<"] = "prev_source",
						[">"] = "next_source",
						["i"] = "show_file_details",
						["e"] = "toggle_auto_expand_width",
					}
				},
				nesting_rules = {},
				filesystem = {
					filtered_items = {
						visible = true, -- when true, they will just be displayed differently than normal items
						hide_dotfiles = false,
						hide_gitignored = false,
						hide_hidden = false, -- only works on Windows for hidden files/directories
						hide_by_name = {
							"node_modules"
						},
						hide_by_pattern = { -- uses glob style patterns
							--"*.meta",
							--"*/src/*/tsconfig.json",
						},
						always_show = { -- remains visible even if other settings would normally hide it
							".gitignored",
						},
						never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
							".DS_Store",
							"thumbs.db",
							".git",
						},
						never_show_by_pattern = { -- uses glob style patterns
							--".null-ls_*",
						},
					},
					follow_current_file = {
						enabled = true,      -- This will find and focus the file in the active buffer every time
						--               -- the current file is changed while the tree is open.
						leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
					},
					group_empty_dirs = false, -- when true, empty folders will be grouped together
					hijack_netrw_behavior = "open_current", -- netrw disabled, opening a directory opens neo-tree
					-- in whatever position is specified in window.position
					-- "open_current",  -- netrw disabled, opening a directory opens within the
					-- window like netrw would, regardless of window.position
					-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
					use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
					-- instead of relying on nvim autocmd events.
					window = {
						mappings = {
							["<bs>"] = "navigate_up",
							["."] = "set_root",
							["H"] = "toggle_hidden",
							["/"] = "fuzzy_finder",
							["D"] = "fuzzy_finder_directory",
							["#"] = "fuzzy_sorter",
							["f"] = "filter_on_submit",
							["<c-x>"] = "clear_filter",
							["[g"] = "prev_git_modified",
							["]g"] = "next_git_modified",
							["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
							["oc"] = { "order_by_created", nowait = false },
							["od"] = { "order_by_diagnostics", nowait = false },
							["og"] = { "order_by_git_status", nowait = false },
							["om"] = { "order_by_modified", nowait = false },
							["on"] = { "order_by_name", nowait = false },
							["os"] = { "order_by_size", nowait = false },
							["ot"] = { "order_by_type", nowait = false },
							["O"] = "system_open",
							["tf"] = "telescope_find",
							["tg"] = "telescope_grep",
						},
						fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
							["<down>"] = "move_cursor_down",
							["<C-n>"] = "move_cursor_down",
							["<up>"] = "move_cursor_up",
							["<C-p>"] = "move_cursor_up",
						},
					},

					commands = {} -- Add a custom command or override a global one using the same function name
				},
				buffers = {
					follow_current_file = {
						enabled = false, -- This will find and focus the file in the active buffer every time
						--              -- the current file is changed while the tree is open.
						leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
					},
					group_empty_dirs = true, -- when true, empty folders will be grouped together
					show_unloaded = true,
					window = {
						mappings = {
							["bd"] = "buffer_delete",
							["<bs>"] = "navigate_up",
							["."] = "set_root",
							["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
						}
					},
				},
				git_status = {
					window = {
						position = "float",
						mappings = {
							["A"]  = "git_add_all",
							["gu"] = "git_unstage_file",
							["ga"] = "git_add_file",
							["gr"] = "git_revert_file",
							["gc"] = "git_commit",
							["gp"] = "git_push",
							["gg"] = "git_commit_and_push",
							["o"]  = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
						}
					}
				},
				source_selector = {
					winbar = true,
					statusline = true
				},
				diagnostics = {
					components = {
						linenr = function(config, node)
							local lnum = tostring(node.extra.diag_struct.lnum + 1)
							local pad = string.rep(" ", 4 - #lnum)
							return {
								{
									text = pad .. lnum,
									highlight = "LineNr",
								},
								{
									text = "▕ ",
									highlight = "NeoTreeDimText",
								}
							}
						end
					},
					renderers = {
						file = {
							{ "indent" },
							{ "icon" },
							{ "grouped_path" },
							{ "name",             highlight = "NeoTreeFileNameOpened" },
							{ "diagnostic_count", highlight = "NeoTreeDimText",       severity = "Error", right_padding = 0 },
							{ "diagnostic_count", highlight = "NeoTreeDimText",       severity = "Warn",  right_padding = 0 },
							{ "diagnostic_count", highlight = "NeoTreeDimText",       severity = "Info",  right_padding = 0 },
							{ "diagnostic_count", highlight = "NeoTreeDimText",       severity = "Hint",  right_padding = 0 },
							{ "clipboard" },
						},
						diagnostic = {
							{ "indent" },
							{ "icon" },
							{ "linenr" },
							{ "name" },
						},
					},
					auto_preview = {   -- May also be set to `true` or `false`
						enabled = false, -- Whether to automatically enable preview mode
						preview_config = {}, -- Config table to pass to auto preview (for example `{ use_float = true }`)
						event = "neo_tree_buffer_enter", -- The event to enable auto preview upon (for example `"neo_tree_window_after_open"`)
					},
					bind_to_cwd = true,
					diag_sort_function = "severity", -- "severity" means diagnostic items are sorted by severity in addition to their positions.
					-- "position" means diagnostic items are sorted strictly by their positions.
					-- May also be a function.
					follow_current_file = { -- May also be set to `true` or `false`
						enabled = true, -- This will find and focus the file in the active buffer every time
						always_focus_file = false, -- Focus the followed file, even when focus is currently on a diagnostic item belonging to that file
						expand_followed = true, -- Ensure the node of the followed file is expanded
						leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
						leave_files_open = false, -- `false` closes auto expanded files, such as with `:Neotree reveal`
					},
					group_dirs_and_files = true, -- when true, empty folders and files will be grouped together
					group_empty_dirs = true, -- when true, empty directories will be grouped together
					show_unloaded = true, -- show diagnostics from unloaded buffers
					refresh = {
						delay = 100,    -- Time (in ms) to wait before updating diagnostics. Might resolve some issues with Neovim hanging.
						event = "vim_diagnostic_changed", -- Event to use for updating diagnostics (for example `"neo_tree_buffer_enter"`)
						-- Set to `false` or `"none"` to disable automatic refreshing
						max_items = 10000, -- The maximum number of diagnostic items to attempt processing
						-- Set to `false` for no maximum
					},
				},
			})

			vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
		end,
	},
}
