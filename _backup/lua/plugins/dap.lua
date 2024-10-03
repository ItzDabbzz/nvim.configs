return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		"nvim-telescope/telescope-dap.nvim",
		"mxsdev/nvim-dap-vscode-js",
		"leoluz/nvim-dap-go",
	},
	lazy = true,
	config = function()
		local dap = require("dap")
		local ui = require("dapui")

		require("dapui").setup()
		require("dap-go").setup()
		require("nvim-dap-virtual-text").setup({
			-- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
			display_callback = function(variable)
				local name = string.lower(variable.name)
				local value = string.lower(variable.value)
				if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
					return "*****"
				end

				if #variable.value > 15 then
					return " " .. string.sub(variable.value, 1, 15) .. "... "
				end

				return " " .. variable.value
			end,
		})

		require("dap-vscode-js").setup({
			-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
			debugger_path = "C:\\Tools\\vscode-js-debug", -- Path to vscode-js-debug installation.
			-- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
			adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
			-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
			-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
			-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
		})

		for _, language in ipairs({ "typescript", "javascript" }) do
			require("dap").configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
				{
					type = "pwa-node",
					request = "launch",
					name = "Debug Bot",
					protocol = "inspector",
					args = { "${workspaceFolder}/src/main.ts" },
					cwd = "${workspaceFolder}",
					runtimeArgs = { "-r", "ts-node/register" },
					internalConsoleOptions = "neverOpen",
				},
			}
		end

		dap.adapters.lldb = {
			type = "executable",
			command = "C:\\Dev\\clang+llvm-18.1.6-x86_64-pc-windows-msvc\\bin\\lldb-dap.exe", -- adjust as needed, must be absolute path
			name = "lldb",
		}

		dap.adapters.gdb = {
			type = "executable",
			command = "gdb",
			args = { "-i", "dap" },
		}

		dap.configurations.cpp = {
			{
				name = "Launch",
				type = "lldb",
				request = "launch",
				program = function()
					return vim.fn.input(
						"Path to executable: ",
						vim.fn.getcwd() .. "/",
						"file"
					)
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
			},
			{
				-- If you get an "Operation not permitted" error using this, try disabling YAMA:
				--  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
				name = "Attach to process",
				type = "cpp", -- Adjust this to match your adapter name (`dap.adapters.<name>`)
				request = "attach",
				pid = require("dap.utils").pick_process,
				args = {},
			},
		}

		dap.configurations.c = dap.configurations.cpp

		dap.configurations.zig = {
			{
				name = "Launch",
				type = "gdb",
				request = "launch",
				program = function()
					return vim.fn.input(
						"Path to executable: ",
						vim.fn.getcwd() .. "/zig-out/bin/",
						"file"
					)
				end,
				cwd = "${workspaceFolder}",
				console = "integratedTerminal",
			},
		}

		dap.configurations.rust = {
			vim.tbl_deep_extend("force", dap.configurations.cpp[1], {
				initCommands = function()
					-- Find out where to look for the pretty printer Python module
					local rustc_sysroot =
						vim.fn.trim(vim.fn.system("rustc --print sysroot"))

					local script_import = 'command script import "'
						.. rustc_sysroot
						.. '/lib/rustlib/etc/lldb_lookup.py"'
					local commands_file = rustc_sysroot
						.. "/lib/rustlib/etc/lldb_commands"

					local commands = {}
					local file = io.open(commands_file, "r")
					if file then
						for line in file:lines() do
							table.insert(commands, line)
						end
						file:close()
					end
					table.insert(commands, 1, script_import)

					return commands
				end,
			}),
			unpack(dap.configurations.cpp, 2, #dap.configurations.cpp),
		}

		 -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
		 dap.configurations.go = {
			{
				type = "delve",
				name = "Debug",
				request = "launch",
				program = "${file}",
			},
			{
				type = "delve",
				name = "Debug test", -- configuration for debugging test files
				request = "launch",
				mode = "test",
				program = "${file}",
			},
			-- works with go.mod packages and sub packages
			{
				type = "delve",
				name = "Debug test (go.mod)",
				request = "launch",
				mode = "test",
				program = "./${relativeFileDirname}",
			},
		}

		
		dap.configurations.lua = {
			{
				type = "nlua",
				request = "attach",
				name = "Attach to running Neovim instance",
				host = function()
					local value = vim.fn.input("Host [127.0.0.1]: ")
					if value ~= "" then
						return value
					end
					return "127.0.0.1"
				end,
				port = function()
					local val = tonumber(vim.fn.input("Port: ", "8086"))
					assert(val, "Please provide a port number")
					return val
				end,
			},
		}

		local keys = require("helpers.keys")
		keys.map("n", "<leader>db", dap.toggle_breakpoint)
		keys.map("n", "<leader>dC", dap.run_to_cursor)
		keys.map("n", "<leader>dc", dap.continue)
		keys.map("n", "<leader>dz", dap.step_over)
		keys.map("n", "<leader>dx", dap.step_into)
		keys.map("n", "<leader>dc", dap.step_out)
		keys.map("n", "<leader>dv", dap.step_back)
		keys.map("n", "<leader>dr", dap.restart)
		keys.map("n", "<leader>d?", function()
			require("dapui").eval(nil, { enter = true })
		end)

		dap.listeners.before.attach.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			ui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			ui.close()
		end
	end,
}
