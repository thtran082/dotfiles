local themes = {
  cyberdream = {
    plugin = {
      "scottmckendry/cyberdream.nvim",
      config = function()
        require("cyberdream").setup({
          transparent = false,
          italic_comments = false,
          hide_fillchars = false,
          borderless_pickers = false,
          terminal_colors = true,
          cache = false,
          theme = {
            variant = "default", -- use "auto" to follow vim.o.background
          },
        })
      end,
    },
  },
  everforest = {
    plugin = {
      "neanias/everforest-nvim",
      config = function()
        require("everforest").setup({
          background = "hard",
          transparent_background_level = 0,
          italics = false,
          disable_italic_comments = false,
          sign_column_background = "none",
          ui_contrast = "low",
          dim_inactive_windows = false,
          diagnostic_text_highlight = false,
          diagnostic_virtual_text = "coloured",
          diagnostic_line_highlight = false,
          spell_foreground = false,
          show_eob = true,
          float_style = "bright",
          inlay_hints_background = "none",
          on_highlights = function(highlight_groups, palette) end,
          colours_override = function(palette) end,
        })
      end,
    },
  },
  ayu = {
    plugin = { "shatur/neovim-ayu" },
    theme_suffix = "-dark",
  },
  gruvbox = {
    plugin = { "ellisonleao/gruvbox.nvim" },
  },
  nightfox = {
    plugin = {
      "EdenEast/nightfox.nvim",
      config = function()
        require("nightfox").setup({
          options = {
            transparent = false,
            terminal_colors = true,
            dim_inactive = false,
            styles = {
              comments = "italic",
              keywords = "bold",
              types = "italic,bold",
            },
          },
        })
      end,
    },
  },
}

local function getColorscheme(theme, scheme)
  local config = {}
  local default_theme = "cyberdream" -- define your default theme here
  local default_scheme = "dark" -- define your default scheme here

  theme = theme or default_theme
  scheme = scheme or default_scheme

  local themeconfig = themes[theme]
  if themeconfig then
    table.insert(config, themeconfig.plugin)
    theme = themeconfig.theme_prefix or theme
    theme = theme .. (themeconfig.theme_suffix or "")
    scheme = themeconfig.scheme or scheme
  else
    print("theme not found in themes table")
  end

  table.insert(config, {
    "LazyVim/LazyVim",
    opts = { colorscheme = theme },
  })

  vim.go.background = scheme

  -- print(vim.inspect(config))

  return config
end

return getColorscheme("cyberdream", "dark")
