return {
	{
		"echasnovski/mini.completion",
		version = "*",
		config = function()
			require("mini.completion").setup({
        delay= {completion= 10^7},
        window={
          info={border="rounded"},
          signature={border="rounded"}
        },
				lsp_completion = {
					auto_setup = false,
				},
			})
		end,
	},
}
