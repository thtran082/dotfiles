-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- remap save to save all
vim.keymap.set("n", ":w", ":wa")
vim.keymap.set("n", ":W", ":wa")

-- stupid :Q
vim.keymap.set("n", ":Q", ":q")

vim.keymap.set("n", ":e", ":e!")
vim.keymap.set("n", ":E", ":e!")

-- format current buffer via conform (prettierd/prettier) -- replaces :Prettier
local function format_buffer()
  require("conform").format({ async = true, lsp_format = "fallback" })
end
vim.keymap.set("n", ":f", format_buffer)
vim.keymap.set("n", ":F", format_buffer)

-- macOS: reveal / open / preview the current file
vim.keymap.set("n", "<leader>oo", function()
  vim.system({ "open", "-R", vim.fn.expand("%:p") })
end, { desc = "Reveal in Finder" })
vim.keymap.set("n", "<leader>oO", function()
  vim.system({ "open", vim.fn.getcwd() })
end, { desc = "Open cwd in Finder" })
vim.keymap.set("n", "<leader>oq", function()
  vim.system({ "qlmanage", "-p", vim.fn.expand("%:p") })
end, { desc = "Quick Look preview" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", '"_dP')

-- next greatest remap ever : asbjornHaland
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

vim.keymap.set("n", "<leader>ig", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<cr>", { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>mm", "<cmd>Telescope neoclip<cr>", { desc = "Telescope Clipboard" })

vim.keymap.set("n", "<leader>bsd", "<cmd>%bd|e#|bd#<cr>|'<cr>", { desc = "Delete surrounding buffers" })
