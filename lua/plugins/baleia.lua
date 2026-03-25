--  Colorize text with ANSI escape sequences (8, 16, 256 or TrueColor)
--  https://github.com/m00qek/baleia.nvim
return {
  "m00qek/baleia.nvim",
  -- version = "*",
  commit = "32617940adb2eea56e85a64883a19961ceac9641", -- todo: change to a version if the project ever adopts publishem them
  lazy = true,
  init = function()
    vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
      pattern = "*.dump",
      group = vim.api.nvim_create_augroup("BaleiaBufWinEnter", { clear = true }),
      callback = function()
        require("baleia")
          .setup({
            colors = require("baleia.ansi").NR_16,
          })
          .once(vim.api.nvim_get_current_buf())
        vim.api.nvim_set_option_value("modified", false, { buf = vim.api.nvim_get_current_buf() })
        vim.cmd("normal! G")
      end,
    })
  end,
}
