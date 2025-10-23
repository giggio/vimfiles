-- https://github.com/romgrk/barbar.nvim
-- The neovim tabline plugin.
return {
  'romgrk/barbar.nvim',
  lazy = true,
  event = "VeryLazy",
  enabled = true,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    icons = {
      buffer_index = true,
      filetype = {
        custom_colors = false,
        enabled = true,
      },
      diagnostics = {
        [vim.diagnostic.severity.ERROR] = {enabled = true, icon = ' '},
        [vim.diagnostic.severity.WARN] = {enabled = true, icon = ' '},
        [vim.diagnostic.severity.INFO] = {enabled = false},
        [vim.diagnostic.severity.HINT] = {enabled = false},
      },
      preset = 'slanted',
    },
  },
  version = '^1.0.0',
  keys = {
    { "<leader>1", "<cmd>BufferGoto 1<CR>" },
    { "<leader>2", "<cmd>BufferGoto 2<CR>" },
    { "<leader>3", "<cmd>BufferGoto 3<CR>" },
    { "<leader>4", "<cmd>BufferGoto 4<CR>" },
    { "<leader>5", "<cmd>BufferGoto 5<CR>" },
    { "<leader>6", "<cmd>BufferGoto 6<CR>" },
    { "<leader>7", "<cmd>BufferGoto 7<CR>" },
    { "<leader>8", "<cmd>BufferGoto 8<CR>" },
    { "<leader>9", "<cmd>BufferGoto 9<CR>" },
    { "<leader>0", "<cmd>BufferLast<CR>" },
    { "<C-A-,>", "<Cmd>BufferMovePrevious<CR>" },
    { "<C-A-.>", "<Cmd>BufferMoveNext<CR>" },
    { "[b", "<Cmd>BufferPrevious<CR>" },
    { "]b", "<Cmd>BufferNext<CR>" },
  }
}
