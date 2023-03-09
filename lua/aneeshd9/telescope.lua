local M = {}

local trouble = require 'trouble.providers.telescope'
local icons = require 'aneeshd9.icons'

function M.setup()
  local actions = require 'telescope.actions'
  local actions_layout = require 'telescope.actions.layout'
  local telescope = require 'telescope'

  local previewers = require 'telescope.previewers'
  local Job = require 'plenary.job'
  local preview_maker = function(filepath, bufnr, opts)
    filepath = vim.fn.expand(filepath)
    Job:new({
      command = 'file',
      args = { '--mime-type', '-b', filepath },
      on_exit = function(j)
        local mime_type = vim.split(j:result()[1], '/')[1]

        if mime_type == 'text' then
          vim.loop.fs_stat(filepath, function(_, stat)
            if not stat then
              return
            end
            if stat.size > 500000 then
              return
            else
              previewers.buffer_previewer_maker(filepath, bufnr, opts)
            end
          end)
        else
          vim.schedule(function()
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'BINARY FILE' })
          end)
        end
      end,
    }):sync()
  end

  telescope.setup {
    defaults = {
      prompt_prefix = icons.ui.Telescope .. ' ',
      selection_caret = ' ',
      buffer_previewer_maker = preview_maker,
      mappings = {
        i = {
          ['<C-j>'] = actions.move_selection_next,
          ['<C-k>'] = actions.move_selection_previous,
          ['<C-n>'] = actions.cycle_history_next,
          ['<C-p>'] = actions.cycle_history_prev,
          ['<c-z>'] = trouble.open_with_trouble,
          ['?'] = actions_layout.toggle_preview,
        },
      },
      history = {
        path = vim.fn.stdpath 'data' .. '/telescope_history.sqlite3',
        limit = 100,
      },
      border = {},
      borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
      color_devicons = true,
    },
    pickers = {
      find_files = {
        theme = 'ivy',
        previewer = false,
        hidden = true,
        find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
      },
      git_files = {
        theme = 'dropdown',
        previewer = false,
      },
      buffers = {
        theme = 'dropdown',
        previewer = false,
      },
    },
    extensions = {
      arecibo = {
        ['selected_engine'] = 'google',
        ['url_open_command'] = 'xdg-open',
        ['show_http_headers'] = false,
        ['show_domain_icons'] = false,
      },
      media_files = {
        filetypes = { 'png', 'webp', 'jpg', 'jpeg', 'pdf', 'mp4', 'webm' },
        find_cmd = 'fd',
      },
      bookmarks = {
        selected_browser = 'firefox',
        url_open_command = nil,
        url_open_plugin = 'open_browser',
        full_path = true,
        firefox_profile_name = nil,
      },
      project = {
        hidden_files = false,
        theme = 'dropdown',
      },
    },
  }

  require('neoclip').setup()

  telescope.load_extension 'fzf'
  telescope.load_extension 'project'
  telescope.load_extension 'repo'
  telescope.load_extension 'file_browser'
  telescope.load_extension 'projects'
  telescope.load_extension 'dap'
  telescope.load_extension 'neoclip'
  telescope.load_extension 'smart_history'
  telescope.load_extension 'media_files'
  telescope.load_extension 'bookmarks'
  telescope.load_extension 'zoxide'
end

return M
