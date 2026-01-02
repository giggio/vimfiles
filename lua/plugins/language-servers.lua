return {
  -- JSON schemas for Neovim
  -- https://github.com/b0o/SchemaStore.nvim
  "b0o/schemastore.nvim",
  {
    -- A neovim plugin that helps managing crates.io dependencies
    -- https://github.com/saecki/crates.nvim
    "saecki/crates.nvim",
    tag = "stable",
    enabled = not vim.g.is_server,
    config = function()
      require("crates").setup({
        lsp = {
          enabled = true,
          -- on_attach = function(client, bufnr)
          --   -- the same on_attach function as for your other language servers
          --   -- can be ommited if you're using the `LspAttach` autocmd
          -- end,
          actions = true,
          completion = true,
          hover = true,
        },
        completion = {
          crates = {
            enabled = true,
            max_results = 8,
            min_chars = 3,
          },
          cmp = {
            enabled = true,
          },
        },
      })
    end,
  },
}
