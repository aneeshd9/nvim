local status_ok, neogit = pcall(require, 'neogit')
if not status_ok then
  return
end

local status_ok, icons = pcall(require, 'user.icons')
if not status_ok then
  return
end

neogit.setup({
  disable_hint = true,
  signs = {
    section = { icons.ui.ArrowClosed, icons.ui.ArrowOpen },
    item = { icons.ui.ArrowClosed, icons.ui.ArrowOpen },
    hunk = { icons.ui.ArrowClosed, icons.ui.ArrowOpen },
  },
})
