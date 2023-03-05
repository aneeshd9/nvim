local status_ok, tokyonight = pcall(require, 'tokyonight')
if not status_ok then
  return
end

tokyonight.setup({
  style = 'night',
  transparent = 'false',
  terminal_colors = 'true',
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    sidebars = 'light',
    floats = 'dark'
  }
})

local colorscheme = 'tokyonight'
vim.cmd.colorscheme(colorscheme)
