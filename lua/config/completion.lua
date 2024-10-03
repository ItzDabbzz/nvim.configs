vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")
local keybinds = require("utils.keybinds")
local lspkind = require("lspkind")
lspkind.init({})

local cmp = require("cmp")

require("luasnip.loaders.from_lua").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({
	paths = {
		"../../snippets/",
	},
})
require("luasnip.loaders.from_snipmate").lazy_load()

cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "buffer" },
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
		{ name = "codeium" },
	},
	formatting = {
		fields = { "abbr", "kind", "menu" },
		format = function(entry, vim_item)
			local kind = require("lspkind").cmp_format({
				mode = "symbol_text", -- show only symbol annotations
				maxwidth = 50, -- prevent the popup from showing more than provided characters
				ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
				symbol_map = { Codeium = "" },
				menu = {
					nvim_lsp = "[LSP]",
					nvim_lua = "[Lua]",
					buffer = "[Buffer]",
					path = "[Path]",
					emoji = "[Emoji]",
					luasnip = "[LuaSnip]",
					vsnip = "[VSCode Snippet]",
					calc = "[Calc]",
					spell = "[Spell]",
				},
				before = require("tailwind-tools.cmp").lspkind_format,
			})(entry, vim_item)
			local strings = vim.split(kind.kind, "%s", { trimempty = true })
			kind.kind = " " .. (strings[1] or "") .. " "
			kind.menu = "    (" .. (strings[2] or "") .. ")"
	  

			return kind
		end,
	},
	mapping = {
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-y>"] = cmp.mapping(
			cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			}),
			{ "i", "c" }
		),
	},

	-- Enable luasnip to handle snippet expansion for nvim-cmp
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},

	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			require("cmp-under-comparator").under,
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
	view = {
		entries = "custom", -- can be "custom", "wildmenu" or "native"
	},
	window = {
	  completion = {
		winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
		col_offset = -3,
		side_padding = 0,
	  },
	},
})

-- Setup up vim-dadbod
cmp.setup.filetype({ "sql" }, {
	sources = {
		{ name = "vim-dadbod-completion" },
		{ name = "buffer" },
	},
})

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	completion = {
		completeopt = "menu,menuone,noselect",
	},
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

-- `/` cmdline setup.
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	completion = {
		completeopt = "menu,menuone,noselect",
	},
	sources = {
		{ name = "buffer" },
	},
})

local ls = require("luasnip")
ls.config.set_config({
	history = false,
	updateevents = "TextChanged,TextChangedI",
})

-- vim.keymap.set({ "i", "s" }, "<c-k>", function()
-- 	if ls.expand_or_jumpable() then
-- 		ls.expand_or_jump()
-- 	end
-- end, { silent = true })

keybinds.map({ "i", "s" }, "<c-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, "LuaSnip Expand Or Jump")

-- vim.keymap.set({ "i", "s" }, "<c-j>", function()
-- 	if ls.jumpable(-1) then
-- 		ls.jump(-1)
-- 	end
-- end, { silent = true })

keybinds.map({ "i", "s" }, "<c-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, "LuaSnip Jump Previous")


-- Customization for Pmenu
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#282C34", fg = "NONE" })
vim.api.nvim_set_hl(0, "Pmenu", { fg = "#C5CDD9", bg = "#22252A" })

vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#7E8294", bg = "NONE", strikethrough = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#82AAFF", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#82AAFF", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#C792EA", bg = "NONE", italic = true })

vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#EED8DA", bg = "#B5585F" })
vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#EED8DA", bg = "#B5585F" })
vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = "#EED8DA", bg = "#B5585F" })

vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#C3E88D", bg = "#9FBD73" })
vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = "#C3E88D", bg = "#9FBD73" })
vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#C3E88D", bg = "#9FBD73" })

vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#FFE082", bg = "#D4BB6C" })
vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = "#FFE082", bg = "#D4BB6C" })
vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = "#FFE082", bg = "#D4BB6C" })

vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#EADFF0", bg = "#A377BF" })
vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#EADFF0", bg = "#A377BF" })
vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#EADFF0", bg = "#A377BF" })
vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#EADFF0", bg = "#A377BF" })
vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = "#EADFF0", bg = "#A377BF" })

vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#C5CDD9", bg = "#7E8294" })
vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#C5CDD9", bg = "#7E8294" })

vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#F5EBD9", bg = "#D4A959" })
vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#F5EBD9", bg = "#D4A959" })
vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#F5EBD9", bg = "#D4A959" })

vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#DDE5F5", bg = "#6C8ED4" })
vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = "#DDE5F5", bg = "#6C8ED4" })
vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = "#DDE5F5", bg = "#6C8ED4" })

vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#D8EEEB", bg = "#58B5A8" })
vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#D8EEEB", bg = "#58B5A8" })
vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = "#D8EEEB", bg = "#58B5A8" })