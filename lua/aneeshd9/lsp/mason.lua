local status_ok, mason = pcall(require, 'mason')
if not status_ok then
  return
end

local status_ok_1, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not status_ok_1 then
  return
end

-- List of mason servers to configure
local servers = {
  'jdtls',
  'pyright',
  'clangd',
  'lua_ls',
}

-- mason settings
local settings = {
  ui = {
    border = 'rounded',
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}

-- Apply mason settings and install the servers.
mason.setup(settings)
mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_status_ok then
  return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  return
end

capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

local function attach_navic(client, bufnr)
  vim.g.navic_silence = true
  local nv_status_ok, navic = pcall(require, "nvim-navic")
  if not nv_status_ok then
    return
  end
  navic.attach(client, bufnr)
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "cd", "<cmd>Telescope lsp_definitions<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "cD", "<cmd>Telescope lsp_declarations<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "cI", "<cmd>Telescope lsp_implementations<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "cr", "<cmd>Telescope lsp_references<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "cl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.format({ async = true })' ]]
  vim.api.nvim_buf_set_keymap(bufnr, "n", "cs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<M-f>", "<cmd>Format<cr>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<M-a>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
end

local on_attach = function (client, bufnr)
  lsp_keymaps(bufnr)
  attach_navic(client, bufnr)
end

for _, server in pairs(servers) do
  if server == 'jdtls' then
    goto continue
  end

  local opts = {
    on_attach = on_attach,
    capabilites = capabilities,
  }
  server = vim.split(server, "@")[1]
  lspconfig[server].setup(opts)
    ::continue::
end
