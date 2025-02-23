return {
  {
    "echasnovski/mini.snippets",
    version = "*",
    config = function()
      local gen_loader = require('mini.snippets').gen_loader
      require('mini.snippets').setup({
        snippets = {
          gen_loader.from_file('~/.config/nvim/lua/snippets/global.json'),
          gen_loader.from_lang(),
        },
      })
    end,
  },
  {
    "echasnovski/mini.move",
    version = false,
    config = function()
      require("mini.move").setup()
    end,
  },
  {
    "echasnovski/mini.move",
    version = false,
    config = function()
      require("mini.move").setup()
    end,
  },
  {
    "echasnovski/mini.splitjoin",
    version = false,
    config = function()
      require("mini.splitjoin").setup()
    end,
  },
  {
    "echasnovski/mini.ai",
    version = false,
    config = function()
      local ai = require("mini.ai")
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),       -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },           -- tags
          d = { "%f[%d]%d+" },                                                          -- digits
          e = {                                                                         -- Word with case
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },
          u = ai.gen_spec.function_call(),                           -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      })
    end,
  },
}
