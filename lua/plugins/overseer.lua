-- A task runner and job management plugin for Neovim
-- https://github.com/stevearc/overseer.nvim
return {
  "stevearc/overseer.nvim",
  enabled = not vim.g.is_server,
  config = function()
    require("overseer").setup({})
  end,
  opts = {},
  keys = {
    { "<CS-B>", "<cmd>OverseerRun BUILD<CR>", desc = "Run BUILD task" },
  },
}
