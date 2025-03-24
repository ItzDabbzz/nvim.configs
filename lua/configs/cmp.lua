dofile(vim.g.base46_cache .. "cmp")

local cmp = require "cmp"

local options = {
    completion = { completeopt = "menu,menuone" },
    format = require("tailwindcss-colorizer-cmp").formatter,
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },

    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),

        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif require("luasnip").expand_or_jumpable() then
                require("luasnip").expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
                require("luasnip").jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },

    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "go_pkgs" },
        { name = "buffer-lines" },
        { name = "codeium" },
        { name = "css-variables" },
        { name = "npm", keyword_length = 4 },
        {
            name = "dotenv",
            -- Defaults
            option = {
                path = ".",
                load_shell = true,
                item_kind = cmp.lsp.CompletionItemKind.Variable,
                eval_on_confirm = false,
                show_documentation = true,
                show_content_on_docs = true,
                documentation_kind = "markdown",
                dotenv_environment = ".*",
                file_priority = function(a, b)
                    -- Prioritizing local files
                    return a:upper() < b:upper()
                end,
            },
        },
    },
}

-- TODO: CSS completetion source needs to be set below
-- vim.g.css_variables_files = { "variables.css" }

-- history
for _, cmd_type in ipairs { ":", "/", "?", "@" } do
    cmp.setup.cmdline(cmd_type, {
        sources = {
            { name = "cmdline_history" },
        },
    })
end

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" },
    },
})

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        {
            name = "cmdline",
            option = {
                ignore_cmds = { "Man", "!" },
            },
        },
    }),
})

require("scrollbar").setup()

return vim.tbl_deep_extend("force", options, require "nvchad.cmp")
