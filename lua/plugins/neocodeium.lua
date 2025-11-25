-- https://github.com/monkoose/neocodeium
-- free AI completion plugin for neovim that uses Windsurf
return {
  "monkoose/neocodeium",
  event = "VeryLazy",
  config = function()
    local neocodeium = require("neocodeium")
    neocodeium.setup()
    vim.keymap.set("i", "<tab>", neocodeium.accept)
  end,
}
