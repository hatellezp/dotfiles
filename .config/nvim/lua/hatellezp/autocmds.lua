-- Create group to assign commands
-- "clear = true" must be set to prevent loading an
-- auto-command repeatedly every time a file is resourced
local autocmd_group = vim.api.nvim_create_augroup("Custom auto-commands", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.py" },
    desc = "Auto-format Python files after saving using the BLACK formatter",
    callback = function()
        local fileName = vim.api.nvim_buf_get_name(0)
        vim.cmd(":silent !black --preview -q " .. fileName)
        vim.cmd(":silent !isort --profile black --float-to-top -q " .. fileName)
        vim.cmd(":silent !docformatter --in-place --black " .. fileName)
    end,
    group = autocmd_group,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.rs", "src/*.rs" },
    desc = "Auto-format rust files after saving using the rust formatter",
    callback = function()
        local fileName = vim.api.nvim_buf_get_name(0)
        vim.cmd(":silent !rustfmt " .. fileName)
        vim.cmd(":silent !cargo fmt")
    end,
    group = autocmd_group,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.go" },
    desc = "Auto-format go files after saving using the go formatter",
    callback = function()
        local fileName = vim.api.nvim_buf_get_name(0)
        vim.cmd(":silent !go fmt " .. fileName)
    end,
    group = autocmd_group,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*.tex" },
  callback = function()
    vim.opt.wrap = true  -- Enable line wrapping
    vim.opt.linebreak = true  -- Break lines at word boundaries
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.tex" },
    desc = "Auto-format go files after saving using the go formatter",
    callback = function()
        local fileName = vim.api.nvim_buf_get_name(0)
        vim.cmd(":silent !latexindent " .. fileName)
        vim.cmd(":silent !pdflatex " .. fileName)
        vim.cmd(":silent !bibtex " .. fileName)
        vim.cmd(":silent !pdflatex " .. fileName)
        vim.cmd(":silent !pdflatex " .. fileName)
    end,
    group = autocmd_group,
})



-- stupid ocamlformat can't format inplace
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.ml" },
    desc = "Auto-format ocaml files using ocamlformat",
    callback = function()
        local fileName = vim.api.nvim_buf_get_name(0)
        local tempFileName = fileName .. "temp"
        vim.cmd(":silent !ocamlformat " .. fileName .. " | tee " .. tempFileName)
        vim.cmd(":silent !cp " .. tempFileName .. " " .. fileName)
        vim.cmd(":silent !rm " .. tempFileName)
    end,
    group = autocmd_group,
})




vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

