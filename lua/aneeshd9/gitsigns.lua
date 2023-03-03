local status_ok, gitsigns = pcall(require, 'gitsigns')
if not status_ok then
  return
end

gitsigns.setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local wk_status_ok, wk = pcall(require, 'which-key')

    if not wk_status_ok then
      return
    end

    opts = {
      buffer = bufnr,
      prefix = "<leader>"
    }

    keymaps = {
      g = {
        s = { gs.stage_buffer, 'Stage Buffer' },
        r = { gs.reseet_buffer, 'Reset Buffer' },
        h = {
          name = 'hunk',
          s = { "<cmd>Gitsigns stage_hunk<cr>", 'Stage Hunk' },
          u = { gs.undo_stage_hunk, 'Undo Stage Hunk' },
          r = { '<cmd>Gitsigns reset_hunk<cr>', 'Reset Hunk' },
          P = { gs.preview_hunk, 'Preview Hunk' },
          n = {
            function()
              vim.schedule(function() gs.next_hunk() end)
              return '<Ignore>'
            end,
            'Next Hunk'
          },
          p = {
            function()
              vim.schedule(function() gs.prev_hunk() end)
              return '<Ignore>'
            end,
            'Previous Hunk'
          },
        },
      },
    }

    wk.register(keymaps, opts)
  end,
})
