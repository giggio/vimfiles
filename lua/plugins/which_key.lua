return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-mini/mini.icons", -- https://github.com/nvim-mini/mini.icons/
    "ryanoasis/vim-devicons", -- https://github.com/nvim-tree/nvim-web-devicons
  },
  opts = {
    icons = {
      rules = {
        -- view rules examples at https://github.com/folke/which-key.nvim/blob/main/lua/which-key/icons.lua
        -- view nerdfont glyphs at https://www.nerdfonts.com/cheat-sheet
        { plugin = "barbar.nvim", icon = " ", color = "orange" },
      },
    },
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
        function()
          require("dap").goto_()
        end,
        desc = "Set Next Statement",
        nowait = true,
      },
      {
        "\\dr",
        function()
          require("dap").repl.open()
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
      {
        "<C-ᚑ>", -- comming from Kitty, as "map menu send_text all \x1b[5777;5u"
        "<Cmd>popup PopUp<CR>",
        mode = { "n", "x", "v" },
        desc = "Open PopUp window",
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
}
