-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  root = vim.g.nvimPluginInstallPath,
  spec = {
    -- import your plugins
    -- { import = "plugins" },
    LazyPlugSpecs, -- bringing in the plugin in list from vim
    {
      "Joakker/lua-json5",
      build = "./install.sh",
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        spec = {
          -- Debugger
          {
            "\\d",
            group = "Debugger",
            nowait = true,
          },
          {
            "<F9>",
            function()
              require("persistent-breakpoints.api").toggle_breakpoint()
            end,
            desc = "Toggle Breakpoint",
            nowait = true,
          },
          {
            "<F5>",
            function()
              require("dap").continue()
            end,
            desc = "Continue",
            nowait = true,
          },
          {
            "<F11>",
            function()
              require("dap").step_into()
            end,
            desc = "Step Into",
            nowait = true,
          },
          {
            "<F10>",
            function()
              require("dap").step_over()
            end,
            desc = "Step Over",
            nowait = true,
          },
          {
            "<F23>", -- "<S-F11>",
            function()
              require("dap").step_out()
            end,
            desc = "Step Out",
            nowait = true,
          },
          {
            "<F17>", --"<S-F5>",
            function()
              require("dap").terminate()
              require("dapui").close()
              require("nvim-dap-virtual-text").toggle()
            end,
            desc = "Terminate",
            nowait = true,
          },
          {
            "C-<F10>",
            function()
              require("dap").run_to_cursor()
            end,
            desc = "Run to cursor",
            nowait = true,
          },
          {
            "<F22>", -- "S-F10",
            function() require("dap").goto_()
            end,
            desc = "Set Next Statement",
            nowait = true,
          },
          {
            "\\dr",
            function() require("dap").repl.open()
            end,
            desc = "Open REPL",
            nowait = true,
          },
          {
            "\\dl",
            function()
              require("dap").run_last()
            end,
            desc = "Run Last",
            nowait = true,
          },
          {
            "\\db",
            function()
              require("dap").list_breakpoints()
            end,
            desc = "List Breakpoints",
            nowait = true,
          },
          {
            "\\de",
            function()
              require("dap").set_exception_breakpoints({ "all" })
            end,
            desc = "Set Exception Breakpoints",
            nowait = true,
          },
        },
      },
      keys = {
        {
          "\\?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    },
    {
      "mfussenegger/nvim-dap",
      event = "VeryLazy",
      dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "theHamsta/nvim-dap-virtual-text",
      },
    },
    {
      "rcarriga/nvim-dap-ui",
      event = "VeryLazy",
      dependencies = {
        "Weissle/persistent-breakpoints.nvim",
      },
    },
    {
      "Weissle/persistent-breakpoints.nvim",
      event = "VeryLazy",
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
vim.lsp.enable('lua_ls')

-- reset leader
vim.g.mapleader = "\\"
