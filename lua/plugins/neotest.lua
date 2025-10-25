-- An extensible framework for interacting with tests within NeoVim.
-- https://github.com/nvim-neotest/neotest
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "rouge8/neotest-rust",
  },
  config = function()
    require('neotest').setup {
      adapters = {
        -- require('rustaceanvim.neotest') -- todo: verify again when this issue is fixed: https://github.com/mrcjkb/rustaceanvim/issues/864
        require("neotest-rust") { args = { "--no-capture" }, }, -- todo: this plugin is archived, consider replacing it
      }
    }
  end,
  keys = {
    {
      "<leader>t",
      desc = "Neotest commands",
      group = "test",
    },
    {
      "<leader>tr",
      function()
        require('neotest').run.run()
        require('neotest').summary.open()
      end,
      mode = { "n", "x", },
      desc = "Run test",
      noremap = true,
      silent = true,
      group = "test",
    },
    {
      "<leader>ta",
      function()
        require('neotest').run.run({ suite = true })
        require('neotest').summary.open()
      end,
      mode = { "n", "x", },
      desc = "Run all tests",
      noremap = true,
      silent = true,
      group = "test",
    },
    {
      "<leader>te",
      function()
        require('neotest').summary.toggle()
      end,
      mode = { "n", "x", },
      desc = "Run test explorer (summary)",
      noremap = true,
      silent = true,
      group = "test",
    },
    {
      "<leader>tl",
      function()
        require("neotest").run.run_last()
        require('neotest').summary.open()
      end,
      mode = { "n", "x", },
      desc = "Run last test",
      noremap = true,
      silent = true,
      group = "test",
    },
    {
      "<leader>t<leader>r",
      function()
        require('neotest').run.run({ strategy = "dap" })
        require('neotest').summary.open()
      end,
      mode = { "n", "x", },
      desc = "Debug test",
      noremap = true,
      silent = true,
      group = "test",
    },
    {
      "<leader>t<leader>a",
      function()
        require('neotest').run.run({ suite = true, strategy = "dap" })
        require('neotest').summary.open()
      end,
      mode = { "n", "x", },
      desc = "Debug all tests",
      noremap = true,
      silent = true,
      group = "test",
    },
  },
}
