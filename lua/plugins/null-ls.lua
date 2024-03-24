return {
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"jay-babu/mason-null-ls.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			local sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.clang_format,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
				null_ls.builtins.diagnostics.revive,
				null_ls.builtins.formatting.golines.with({
					extra_args = {
						"--max-len=180",
						"--base-formatter=gofumpt",
					},
				})
			}
			-- TODO: Fix Markdown formatting
			-- for go.nvim
			local gotest = require("go.null_ls").gotest()
			local gotest_codeaction = require("go.null_ls").gotest_action()
			local golangci_lint = require("go.null_ls").golangci_lint()
			table.insert(sources, gotest)
			table.insert(sources, golangci_lint)
			table.insert(sources, gotest_codeaction)
			null_ls.setup({ sources = sources, debounce = 1000, default_timeout = 5000 })

			local null_ls = require("null-ls")
			local helpers = require("null-ls.helpers")

			local markdownlint = {
				method = null_ls.methods.DIAGNOSTICS,
				filetypes = { "markdown" },
				-- null_ls.generator creates an async source
				-- that spawns the command with the given arguments and options
				generator = null_ls.generator({
					command = "markdownlint-cli2",
					args = { "--stdin" },
					to_stdin = true,
					from_stderr = true,
					-- choose an output format (raw, json, or line)
					format = "line",
					check_exit_code = function(code, stderr)
						local success = code <= 1

						if not success then
							-- can be noisy for things that run often (e.g. diagnostics), but can
							-- be useful for things that run on demand (e.g. formatting)
							print(stderr)
						end

						return success
					end,
					-- use helpers to parse the output from string matchers,
					-- or parse it manually with a function
					on_output = helpers.diagnostics.from_patterns({
						{
							pattern = [[:(%d+):(%d+) [%w-/]+ (.*)]],
							groups = { "row", "col", "message" },
						},
						{
							pattern = [[:(%d+) [%w-/]+ (.*)]],
							groups = { "row", "message" },
						},
					}),
				}),
			}

			null_ls.register(markdownlint)
		end,
	},
}
