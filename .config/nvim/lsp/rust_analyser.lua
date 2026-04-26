---@type vim.lsp.Config
return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json" },
	settings = {
		["rust-analyzer"] = {
			inlayHints = {
				typeHints = { enable = false },
				chainingHints = { enable = false },
				parameterHints = { enable = false },
				closingBraceHints = { enable = false },
			},
		},
	},
}
