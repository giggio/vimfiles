return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for default `toggle()` implementation.
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
    }

    -- Required for `opts.auto_reload`.
    vim.o.autoread = true

    -- Recommended/example keymaps.
    vim.keymap.set({ "n", "x" }, "<leader>oa", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask opencode" })
    vim.keymap.set({ "n", "x" }, "<leader>ox", function()
      require("opencode").select()
    end, { desc = "Execute opencode action" })
    vim.keymap.set({ "n", "x" }, "<leader>og", function()
      require("opencode").prompt("@this")
    end, { desc = "Add to opencode" })
    vim.keymap.set("n", "<leader>o.", function()
      require("opencode").toggle()
    end, { desc = "Toggle opencode" })
    vim.keymap.set("n", "<leader>ou", function()
      require("opencode").command("messages_half_page_up")
    end, { desc = "opencode half page up" })
    vim.keymap.set("n", "<leader>od", function()
      require("opencode").command("messages_half_page_down")
    end, { desc = "opencode half page down" })
  end,
}
