-- Remove default staus line
vim.opt.laststatus = 0

require('lualine').setup {
tabline = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },

  sections = {},
  inactive_sections = {},

}
