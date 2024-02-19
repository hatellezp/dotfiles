vim.opt.nu = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = { "100", "120" }

vim.opt.listchars = {
    trail = ".",
    lead = ".",
    tab = "·\\⇨",
    extends = "▶",
    precedes = "◀",
    nbsp = "␣",
    eol = "↵"
}
vim.opt.list = true

vim.g.rustfmt_autosave = 1
vim.g.rustfmt_autosave = 1

-- try to format on save
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
