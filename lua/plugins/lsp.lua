return {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        { 'onsails/lspkind.nvim',              lazy = true },
        { 'hrsh7th/cmp-nvim-lua',              lazy = true },
        { 'hrsh7th/cmp-nvim-lsp',              lazy = true },
        { 'hrsh7th/cmp-buffer',                lazy = true },
        { 'hrsh7th/cmp-path',                  lazy = true },
        { 'saadparwaiz1/cmp_luasnip',          lazy = true },
        { 'williamboman/mason-lspconfig.nvim', lazy = true },
        { "b0o/schemastore.nvim",              lazy = true },
        {
            "j-hui/fidget.nvim",
            tag = "legacy",
            event = "LspAttach",
        },
    },
    config = function()
        -- This is where all the LSP shenanigans will live
        local lsp_zero = require('lsp-zero')
        lsp_zero.extend_lspconfig()

        --- if you want to know more about lsp-zero and mason.nvim
        --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
        lsp_zero.on_attach(function(client, bufnr)
            -- see :help lsp-zero-keybindings
            -- to learn the available actions
            lsp_zero.default_keymaps({ buffer = bufnr })
            require("illuminate").on_attach(client)
        end)

        local icons = require("helpers.icons")
        lsp_zero.set_sign_icons({
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warning,
            hint = icons
                .diagnostics.Hint,
            info = icons.diagnostics.Information
        })

        -- TODO: Let which-key know about gq being format file
        lsp_zero.format_mapping('gq', {
            format_opts = {
                async = false,
                timeout_ms = 10000,
            },
            servers = {
                ['tsserver'] = { 'javascript', 'typescript' },
                ['rust_analyzer'] = { 'rust' },
                ['lua_ls'] = { 'lua' },
                ['prismals'] = { 'prisma' },
                ['astro'] = { 'astro' }
            }
        })
        lsp_zero.set_server_config({
            capabilities = {
                textDocument = {
                    foldingRange = {
                        dynamicRegistration = false,
                        lineFoldingOnly = true
                    }
                }
            }
        })

        require('mason').setup({})

        require('mason-lspconfig').setup({
            ensure_installed = { "astro", "cssls", "dockerls", "docker_compose_language_service", "gradle_ls", "gopls", "jdtls", "tsserver", "lua_ls", "markdown_oxide", "powershell_es", "prismals", "rust_analyzer", "sqlls", "taplo", "tailwindcss", "hydra_lsp", "zls" },
            handlers = {
                lsp_zero.default_setup,
                astro = function()
                    require('lspconfig').astro.setup({})
                end,
                cssls = function()
                    require('lspconfig').cssls.setup({})
                end,
                dockerls = function()
                    require('lspconfig').dockerls.setup({})
                end,
                docker_compose_language_service = function()
                    require('lspconfig').docker_compose_language_service.setup({})
                end,
                gradle_ls = function()
                    require('lspconfig').gradle_ls.setup({})
                end,
                gopls = function()
                    require('lspconfig').gopls.setup({})
                end,
                jsonls = function()
                    require('lspconfig').jsonls.setup {
                        settings = {
                            json = {
                                schemas = require('schemastore').json.schemas(),
                                validate = { enable = true },
                            },
                            yaml = {
                                schemaStore = {
                                    -- You must disable built-in schemaStore support if you want to use
                                    -- this plugin and its advanced options like `ignore`.
                                    enable = false,
                                    -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                                    url = "",
                                },
                                schemas = require('schemastore').yaml.schemas(),
                            },
                        },
                        setup = {
                            commands = {
                                Format = {
                                    function()
                                        vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
                                    end,
                                },
                            },
                        },
                    }
                end,
                jdtls = function()
                    require('lspconfig').jdtls.setup({})
                end,
                tsserver = function()
                    require('lspconfig').tsserver.setup({})
                end,
                lua_ls = function()
                    local lua_opts = lsp_zero.nvim_lua_ls()
                    local opts = {
                        diagnostics = {
                            globals = { "vim" }
                        },
                        runtime = {
                            path = {
                                "",
                                ".\\?.lua",
                                "C:\\Tools\\neovim\\nvim-win64\\bin\\lua\\?.lua",
                                "C:\\Tools\\neovim\\nvim-win64\\bin\\lua\\?\\init.lua",
                                "C:\\Dev\\Lua\\5.1\\lua\\?.luac",
                                "lua/?.lua",
                                "lua/?/init.lua"
                            },
                            version = "LuaJIT"
                        },
                        telemetry = {
                            enable = false
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                "C:\\Tools\\neovim\\nvim-win64\\share\\nvim\\runtime\\lua",
                                "C:\\Users\\Davin\\AppData\\Local\\nvim\\lua",
                                "C:\\Dev\\Lua\\lls-addons"
                            }
                        }
                    }
                    require('lspconfig').lua_ls.setup(opts)
                end,
                markdown_oxide = function()
                    require('lspconfig').markdown_oxide.setup({})
                end,
                powershell_es = function()
                    require('lspconfig').powershell_es.setup({})
                end,
                prismals = function()
                    require('lspconfig').prismals.setup({})
                end,
                rust_analyzer = function()
                    require('lspconfig').rust_analyzer.setup({})
                end,
                sqlls = function()
                    require('lspconfig').sqlls.setup({})
                end,
                taplo = function()
                    require('lspconfig').taplo.setup({})
                end,
                tailwindcss = function()
                    require('lspconfig').tailwindcss.setup({})
                end,
                hydra_lsp = function()
                    require('lspconfig').hydra_lsp.setup({})
                end,
                zls = function()
                    require('lspconfig').zls.setup({})
                end,
            },
        })


        -- Turn on LSP status information
        require("fidget").setup({
            progress = {
                poll_rate = 0,
                suppress_on_insert = false,
                ignore_done_already = false,
                ignore_empty_message = false,
                clear_on_deatch = function(client_id)
                    local client = vim.lsp.get_client_by_id(client_id)
                    return client and client.name or nil
                end,
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
                ["neo-tree"] = {
                    enable = true,
                }
            }
        })
    end
}
