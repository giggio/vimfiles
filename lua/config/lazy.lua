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
  performance = {
    reset_packpath = false,
  },
  spec = {
    -- import your plugins
    -- { import = "plugins" },
    LazyPlugSpecs, -- bringing in the plugin in list from vim
    {
      "neovim/nvim-lspconfig",
      -- event = "VeryLazy",
    },
    {
      "Joakker/lua-json5",
      build = "./install.sh",
      event = "VeryLazy",
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
        "Joakker/lua-json5",
      },
      config = function()
        local dap = require('dap')
        dap.adapters = {
          lldb_dap = { -- lldb_dap is the name we use in the configuration.type
            type = 'executable',
            command = 'lldb-dap',
            name = 'lldb-dap'
          },
          lldb = { -- use lldb for codelldb as it works the same in vscode
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
            end
          }
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
        dap.configurations =
        {
          rust = {
            {
              name = 'Debug Rust (nvim - codelldb)',
              type = "lldb",
              request = "launch",
              program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
              end,
              cwd = '${workspaceFolder}',
              stopOnEntry = false,
            },
            {
              name = 'Debug Rust (nvim - lldb-dap)',
              type = 'lldb_dap',
              request = 'launch',
              program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
              end,
              cwd = '${workspaceFolder}',
              stopOnEntry = false,
              args = { },
            },
          },
          javascript = {
            {
              name = "Node - Launch file (nvim - js-debug)",
              type = "node",
              request = "launch",
              program = "${file}",
              skipFiles = {
                  "<node_internals>/**"
              },
              cwd = "${workspaceFolder}",
            },
            {
              name = "Node - npm run debug (nvim - js-debug)",
              type = "node",
              request = "launch",
              runtimeArgs = {
                "run-script",
                "debug"
              },
              runtimeExecutable = "npm",
              skipFiles = {
                "<node_internals>/**"
              },
              cwd = "${workspaceFolder}",
            },
          },
        }
        local ext_vscode = require('dap.ext.vscode')
        ext_vscode.json_decode = require'json5'.parse
      end
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      -- event = "VeryLazy",
      -- config = true,
      config = function()
        require('nvim-dap-virtual-text').setup {
        }
      end,
      requires = {
        "nvim-treesitter/nvim-treesitter",
        "mfussenegger/nvim-dap",
      },
    },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'main',
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local languages = {
        'javascript',
        'lua',
        'rust',
      }
      local installed = vim.fn.glob(vim.fn.stdpath('data') .. '/site/parser/*.so', 0, 1)
      local missing = {}
      for _, lang in ipairs(languages) do
        local found = false
        for _, file in ipairs(installed) do
          if file:match(lang .. '%.so$') then
            found = true
            break
          end
        end
        if not found then
          table.insert(missing, lang)
        end
      end
      if #missing > 0 then
        print("Missing parsers: " .. table.concat(missing, ", "))
        require'nvim-treesitter'.install(missing)
      else
        print("All tree-sitter parsers are installed.")
      end
    end,
  },
    {
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
          ui.open()
          vim.g.dap_debugger_running = 1
        end
        dap.listeners.before.launch.dapui_config = function()
          ui.open()
          vim.g.dap_debugger_running = 1
        end
        dap.listeners.before.event_terminated.dapui_config = function()
          ui.close()
          vim.g.dap_debugger_running = 0
        end
        dap.listeners.before.event_exited.dapui_config = function()
          ui.close()
          vim.g.dap_debugger_running = 0
        end
      end
    },
    {
      "Weissle/persistent-breakpoints.nvim",
      event = "VeryLazy",
      opts = {
        load_breakpoints_event = { "BufReadPost" },
        always_reload = true,
      },
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
