local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Plugins
return packer.startup(
  function(use)
    use({ "wbthomason/packer.nvim", opt = true })

    ----------------------
    -- Utilities Plugins
    ----------------------
    use 'nvim-lua/popup.nvim'   -- An implementation of the Popup API from vim in Neovim
    use 'nvim-lua/plenary.nvim' -- Useful lua functions used ny lots of plugins

    use 'tpope/vim-repeat'      -- Allows to repeat plugin maps
    use 'echasnovski/mini.surround' -- Manage sorroundings of text

    -- Manage marks as well as show in the left bar
    use 'chentoast/marks.nvim'

    -- Like emacs popup for showing bindings
    use 'folke/which-key.nvim'

    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'

    ----------------------
    -- Format text Plugins
    ----------------------

    -- IndentLine
    use 'lukas-reineke/indent-blankline.nvim'

    -- Better way of commenting
    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end
    }

    -- Better way of folding code in files
    use { 'anuvyklack/pretty-fold.nvim',
      config = function()
        require('pretty-fold').setup({})
      end
    }

    -- Auto open and close brackets
    use {
      'windwp/nvim-autopairs',
    }

    ------------------
    -- Movement Plugins
    ------------------

    -- Amazing plugin for jumping around
    use { 'ggandor/leap.nvim' }
    use { 'ggandor/flit.nvim' }
    use { 'wellle/targets.vim' }

    ------------------
    -- UI Plugins
    ------------------

    -- Simple Init page for nvim
    use 'mhinz/vim-startify'

    -- Theme plugin
    use { 'catppuccin/nvim', as = 'catppuccin' }

    -- Open state for resizing windows and switch, its amazing
    use 'simeji/winresizer'

    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    -- Buffer line at the top
    use {
      'akinsho/bufferline.nvim',
      event = 'BufReadPre',
      wants = 'nvim-web-devicons',
      config = function()
        require('bufferline').setup()
      end,
    }

    ------------------
    -- CMP Plugins
    ------------------

    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'

    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'

    use 'hrsh7th/nvim-cmp'

    use 'L3MON4D3/LuaSnip'
    use 'rafamadriz/friendly-snippets'
    use 'saadparwaiz1/cmp_luasnip'

    use {
      'petertriho/cmp-git',
      requires = 'nvim-lua/plenary.nvim'
    }

    -- -- Github Copilot completion
    -- use {
    --   'zbirenbaum/copilot.lua',
    --   cmd = 'Copilot',
    --   event = 'InsertEnter',
    --   config = function()
    --     require('copilot').setup({})
    --   end,
    -- }
    --
    -- -- Integrate copilot in cmp
    -- use {
    --   'zbirenbaum/copilot-cmp',
    --   after = { 'copilot.lua' },
    --   config = function()
    --     require('copilot_cmp').setup()
    --   end
    -- }

    use({
      'nvimdev/lspsaga.nvim',
      after = 'nvim-lspconfig',
      config = function()
        require('lspsaga').setup({})
      end,
    })

    ---------------------------
    -- Treesitter
    ---------------------------

    -- Treesitter
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ":TSUpdate",
    }

    use 'nvim-treesitter/playground'

    ---------------------------
    -- File Explorer Plugins
    ---------------------------

    use 'tpope/vim-vinegar' -- Better Netrw

    -- Best fuzzy file explorer ever
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'

    -- Extend functionality of fzf for searching Definitions, Diagnostics..
    use 'gfanto/fzf-lsp.nvim'

    use {
      'nvim-telescope/telescope.nvim',
      requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use {
      'nvim-tree/nvim-tree.lua',
      requires = {
        'nvim-tree/nvim-web-devicons',
      },
    }

    ------------------
    -- Git Plugins
    ------------------

    -- Git wrapper
    use 'tpope/vim-fugitive'

    -- Git signs
    use 'lewis6991/gitsigns.nvim'

    -- Git diff view
    use 'sindrets/diffview.nvim'

    use {
      'akinsho/git-conflict.nvim',
      config = function()
        require('git-conflict').setup()
      end }

    ------------------
    -- TMUX Plugins
    ------------------

    -- AMAZING Lets use the same keys to map from vim to tmux and back
    use 'christoomey/vim-tmux-navigator'

    -- Add spawning a tmux from nvim easyy
    use 'preservim/vimux'

    ------------------
    -- Language Plugins
    ------------------

    -- Debugger for neovim
    use 'mfussenegger/nvim-dap'

    -- Scala metals
    use({
      'scalameta/nvim-metals',
      requires = {
        'nvim-lua/plenary.nvim',
        'mfussenegger/nvim-dap',
      },
    })

    use { 'rcarriga/nvim-dap-ui',
      requires = { 'mfussenegger/nvim-dap' }
    }

    -- Add helm support
    use 'towolf/vim-helm'

    -- Theme support
    use 'maxmx03/fluoromachine.nvim'

    -- Lua
    use {
      "ahmedkhalf/project.nvim",
      config = function()
        require("project_nvim").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    }

    -- Edit fiels like buffer
    use {
      "stevearc/oil.nvim",
      config = function()
        require("oil").setup()
      end
    }


    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
      require("packer").sync()
    end
  end
)
