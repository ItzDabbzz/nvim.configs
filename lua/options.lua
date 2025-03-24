require "nvchad.options"

-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

o.breakindent = true
-- Wrap-broken line prefix
o.showbreak = [[↪ ]]

vim.opt.guicursor:append("a:blinkwait100-blinkoff700-blinkon700-blinkwait500")
vim.cmd([[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]])

local autocmd = vim.api.nvim_create_autocmd -- create autocmd

local augroup = vim.api.nvim_create_augroup


-- define autocmd in a group so that you can clear it easily
autocmd({ "TermOpen" }, {
    group = augroup("Terminal", { clear = true }),
    pattern = { "*" },
    callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.api.nvim_command("startinsert")
    end,
})


-- resize splits if window got resized
autocmd({ "VimResized" }, {
    group = augroup("resize_splits", { clear = true }),
    callback = function()
        vim.cmd("wincmd =")
        vim.cmd("tabdo wincmd =")
    end,
})

-- go to the last known loc/position when opening a file/buffer
-- :h restore-position and :h restore-cursor
autocmd("BufReadPost", {
    group = augroup("restore cursor", { clear = true }),
    pattern = { "*" },
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] >= 1 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- wrap and check for spell in text filetypes
autocmd("FileType", {
    group = augroup("wrap_spell", { clear = true }),
    pattern = { "gitcommit", "markdown", "norg" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})


-- Remove Trailing whitespaces in all files
autocmd({ "BufWritePre" }, { pattern = { "*" }, command = [[%s/\s\+$//e]] })

-- Remove Trailing windows carriage return in all files
if vim.fn.has("win64") == 1 or vim.fn.has("wsl") == 1 then
    autocmd({ "BufWritePre" }, { pattern = { "*" }, command = [[%s/\r$//e]] })
end

-- Enable auto formating at textwidth
autocmd({ "FileType" }, {
    group = augroup("FormatOptions", { clear = true }),
    pattern = { "*" },
    -- INFO: https://stackoverflow.com/questions/16030639/vim-formatoptions-or/16035812#16035812
    -- https://stackoverflow.com/questions/76259118/neovim-vim-optremove-doesnt-actually-change-the-option
    callback = function()
        vim.opt.formatoptions = {
            t = true,
            c = true,
            r = true,
            o = true,
            q = true,
            ["]"] = true,
            j = true,
        }
    end,
})

autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
      vim.cmd "Nvdash"
    end
  end,
})

autocmd({ "LspAttach" }, {
  pattern = { "*.go" },
  callback = function(args)
    require("cmp_go_pkgs").init_items(args)
  end,
})
