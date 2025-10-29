return {
  -- Quickstart configs for Nvim LSP
  -- https://github.com/neovim/nvim-lspconfig
  "neovim/nvim-lspconfig", -- Quickstart configs for Nvim LSP https://github.com/neovim/nvim-lspconfig
  -- Neovim treesitter plugin for setting the commentstring based on the cursor location in a file.
  -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
  "JoosepAlviste/nvim-ts-context-commentstring",
  -- Provides Nerd Font icons (glyphs) for use by neovim plugins
  -- https://github.com/nvim-tree/nvim-web-devicons
  "nvim-tree/nvim-web-devicons",
  {
    -- Smart and powerful comment plugin for neovim.
    -- https://github.com/numToStr/Comment.nvim
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    -- A json5 parser for luajit
    -- https://github.com/Joakker/lua-json5
    "Joakker/lua-json5",
    build = vim.fn.has("unix") and "./install.sh" or "powershell ./install.ps1",
    event = "VeryLazy",
  },
  {
    -- Git integration for buffers
    -- https://github.com/lewis6991/gitsigns.nvim
    "lewis6991/gitsigns.nvim",
    lazy = true,
    opts = { sign_priority = 100 },
  },
}
