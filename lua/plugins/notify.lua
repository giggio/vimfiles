return {
  "rcarriga/nvim-notify",
  lazy = true,
  event = "VeryLazy",
  config = function()
    local notify = require("notify")
    notify.setup({
      background_colour = "#000000",
    })
    vim.notify = notify
  end,
}
