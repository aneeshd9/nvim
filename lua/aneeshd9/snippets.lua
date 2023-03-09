local M = {}

function M.setup()
  local status_ok, luasnip = pcall(require, 'luasnip')
  if not status_ok then
    return
  end

  local types = require('luasnip.util.types')

  luasnip.config.set_config {
    history = true,
    updateevents = 'TextChanged,TextChangedI',
    enable_autosnippets = false,
    store_selection_keys = '<C-q>',
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { '●', 'GruvboxOrange' } },
        },
      },
      [types.insertNode] = {
        active = {
          virt_text = { { '●', 'GruvboxOrange' } },
        },
      },
    },
  }

  require('luasnip.loaders.from_vscode').lazy_load()
end

return M
