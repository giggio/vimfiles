-- Integrate the opencode AI assistant with Neovim
-- https://github.com/NickvanDyke/opencode.nvim
return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  enabled = not vim.g.is_server,
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {}

    vim.o.autoread = true
  end,
  keys = {
    {
      "<leader>o",
      mode = { "n", "x" },
      desc = "Opencode",
    },
    {
      "<leader>oa",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Ask opencode",
    },
    {
      "<leader>ox",
      function()
        require("opencode").select()
      end,
      mode = { "n", "x" },
      desc = "Execute opencode action",
    },
    {
      "<leader>og",
      function()
        require("opencode").prompt("@this")
      end,
      mode = { "n", "x" },
      desc = "Add to opencode",
    },
    {
      "<leader>o.",
      function()
        require("opencode").toggle()
      end,
      mode = "n",
      desc = "Toggle opencode",
    },
    {
      "<leader>ou",
      function()
        require("opencode").command("messages_half_page_up")
      end,
      mode = "n",
      desc = "opencode half page up",
    },
    {
      "<leader>od",
      function()
        require("opencode").command("messages_half_page_down")
      end,
      mode = "n",
      desc = "opencode half page down",
    },
  },
}
