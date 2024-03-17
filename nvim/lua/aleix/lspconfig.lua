local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local configs = require('lspconfig.configs')
local util = require('lspconfig.util')

-- Set up LSP servers with the same config
local servers = {"jsonnet_ls", "gopls","bashls", "marksman", "jsonls", "pyright", "rust_analyzer" }
for _, lsp in pairs(servers) do
	require("lspconfig")[lsp].setup({
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
	})
end

----------------------------------
---------- Lua Setup   ----------
----------------------------------
lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

----------------------------------
---------- Helper Function -------
----------------------------------

local function is_helm_file(fname)
  return fname:match('Chart.yaml')
      or fname:match('values.yaml')
      or fname:match('templates/.*%.yaml$')
      or fname:match('templates/.*%.tpl$')
end

----------------------------------
---------- Yaml Setup   ----------
----------------------------------

lspconfig.yamlls.setup {
  capabilities = capabilities,
  settings = {
    yaml = {
      schemas = {
        ["Kubernetes"] = "globPattern"
      }
    }
  },
  filetypes = { "yaml", "yml" },
  autostart = true,
  root_dir = function(fname)
    if not is_helm_file(fname) then
      local determined_root = util.root_pattern('.git')(fname) or util.path.dirname(fname)
      return determined_root
    else
      return nil
    end
  end,
  on_attach = function(client)
    -- When a file is opened, check its filetype. If it's "helm", disable yamlls for that buffer.
    if vim.bo.filetype == "helm" then
      client.stop()
      vim.lsp.buf_detach_client(vim.api.nvim_get_current_buf(), client.id)
    end
  end,
}

----------------------------------
---------- Helm Setup   ----------
----------------------------------

if not lspconfig.helm_ls then
  configs.helm_ls = {
    default_config = {
      cmd = { "helm_ls", "serve" },
      root_dir = function(fname)
        if is_helm_file(fname) then
          return util.root_pattern('Chart.yaml', '.git')(fname) or util.path.dirname(fname)
        else
          return nil -- Prevent helm_ls from initializing for non-Helm YAML files
        end
      end,
    },
  }
end

lspconfig.helm_ls.setup {
  filetypes = { "helm" },
  cmd = { "helm_ls", "serve" },
  autostart = true,
}

------------------------------------
------------ Scala Setup   ----------
------------------------------------
--lspconfig.metals.setup{
--    capabilities = capabilities,
--    diagnostics = {
--      enable = true,
--      update_in_insert = true,
--    }
--}

-- Enable diagnositcs without saving
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = false,
})

-- In theory show comments in the comments section
function PrintDiagnostics(opts, bufnr, line_nr, client_id)
  bufnr = bufnr or 0
  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
  opts = opts or { ['lnum'] = line_nr }

  local line_diagnostics = vim.diagnostic.get(bufnr, opts)
  if vim.tbl_isempty(line_diagnostics) then return end

  local diagnostic_message = ""
  for i, diagnostic in ipairs(line_diagnostics) do
    diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
    print(diagnostic_message)
    if i ~= #line_diagnostics then
      diagnostic_message = diagnostic_message .. "\n"
    end
  end
  vim.api.nvim_echo({ { diagnostic_message, "Normal" } }, false, {})
end

vim.cmd [[ autocmd! CursorHold * lua PrintDiagnostics() ]]

-- Add signs instead of letters for the diagnostics
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
