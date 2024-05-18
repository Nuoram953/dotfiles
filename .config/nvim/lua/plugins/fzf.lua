return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("fzf-lua").setup({
			"borderless",
			grep = { rg_opts = "--hidden --line-number" },
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
            lsp={
                jump_to_single_result =true
            },
			defaults = {
				formatter = "path.filename_first",
			},
			winopts = {
				preview = {
					layout = "vertical",
					vertical = "top:50%",
				},
			},
			file_icons = true,
		})
	end,
}
