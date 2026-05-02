vim.pack.add({
	"https://github.com/pwntester/octo.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
})

local Octo = require("octo")

Octo.setup({
	picker = "snacks",
	enable_builtin = true,
})
