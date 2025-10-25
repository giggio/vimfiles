-- An extensible framework for interacting with tests within NeoVim.
-- https://github.com/nvim-neotest/neotest
local function open_neotest_summary()
  local win_found = false
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_get_option_value("filetype", { buf = buf }) == "neotest-summary" then
      win_found = true
      break
    end
  end
  require('neotest').watch.toggle({ suite = true })
  if not win_found then
    require('neotest').summary.open()
  end
  if not win_found then
    require('neotest').summary.open()
  end
end
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
    },
    {
      "<leader>tr",
      function()
        open_neotest_summary()
        require('neotest').run.run()
      end,
      mode = { "n", "x", },
      desc = "Run test",
      noremap = true,
      silent = true,
    },
    {
      "<leader>ta",
      function()
        open_neotest_summary()
        require('neotest').run.run({ suite = true })
      end,
      mode = { "n", "x", },
      desc = "Run all tests",
      noremap = true,
      silent = true,
    },
    {
      "<leader>tw",
      function()
        open_neotest_summary()
        require('neotest').run.run()
      end,
      mode = { "n", "x", },
      desc = "Watch test",
      noremap = true,
      silent = true,
    },
    {
      "<leader>twa",
      function()
        open_neotest_summary()
        require('neotest').watch.toggle({ suite = true })
      end,
      mode = { "n", "x", },
      desc = "Watch all tests",
      noremap = true,
      silent = true,
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
    },
    {
      "<leader>tl",
      function()
        open_neotest_summary()
        require("neotest").run.run_last()
      end,
      mode = { "n", "x", },
      desc = "Run last test",
      noremap = true,
      silent = true,
    },
    {
      "<leader>t<leader>dt",
      function()
        open_neotest_summary()
        require('neotest').run.run({ strategy = "dap" })
      end,
      mode = { "n", "x", },
      desc = "Debug test",
      noremap = true,
      silent = true,
    },
    {
      "<leader>t<leader>da",
      function()
        open_neotest_summary()
        require('neotest').run.run({ suite = true, strategy = "dap" })
      end,
      mode = { "n", "x", },
      desc = "Debug all tests",
      noremap = true,
      silent = true,
    },
  },
}
