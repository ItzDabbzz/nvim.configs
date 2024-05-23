---@class TerminalManager
local M = {}

---@type table<string,table<integer,table>>
M.terminals = {}

--- Merge extended options with a default table of options
---@param default? table The default table that you want to merge into
---@param opts? table The new options that should be merged with the default table
---@return table # The merged table
function M.extend_tbl(default, opts)
	opts = opts or {}
	return default and vim.tbl_deep_extend("force", default, opts) or opts
end

--- Toggle a user terminal if it exists, if not then create a new one and save it
---@param opts string|table A terminal command string or a table of options for Terminal:new() (Check toggleterm.nvim documentation for table format)
function M.toggle_term_cmd(opts)
	local terms = M.terminals
	-- if a command string is provided, create a basic table for Terminal:new() options
	if type(opts) == "string" then
		opts = { cmd = opts }
	end
	opts = M.extend_tbl({ hidden = true }, opts)
	local num = vim.v.count > 0 and vim.v.count or 1
	-- if terminal doesn't exist yet, create it
	if not terms[opts.cmd] then
		terms[opts.cmd] = {}
	end
	if not terms[opts.cmd][num] then
		if not opts.count then
			opts.count = vim.tbl_count(terms) * 100 + num
		end
		local on_exit = opts.on_exit
		opts.on_exit = function(...)
			terms[opts.cmd][num] = nil
			if on_exit then
				on_exit(...)
			end
		end
		terms[opts.cmd][num] = require("toggleterm.terminal").Terminal:new(opts)
	end
	-- toggle the terminal
	terms[opts.cmd][num]:toggle()
end

--- Run a shell command and capture the output and if the command succeeded or failed
---@param cmd string|string[] The terminal command to execute
---@param show_error? boolean Whether or not to show an unsuccessful command as an error to the user
---@return string|nil # The result of a successfully executed command or nil
function M.cmd(cmd, show_error)
	if type(cmd) == "string" then
		cmd = { cmd }
	end
	if vim.fn.has("win32") == 1 then
		cmd = vim.list_extend({ "cmd.exe", "/C" }, cmd)
	end
	local result = vim.fn.system(cmd)
	local success = vim.api.nvim_get_vvar("shell_error") == 0
	if not success and (show_error == nil or show_error) then
		vim.api.nvim_err_writeln(
			("Error running command %s\nError message:\n%s"):format(table.concat(cmd, " "), result)
		)
	end
	return success and assert(result):gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "") or nil
end

return M
