-- Lightweight yet powerful formatter plugin for Neovim
-- https://github.com/stevearc/conform.nvim
return {
  'stevearc/conform.nvim',
  opts = {},
  lazy = true,
  event = "VeryLazy",
  config = function()
    require("conform").setup({
      formatters_by_ft = { -- todo: add more formatters
        markdown = { "markdownlint-cli2" },
      },
    })
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
