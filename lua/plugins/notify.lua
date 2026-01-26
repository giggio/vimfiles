-- A fancy, configurable, notification manager for NeoVim
-- https://github.com/rcarriga/nvim-notify
return {
  "rcarriga/nvim-notify",
  lazy = true,
  event = "VeryLazy",
  config = function()
    local notify = require("notify")
    notify.setup({
      background_colour = "NotifyBackground",
      top_down = false,
      stages = "slide",
      icons = {
        DEBUG = "🪲",
        error = "🛑",
        info = "✅️",
        trace = "✏️",
        warn = "⚠️",
      },
    })
    vim.notify = notify
  end,
}
