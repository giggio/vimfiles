return {
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
}
