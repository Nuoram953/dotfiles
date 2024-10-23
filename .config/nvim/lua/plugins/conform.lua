return {
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
        formatters_by_ft = {
          lua = {"stylua"},
          python  = {"black"},
          typescript ={"prettier"},
          php = {"php-cs-fixer"}
        }
      })
		end,
	},
}
