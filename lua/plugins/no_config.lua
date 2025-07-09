return {
  "neovim/nvim-lspconfig",
  {
    "numToStr/Comment.nvim",
    config = function()
      require('Comment').setup()
    end,
  },
  "JoosepAlviste/nvim-ts-context-commentstring",
  {
    "kosayoda/nvim-lightbulb",
    config = function()
      require('nvim-lightbulb').setup {
        autocmd = { enabled = true },
        action_kinds = {
          "call_hints",
          "quickfix",
          "diagnostic",
          "fix_all",
          "inlay_hint",
        },
      }
    end,
  },
  {
    "Joakker/lua-json5",
    build = "./install.sh",
    event = "VeryLazy",
  },
  "nvim-tree/nvim-web-devicons",
}

