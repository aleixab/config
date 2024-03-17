local wk = require("which-key")

wk.register({
  -- Normal Mode Mappings
  ["<leader>"] = {
    h = { ":wincmd h<CR>", "Window Left" },
    j = { ":wincmd j<CR>", "Window Down" },
    k = { ":wincmd k<CR>", "Window Up" },
    l = { ":wincmd l<CR>", "Window Right" },
    to = { ":VimuxOpenRunner<CR>", "Open Vimux Runner" },
    tp = { ":silent !tmux popup -d $(pwd)<CR>", "Tmux Popup" },
    cl = { "<cmd>lua vim.lsp.codelens.run()<CR>", "LSP Codelens Run" },
    ct = { "<cmd>lua vim.lsp.codelens.test()<CR>", "LSP Codelens Test" },
    sh = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "LSP Signature Help" },
    rn = { "<cmd>lua vim.lsp.buf.rename()<CR>", "LSP Rename" },
    f = {
      name = "file",
      f = { "<cmd>Telescope find_files<CR>", "Files" },
      g = { "<cmd>Telescope find_files<CR>", "Help Tags" },
      r = { "<cmd>Telescope live_grep<CR>", "Ripgrep" },
      c = { "<cmd>Telescope commands<CR>", "Commands" },
      b = { "<cmd>Telescope buffers<CR>", "Buffers" },
      h = { "<cmd>Telescope help_tags<CR>", "Help Tags" },
    },
    ca = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "LSP Code Action" },
    ws = { '<cmd>lua require"metals".hover_worksheet()<CR>', "LSP Metals Hover Worksheet" },
    aa = { "<cmd>lua vim.diagnostic.setqflist()<CR>", "All Workspace Diagnostics" },
    ae = { "<cmd>lua vim.diagnostic.setqflist({severity = \"E\"})<CR>", "All Workspace Errors" },
    aw = { "<cmd>lua vim.diagnostic.setqflist({severity = \"W\"})<CR>", "All Workspace Warnings" },
    dd = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Buffer Diagnostics Only" },
    dh = { "<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<CR>", "Buffer Diagnostics Float" },
    xx = { "<cmd>TroubleToggle<CR>", "Trouble Toggle" },
    xw = { "<cmd>TroubleToggle workspace_diagnostics<CR>", "Trouble Workspace Diagnostics" },
    xd = { "<cmd>TroubleToggle document_diagnostics<CR>", "Trouble Document Diagnostics" },
    xq = { "<cmd>TroubleToggle quickfix<CR>", "Trouble Quickfix" },
    xl = { "<cmd>TroubleToggle loclist<CR>", "Trouble Loclist" },
    tt = { "<cmd>lua require'test-toggle'.toggle_between_source_and_test()<CR>", "Toggle Between Source and Test" },
  },

  -- LSP mappings
  g = {
    f = { "<cmd>lua vim.lsp.buf.format()<CR>", "LSP Format" },
    D = { "<cmd>lua vim.lsp.buf.definition()<CR>", "LSP Definition" },
    K = { "<cmd>lua vim.lsp.buf.hover()<CR>", "LSP Hover" },
    i = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "LSP Implementation" },
    r = { "<cmd>lua vim.lsp.buf.references()<CR>", "LSP References" },
    ds = { "<cmd>lua vim.lsp.buf.document_symbol()<CR>", "LSP Document Symbol" },
    ws = { "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", "LSP Workspace Symbol" },
    R = { "<cmd>TroubleToggle lsp_references<CR>", "Trouble LSP References" },
  },
  ["-"] = { "<cmd>Oil<CR>", "Open parent directory" },
})

