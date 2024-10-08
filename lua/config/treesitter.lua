require('nvim-treesitter.configs').setup({
    -- A list of parser names, or "all"
    ensure_installed = { "bash", "comment", "markdown", "markdown_inline", "regex", "lua", "astro", "javascript", "typescript", "tsx", "html", "json" },
    -- A list of paser names to ignore
    ignore_install = {},

    sync_install = false,
    auto_install = false,
    matchup = {
        enable = false,
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = true,
        config = {
            typescript = "// %s",
            css = "/* %s */",
            scss = "/* %s */",
            html = "<!-- %s -->",
            svelte = "<!-- %s -->",
            vue = "<!-- %s -->",
            json = "",
        },
    },
    indent = {
        enable = false,
        disable = { "yaml", "python" },
    },
    -- autotag = { enable = true },
    textobjects = {
        swap = { enable = true },
        select = { enable = true },
    },
    textsubjects = {
        enable = false,
        keymaps = { ["."] = "textsubjects-smart", [";"] = "textsubjects-big" },
    },
    playground = {
        enable = false,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
        },
    },
    rainbow = {
        enable = false,
        extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
        max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
    },
})