return {
  "theHamsta/nvim-dap-virtual-text",
  -- event = "VeryLazy",
  -- config = true,
  config = function()
    require('nvim-dap-virtual-text').setup {
    }
  end,
  requires = {
    "nvim-treesitter/nvim-treesitter",
    "mfussenegger/nvim-dap",
  },
}

