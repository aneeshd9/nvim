local M = {}

local function configure()
  local dap_breakpoint = {
    breakpoint = {
      text = '',
      texthl = 'LspDiagnosticsSignError',
      linehl = '',
      numhl = '',
    },
    rejected = {
      text = '',
      texthl = 'LspDiagnosticsSignHint',
      linehl = '',
      numhl = '',
    },
    stopped = {
      text = '',
      texthl = 'LspDiagnosticsSignInformation',
      linehl = 'DiagnosticUnderlineInfo',
      numhl = 'LspDiagnosticsSignInformation',
    },
  }

  vim.fn.sign_define('DapBreakpoint', dap_breakpoint.breakpoint)
  vim.fn.sign_define('DapStopped', dap_breakpoint.stopped)
  vim.fn.sign_define('DapBreakpointRejected', dap_breakpoint.rejected)
end

local function configure_exts()
  require('nvim-dap-virtual-text').setup {
    commented = true,
  }

  local dap, dapui = require 'dap', require 'dapui'
  dapui.setup {
    expand_lines = true,
    icons = { expanded = '', collapsed = '', circular = '' },
    mappings = {
      expand = { '<CR>', '<2-LeftMouse>' },
      open = 'o',
      remove = 'd',
      edit = 'e',
      repl = 'r',
      toggle = 't',
    },
    windows = { indent = 1 },
    render = {
      max_type_length = nil,
    },
    layouts = {
      {
        elements = {
          { id = 'scopes', size = 0.33 },
          { id = 'breakpoints', size = 0.17 },
          { id = 'stacks', size = 0.25 },
          { id = 'watches', size = 0.25 },
        },
        size = 0.33,
        position = 'right',
      },
      {
        elements = {
          { id = 'repl', size = 0.45 },
          { id = 'console', size = 0.55 },
        },
        size = 0.27,
        position = 'bottom',
      },
    },
    floating = {
      max_height = 0.9,
      max_width = 0.5,
      border = vim.g.border_chars,
      mappings = {
        close = { 'q', '<Esc>' },
      },
    },
  }
  dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
  end
end

local function configure_debuggers()
  require('aneeshd9.dap.lua').setup()
  require('aneeshd9.dap.python').setup()
  require('aneeshd9.dap.cpp').setup()
end

function M.setup()
  configure()
  configure_exts()
  configure_debuggers()
  require('aneeshd9.dap.keymaps').setup()
end

configure_debuggers()

return M