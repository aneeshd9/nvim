local status_ok, mbr = pcall(require, 'mini.bufremove')
if not status_ok then
  return
end

local wk_status_ok, wk = pcall(require, 'which-key')
if not wk_status_ok then
  return
end

local keymaps = {
  b = {
    name = 'buffer',
    d = { function() mbr.delete(0, false) end, 'Delete Buffer' },
    D = { function() mbr.delete(0, true) end, 'Delete Buffer (force)' }
  },
}

local opts = {
  prefix = '<leader>',
}

wk.register(keymaps, opts)
