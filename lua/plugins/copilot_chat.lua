-- https://github.com/CopilotC-Nvim/CopilotChat.nvim
-- Chat with GitHub Copilot in Neovim
return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = "VeryLazy",
    enabled = vim.fn.has('unix') == 1, -- not working on Windows
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      {
        model = 'gpt-4.1',           -- AI model to use
        temperature = 0.1,           -- Lower = focused, higher = creative
        window = {
          layout = 'vertical',       -- 'vertical', 'horizontal', 'float'
          width = 0.3,              -- 50% of screen width
        },
        auto_insert_mode = true,     -- Enter insert mode when opening
      }
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
