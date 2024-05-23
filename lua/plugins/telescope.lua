return {
    { "nvim-lua/plenary.nvim" },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
            -- { "nvim-telescope/telescope-smart-history.nvim" },
			{ 'ghassan0/telescope-glyph.nvim' },
            -- { "kkharji/sqlite.lua" },
			{ "nvim-telescope/telescope-dap.nvim" },
			{ "HUAHUAI23/telescope-dapzzzz" },
            {
                "ajeetdsouza/zoxide"
            },
			{
				"benfowler/telescope-luasnip.nvim",
				module = "telescope._extensions.luasnip"
			},
            { "jvgrootveld/telescope-zoxide" },
            { 'nvim-telescope/telescope-ui-select.nvim' },
			{ "lpoto/telescope-docker.nvim" },
			{ "nvim-telescope/telescope-file-browser.nvim", },
			{ "nvim-telescope/telescope-project.nvim", },
			{ "cljoly/telescope-repo.nvim" },
            { '2kabhishek/nerdy.nvim' }
        },
        config = function()
            require "config.telescope"
        end,
    },
}
