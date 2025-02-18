return {
  {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          php = { "php-cs-fixer" },
          markdown = { "doctoc" },
          zsh = { "beautysh" },
          mysql = { "sqlfmt" },
          htmldjango = { "djlint" },
          json = { "fixjson" },
        },
      })
    end,
  },
}
