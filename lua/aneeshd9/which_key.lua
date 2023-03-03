local status_ok, wk = pcall(require, 'which-key')
if not status_ok then
  return
end

wk.setup({
  window = {
    border = 'single',
  },
})

local mappings = {
  g = {
    -- neogit keymaps
    name = "neogit",
    g = { "<cmd>Neogit<cr>", "Neogit Status" },
  }
}

local opts = {
  prefix = "<leader>",
}

wk.register(mappings, opts)
