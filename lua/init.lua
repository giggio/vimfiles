-- require'lspconfig'.lua_ls.setup{}
vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library'
          -- '${3rd}/busted/library'
        }
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = {
        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})

vim.lsp.enable('lua_ls')

local dap = require("dap")
local ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

dap_virtual_text.setup()

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
  }
}

local dap = require('dap')
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
}

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

require('dap.ext.vscode').json_decode = require'json5'.parse

require('persistent-breakpoints').setup{
	load_breakpoints_event = { "BufReadPost" },
  always_reload = true,
}
