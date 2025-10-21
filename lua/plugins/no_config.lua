return {
  "neovim/nvim-lspconfig", -- Quickstart configs for Nvim LSP https://github.com/neovim/nvim-lspconfig
  {
    "numToStr/Comment.nvim",
    config = function()
      require('Comment').setup()
    end,
  },
  "JoosepAlviste/nvim-ts-context-commentstring",
  {
    "Joakker/lua-json5",
    build = vim.fn.has('unix') and "./install.sh" or "powershell ./install.ps1",
    event = "VeryLazy",
  },
  "nvim-tree/nvim-web-devicons",
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'ayu_dark',
        }
      }
    end,
  },
}
