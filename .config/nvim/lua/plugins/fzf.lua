return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("fzf-lua").setup({
			"max-perf",
			grep = { rg_opts = "--hidden --line-number" },
			keymap = {
				fzf = {
					["ctrl-q"] = "select-all+accept",
				},
			},
            fzf_opts = {
                ['--layout'] = 'reverse-list'
            },
			winopts = {
				preview = {
					layout = "vertical",
                    vertical = "top:50%"
				},
			},
		})
	end,
}
