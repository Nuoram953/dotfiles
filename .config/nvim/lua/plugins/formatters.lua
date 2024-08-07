local prettier = function()
	local util = require("formatter.util")
	return {
		exe = "~/dotfiles/node_modules/.bin/prettier",
		args = {
			"--config-precedence",
			"prefer-file",
			"--stdin-filepath",
			util.escape_path(util.get_current_buffer_file_path()),
		},
		stdin = true,
	}
end

local sqlfluff = function()
	return {
		exe = { "sqlfluff" },
		argr = {
			"format",
			"--disable-progress-bar",
			"--no-color",
			"--dialect mysql",
		},
		stdin = true,
		ignore_exitcode = true,
	}
end

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
						prettier,
					},
					json = {
						require("formatter.filetypes.json").fixjson,
					},
					python = {
						require("formatter.filetypes.python").black,
					},
					typescript = {
						prettier,
						require("formatter.filetypes.typescript").ts_standard,
					},
					typescriptreact = {
						prettier,
					},
					sql = {
						sqlfluff,
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
