-- Inline image rendering via snacks.image.
--
-- Ghostty implements the Kitty graphics protocol, so images render in the
-- terminal. snacks.image ships with LazyVim (no luarocks/imagemagick build
-- step), renders images inline in buffers, and provides hover previews in
-- neo-tree and the snacks picker. This replaces the unconfigured
-- 3rd/image.nvim that was a neo-tree dependency.

return {
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        enabled = true,
        doc = {
          -- Render images referenced in markdown/docs inline.
          enabled = true,
          inline = true,
        },
      },
    },
  },
}
