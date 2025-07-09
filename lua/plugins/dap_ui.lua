return {
  "rcarriga/nvim-dap-ui",
  event = "VeryLazy",
  dependencies = {
    "Weissle/persistent-breakpoints.nvim",
  },
  config = function()
    local dap = require('dap')
    local ui = require("dapui")
    ui.setup()

    vim.g.dap_debugger_running = 0
    vim.fn.sign_define("DapBreakpoint", { text = "🛑" })
    dap.listeners.before.attach.dapui_config = function()
      vim.cmd("Neotree close")
      ui.open()
      vim.g.dap_debugger_running = 1
    end
    dap.listeners.before.launch.dapui_config = function()
      vim.cmd("Neotree close")
      ui.open()
      vim.g.dap_debugger_running = 1
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      ui.close()
      vim.g.dap_debugger_running = 0
      vim.cmd("Neotree reveal")
      vim.cmd("wincmd t")
    end
    dap.listeners.before.event_exited.dapui_config = function()
      ui.close()
      vim.g.dap_debugger_running = 0
      vim.cmd("Neotree reveal")
      vim.cmd("wincmd t")
    end
  end
}
