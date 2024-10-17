return {
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function(_, _)
			local utils = require("utils")
			local mason_lspconfig = require("mason-lspconfig")
			local lspconfig = require("lspconfig")
			local lsp_utils = require("plugins.lsp.lsp-utils")
			lsp_utils.setup()

			mason_lspconfig.setup({
				ensure_installed = utils.lsp_servers,
			})

			local handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
			}

			mason_lspconfig.setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({
            handlers=handlers,
						on_attach = lsp_utils.on_attach,
						capabilities = lsp_utils.capabilities,
					})
				end,
				["pyright"] = function()
					lspconfig.pyright.setup({
						on_attach = lsp_utils.on_attach,
						capabilities = lsp_utils.capabilities,
						settings = {
							python = {
								analysis = {
									typeCheckingMode = "off",
								},
							},
						},
					})
				end,
				["clangd"] = function()
					local capabilities_cpp = lsp_utils.capabilities
					capabilities_cpp.offsetEncoding = { "uts-16" }
					lspconfig.clangd.setup({
						on_attach = lsp_utils.on_attach,
						capabilities = capabilities_cpp,
					})
				end,
				["jdtls"] = function()
					lspconfig.jdtls.setup({
						on_attach = lsp_utils.on_attach,
						capabilities = lsp_utils.capabilities,
						settings = {
							java = {
								configuration = {
									{
										name = "JavaSE-17",
										path = "/opt/jdk-17",
										default = true,
									},
								},
							},
						},
					})
				end,
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						on_attach = lsp_utils.on_attach,
						capabilities = lsp_utils.capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim", "opts" },
								},
							},
						},
					})
				end,
				["ts_ls"] = function()
					lspconfig.ts_ls.setup({
						on_attach = lsp_utils.on_attach,
						capabilities = lsp_utils.capabilities,
						settings = {
							typescript = {
								inlayHints = {
									includeInlayEnumMemberValueHint = false,
									includeInlayFunctionLikeReturnTypeHints = false,
									includeInlayFunctionParameterTypeHints = true,
									includeInlayParameterNameHints = "all",
									includeInlayParameterNameHintsWhenArgumentMatchesName = true,
									includeInlayPropertyDeclarationTypeHints = false,
									includeInlayVariableTypeHints = false,
								},
							},
						},
					})
				end,
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		opts = {
			pip = {
				upgrade_pip = true,
			},
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local utils = require("utils")
			local mr = require("mason-registry")
			local packages = utils.mason_packages
			local function ensure_installed()
				for _, package in ipairs(packages) do
					local p = mr.get_package(package)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
}
