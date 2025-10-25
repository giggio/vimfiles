-- The fastest Neovim colorizer
-- https://github.com/catgoose/nvim-colorizer.lua
return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    lazy_load = true,
    user_default_options = {
      mode = "virtualtext",
      virtualtext_inline = "before",
      xterm = true,
    },
  },
}
