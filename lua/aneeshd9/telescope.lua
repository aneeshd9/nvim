local status_ok, builtin = pcall(require, 'telescope.builtin')
if not status_ok then
  return
end

local wk_status_ok, wk = pcall(require, 'which-key')
if not wk_status_ok then
  return
end

local opts = {
  prefix = '<leader>'
}

local keymaps = {
  t = {
    name = 'telescope',
    f = { builtin.find_files, 'Find Files' },
    g = { builtin.live_grep, 'Live grep' },
    b = { builtin.buffers, 'Buffers' },
    h = { builtin.help_tags, 'Help Tags' },
    t = { '<cmd>TodoTelescope<cr>', 'Todos' },
  },
}

wk.register(keymaps, opts)

local t_status_ok, telescope = pcall(require, 'telescope')
if not t_status_ok then
  return
end

telescope.setup({
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown {

      }
    },
  },
})

telescope.load_extension('ui-select')
