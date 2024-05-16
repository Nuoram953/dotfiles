local prettier = function()
  return {
    exe = "~/dotfiles/node_modules/.bin/prettier",
    args = {"--stdin-filepath","--tab-width 4", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)), "--single-quote"},
    stdin = true,
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
						require("formatter.filetypes.python").isort,
					},
					typescript = {
						prettier,
						require("formatter.filetypes.typescript").ts_standard,
					},
					typescriptreact = {
						prettier,
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
