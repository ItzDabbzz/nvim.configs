return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	--ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	-- event = {
	--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
	--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
	"BufReadPre Z:\\Obsidian\\**.md",
	"BufNewFile Z:\\Obsidian\\**.md",
	-- },
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",

		-- see below for full list of optional dependencies 👇
	},
	opts = {
		workspaces = {
			{
				name = "main",
				path = "Z:\\Obsidian\\Main",
			},
			{
				name = "work",
				path = "Z:\\Obsidian\\Work",
			},
			{
				name = "requiem",
				path = "Z:\\Obsidian\\Requiem",
			},
		},

		-- see below for full list of options 👇
	},
}
