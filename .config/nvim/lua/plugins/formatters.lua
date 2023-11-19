return {
	{
		"mhartington/formatter.nvim",
		config = function(_)
			require("formatter").setup({
				logging = true,
				log_level = vim.log.levels.WARN,
				filetype = {
					lua = {
						require("formatter.filetypes.lua").stylua,
					},
					javascript = {
						require("formatter.defaults.prettier"),
					},
					json = {
						require("formatter.filetypes.json").fixjson,
					},
					python = {
						require("formatter.filetypes.python").black,
						require("formatter.filetypes.python").isort,
					},
					sql = {
						require("formatter.filetypes.sql").pgformat,
					},
					php = {
						require("formatter.defaults.prettier"),
						require("formatter.filetypes.php").phpcbf,
						require("formatter.filetypes.php").php_cs_fixer,
					},
					["*"] = {
						require("formatter.filetypes.any").remove_trailing_whitespace,
					},
				},
			})
		end,
	},
}
