return {
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufReadPre",
		config = function()
			-- Using protected call
			local status_ok, treesitter_config = pcall(require, "nvim-treesitter.configs")
			if not status_ok then
				return
			end

			treesitter_config.setup({
				ensure_installed = require("utils").parsers,
				sync_install = false,
				disable = { "text" },

				highlight = {
					enable = true,
					disable = { "text" },
				},
				indent = { enable = true, disable = { "python", "css" } },

				-- Integration with other plugins
				autopairs = { -- require autopairs plugin
					enable = true,
				},
				autotag = { -- require autotag plugin
					enable = true,
				},
				context_commentstring = { -- require ts-comment string plugin
					enable = true,
					enable_autocmd = false,
				},
				textobjects = {
					select = {
						enable = true,

						lookahead = true,

						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
							["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
						},
						selection_modes = {
							["@parameter.outer"] = "v", -- charwise
							["@function.outer"] = "V", -- linewise
							["@class.outer"] = "<c-v>", -- blockwise
						},
						include_surrounding_whitespace = true,
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
							["]a"] = "@parameter.inner",
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]C"] = "@class.outer",
							["]A"] = "@parameter.inner",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
							["[a"] = "@parameter.inner",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[C"] = "@class.outer",
							["[A"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},
}
