-- Find, Filter, Preview, Pick. All lua, all the time.
-- https://github.com/nvim-telescope/telescope.nvim
return {
  "nvim-telescope/telescope.nvim",
  -- todo: switch back to branch or tag when treesitter integration is released: branch = '0.1.x',
  commit = "b4da76be54691e854d3e0e02c36b0245f945c2c7",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-dap.nvim",
    "nvim-telescope/telescope-github.nvim",
  },
  lazy = true,
  event = "VeryLazy",
  config = function()
    require("telescope").setup({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })
    require("telescope").load_extension("ui-select")
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("dap")
  end,
  keys = {
    { "<C-P>", "<cmd>Telescope find_files<CR>" },
    { "\\f", "<cmd>Telescope live_grep<CR>" },
  },
}
