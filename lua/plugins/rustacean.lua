-- 🦀 Supercharge your Rust experience in Neovim!
-- https://github.com/mrcjkb/rustaceanvim
return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false, -- This plugin is already lazy
  opt = {
    tools = {
      enable_nextest = false,
    },
  },
  config = function()
    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {
        -- enable_nextest = false,
      },
      -- LSP configuration
      -- server = {
      --   on_attach = function(client, bufnr)
      --     -- you can also put keymaps in here
      --   end,
      --   default_settings = {
      --     -- rust-analyzer language server configuration
      --     ['rust-analyzer'] = {
      --     },
      --   },
      -- },
      -- DAP configuration
      -- dap = {
      -- },
    }
  end,
}
