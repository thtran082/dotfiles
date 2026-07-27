-- Git compare support: side-by-side diffs against branches and revisions.
-- Branch/commit selection is driven by Telescope pickers; keymaps live under
-- the <leader>gd "+diff/compare" group.

-- Open a Telescope picker and, on selection, open diffview against the chosen
-- ref. `builtin_name` is a telescope.builtin picker; `ref_fmt` formats the
-- selected entry's value into a diffview ref (e.g. "%s" or "%s -- " .. file).
local function pick_then_diff(builtin_name, ref_fmt, picker_opts)
  return function()
    local opts = vim.tbl_extend("force", picker_opts or {}, {
      attach_mappings = function(prompt_bufnr)
        local actions = require("telescope.actions")
        local state = require("telescope.actions.state")
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local sel = state.get_selected_entry()
          if sel and sel.value then
            vim.cmd("DiffviewOpen " .. string.format(ref_fmt, sel.value))
          end
        end)
        return true
      end,
    })
    require("telescope.builtin")[builtin_name](opts)
  end
end

return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gd", "", desc = "+diff/compare" },
      {
        "<leader>gdd",
        "<cmd>DiffviewOpen<cr>",
        desc = "Diff working tree (uncommitted)",
      },
      {
        "<leader>gdb",
        pick_then_diff("git_branches", "%s"),
        desc = "Compare with branch (pick)",
      },
      {
        "<leader>gdc",
        pick_then_diff("git_commits", "%s"),
        desc = "Compare with revision (pick)",
      },
      {
        "<leader>gdp",
        "<cmd>DiffviewOpen HEAD~1 -- %<cr>",
        desc = "Compare file with previous revision",
      },
      {
        "<leader>gdh",
        "<cmd>DiffviewFileHistory %<cr>",
        desc = "File revision history",
      },
      {
        "<leader>gdH",
        "<cmd>DiffviewFileHistory<cr>",
        desc = "Repo revision history",
      },
      {
        "<leader>gdq",
        "<cmd>DiffviewClose<cr>",
        desc = "Close diffview",
      },
    },
    opts = {},
  },
}
