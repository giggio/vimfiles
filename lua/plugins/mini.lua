return {
  'echasnovski/mini.nvim',
  lazy = false,
  event = "VeryLazy",
  version = '*',
  config = function()
    require('mini.pick').setup({
       -- mappings = {
       --  choose            = '<C-t>',
       --  choose_in_tabpage = '<CR>',
      -- }
    })
    vim.ui.select = require('mini.pick').ui_select
    require('mini.icons').setup()

  end,
  keys = {
    { "<C-P>", "<cmd>Pick files<CR>" },
    { "\\f", "<cmd>Pick grep_live<CR>" },
  },
}
