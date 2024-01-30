return {
	{
		"mfussenegger/nvim-dap-python",
		config = function(_)
			require("dap-python").setup("~/../../mnt/c/Python310")
			table.insert(require("dap").configurations.python, {
				type = "python",
				request = "launch",
				name = "Windows",
				program = "${file}",
				python = "../../../../../../../../mnt/c/Python310",
                sudo = true,
			})
		end,
	},
}
