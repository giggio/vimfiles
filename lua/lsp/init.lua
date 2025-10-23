local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('*', {
  capabilities = capabilities,
})

vim.lsp.config('rust_analyzer', {
  settings = { -- https://rust-analyzer.github.io/book/configuration.html
    ['rust-analyzer'] = {
      check = {
        command = "clippy",
        features = "all",
        allTargets = true,
      },
    }
  }
})
vim.lsp.config('bacon_ls', { -- bacon is disabled
  init_options = {
    updateOnSave = true,
    updateOnSaveWaitMillis = 1000
  }
})

-- todo: can't use Cspell LS until it supports .yaml and more than one config file
-- see: https://github.com/vlabo/cspell-lsp/issues/13
-- if cspell.yaml exists, use it as the config filename
-- if vim.fn.filereadable('./cspell.yaml') == 1 then
--   vim.lsp.config('cspell_ls', {
--     cmd = { 'cspell-lsp', '--stdio', '--config', 'cspell.yaml' },
--   })
-- end
-- vim.lsp.enable('cspell_ls')

vim.lsp.config('cSpell', require 'lsp.cspellls')
vim.lsp.enable('cSpell')

vim.lsp.config('powershell_es', {
  -- using powershell-editor-services from nix, it comes already bundled
  cmd = function(dispatchers)
    local temp_path = vim.fn.stdpath('cache')
    local command_fmt = [[ -LogPath '%s/powershell_es.log' -SessionDetailsPath '%s/powershell_es.session.json' -FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio -LogLevel Normal]]
    local command = command_fmt:format(temp_path, temp_path)
    local cmd = { 'powershell-editor-services', command }
    return vim.lsp.rpc.start(cmd, dispatchers)
  end,
})

vim.lsp.config('jsonls', {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

require("lsp.lua_ls")

-- vim.lsp.enable('bacon_ls') -- rust
vim.lsp.enable('basedpyright')
vim.lsp.enable('bashls')
vim.lsp.enable('clangd')
vim.lsp.enable('csharp_ls')
vim.lsp.enable('cssls')
vim.lsp.enable('dockerls')
vim.lsp.enable('emmet_language_server')
vim.lsp.enable('eslint')
vim.lsp.enable('fsautocomplete')
vim.lsp.enable('gopls')
vim.lsp.enable('html')
vim.lsp.enable('jsonls')
vim.lsp.enable('marksman')
vim.lsp.enable('nushell')
vim.lsp.enable('powershell_es')
vim.lsp.enable('ruby_lsp')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('sqls')
vim.lsp.enable('systemd_ls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('vimls')
vim.lsp.enable('yamlls')

vim.api.nvim_create_augroup("LspDiagnosticsHold", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  pattern = "*",
  callback = function(_)
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winid).zindex then
        return
      end
    end
    vim.diagnostic.open_float({
      bufnr = 0,
      scope = "cursor",
      focusable = false,
      close_events = {
        "CursorMoved",
        "CursorMovedI",
        "BufHidden",
        "InsertCharPre",
        "WinLeave",
      },
    })
  end,
  group = "LspDiagnosticsHold",
})

-- allow gotmpl files to be recognized as HTML files when hugo config files are present
if vim.fn.filereadable('./hugo.yaml') == 1 or vim.fn.filereadable('./hugo.toml') == 1 or vim.fn.filereadable('./hugo.json') == 1
  or vim.fn.glob('./config/**/hugo.yaml') ~= '' or vim.fn.glob('./config/**/hugo.toml') ~= '' or vim.fn.glob('./config/**/hugo.json') ~= '' then
  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = { '*.html' },
    command = "set filetype=gotmpl",
  })
end

-- using tiny_code_action.nvim for code actions:
-- vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "LSP: code action" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "LSP: rename" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "LSP: go to definition" })
vim.keymap.set("n", "<F12>", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "LSP: go to definition" })
vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { noremap = true, silent = true, desc = "LSP: go to type definition" })
-- vim.keymap.set( "n", "gr", vim.lsp.buf.references, { noremap = true, silent = true, desc = "LSP: go to references" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { noremap = true, silent = true, desc = "LSP: go to implementation" })

-- vim.api.nvim_set_keymap('n', '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>do', function() vim.diagnostic.open_float({ scope = 'buffer' }) end, { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d]', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
-- The following command requires plug-ins "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", and optionally "kyazdani42/nvim-web-devicons" for icon support
vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>Telescope diagnostics<CR>', { noremap = true, silent = true })
-- If you don't want to use the telescope plug-in but still want to see all the errors/warnings, comment out the telescope line and uncomment this:
-- vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

vim.lsp.inlay_hint.enable(true)

-- vim.api.nvim_create_autocmd('BufRead', {
--   -- configuration of update_in_insert as per https://github.com/crisidev/bacon-ls#neovim---manual
--   group = vim.api.nvim_create_augroup('filetype_rust', { clear = true }),
--   desc = 'Set LSP diagnostics for Rust',
--   pattern = { '*.rs' },
--   callback = function()
--     vim.diagnostic.config({
--       update_in_insert = true,
--     })
--   end,
-- })
