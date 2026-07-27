-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Open neo-tree on startup when no file is specified, or alongside a file
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Skip if opening a directory (neo-tree handles that itself)
    local arg = vim.fn.argv(0)
    if vim.fn.isdirectory(arg) == 0 then
      require("neo-tree.command").execute({ action = "show", dir = vim.loop.cwd() })
    end
  end,
})
