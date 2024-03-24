-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local ok, lazy = pcall(require, "lazy")
if not ok then
	return
end

-- We have to set the leader key here for lazy.nvim to work
require("helpers.keys").set_leader(" ")

-- Load plugins from specifications
-- (The leader key must be set before this)
lazy.setup("plugins")

-- Might as well set up an easy-access keybinding

require("helpers.keys").map("n", "<leader>L", lazy.show, "Show Lazy")

require 'nvim-treesitter.install'.compilers = { "clang", "zig"}
require 'nvim-treesitter.install'.prefer_git = false

require 'colorizer'.setup()


local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

local markdownlint = {
    method = null_ls.methods.DIAGNOSTICS,
    filetypes = { "markdown" },
    -- null_ls.generator creates an async source
    -- that spawns the command with the given arguments and options
    generator = null_ls.generator({
        command = "markdownlint",
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
