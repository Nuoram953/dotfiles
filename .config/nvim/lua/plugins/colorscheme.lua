return {
  {
    "Mofiqul/dracula.nvim",

    config = function(_)
      local dracula = require("dracula")
      dracula.setup({
        -- customize dracula color palette
        colors = {
          bg = "#282A36",
          fg = "#F8F8F2",
          selection = "#44475A",
          comment = "#6272A4",
          red = "#FF5555",
          orange = "#FFB86C",
          yellow = "#F1FA8C",
          green = "#50fa7b",
          purple = "#BD93F9",
          cyan = "#8BE9FD",
          pink = "#FF79C6",
          bright_red = "#FF6E6E",
          bright_green = "#69FF94",
          bright_yellow = "#FFFFA5",
          bright_blue = "#D6ACFF",
          bright_magenta = "#FF92DF",
          bright_cyan = "#A4FFFF",
          bright_white = "#FFFFFF",
          menu = "#21222C",
          visual = "#3E4452",
          gutter_fg = "#4B5263",
          nontext = "#3B4048",
          white = "#ABB2BF",
          black = "#191A21",
        },
        -- show the '~' characters after the end of buffers
        show_end_of_buffer = true, -- default false
        -- use transparent background
        transparent_bg = true,    -- default false
        -- set custom lualine background color
        lualine_bg_color = "#44475a", -- default nil
        -- set italic comment
        italic_comment = true,    -- default false
        -- -- overrides the default highlights with table see `:h synIDattr`
        -- overrides = {},
        -- You can use overrides as table like this
        -- Or you can also use it like a function to get color from theme
        overrides = function(colors)
          return {
            Special = { fg = colors.green, italic = false },
            -- SpecialComment = { fg = "comment", italic = false },
            Todo = { fg = colors.purple, bold = true, italic = false },
            ["@type.builtin"] = { fg = colors.cyan, italic = false },
            ["@text.emphasis"] = { fg = colors.yellow, italic = false }, -- italic
            ["@text.uri"] = { fg = colors.yellow, italic = false }, -- urls
            htmlItalic = { fg = colors.purple, italic = false },
            markdownBlockquote = { fg = colors.yellow, italic = false },
            markdownItalic = { fg = colors.yellow, italic = false },
          }
        end,
      })
    end,
  },
  {
    'maxmx03/solarized.nvim',
    lazy = false,
    priority = 1000,
    ---@type solarized.config
    opts = {},
  }
}
