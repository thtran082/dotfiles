-- ESLint for NX monorepos: diagnostics everywhere + fix-on-save.
--
-- `workingDirectories = "auto"` lets the server resolve the nearest
-- eslint config per NX project (each lib/app can have its own). `format = false`
-- keeps ESLint out of the formatting business — prettier (via conform) owns that.
-- On save we apply `source.fixAll.eslint` *before* conform runs prettier, so lint
-- fixes land first and prettier gets the final word on style.

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
            format = false,
          },
        },
      },
      setup = {
        eslint = function()
          local group = vim.api.nvim_create_augroup("eslint_fix_on_save", { clear = true })
          LazyVim.lsp.on_attach(function(_, bufnr)
            -- `EslintFixAll` is a user command registered by the eslint LSP on
            -- attach; it runs `eslint.applyAllFixes` synchronously, which is safe
            -- inside BufWritePre (unlike async code_action). conform's prettier
            -- pass runs in its own BufWritePre and gets the last word on style.
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = group,
              buffer = bufnr,
              callback = function()
                if vim.fn.exists(":EslintFixAll") > 0 then
                  vim.cmd("EslintFixAll")
                end
              end,
            })
          end, "eslint")
        end,
      },
    },
  },
}
