vim.pack.add({
	"https://github.com/emrearmagan/atlas.nvim",
})

require("atlas").setup({
	providers = {
		github = {},
	},
})
