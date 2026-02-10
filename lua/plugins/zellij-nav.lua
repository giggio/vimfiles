-- Seamless navigation between Neovim windows and Zellij panes
-- https://github.com/swaits/zellij-nav.nvim
return {
  "swaits/zellij-nav.nvim",
  lazy = true,
  event = "VeryLazy",
  keys = {
    { "<c-h>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "Navigate left or tab" } },
    { "<c-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "Navigate down or tab" } },
    { "<c-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "Navigate up or tab" } },
    { "<c-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "Navigate right or tab" } },
  },
  opts = {},
}
