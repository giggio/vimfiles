return {
  'echasnovski/mini.nvim',
  version = '*',
  config = function()
    require('mini.pick').setup({
       mappings = {
        choose            = '<C-t>',
        choose_in_tabpage = '<CR>',
      }
    })
    require('mini.icons').setup()
  end,
  keys = {
    {
      "<C-P>",
      "<cmd>Pick files<CR>",
    },
  },
}
