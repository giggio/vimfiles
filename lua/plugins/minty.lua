-- Most Beautifully crafted color tools for Neovim
-- https://github.com/nvzone/minty
return {
  "nvzone/minty",
  cmd = { "Shades", "Huefy" },
  lazy = true,
  dependencies = {
    { "nvzone/volt", lazy = true }, -- Create blazing fast & beautiful reactive UI in Neovim https://github.com/nvzone/volt
  }
}
