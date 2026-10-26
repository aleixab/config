-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Free up <leader>n for annotate (LazyVim binds it to Notification History)
pcall(vim.keymap.del, "n", "<leader>n")

-- Optional: move notification history elsewhere instead of losing it
vim.keymap.set("n", "<leader>sn", function()
  require("snacks").notifier.show_history()
end, { desc = "Notification History" })
