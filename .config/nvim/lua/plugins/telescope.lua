return { -- Telescope
	-- Find, Filter, Preview, Pick. All lua, all the time.
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function(_)
			require("telescope").setup({
				pickers = {
					find_files = {
                        cwd = vim.fn.expand('%:p:h'),
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*", "-L" },
					}
				},
				defaults = {
					file_ignore_patterns = { "node_modules", "static", ".git" },
				},
			})
		end,
	},
}
