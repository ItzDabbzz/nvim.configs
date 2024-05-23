local data = "C:\\Users\\Davin\\AppData\\Local\\nvim-data" --[[@as string]]
local utils = require("helpers.utils")
local icons = require("helpers.icons")
local actions = require("telescope.actions")
local z_utils = require("telescope._extensions.zoxide.utils")

local previewers = require("telescope.previewers")
local Job = require("plenary.job")
local new_maker = function(filepath, bufnr, opts)
	filepath = vim.fn.expand(filepath)
	Job:new({
		command = "file",
		args = { "--mime-type", "-b", filepath },
		on_exit = function(j)
			local mime_type = vim.split(j:result()[1], "/")[1]
			if mime_type == "text" then
				previewers.buffer_previewer_maker(filepath, bufnr, opts)
			else
				-- maybe we want to write something to the buffer here
				vim.schedule(function()
					vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
				end)
			end
		end,
	}):sync()
end

local Layout = require("nui.layout")
local Popup = require("nui.popup")

local telescope = require("telescope")
local TSLayout = require("telescope.pickers.layout")

local function make_popup(options)
	local popup = Popup(options)
	function popup.border:change_title(title)
		popup.border.set_text(popup.border, "top", title)
	end
	return TSLayout.Window(popup)
end

telescope.setup({
	defaults = {
		prompt_prefix = icons.ui.Telescope .. " ",
		selection_caret = icons.ui.Forward .. " ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		history = false,
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
			"--glob=!.git/",
		},
		preview = {
			mime_hook = function(filepath, bufnr, opts)
				local is_image = function(filepath)
					local image_extensions = { "png", "jpg" } -- Supported image formats
					local split_path = vim.split(filepath:lower(), ".", { plain = true })
					local extension = split_path[#split_path]
					return vim.tbl_contains(image_extensions, extension)
				end
				if is_image(filepath) then
					local term = vim.api.nvim_open_term(bufnr, {})
					local function send_output(_, data, _)
						for _, d in ipairs(data) do
							vim.api.nvim_chan_send(term, d .. "\r\n")
						end
					end
					vim.fn.jobstart({
						"catimg",
						filepath, -- Terminal image viewer command
					}, { on_stdout = send_output, stdout_buffered = true, pty = true })
				else
					require("telescope.previewers.utils").set_preview_message(
						bufnr,
						opts.winid,
						"Binary cannot be previewed"
					)
				end
			end,
		},
		mappings = {
			i = {
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-c>"] = actions.close,
				["<C-j>"] = actions.cycle_history_next,
				["<C-k>"] = actions.cycle_history_prev,
				["<C-q>"] = function(...)
					actions.smart_send_to_qflist(...)
					actions.open_qflist(...)
				end,
				["<CR>"] = actions.select_default,
			},
			n = {
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-q>"] = function(...)
					actions.smart_send_to_qflist(...)
					actions.open_qflist(...)
				end,
			},
		},
		file_ignore_patterns = {},
		path_display = { "smart" },
		winblend = 0,
		border = {},
		color_devicons = true,
		set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
		-- buffer_previewer_maker = new_maker,
		layout_strategy = "flex",
		layout_config = {
			horizontal = {
				size = {
					width = "90%",
					height = "60%",
				},
			},
			vertical = {
				size = {
					width = "90%",
					height = "90%",
				},
			},
		},
		create_layout = function(picker)
			local border = {
				results = {
					top_left = "┌",
					top = "─",
					top_right = "┬",
					right = "│",
					bottom_right = "",
					bottom = "",
					bottom_left = "",
					left = "│",
				},
				results_patch = {
					minimal = {
						top_left = "┌",
						top_right = "┐",
					},
					horizontal = {
						top_left = "┌",
						top_right = "┬",
					},
					vertical = {
						top_left = "├",
						top_right = "┤",
					},
				},
				prompt = {
					top_left = "├",
					top = "─",
					top_right = "┤",
					right = "│",
					bottom_right = "┘",
					bottom = "─",
					bottom_left = "└",
					left = "│",
				},
				prompt_patch = {
					minimal = {
						bottom_right = "┘",
					},
					horizontal = {
						bottom_right = "┴",
					},
					vertical = {
						bottom_right = "┘",
					},
				},
				preview = {
					top_left = "┌",
					top = "─",
					top_right = "┐",
					right = "│",
					bottom_right = "┘",
					bottom = "─",
					bottom_left = "└",
					left = "│",
				},
				preview_patch = {
					minimal = {},
					horizontal = {
						bottom = "─",
						bottom_left = "",
						bottom_right = "┘",
						left = "",
						top_left = "",
					},
					vertical = {
						bottom = "",
						bottom_left = "",
						bottom_right = "",
						left = "│",
						top_left = "┌",
					},
				},
			}

			local results = make_popup({
				focusable = false,
				border = {
					style = border.results,
					text = {
						top = picker.results_title,
						top_align = "center",
					},
				},
				win_options = {
					winhighlight = "Normal:Normal",
				},
			})

			local prompt = make_popup({
				enter = true,
				border = {
					style = border.prompt,
					text = {
						top = picker.prompt_title,
						top_align = "center",
					},
				},
				win_options = {
					winhighlight = "Normal:Normal",
				},
			})

			local preview = make_popup({
				focusable = false,
				border = {
					style = border.preview,
					text = {
						top = picker.preview_title,
						top_align = "center",
					},
				},
			})

			local box_by_kind = {
				vertical = Layout.Box({
					Layout.Box(preview, { grow = 1 }),
					Layout.Box(results, { grow = 1 }),
					Layout.Box(prompt, { size = 3 }),
				}, { dir = "col" }),
				horizontal = Layout.Box({
					Layout.Box({
						Layout.Box(results, { grow = 1 }),
						Layout.Box(prompt, { size = 3 }),
					}, { dir = "col", size = "50%" }),
					Layout.Box(preview, { size = "50%" }),
				}, { dir = "row" }),
				minimal = Layout.Box({
					Layout.Box(results, { grow = 1 }),
					Layout.Box(prompt, { size = 3 }),
				}, { dir = "col" }),
			}

			local function get_box()
				local strategy = picker.layout_strategy
				if strategy == "vertical" or strategy == "horizontal" then
					return box_by_kind[strategy], strategy
				end

				local height, width = vim.o.lines, vim.o.columns
				local box_kind = "horizontal"
				if width < 100 then
					box_kind = "vertical"
					if height < 40 then
						box_kind = "minimal"
					end
				end
				return box_by_kind[box_kind], box_kind
			end

			local function prepare_layout_parts(layout, box_type)
				layout.results = results
				results.border:set_style(border.results_patch[box_type])

				layout.prompt = prompt
				prompt.border:set_style(border.prompt_patch[box_type])

				if box_type == "minimal" then
					layout.preview = nil
				else
					layout.preview = preview
					preview.border:set_style(border.preview_patch[box_type])
				end
			end

			local function get_layout_size(box_kind)
				return picker.layout_config[box_kind == "minimal" and "vertical" or box_kind].size
			end

			local box, box_kind = get_box()
			local layout = Layout({
				relative = "editor",
				position = "50%",
				size = get_layout_size(box_kind),
			}, box)

			layout.picker = picker
			prepare_layout_parts(layout, box_kind)

			local layout_update = layout.update
			function layout:update()
				local box, box_kind = get_box()
				prepare_layout_parts(layout, box_kind)
				layout_update(self, { size = get_layout_size(box_kind) }, box)
			end

			return TSLayout(layout)
		end,
	},
	pickers = {
		find_files = {
			hidden = true,
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
		live_grep = {
			--@usage don't include the filename in the search results
			only_sort_text = true,
		},
		grep_string = {
			only_sort_text = true,
		},
		buffers = {
			initial_mode = "normal",
			mappings = {
				i = {
					["<C-d>"] = actions.delete_buffer,
				},
				n = {
					["dd"] = actions.delete_buffer,
				},
			},
		},
		planets = {
			show_pluto = true,
			show_moon = true,
		},
		git_files = {
			hidden = true,
			show_untracked = true,
		},
		colorscheme = {
			enable_preview = true,
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		glyph = {
			action = function(glyph)
				vim.fn.setreg("*", glyph.value)
				print([[Press p or "*p to paste this glyph]] .. glyph.value)
			end,
		},
		zoxide = {
			prompt_title = "[ Zoxide List ]",

			-- Zoxide list command with score
			list_command = "zoxide query -ls",
			mappings = {
				default = {
					action = function(selection)
						vim.cmd.edit(selection.path)
					end,
					after_action = function(selection)
						print("Directory changed to " .. selection.path)
					end,
				},
				["<C-s>"] = { action = z_utils.create_basic_command("split") },
				["<C-v>"] = { action = z_utils.create_basic_command("vsplit") },
				["<C-e>"] = { action = z_utils.create_basic_command("edit") },
				["<C-b>"] = {
					keepinsert = true,
					action = function(selection)
						builtin.file_browser({ cwd = selection.path })
					end,
				},
				["<C-f>"] = {
					keepinsert = true,
					action = function(selection)
						builtin.find_files({ cwd = selection.path })
					end,
				},
				["<C-t>"] = {
					action = function(selection)
						vim.cmd.tcd(selection.path)
					end,
				},
			},
		},
		wrap_results = true,
	},
})

pcall(require("telescope").load_extension, "fzf")
-- pcall(require("telescope").load_extension, "smart_history")
pcall(require("telescope").load_extension("luasnip"))
pcall(require("telescope").load_extension("yank_history"))
pcall(require("telescope").load_extension("glyph"))
pcall(require("telescope").load_extension("dap"))
pcall(require("telescope").load_extension("i23"))
pcall(require("telescope").load_extension("zoxide"))
pcall(require("telescope").load_extension("ui-select"))
pcall(require("telescope").load_extension("repo"))
pcall(require("telescope").load_extension("docker"))
pcall(require("telescope").load_extension("project"))
pcall(require("telescope").load_extension("file_browser"))
pcall(require("telescope").load_extension("nerdy"))

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<space>fd", builtin.find_files)
vim.keymap.set("n", "<space>fh", builtin.help_tags)
vim.keymap.set("n", "<space>fg", builtin.live_grep)
vim.keymap.set("n", "<space>/", builtin.current_buffer_fuzzy_find)
-- vim.keymap.set("n", "<space>gtb", builtin.git_branches({ use_file_path = true }))
-- vim.keymap.set("n", "<space>gtc", builtin.git_commits({ use_file_path = true }))
-- vim.keymap.set("n", "<space>gtC", builtin.git_bcommits({ use_file_path = true }))
-- vim.keymap.set("n", "<space>gtt", builtin.git_status({ use_file_path = true }))
vim.keymap.set("n", "<space>gw", builtin.grep_string)

vim.keymap.set("n", "<space>fa", function()
	---@diagnostic disable-next-line: param-type-mismatch
	builtin.find_files({ cwd = utils.path_join(vim.fn.stdpath("data"), "lazy") })
end)

vim.keymap.set("n", "<space>en", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end)
