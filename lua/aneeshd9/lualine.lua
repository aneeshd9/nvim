local M = {}

local icons = require 'aneeshd9.icons'
local lualine = require 'lualine'

local colors = {
  bg = '#202328',
  fg = '#bbc2cf',
  yellow = '#ECBE7B',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#98be65',
  orange = '#FF8800',
  violet = '#a9a1e1',
  magenta = '#c678dd',
  blue = '#51afef',
  red = '#ec5f67',
}

local function separator()
  return '%='
end

local function tab_stop()
  return icons.ui.Tab .. ' ' .. vim.bo.shiftwidth
end

local function show_macro_recording()
  local rec_reg = vim.fn.reg_recording()
  if rec_reg == '' then
    return ''
  else
    return 'recording @' .. rec_reg
  end
end

local function lsp_client(msg)
  msg = msg or ''
  local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }

  if next(buf_clients) == nil then
    if type(msg) == 'boolean' or #msg == 0 then
      return ''
    end
    return msg
  end

  -- local buf_ft = vim.bo.filetype
  local buf_client_names = {}

  for _, client in pairs(buf_clients) do
    if client.name ~= 'null-ls' then
      table.insert(buf_client_names, client.name)
    end
  end

  -- add formatter
  -- local formatters = require 'aneeshd9.lsp.null-ls.formatters'
  -- local supported_formatters = formatters.list_registered(buf_ft)
  -- vim.list_extend(buf_client_names, supported_formatters)

  -- add linter
  -- local linters = require 'aneeshd9.lsp.null-ls.linters'
  -- local supported_linters = linters.list_registered(buf_ft)
  -- vim.list_extend(buf_client_names, supported_linters)

  -- add hover
  -- local hovers = require 'aneeshd9.lsp.null-ls.hovers'
  -- local supported_hovers = hovers.list_registered(buf_ft)
  -- vim.list_extend(buf_client_names, supported_hovers)

  -- add code action
  -- local code_actions = require 'aneeshd9.lsp.null-ls.code_actions'
  -- local supported_code_actions = code_actions.list_registered(buf_ft)
  -- vim.list_extend(buf_client_names, supported_code_actions)

  local hash = {}
  local client_names = {}
  for _, v in ipairs(buf_client_names) do
    if not hash[v] then
      client_names[#client_names + 1] = v
      hash[v] = true
    end
  end
  table.sort(client_names)
  return '' .. table.concat(client_names, ', ') .. ''
end

local winbar = require 'aneeshd9.winbar'

local function get_repo_name()
  if
    #vim.api.nvim_list_tabpages() > 1 and vim.fn.trim(vim.fn.system "git rev-parse --is-inside-work-tree") == "true"
  then
    return vim.fn.trim(vim.fn.system "basename `git rev-parse --show-toplevel`")
  end
  return ""
end

local config = {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = {},
    section_separators = {},
    disabled_filetypes = {
      statusline = {},
      winbar = {
        'help',
        'startify',
        'dashboard',
        'packer',
        'neogitstatus',
        'NvimTree',
        'Trouble',
        'alpha',
        'lir',
        'Outline',
        'spectre_panel',
        'toggleterm',
        'dap-repl',
        'dapui_console',
        'dapui_watches',
        'dapui_stacks',
        'dapui_breakpoints',
        'dapui_scopes',
      },
    },
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = {
      { 'diff', colored = false },
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        diagnostics_color = {
          error = 'DiagnosticError',
          warn = 'DiagnosticWarn',
          info = 'DiagnosticInfo',
          hint = 'DiagnosticHint',
        },
        colored = true,
      },
      { separator },
      {
        'macro-recording',
        fmt = show_macro_recording,
      },
      { separator },
      {
        lsp_client,
        icon = icons.ui.Code,
        on_click = function()
          vim.cmd [[LspInfo]]
        end,
      },
    },
    lualine_x = { 'filename', { tab_stop }, 'encoding', 'fileformat', 'filetype', 'progress' },
    lualine_y = {},
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {
    lualine_a = { { get_repo_name } },
    lualine_b = {
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        diagnostics_color = {
          error = 'DiagnosticError',
          warn = 'DiagnosticWarn',
          info = 'DiagnosticInfo',
          hint = 'DiagnosticHint',
        },
        colored = true,
        on_click = function()
          vim.diagnostic.setloclist()
        end,
      },
    },
    lualine_c = {},
    lualine_x = {
      {
        winbar.get_winbar,
        color = { fg = colors.violet, gui = 'bold' },
      },
    },
    lualine_y = {},
    lualine_z = {},
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  -- extensions = { 'nvim-tree', 'toggleterm', 'quickfix' },
}

function M.setup()
  lualine.setup(config)
end

return M
