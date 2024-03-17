require("mason").setup()

require("mason-lspconfig").setup({
  -- list of servers for mason to install
  ensure_installed = {
    "lua_ls",
    "bashls",

    "marksman",
    "jsonls",
    "yamlls",
    "helm_ls",

    --"black",
    "pyright",
    "jsonnet_ls",
    "gopls",
    "rust_analyzer",
  },
  -- auto-install configured servers (with lspconfig)
  automatic_installation = true, -- not the same as ensure_installed
})
