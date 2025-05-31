local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('*', {
  capabilities = capabilities,
})
require("lsp.lua_ls")

vim.lsp.enable('rust_analyzer')
vim.lsp.enable('ts_ls')
vim.lsp.enable('marksman')
vim.lsp.enable('vimls')
vim.lsp.enable('html')
vim.lsp.enable('jsonls')
vim.lsp.enable('cssls')
vim.lsp.enable('eslint')
vim.lsp.enable('emmet_language_server')

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

vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "LSP: code action" })
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

