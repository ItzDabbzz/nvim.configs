-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = {
    "html",
    "cssls",
    "ts_ls",
    "gopls",
    "jsonls",
    "lua_ls",
    "markdown_oxide",
    "nextls",
    "yamlls",
    "sqlls",
    "eslint",
    "tailwindcss",
    "pyright",
}
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,
    }
end

-- configuring single server, example: typescript
lspconfig.ts_ls.setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.cssls.setup {
    capabilities = capabilities,
}

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
        if not client or type(value) ~= "table" then
            return
        end
        local p = progress[client.id]

        for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
                p[i] = {
                    token = ev.data.params.token,
                    msg = ("[%3d%%] %s%s"):format(
                        value.kind == "end" and 100 or value.percentage or 100,
                        value.title or "",
                        value.message and (" **%s**"):format(value.message) or ""
                    ),
                    done = value.kind == "end",
                }
                break
            end
        end

        local msg = {} ---@type string[]
        progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
        end, p)

        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
                notif.icon = #progress[client.id] == 0 and " "
                    or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
        })
    end,
})

require("lumberjack").setup {
    -- Set highlight colours for log level text
    foreground = {
        -- Override default namespace for ERROR logs
        ERROR = "@comment.error",
        -- Extend built-in log levels to also highlight Debug logs
        DEBUG = "DiagnosticHint",
    },
    -- Set highlight colours for other text in log that isn't the log level
    background = {
        DEBUG = "DiagnosticHint",
    },
}

-- Add keymaps
local set = vim.keymap.set
set("n", "<leader>lha", ":LumberjackAll<CR>", { desc = "[L]umberjack highlight [A]ll" })
set("n", "<leader>lhc", ":LumberjackClear<CR>", { desc = "[L]umberjack [C]lear highlights" })
set("n", "<leader>lhE", ":LumberjackCustom FATAL ERROR WARN<CR>", { desc = "[L]umberjack highlight FATAL/ERROR/WARN" })
set("n", "<leader>lhf", ":LumberjackFatal<CR>", { desc = "[L]umberjack highlight [F]ATAL" })
set("n", "<leader>lhe", ":LumberjackError<CR>", { desc = "[L]umberjack highlight [E]RROR" })
set("n", "<leader>lhw", ":LumberjackWarn<CR>", { desc = "[L]umberjack highlight [W]ARN" })
set("n", "<leader>lhi", ":LumberjackInfo<CR>", { desc = "[L]umberjack highlight [I]NFO" })
set("n", "<leader>lhd", ":LumberjackCustom DEBUG<CR>", { desc = "[L]umberjack highlight [D]EBUG" })

local dap = require "dap"
set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[D]ebug [B]reakpoint" })
set("n", "<leader>dC", dap.run_to_cursor, { desc = "[D]ebug Run To [C]ursor" })
set("n", "<leader>dc", dap.continue, { desc = "[D]ebug [C]ontinue" })
set("n", "<leader>dz", dap.step_over, { desc = "[D]ebug Step Over" })
set("n", "<leader>dx", dap.step_into, { desc = "[D]ebug Step Into" })
set("n", "<leader>dc", dap.step_out, { desc = "[D]ebug Step Out" })
set("n", "<leader>dv", dap.step_back, { desc = "[D]ebug Step [B]ack" })
set("n", "<leader>dr", dap.restart, { desc = "[D]ebug [R]estart" })
set("n", "<leader>d?", function()
    require("dapui").eval(nil, { enter = true })
end, { desc = "[D]ebug [?] Help" })
require("lazydev").setup {
    library = { "nvim-dap-ui" },
}
set("n", "<leader>Ct", function()
    require("cord.api.command").toggle_presence()
end, { desc = "Toggle [C]ord [T]oggle" })
set("n", "<leader>Ci", function()
    require("cord.api.command").toggle_idle_force()
end, { desc = "Toggle [C]ord [I]dle" })

local dap, dapui = require "dap", require "dapui"
require("cord").setup {}
dapui.setup()

dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

-- This module contains a number of default definitions
local rainbow_delimiters = require "rainbow-delimiters"

---@type rainbow_delimiters.config
vim.g.rainbow_delimiters = {
    strategy = {
        [""] = rainbow_delimiters.strategy["global"],
        vim = rainbow_delimiters.strategy["local"],
    },
    query = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
    },
    priority = {
        [""] = 110,
        lua = 210,
    },
    highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
    },
}

require("scrollbar").setup {
    show = true,
    show_in_active_only = false,
    set_highlights = true,
    folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
    max_lines = false, -- disables if no. of lines in buffer exceeds this
    hide_if_all_visible = false, -- Hides everything if all lines are visible
    throttle_ms = 100,
    handle = {
        text = " ",
        blend = 30, -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent. Defaults to 30.
        color = nil,
        color_nr = nil, -- cterm
        highlight = "CursorColumn",
        hide_if_all_visible = true, -- Hides handle if all lines are visible
    },
    marks = {
        Cursor = {
            text = "•",
            priority = 0,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "Normal",
        },
        Search = {
            text = { "-", "=" },
            priority = 1,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "Search",
        },
        Error = {
            text = { "-", "=" },
            priority = 2,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "DiagnosticVirtualTextError",
        },
        Warn = {
            text = { "-", "=" },
            priority = 3,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "DiagnosticVirtualTextWarn",
        },
        Info = {
            text = { "-", "=" },
            priority = 4,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "DiagnosticVirtualTextInfo",
        },
        Hint = {
            text = { "-", "=" },
            priority = 5,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "DiagnosticVirtualTextHint",
        },
        Misc = {
            text = { "-", "=" },
            priority = 6,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "Normal",
        },
        GitAdd = {
            text = "┆",
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "GitSignsAdd",
        },
        GitChange = {
            text = "┆",
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "GitSignsChange",
        },
        GitDelete = {
            text = "▁",
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "GitSignsDelete",
        },
    },
    excluded_buftypes = {
        "terminal",
    },
    excluded_filetypes = {
        "dropbar_menu",
        "dropbar_menu_fzf",
        "DressingInput",
        "cmp_docs",
        "cmp_menu",
        "noice",
        "prompt",
        "TelescopePrompt",
    },
    autocmd = {
        render = {
            "BufWinEnter",
            "TabEnter",
            "TermEnter",
            "WinEnter",
            "CmdwinLeave",
            "TextChanged",
            "VimResized",
            "WinScrolled",
        },
        clear = {
            "BufWinLeave",
            "TabLeave",
            "TermLeave",
            "WinLeave",
        },
    },
    handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true, -- Requires gitsigns
        handle = true,
        search = true, -- Requires hlslens
        ale = false, -- Requires ALE
    },
}
