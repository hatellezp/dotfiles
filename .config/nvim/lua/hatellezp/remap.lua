
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- FloaTerm configuration
vim.keymap.set('n', "<leader>ft", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=2 <CR> ")
-- vim.keymap.set('n', "<leader>cr", ":FloatermNew --name=cargorun --height=0.8 --width=0.7 --autoclose=0 --cmd=\"cargo run\" <CR> ")
-- vim.keymap.set('n', "<leader>cb", ":FloatermNew --name=cargobuild --height=0.8 --width=0.7 --autoclose=0 --cmd='cargo build' <CR> ")
vim.keymap.set('n', "t", ":FloatermToggle myfloat<CR>")
vim.keymap.set('t', "<Esc>", "<C-\\><C-n>:q<CR>")

-- cargo run and build
vim.keymap.set('n', "<leader>cr", ":!cargo fmt; cargo run <CR>")
vim.keymap.set('n', "<leader>cb", ":!cargo fmt; cargo build <CR>")

-- ocaml run and build
vim.keymap.set('n', "<leader>ob", ":!opam exec -- dune build <CR>")
vim.keymap.set('n', "<leader>or", function()
    vim.cmd(string.format("!opam exec -- dune build && opam exec -- dune exec %s", vim.fn.input("project: ")))
end)
vim.keymap.set('n', '<leader>ou', ":FloatermNew --name=ocamlutop --height=0.8 --width=0.7 --autoclose=0 opam exec -- dune utop <CR>")
vim.keymap.set('n', "<leader>ot", ":FloatermToggle ocamlutop<CR>")

-- go run and build
vim.keymap.set('n', "<leader>gr", ":!go fmt; go vet .; go run . <CR>")
vim.keymap.set('n', "<leader>gb", ":!go fmt; go vet .; go build <CR>")

-- split
vim.keymap.set("n", "<leader>sv", ":vsplit <CR>")
vim.keymap.set("n", "<leader>sh", ":split <CR>")


vim.keymap.set("n", "<leader>ff", ":Format <CR>")
vim.keymap.set("n", "<leader>fF", ":FormatWrite <CR>")

