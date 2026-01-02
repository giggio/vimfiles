-- A neovim watcher for ActivityWatch time tracker.
-- https://github.com/lowitea/aw-watcher.nvim
return {
  "lowitea/aw-watcher.nvim",
  lazy = true,
  enabled = not vim.g.is_server,
  event = "VeryLazy",
  config = function()
    require("aw_watcher").setup({
      aw_server = {
        pulsetime = 5,
      },
    })
  end,
}
