return {
  "rcarriga/nvim-dap-ui",
  event = "VeryLazy",
  dependencies = {
    "Weissle/persistent-breakpoints.nvim",
  },
  config = function()
    local dap = require("dap")
    local ui = require("dapui")
    ui.setup()

    vim.g.dap_debugger_running = 0
    vim.fn.sign_define("DapBreakpoint", { text = "🛑" })
    dap.listeners.before.attach.dapui_config = function()
      vim.g.neotree_open = 0
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_get_option_value("filetype", { buf = buf }) == "neo-tree" then
          vim.g.neotree_open = 1
          break
        end
      end
      vim.cmd("Neotree close")
      ui.open()
      vim.g.dap_debugger_running = 1
    end
    dap.listeners.before.launch.dapui_config = function()
      vim.g.neotree_open = 0
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_get_option_value("filetype", { buf = buf }) == "neo-tree" then
          vim.g.neotree_open = 1
          break
        end
      end
      vim.cmd("Neotree close")
      ui.open()
      vim.g.dap_debugger_running = 1
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      ui.close()
      vim.g.dap_debugger_running = 0
      if vim.g.neotree_open == 1 then
        vim.cmd("Neotree reveal")
        vim.cmd("wincmd t")
      end
    end
    dap.listeners.before.event_exited.dapui_config = function()
      ui.close()
      vim.g.dap_debugger_running = 0
      if vim.g.neotree_open == 1 then
        vim.cmd("Neotree reveal")
        vim.cmd("wincmd t")
      end
    end
  end,
}
