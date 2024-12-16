return {
	{
		"saghen/blink.cmp",
		lazy = false,
		dependencies = { "rafamadriz/friendly-snippets", "mikavilpas/blink-ripgrep.nvim" },

		version = "v0.*",

		opts = {
			keymap = { preset = "default" },
			completion = {
				menu = {
					border = "rounded",
				},

				documentation = {
					auto_show = true,
					window = {
						border = "rounded",
					},
				},
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer", "ripgrep", "lazydev" },
				providers = {
					lsp = { fallback_for = { "lazydev" } },
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
					ripgrep = {
						module = "blink-ripgrep",
						name = "Ripgrep",
						opts = {

							prefix_min_len = 3,

							context_size = 5,

							max_filesize = "1M",

							additional_rg_options = {},
						},
					},
				},
			},

			signature = { enabled = true, window = { border = "rounded" } },
		},
	},
}
