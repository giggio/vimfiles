return {
  "theHamsta/nvim-dap-virtual-text",
  config = function()
    require("nvim-dap-virtual-text").setup({})
  end,
  requires = {
    "nvim-treesitter/nvim-treesitter",
    "mfussenegger/nvim-dap",
  },
}
