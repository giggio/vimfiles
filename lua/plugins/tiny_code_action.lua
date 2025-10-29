-- A Neovim plugin that provides a simple way to run and visualize code actions with Telescope.
-- https://github.com/rachartier/tiny-code-action.nvim
return {
  "rachartier/tiny-code-action.nvim",
  dependencies = {
    { "nvim-telescope/telescope.nvim" },
  },
  event = "LspAttach",
  config = function()
    require("tiny-code-action").setup({
      backend = "delta",
      -- picker = "telescope",
      picker = {
        "buffer",
        opts = {
          hotkeys = true,
          hotkeys_mode = "sequential",
          auto_preview = true,
          position = "center",
          keymaps = {
            preview = "K",
            close = { "q", "<Esc>" },
            select = "<CR>",
          },
        },
      },
      backend_opts = {
        delta = {
          header_lines_to_remove = 4,
          args = {
            "--line-numbers",
          },
        },
      },
    })
  end,
  keys = {
    {
      "<leader>.",
      function()
        require("tiny-code-action").code_action()
      end,
      mode = { "n", "x" },
      desc = "Code Action",
      noremap = true,
      silent = true,
    },
  },
}
