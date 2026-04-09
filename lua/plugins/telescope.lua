-- Find, Filter, Preview, Pick. All lua, all the time.
-- https://github.com/nvim-telescope/telescope.nvim
return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
    { "nvim-telescope/telescope-dap.nvim", enabled = not vim.g.is_server },
    { "nvim-telescope/telescope-github.nvim", enabled = not vim.g.is_server },
  },
  lazy = true,
  event = "VeryLazy",
  config = function()
    local actions = require("telescope.actions")
    require("telescope").setup({
      defaults = {
        cache_picker = {
          num_pickers = 10,
          ignore_empty_prompt = false,
        },
        mappings = {
          i = {
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })
    require("telescope").load_extension("ui-select")
    require("telescope").load_extension("fzf")
    if not vim.g.is_server then
      require("telescope").load_extension("dap")
    end
  end,
  keys = {
    { "<C-P>", "<cmd>Telescope find_files<CR>" },
    {
      "<leader>f",
      function()
        local telescope = require("telescope.builtin")
        local cached_pickers = require("telescope.state").get_global_key("cached_pickers") or {}
        for i, cached_picker in pairs(cached_pickers) do
          if cached_picker.prompt_title == "Live Grep" then
            telescope.resume({ cache_index = i })
            return
          end
        end
        telescope.live_grep()
      end,
    },
  },
}
