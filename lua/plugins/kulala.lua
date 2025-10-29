-- A fully-featured HTTP-client interface for Neovim
-- https://github.com/mistweaverco/kulala.nvim
return {
  {
    "mistweaverco/kulala.nvim",
    -- todo: go back to main when treesitter/main stabilizes, see: https://github.com/mistweaverco/kulala.nvim/issues/591
    commit = "698307bbe630a5cce93addd942fb721cf4ff32bf",
    init = function()
      vim.filetype.add({
        extension = {
          ["http"] = "http",
        },
      })
    end,
    keys = {
      { "<leader>Rs", desc = "Send request" },
      { "<leader>Ra", desc = "Send all requests" },
      { "<leader>Rb", desc = "Open scratchpad" },
    },
    ft = { "http", "rest" },
    opts = {
      global_keymaps = true,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps_prefix = "",
    },
  },
}
