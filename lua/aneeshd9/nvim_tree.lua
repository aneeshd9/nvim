local status_ok, nvim_tree = pcall(require, 'nvim-tree')
if not status_ok then
  return
end

local icons_ok, icons = pcall(require, 'aneeshd9.icons')
if not icons_ok then
  return
end

nvim_tree.setup({
  disable_netrw = true,
  hijack_directories = {
    enable = true,
  },
  filters = {
    custom = { '.git' },
    exclude = { '.gitignore' },
  },
  update_cwd = true,
  renderer = {
    add_trailing = false,
    group_empty = false,
    highlight_git = false,
    highlight_opened_files = 'none',
    root_folder_modifier = ':t',
    indent_markers = {
      enable = false,
      icons = {
        corner = '└ ',
        edge = '│ ',
        none = '  ',
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = 'before',
      padding = ' ',
      symlink_arrow = ' ➛ ',
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = '',
        symlink = '',
        folder = {
          arrow_open = icons.ui.ArrowOpen,
          arrow_closed = icons.ui.ArrowClosed,
          default = '',
          open = '',
          empty = '',
          empty_open = '',
          symlink = '',
          symlink_open = '',
        },
        git = {
          unstaged = '',
          staged = 'S',
          unmerged = '',
          renamed = '➜',
          untracked = 'U',
          deleted = '',
          ignored = '◌',
        },
      },
    },
  },
  diagnostics = {
    enable = true,
    icons = {
      hint = icons.diagnostics.Hint,
      info = icons.diagnostics.Information,
      warning = icons.diagnostics.Warning,
      error = icons.diagnostics.Error,
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 30,
    hide_root_folder = false,
    side = 'left',
    number = false,
    relativenumber = false,
  },
})

local wk_status_ok, wk = pcall(require, 'which-key')
if not wk_status_ok then
  return
end

local keymaps = {
  e = {
    name = 'explorer',
    e = { '<cmd>NvimTreeToggle<cr>', 'Toggle NvimTree' }
  }
}

local opts = {
  prefix = '<leader>',
}

wk.register(keymaps, opts)
