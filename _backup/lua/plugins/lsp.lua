return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/neodev.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{
				"j-hui/fidget.nvim",
				tag = "v1.4.5", -- Make sure to update this to something recent!
				event = "LspAttach",
			},
			-- Autoformatting
			"stevearc/conform.nvim",
			-- Schema information
			"b0o/SchemaStore.nvim",
			"SmiteshP/nvim-navic",
		},
		config = function()
			require("neodev").setup({})

			local yamlCfg = require("yaml-companion").setup({
				-- Add any options here, or leave empty to use the default settings
				-- lspconfig = {
				--   cmd = {"yaml-language-server"}
				-- },
			})

			local capabilities = nil
			if pcall(require, "cmp_nvim_lsp") then
				capabilities = require("cmp_nvim_lsp").default_capabilities()
			end
			local lspconfig = require("lspconfig")
			local servers = {
				astro = true,
				bashls = true,
				dockerls = true,
				docker_compose_language_service = true,
				gradle_ls = true,
				gopls = true,
				jsonls = {
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
					setup = {
						commands = {
							Format = {
								function()
									vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
								end,
							},
						},
					},
				},
				lua_ls = {
					diagnostics = {
						globals = {
							"vim",
							"require",
						},
					},
					runtime = {
						path = {
							"",
							".\\?.lua",
							"C:\\Tools\\neovim\\nvim-win64\\bin\\lua\\?.lua",
							"C:\\Tools\\neovim\\nvim-win64\\bin\\lua\\?\\init.lua",
							"C:\\Dev\\Lua\\5.1\\lua\\?.luac",
							"lua/?.lua",
							"lua/?/init.lua",
						},
						version = "LuaJIT",
					},
					telemetry = {
						enable = false,
					},
					workspace = {
						checkThirdParty = false,
						library = {
							"C:\\Tools\\neovim\\nvim-win64\\share\\nvim\\runtime\\lua",
							"C:\\Users\\Davin\\AppData\\Local\\nvim\\lua",
							"C:\\Dev\\Lua\\lls-addons",
							vim.api.nvim_get_runtime_file("", true),
						},
					},
				},
				rust_analyzer = true,
				templ = true,
				cssls = true,
				tsserver = true,
				yamlls = true,
			}

			local servers_to_install = vim.tbl_filter(function(key)
				local t = servers[key]
				if type(t) == "table" then
					return t.manual_install
				else
					return t
				end
			end, vim.tbl_keys(servers))

			require("mason").setup()
			local ensure_installed = {
				"stylua",
				"lua_ls",
				"delve",
			}

			vim.list_extend(ensure_installed, servers_to_install)
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			for name, config in pairs(servers) do
				if config == true then
					config = {}
				end
				config = vim.tbl_deep_extend("force", {}, {
					capabilities = capabilities,
				}, config)

				lspconfig[name].setup(config)
			end

			local disable_semantic_tokens = {
				lua = true,
			}
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

					vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
					vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = 0 })
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
					vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

					vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
					vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })

					local filetype = vim.bo[bufnr].filetype
					if disable_semantic_tokens[filetype] then
						client.server_capabilities.semanticTokensProvider = nil
					end
				end,
			})

			require("lspconfig")["yamlls"].setup(yamlCfg)

			-- Autoformatting Setup
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
				},
			})

			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function(args)
					require("conform").format({
						bufnr = args.buf,
						lsp_fallback = true,
						quiet = true,
					})
				end,
			})

			require("fidget").setup({
				progress = {
					poll_rate = 0,
					suppress_on_insert = false,
					ignore_done_already = false,
					ignore_empty_message = false,
					-- clear_on_deatch = function(client_id)
					-- 	local client = vim.lsp.get_client_by_id(client_id)
					-- 	return client and client.name or nil
					-- end,
					notification_group = function(msg)
						return msg.lsp_client.name
					end,
					ignore = {}, -- List of LSP servers to ignore
					display = {
						render_limit = 16,
						done_ttl = 4,
						done_icon = "",
						done_style = "Constant",
						progress_ttl = math.huge,
						progress_icon = { pattern = "dots", period = 2 },
						progress_style = "WarningMsg",
						group_style = "Title",
						icon_style = "Question",
						priority = 30,
						skip_history = true,
					},
				},
				notification = {
					filter = vim.log.levels.DEBUG,
					history_size = 256,
					override_vim_notify = true,
				},
				integration = {
				},
			})
			local navic = require("nvim-navic")

			navic.setup({
				icons = {
					File = " ",
					Module = " ",
					Namespace = " ",
					Package = " ",
					Class = " ",
					Method = " ",
					Property = " ",
					Field = " ",
					Constructor = " ",
					Enum = " ",
					Interface = " ",
					Function = " ",
					Variable = " ",
					Constant = " ",
					String = " ",
					Number = " ",
					Boolean = " ",
					Array = " ",
					Object = " ",
					Key = " ",
					Null = " ",
					EnumMember = " ",
					Struct = " ",
					Event = " ",
					Operator = " ",
					TypeParameter = " ",
				},
				lsp = {
					auto_attach = true,
					preference = nil,
				},
				highlight = true,
				separator = " > ",
				depth_limit = 0,
				depth_limit_indicator = "..",
				safe_output = true,
				lazy_update_context = false,
				click = true,
				format_text = function(text)
					return text
				end,
			})

			require("lspconfig").clangd.setup({
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
			})
		end,
	},
}
