local term_opts = { silent = true }

-- Shorten function name
function keymap(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--Remap space as leader key
keymap("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>")

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

------------
-- Normal --
------------
-- Better window navigation

keymap("n", "<leader>h", ":wincmd h<CR>")
keymap("n", "<leader>j", ":wincmd j<CR>")
keymap("n", "<leader>k", ":wincmd k<CR>")
keymap("n", "<leader>l", ":wincmd l<CR>")

-- Good to integrate with tmux
keymap("n", "c-h", ":wincmd h<CR>")
keymap("n", "c-j", ":wincmd j<CR>")
keymap("n", "c-k", ":wincmd k<CR>")
keymap("n", "c-l", ":wincmd l<CR>")

vim.cmd[[
augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
  nnoremap <buffer> <c-l> :wincmd l<cr>
endfunction
]]

-- Vimux, terminal call from nvim
keymap("n", "<c-t>", ":VimuxTogglePane<CR>")
keymap("n", "<leader>to", ":VimuxOpenRunner<CR>")
keymap("n", "<leader>tp", ":silent !tmux popup -d $(pwd)<CR>")


-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>")
keymap("n", "<S-h>", ":bprevious<CR>")

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi")
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi")

------------
-- Visual --
------------
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

------------------
-- Visual Block --
------------------
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)


----------------------------------
-- OPTIONS -----------------------
----------------------------------
-- global
vim.opt_global.completeopt = { "menu", "noinsert", "noselect" }
-- vim.opt_global.shortmess:remove("F"):append("c")

-- ----------------------------------
-- -- LSP mappings -----------------------
-- ----------------------------------
-- keymap("n", "gD", "<cmd>lua vim.lsp.buf.definition()<CR>")
-- keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
-- keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
-- keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
-- keymap("n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
-- keymap("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
-- keymap("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
-- keymap("n", "<leader>ct", [[<cmd>lua vim.lsp.codelens.test()<CR>]])
-- keymap("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
-- keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
-- keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>")
-- keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
-- keymap("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
-- keymap("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]]) -- all workspace diagnostics
-- keymap("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
-- keymap("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings
-- keymap("n", "<leader>dd", "<cmd>lua vim.diagnostic.setloclist()<CR>") -- buffer diagnostics only
-- keymap("n", "<leader>dh", "<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<CR>") -- buffer diagnostics only

keymap("n", "[c", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>")
keymap("n", "]c", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>")

-- ----------------------------------
-- -- LSP Trouble diagnositcs -----------------------
-- ----------------------------------
-- keymap("n", "<leader>xx", "<cmd>TroubleToggle<CR>")
-- keymap("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>")
-- keymap("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>")
-- keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<CR>")
-- keymap("n", "<leader>xl", "<cmd>TroubleToggle loclist<CR>")
-- keymap("n", "gR",  "<cmd>TroubleToggle lsp_references<CR>")

-- Example mappings for usage with nvim-dap. If you don't use that, you can
-- skip these
keymap("n", "<leader>do", [[<cmd>lua require"dapui".open()<CR>]])
keymap("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]])
keymap("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
keymap("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
keymap("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
keymap("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
keymap("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])
keymap("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]])

keymap("n", "<c-t>", "<cmd>lua Black()<CR>")
