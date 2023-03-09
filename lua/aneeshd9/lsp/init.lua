local M = {}

local servers = {
  jsonls = {
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
      },
    },
  },
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = 'off',
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'workspace',
        },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
        },
        diagnostics = {
          globals = { 'vim', 'describe', 'it', 'before_each', 'after_each', 'packer_plugins', 'MiniTest' },
        },
        workspace = {
          checkThirdParty = false,
        },
        completion = { callSnippet = 'Replace' },
        telemetry = { enable = false },
        hint = {
          enable = false,
        },
      },
    },
  },
  vimls = {},
  yamlls = {
    schemastore = {
      enable = true,
    },
    settings = {
      yaml = {
        hover = true,
        completion = true,
        validate = true,
        schemas = require('schemastore').json.schemas(),
      },
    },
  },
  jdtls = {},
  bashls = {},
  clangd = {},
}

function M.on_attach(client, bufnr)
  local caps = client.server_capabilities

  if caps.completionProvider then
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
  end

  if caps.documentFormattingProvider then
    vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr()'
  end

  require('aneeshd9.lsp.keymaps').setup(client, bufnr)

  require('aneeshd9.lsp.highlighter').setup(client, bufnr)

  -- require('aneeshd9.lsp.null-ls.formatters').setup(client, bufnr)

  if caps.definitionProvider then
    vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
  end

  if client.name == 'jdtls' then
    require('jdtls').setup_dap { hotcodereplace = 'auto' }
    require('jdtls.dap').setup_dap_main_class_configs()
    vim.lsp.codelens.refresh()
  end

  if caps.documentSymbolProvider then
    local navic = require 'nvim-navic'
    navic.attach(client, bufnr)
  end

  if client.name ~= 'null-ls' then
    local ih = require 'inlay-hints'
    ih.on_attach(client, bufnr)
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}
M.capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local opts = {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}

require('aneeshd9.lsp.handlers').setup()

function M.setup()
  -- require('aneeshd9.lsp.null-ls').setup(opts)
  require('aneeshd9.lsp.installer').setup(servers, opts)
  require('aneeshd9.lsp.inlay-hints').setup()
end

local diagnostics_active = true

function M.toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end

return M
