local Themes = {
  ["gruvbox-material"] = {
    plugins = { "sainnhe/gruvbox-material" },
    settings = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_better_performance = 1
    end,
  },
  kanagawa = {
    plugins = { "rebelot/kanagawa.nvim" },
    theme_suffix = "-dragon",
  },
  ayu = {
    plugins = { "Shatur/neovim-ayu" },
    theme_suffix = "-mirage",
  },
}

local function getColorscheme(theme, scheme)
  local config = {}
  local default_theme = "tokyonight-moon" -- Define your default theme here
  local default_scheme = "dark" -- Define your default scheme here

  theme = theme or default_theme
  scheme = scheme or default_scheme

  local themeConfig = Themes[theme]
  if themeConfig then
    for _, plugin in ipairs(themeConfig.plugins) do
      table.insert(config, { plugin })
    end
    if themeConfig.settings then
      themeConfig.settings()
    end
    theme = themeConfig.theme_prefix or theme
    theme = theme .. (themeConfig.theme_suffix or "")
    scheme = themeConfig.scheme or scheme
  else
    print("Theme not found in Themes table")
  end

  table.insert(config, {
    "LazyVim/LazyVim",
    opts = { colorscheme = theme },
  })

  vim.go.background = scheme

  -- Uncomment the line below to print out the config for debugging if needed
  -- print(vim.inspect(config))

  return config
end

return getColorscheme("kanagawa", "dark")
