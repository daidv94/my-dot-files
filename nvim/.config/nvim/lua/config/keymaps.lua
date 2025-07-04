vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- pressing "Q" in normal mode enters Ex mode, this line to disable it
vim.keymap.set("n", "Q", "<nop>")

-- vim.keymap.set("i", "<C-h>", "<Left>", { desc = "move left" })
-- vim.keymap.set("i", "<C-l>", "<Right>", { desc = "move right" })
-- vim.keymap.set("i", "<C-j>", "<Down>", { desc = "move down" })
-- vim.keymap.set("i", "<C-k>", "<Up>", { desc = "move up" })
vim.keymap.set("i", "jj", "<Esc>")

-- Switch to last opened buffer
vim.keymap.set("n", "<leader><leader>", "<C-^>", { noremap = true, silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]])
vim.keymap.set("x", "P", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("n", "ycc", '"yy" . v:count1 . "gcc\']p"', { remap = true, expr = true })
-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set(
  { "v" },
  "<leader>r",
  '"hy:%s/<C-r>h/<C-r>h/gc<left><left><left>',
  { desc = "Open search and replace for currently selected text" }
)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- vim.keymap.set("n", "<leader>eh", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

vim.keymap.set("n", "<C-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<leader>o", ":normal o<CR>")
vim.keymap.set("n", "<leader>O", ":normal O<CR>")

-- Jump cursor to the end of visual selection after yanking
vim.keymap.set("x", "y", "ygv<esc>", { desc = "Yank selection" })

-- Remap ` to ' in normal mode, mostly use to jump to exact mark position
vim.keymap.set("n", "'", "`", { noremap = true, desc = "Remap ` to ' in normal mode" })

-- Quickfix list keymap
vim.keymap.set("n", "<leader>qo", ":copen<CR>")
vim.keymap.set("n", "<leader>qc", ":cclose<CR>")
vim.keymap.set("n", "H", ":cprev<CR>")
vim.keymap.set("n", "L", ":cnext<CR>")

vim.keymap.set("n", "<leader>qr", [[:cfdo %s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "<leader>qr", [[hy:cfdo %s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Markdown keymap
vim.keymap.set("n", "<leader>m", ":MarkdownPreviewToggle<CR>")

-- Copy current buffer path
vim.keymap.set("n", "<leader>cf", ':let @+ = expand("%:p")<CR>', { desc = "Copy absolute file path" })
-- Copy current buffer parent directory
vim.keymap.set("n", "<leader>cd", ':let @+ = expand("%:p:h")<CR>', { desc = "Copy absolute directory path" })
-- Copy current relative buffer parent directory
vim.keymap.set("n", "<leader>cr", ':let @+ = expand("%:h")<CR>', { desc = "Copy relative directory path" })

vim.keymap.set("x", "/", "<Esc>/\\%V") --search within visual selection

vim.keymap.set('n', '<leader>ca', '<cmd>ClaudeCode<CR>', { desc = 'Toggle Claude Code' })
