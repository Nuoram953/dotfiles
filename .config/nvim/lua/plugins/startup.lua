return { -- Telescope
	-- Find, Filter, Preview, Pick. All lua, all the time.
	{
		"startup-nvim/startup.nvim",
        lazy=false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function(_)
			require("startup").setup({ theme = "dashboard" })
		end,
	},
}
