-- local vimtex = require('vimtex')
--
-- Enable filetype detection, plugins, and indentation
vim.cmd("filetype plugin indent on")

-- Enable syntax highlighting
vim.cmd("syntax enable")

-- Set VimTeX viewer method
vim.g.vimtex_view_method = 'zathura'

-- Alternative generic viewer settings
vim.g.vimtex_view_general_viewer = 'okular'
vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'

-- Set compiler method
vim.g.vimtex_compiler_method = 'latexrun'

-- Set local leader key for VimTeX mappings
vim.g.maplocalleader = ","


