-- Seamless navigation between Neovim windows and Zellij panes
-- https://github.com/swaits/zellij-nav.nvim
return {
  "swaits/zellij-nav.nvim",
  enabled = false, -- todo: reenable when fixed, it does not work on remote ssh sessions: https://github.com/zellij-org/zellij/issues/4699
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
