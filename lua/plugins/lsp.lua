return {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        { 'onsails/lspkind.nvim' },
        { 'hrsh7th/cmp-nvim-lua' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'saadparwaiz1/cmp_luasnip' },
        { 'williamboman/mason-lspconfig.nvim' },
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
        end)

        
        lsp_zero.set_sign_icons({ error = "✘", warn = "", hint = "󱧡", info = "" })

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
                jdtls = function()
                    require('lspconfig').jdtls.setup({})
                end,
                tsserver = function()
                    require('lspconfig').tsserver.setup({})
                end,
                lua_ls = function()
                    local lua_opts = lsp_zero.nvim_lua_ls()
                    require('lspconfig').lua_ls.setup(lua_opts)
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
    end
}
