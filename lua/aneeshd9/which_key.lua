local status_ok, wk = pcall(require, 'which-key')
if not status_ok then
  return
end

wk.setup({
  window = {
    border = 'single',
  },
})

-- These are global mappings
-- Plugin related mappings are in their own files
local keymaps = {
  g = {
    -- neogit keymaps
    name = 'neogit',
    g = { '<cmd>Neogit<cr>', 'Neogit Status' },
  },
  s = {
    -- search keymaps
    name = 'search',
    h = { '<cmd>nohlsearch<cr>', 'No Highlight Search'},
  },
}

local opts = {
  prefix = '<leader>',
}

wk.register(keymaps, opts)
