local M = {}

function M.setup()
  local swap_next, swap_prev = (function()
    local swap_objects = {
      p = '@parameter.inner',
      f = '@function.outer',
      c = '@class.outer',
    }

    local n, p = {}, {}
    for key, obj in pairs(swap_objects) do
      n[string.format('<Leader>cx%s', key)] = obj
      p[string.format('<Leader>cX%s', key)] = obj
    end

    return n, p
  end)()

  require('nvim-treesitter.configs').setup {
    ensure_installed = 'all',
    sync_install = false,
    highlight = {
      enable = true,
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = nil,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn',
        node_incremental = 'grn',
        scope_incremental = 'grc',
        node_decremental = 'grm',
      },
    },
    indent = { enable = true, disable = { 'python', 'java', 'rust', 'lua' } },
    matchup = {
      enable = true,
    },
    textsubjects = {
      enable = true,
      prev_selection = ',',
      keymaps = {
        ['.'] = 'textsubjects-smart',
        [';'] = 'textsubjects-container-outer',
        ['i;'] = 'textsubjects-container-inner',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
        },
        selection_modes = {
          ['@parameter.outer'] = 'v',
          ['@function.outer'] = 'V',
          ['@class.outer'] = '<c-v>',
        },
      },

      swap = {
        enable = true,
        swap_next = swap_next,
        swap_previous = swap_prev,
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
    },
    endwise = {
      enable = true,
    },
    autotag = {
      enable = true,
    },
    context_commentstring = {
      enable = true,
    },
    playground = {
      enable = true,
      disable = {},
      updatetime = 25,
      persist_queries = false,
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { 'BufWrite', 'CursorHold' },
    },
  }
end

return M
