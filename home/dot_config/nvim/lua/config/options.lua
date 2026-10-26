-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- No format on save; format on demand with <leader>cf (toggle back with <leader>uf)
vim.g.autoformat = false

-- Words added with zg live in the dotfiles repo (chezmoi re-add to sync them)
vim.opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

-- Softer spell marks than the default red zigzag: dotted, and only misspellings
-- stand out. Themes reset these, so apply after startup (LazyVim loads the
-- colorscheme without firing ColorScheme) and on every colorscheme change.
local function spell_highlights()
  vim.api.nvim_set_hl(0, "SpellBad", { underdotted = true, sp = "#f38ba8" })
  for _, group in ipairs({ "SpellCap", "SpellRare", "SpellLocal" }) do
    vim.api.nvim_set_hl(0, group, { underdotted = true, sp = "#585b70" })
  end
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = spell_highlights })
vim.api.nvim_create_autocmd("User", { pattern = "VeryLazy", callback = spell_highlights })
