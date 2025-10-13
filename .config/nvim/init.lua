require("config.init")
require("config.keymaps")
require("config.options")

-- -----------------------------------------------------------------------------------------------
-- GENERAL CONFIGURATION
-- -----------------------------------------------------------------------------------------------
-- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildmenu = true

-- Indention
vim.opt.autoindent = true    -- auto indentation
vim.opt.expandtab = true     -- convert tabs to spaces
vim.opt.shiftwidth =2   -- the number of spaces inserted for each indentation
vim.opt.smartindent = true   -- make indenting smarter
vim.opt.softtabstop = 2 -- when hitting <BS>, pretend like a tab is removed, even if spaces
vim.opt.tabstop = 2     -- insert 2 spaces for a tab
vim.opt.shiftround = true    -- use multiple of shiftwidth when indenting with "<" and ">"

--
-- -----------------------------------------------------------------------------------------------
-- PLUGINS
-- -----------------------------------------------------------------------------------------------
--
--
-- -----------------------------------------------------------------------------------------------
-- KEYMAPS
-- -----------------------------------------------------------------------------------------------
--
--
-- -----------------------------------------------------------------------------------------------
-- LSP
-- -----------------------------------------------------------------------------------------------
