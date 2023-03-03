local status_ok, notify = pcall(require, 'notify')
if not status_ok then
  vim.notify('nvim-notify not found')
  return
end

vim.notify = notify

