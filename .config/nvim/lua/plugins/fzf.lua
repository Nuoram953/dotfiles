return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("fzf-lua").setup({
			"fzf-native",
			keymap = {
				fzf = {
					["ctrl-q"] = "select-all+accept",
				},
			},
			file = {
				fzf_opts = {

					["--ansi"] = true,
				},
			},
			files = {
				git_icons = false,
				file_icons = true,
				color_icons = true,
			},
			git = {
				git_icons = false,
				file_icons = true,
				color_icons = true,
			},
			grep = {
				rg_opts = "--hidden --line-number --multiline",
				git_icons = false,
				file_icons = true,
				color_icons = true,
			},
			lsp = {
				jump_to_single_result = true,
			},
			defaults = {
				formatter = "path.filename_first",
				multiline = 1,
			},
			winopts = {
				preview = {
					layout = "vertical",
					vertical = "top:50%",
				},
				height = 0.75,
			},
			file_icons = true,
		})
	end,
}
