return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim", "opts", "snacks" },
              },
              worspace = {
                library = vim.api.nvim_get_runtime_file("lua", true),
              }
            },
          },
        },
        gopls = {},
        marksman = {},
        markdown_oxide = {},
        tailwindcss = {},
        ts_ls = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingModel = "off",
                diagnosticSeverityOverrides = {
                  reportGeneralTypeIssues = "none",
                  reportOptionalMemeberAccess = "none",
                  reportOptionalSubscript = "none",

                }
              }
            }
          }
        },
        fixjson = {},
        jdtls = {},
        yamlls = {}
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
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
