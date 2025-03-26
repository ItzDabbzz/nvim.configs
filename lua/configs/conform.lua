local autocmd = vim.api.nvim_create_autocmd
local conform = require "conform"
local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        markdown = { "markdownlint", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        -- css = { "prettier" },
        -- html = { "prettier" },
    },

    -- format_on_save = {
    --   -- These options will be passed to conform.format()
    --   timeout_ms = 500,
    --   lsp_fallback = true,
    -- },
}
autocmd("bufwritepre", {
    pattern = "*",
    callback = function(args)
        conform.format { bufnr = args.buf }
    end,
})
return options
