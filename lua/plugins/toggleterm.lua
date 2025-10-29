-- A neovim lua plugin to help easily manage multiple terminal windows
-- https://github.com/akinsho/toggleterm.nvim
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    open_mapping = [[<c-\>]],
    insert_mappings = true,
    direction = "float",
    float_opts = {
      border = "curved",
    },
  },
}
