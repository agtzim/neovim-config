-- My init.lua

vim.opt.number = true
vim.opt.guifont = 'Cascadia Code PL:h11'

require('aggelos.packer')

-- Treesitter
require('aggelos.treesitter')


require('tokyonight').load()


require('aggelos.autopairs')
