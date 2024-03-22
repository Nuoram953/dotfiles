return {
	{
		"aserowy/tmux.nvim",
		config = function()
			require("tmux").setup({
				copy_sync = {
					enable = true,
					sync_clipboard = false,
					sync_registers = true,
				},
			})
		end,
	},
}
