local status_ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end

treesitter_configs.setup({
  ensure_installed = 'all',
  sync_install = true,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  }
})
