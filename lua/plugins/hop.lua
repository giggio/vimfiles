-- Neovim motions on speed! (easymotion like motions)
-- https://github.com/smoka7/hop.nvim
return {
  "smoka7/hop.nvim",
  version = "*",
  lazy = true,
  opts = {},
  keys = {
    { "<leader><leader>", "<cmd>HopWord<cr>", desc = "Hop to word" },
  },
}
