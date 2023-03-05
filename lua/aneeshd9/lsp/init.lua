require 'aneeshd9.lsp.mason'

local icons = require 'aneeshd9.icons'
local signs = {

  { name = 'DiagnosticSignError', text = icons.diagnostics.Error },
  { name = 'DiagnosticSignWarn', text = icons.diagnostics.Warning },
  { name = 'DiagnosticSignHint', text = icons.diagnostics.Hint },
  { name = 'DiagnosticSignInfo', text = icons.diagnostics.Information },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
end

local config = {
  signs = {
    active = signs,
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
}

vim.diagnostic.config(config)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})
