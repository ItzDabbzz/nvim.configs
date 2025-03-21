return {
	--[[
        @URL: https://github.com/LintaoAmons/scratch.nvim
        @Description:
            Temprary File Buffer Playgrounds for Neovim
        @Commands:
            - :Scratch
            - :ScratchOpen
            - :ScratchWithName
            - :ScratchOpenFzf
            - :ScratchEditConfig
            - :ScratchPad
    ]]
	{
		"LintaoAmons/scratch.nvim",
		event = "VeryLazy",
	},
	--[[
        @URL:https://github.com/LintaoAmons/bookmarks.nvim
        @Description:
            Bookmarks for Neovim
        @Commands:
            - :Bookmarks
            - :BookmarksList
            - :BookmarksMark
            - :BookmarksGoto
            - :BookmarksCommands
            - :BookmarksGotoRecent
    ]]
	-- {
	-- 	"LintaoAmons/bookmarks.nvim",
	-- 	dependencies = {
	-- 		{ "stevearc/dressing.nvim" }, -- optional: to have the same UI shown in the GIF
	-- 	},
	-- },
	{
		"NStefan002/screenkey.nvim",
		cmd = "Screenkey",
		version = "*",
		config = true,
		lazy = true,
	},
	{
		"chrisgrieser/nvim-scissors",
		dependencies = "nvim-telescope/telescope.nvim", -- optional
		opts = {
			snippetDir = "C:\\Users\\Davin\\AppData\\Local\\nvim\\snippets",
		},
	},
	{
		"hinell/lsp-timeout.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
	},
	{
		"liuzihua699/startuptime.nvim",
		lazy = false,
	},
	{
		"IogaMaster/neocord",
		event = "VeryLazy",
	},
	{
		"Kurama622/profile.nvim",
		-- dependencies = { "3rd/image.nvim" },
		config = function()
			require("profile").setup({
				-- avatar_path = "Z:\\GFX\\bart.jpg", -- default: profile.nvim/resources/profile.png
				user = "ItzDabbzz",
			})
			vim.api.nvim_set_keymap("n", "<leader>po", "<cmd>Profile<cr>", { silent = true })
		end,
	},
}
