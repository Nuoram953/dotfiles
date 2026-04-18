vim.pack.add({
	"https://github.com/mistweaverco/kulala.nvim",
})

local Kulala = require("kulala")

Kulala.setup({
	ft = { "http", "rest" },
	global_keymaps = true,
	global_keymaps_prefix = "<leader>R",
	kulala_keymaps_prefix = "",
})
