return {
	{
		"famiu/bufdelete.nvim",
		keys = {
			{ "<leader>x", "<cmd>Bdelete<CR>", desc = "Delete buffer" },
		},
	},
	{
		"akinsho/bufferline.nvim",
		config = function(_)
			require("bufferline").setup()
		end,
	},
}
