-- https://codeberg.org/mfussenegger/nvim-dap
-- Debug Adapter Protocol client implementation for Neovim
return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  enabled = not vim.g.is_server,
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "Joakker/lua-json5",
    {
      -- A json5 parser for luajit
      -- https://github.com/Joakker/lua-json5
      "Joakker/lua-json5",
      -- vim.fn.has() returns 0/1, and 0 is truthy in Lua, so it has to be compared explicitly
      build = vim.fn.has("win32") == 1 and "powershell -NoProfile -File ./install.ps1" or "./install.sh",
      event = "VeryLazy",
    },
  },
  config = function()
    local dap = require("dap")
    dap.adapters = {
      lldb_dap = { -- lldb_dap is the name we use in the configuration.type
        type = "executable",
        command = "lldb-dap",
        name = "lldb-dap",
      },
      lldb = { -- use lldb for codelldb as it works the same in vscode
        -- https://codeberg.org/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)
        -- https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#c-c-rust-via-codelldb-https-github-com-vadimcn-vscode-lldb
        type = "executable",
        command = "codelldb",
        name = "codelldb",
        -- On windows you may have to uncomment this:
        -- detached = false,
      },
      node = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "js-debug",
          args = { "${port}" },
        },
        enrich_config = function(conf, on_config) -- necessary so type 'node' also works
          if not vim.startswith(conf.type, "pwa-") then
            local config = vim.deepcopy(conf)
            config.type = "pwa-" .. config.type
            on_config(config)
          else
            on_config(conf)
          end
        end,
      },
    }
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "js-debug",
        args = { "${port}" },
      },
    }
    dap.configurations = {
      rust = {
        {
          name = "Debug Rust (nvim - codelldb)",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          preRunCommands = {
            "command script import " .. vim.g.vimHome .. "/helpers/rust_prettifier_for_lldb.py",
          },
        },
        {
          name = "Debug Rust (nvim - lldb-dap)",
          type = "lldb_dap",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      },
      javascript = {
        {
          name = "Node - Launch file (nvim - js-debug)",
          type = "node",
          request = "launch",
          program = "${file}",
          skipFiles = {
            "<node_internals>/**",
          },
          cwd = "${workspaceFolder}",
        },
        {
          name = "Node - npm run debug (nvim - js-debug)",
          type = "node",
          request = "launch",
          runtimeArgs = {
            "run-script",
            "debug",
          },
          runtimeExecutable = "npm",
          skipFiles = {
            "<node_internals>/**",
          },
          cwd = "${workspaceFolder}",
        },
      },
    }
    local ext_vscode = require("dap.ext.vscode")
    -- lua-json5 is a native module that has to be compiled by its build step; if that
    -- did not run (missing toolchain) fall back to nvim-dap's own json decoder instead
    -- of breaking the whole nvim-dap setup.
    local ok, json5 = pcall(require, "json5")
    if ok then
      ext_vscode.json_decode = json5.parse
    else
      vim.notify(
        "lua-json5 is not built, falling back to the default launch.json decoder. Run :Lazy build lua-json5",
        vim.log.levels.WARN
      )
    end
  end,
}
