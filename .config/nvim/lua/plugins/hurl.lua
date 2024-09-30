return {
	{
		"jellydn/hurl.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		ft = "hurl",
		opts = {
			-- Show debugging info
			debug = false,
			slit_position = "right",
			split_size = "50%",
			-- Show notification on run
			show_notification = false,
			-- Show response in popup or split
			mode = "split",
			-- Default formatter
			formatters = {
				json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
				html = {
					"prettier", -- Make sure you have install prettier in your system, e.g: npm install -g prettier
					"--parser",
					"html",
				},
			},
		},
		keys = {
			-- Run API request
			{ "<leader>huA", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
			{ "<leader>hua", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
			{ "<leader>hute", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
			{ "<leader>hutm", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode" },
			{ "<leader>tv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
			{ "<leader>h", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },
		},
	},
}
