require "nvchad.options"

-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
o.foldcolumn = '1' -- '0' is not bad
o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
o.foldlevelstart = 99
o.foldenable = true
o.breakindent = true
-- Wrap-broken line prefix
o.showbreak = [[↪ ]]
vim.opt.clipboard = "unnamedplus"

if vim.fn.has("wsl") == 1 then
	vim.g.clipboard = {
		name = "win32yank-wsl",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --lf",
			["*"] = "win32yank.exe -o --lf",
		},
		cache_enabled = 0,
	}
end

vim.opt.guicursor:append("a:blinkwait100-blinkoff700-blinkon700-blinkwait500")
vim.cmd([[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]])

local autocmd = vim.api.nvim_create_autocmd -- create autocmd

local augroup = vim.api.nvim_create_augroup

local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' 󰁂 %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, {suffix, 'MoreMsg'})
    return newVirtText
end

require('ufo').setup({
    open_fold_hl_timeout = 150,
    fold_virt_text_handler = handler,
    close_fold_kinds_for_ft = {
        default = {'imports', 'comment'},
        json = {'array'},
        c = {'comment', 'region'}
    },
    preview = {
        win_config = {
            border = {'', '─', '', '', '', '─', '', ''},
            winhighlight = 'Normal:Folded',
            winblend = 0
        },
        mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>',
            jumpTop = '[',
            jumpBot = ']'
        }
    },
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end
})

vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })
vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = 'Open all folds except kinds' })
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = "Close Folds With" }) -- closeAllFolds == closeFoldsWith(0)
vim.keymap.set('n', 'K', function()
    local winid = require('ufo').peekFoldedLinesUnderCursor()
    if not winid then
        vim.lsp.buf.hover()
    end
end, { desc = 'Peek Folded Lines Under Cursor' })


require('hlslens').setup()

local kopts = {noremap = true, silent = true, desc = 'Hlsearch' }

vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap('n', '<Leader>lf', '<Cmd>noh<CR>', kopts)

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
