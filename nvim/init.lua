-- General options of vim
require "options"

-- General or helper funcitons for neovim
require "globals"

-- All remapings of keys
require "aleix.keymaps"

-- Plugin manager and all plugins
require "aleix.plugins"

-- Nvimtree config
require "aleix.treesitter"

-- Scala config minimal
require "aleix.scala"

-- Netrw plugin configuration
require "aleix.netrw"

-- Lsp server installer
require "aleix.mason"

-- LSP plugin configuration
require "aleix.lspconfig"

-- -- Autocomplete plugin configuration
require "aleix.cmp"

-- Whichkey personal config
require "aleix.whichkey"

-- Lualine personal config
require "aleix.lualine"

-- Indentblankline personal config
require "aleix.indentblankline"

-- -- Autopairs config
require "aleix.autopairs"

-- Nvimtree config
require "aleix.nvimtree"

-- -- Autopairs config
require "aleix.gitsigns"

-- -- Autopairs config
require "aleix.marks"




------------------
-- Themes
------------------

-- Themes
vim.cmd("colorscheme catppuccin-mocha")
-- local fm = require 'fluoromachine'
--
-- fm.setup {
--   glow = true,
--   theme = 'retrowave',
--   transparent = 'full',
-- }
--
-- vim.cmd.colorscheme('fluoromachine')




------------------
-- Configuration
------------------

-- Enable debug for lsp protocol
-- vim.lsp.set_log_level("debug")

-- -- List of autocommands
-- local autoCommands = {
--     -- other autocommands
--     open_folds = {
--         -- Unfold code on enter buffer, not needed if fold level is high
--         {"BufWinEnter,BufReadPost,FileReadPost", "*", "normal zR"}
--     }
-- }
-- M.nvim_create_augroups(autoCommands)

-- Motions
require('leap').add_default_mappings()
require('flit').setup()


require("cmp_git").setup()

require("dapui").setup()
