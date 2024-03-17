-- Treesitter Plugin Setup
require('nvim-treesitter.configs').setup {
  ensure_installed = { "jsonnet", "go", "lua", "rust", "toml", "scala" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = disable_function,
  },
  ident = { enable = true },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}

-- Treesitter folding 
local vim = vim
local opt = vim.opt

-- Set fold level high so it does not fold everything by default
opt.foldlevel = 9
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
