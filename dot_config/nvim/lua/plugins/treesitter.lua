return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
        "html",
        "yaml",
        "angular",
        "scss",
        "css",
      })

      -- Angular component templates are plain `.html` files; force the angular
      -- parser for them so template syntax (bindings, control flow) highlights
      -- and injects correctly.
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        pattern = { "*.component.html", "*.container.html" },
        callback = function()
          pcall(vim.treesitter.start, nil, "angular")
        end,
      })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-context", enabled = false },
  { "nvim-treesitter/playground" },
  {
    "windwp/nvim-ts-autotag",
  },
}
