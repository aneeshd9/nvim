local M = {}

function M.setup()
  local is_bootstrap = false

  local packer_config = {
    profile = {
      enable = true,
      threshold = 0,
    },
    display = {
      open_fn = function()
        return require('packer.util').float { border = 'rounded' }
      end,
    },
  }

  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
      fn.system {
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path,
      }
      is_bootstrap = true
      vim.cmd [[packadd packer.nvim]]
    end

    local packer_group = vim.api.nvim_create_augroup('packer_user_config', { clear = true })
    vim.api.nvim_create_autocmd(
      { 'BufWritePost' },
      { pattern = vim.fn.expand '$MYVIMRC', command = 'source <afile> | PackerSync', group = packer_group }
    )
  end

  local function plugins(use)
    use { 'wbthomason/packer.nvim' }

    -- Colorscheme
    use {
      'folke/tokyonight.nvim',
      config = function()
        vim.cmd.colorscheme [[tokyonight]]
      end,
      disable = false,
    }

    -- Startup screen
    use {
      'goolord/alpha-nvim',
      config = function()
        require('aneeshd9.alpha').setup()
      end,
    }

    -- icons
    use {
      'nvim-tree/nvim-web-devicons',
      module = 'nvim-web-devicons',
      config = function()
        require('nvim-web-devicons').setup { default = true }
      end,
    }

    -- Completion
    use {
      'hrsh7th/nvim-cmp',
      config = function()
        require('aneeshd9.cmp').setup()
      end,
      requires = {
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-nvim-lua',
        'saadparwaiz1/cmp_luasnip',
        { 'hrsh7th/cmp-nvim-lsp', module = { 'cmp_nvim_lsp' } },
        'hrsh7th/cmp-nvim-lsp-signature-help',
        { 'onsails/lspkind-nvim', module = { 'lspkind' } },
        {
          'L3MON4D3/LuaSnip',
          config = function()
            require('aneeshd9.snippets').setup()
          end,
          module = { 'luasnip' },
        },
        'rafamadriz/friendly-snippets',
      },
    }

    -- Which-key
    use {
      'folke/which-key.nvim',
      event = 'VimEnter',
      module = { 'which-key' },
      config = function()
        -- require('aneeshd9.whichkey').setup()
      end,
      disable = false,
    }

    -- LSP
    use {
      'neovim/nvim-lspconfig',
      config = function()
        require('aneeshd9.lsp').setup()
      end,
      requires = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        { 'jayp0521/mason-null-ls.nvim' },
        'folke/neodev.nvim',
        'RRethy/vim-illuminate',
        'jose-elias-alvarez/null-ls.nvim',
        {
          'j-hui/fidget.nvim',
          config = function()
            require('fidget').setup {}
          end,
        },
        { 'b0o/schemastore.nvim', module = { 'schemastore' } },
        {
          'SmiteshP/nvim-navic',
          config = function()
            require('nvim-navic').setup {}
          end,
          module = { 'nvim-navic' },
        },
        {
          'simrat39/inlay-hints.nvim',
          config = function()
            require('inlay-hints').setup()
          end,
        },
      },
    }

    -- trouble.nvim
    use {
      'folke/trouble.nvim',
      cmd = { 'TroubleToggle', 'Trouble' },
      module = { 'trouble.providers.telescope' },
      config = function()
        require('trouble').setup {
          use_diagnostic_signs = true,
        }
      end,
    }

    -- renamer
    use {
      'filipdutescu/renamer.nvim',
      module = { 'renamer' },
      config = function()
        require('renamer').setup {}
      end,
    }

    -- lspsaga.nvim
    use {
      'glepnir/lspsaga.nvim',
      cmd = { 'Lspsaga' },
      config = function()
        require('aneeshd9.lspsaga').setup()
      end,
    }

    -- Telescope
    use {
      'nvim-telescope/telescope.nvim',
      event = { 'VimEnter' },
      config = function()
        require('aneeshd9.telescope').setup()
      end,
      requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
        },
        { 'nvim-telescope/telescope-project.nvim' },
        { 'cljoly/telescope-repo.nvim' },
        { 'nvim-telescope/telescope-file-browser.nvim' },
        {
          'ahmedkhalf/project.nvim',
          config = function()
            require('aneeshd9.project').setup()
          end,
        },
        { 'nvim-telescope/telescope-dap.nvim' },
        {
          'AckslD/nvim-neoclip.lua',
          requires = {
            { 'tami5/sqlite.lua', module = 'sqlite' },
          },
        },
        { 'nvim-telescope/telescope-smart-history.nvim' },
        { 'nvim-telescope/telescope-media-files.nvim' },
        { 'dhruvmanila/telescope-bookmarks.nvim' },
        { 'nvim-telescope/telescope-github.nvim' },
        { 'jvgrootveld/telescope-zoxide' },
        'nvim-telescope/telescope-symbols.nvim',
      },
    }

    -- debuuger
    use {
      'mfussenegger/nvim-dap',
      opt = true,
      module = { 'dap' },
      requires = {
        { 'theHamsta/nvim-dap-virtual-text', module = { 'nvim-dap-virtual-text' } },
        { 'rcarriga/nvim-dap-ui', module = { 'dapui' } },
        { 'mfussenegger/nvim-dap-python', module = { 'dap-python' } },
        'nvim-telescope/telescope-dap.nvim',
      },
      config = function()
        require('aneeshd9.dap').setup()
      end,
      disable = false,
    }

    if is_bootstrap then
      require('packer').sync()
    end
  end

  packer_init()

  local packer = require('packer')
  packer.init(packer_config)
  packer.startup(plugins)
end

return M
