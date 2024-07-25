return {
  {
    "f-person/git-blame.nvim",
    config = function()
      require("gitblame").setup({
        enabled = true,
        date_format = "%r",
        message_when_not_committed = " 𐄑  Uncommited changes",
      })
    end,
  },
}
