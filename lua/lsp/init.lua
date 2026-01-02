local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
  capabilities = capabilities,
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

if not vim.g.is_server then
  vim.lsp.config("cSpell", require("lsp.cspellls"))

  vim.lsp.config("powershell_es", {
    -- using powershell-editor-services from nix, it comes already bundled
    cmd = function(dispatchers)
      local temp_path = vim.fn.stdpath("cache")
      local command_fmt =
        [[ -LogPath '%s/powershell_es.log' -SessionDetailsPath '%s/powershell_es.session.json' -FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio -LogLevel Normal]]
      local command = command_fmt:format(temp_path, temp_path)
      local cmd = { "powershell-editor-services", command }
      return vim.lsp.rpc.start(cmd, dispatchers)
    end,
  })

  vim.lsp.config("jsonls", {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  })
end

require("lsp.lua_ls")

if not vim.g.is_server then
  -- vim.lsp.enable('bacon_ls') -- rust enabled using rustacean.lua
  vim.lsp.enable("basedpyright")
  vim.lsp.enable("cSpell")
  vim.lsp.enable("clangd")
  vim.lsp.enable("csharp_ls")
  vim.lsp.enable("cssls")
  vim.lsp.enable("emmet_language_server")
  vim.lsp.enable("eslint")
  vim.lsp.enable("fsautocomplete")
  vim.lsp.enable("gopls")
  vim.lsp.enable("html")
  vim.lsp.enable("jsonls")
  vim.lsp.enable("marksman")
  vim.lsp.enable("nushell")
  vim.lsp.enable("powershell_es")
  vim.lsp.enable("ruby_lsp")
  -- vim.lsp.enable('rust_analyzer') -- rust enabled using rustacean.lua
  vim.lsp.enable("sqls")
  vim.lsp.enable("ts_ls")
end
vim.lsp.enable("bashls")
vim.lsp.enable("dockerls")
vim.lsp.enable("systemd_ls")
vim.lsp.enable("vimls")
vim.lsp.enable("yamlls")

vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("LspDiagnosticsHold", { clear = true }),
  callback = function()
    -- Only open if a diagnostic exists under the cursor
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local diags = vim.diagnostic.get(0, { lnum = line - 1 })
    for _, d in ipairs(diags) do
      if col >= d.col and col < d.end_col then
        vim.diagnostic.open_float(nil, {
          focusable = false,
          close_events = {
            "BufHidden",
            "BufLeave",
            "CursorMoved",
            "InsertEnter",
            "WinLeave",
          },
          border = "rounded",
          source = "always",
          prefix = " ",
          scope = "cursor",
        })
        break
      end
    end
  end,
})

-- allow gotmpl files to be recognized as HTML files when hugo config files are present
if not vim.g.is_server then
  if
    vim.fn.filereadable("./hugo.yaml") == 1
    or vim.fn.filereadable("./hugo.toml") == 1
    or vim.fn.filereadable("./hugo.json") == 1
    or vim.fn.glob("./config/**/hugo.yaml") ~= ""
    or vim.fn.glob("./config/**/hugo.toml") ~= ""
    or vim.fn.glob("./config/**/hugo.json") ~= ""
  then
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = { "*.html" },
      command = "set filetype=gotmpl",
    })
  end
end

-- using tiny_code_action.nvim for code actions:
-- vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "LSP: code action" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "LSP: rename" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "LSP: go to definition" })
vim.keymap.set("n", "<F12>", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "LSP: go to definition" })
vim.keymap.set(
  "n",
  "gy",
  vim.lsp.buf.type_definition,
  { noremap = true, silent = true, desc = "LSP: go to type definition" }
)
-- vim.keymap.set( "n", "gr", vim.lsp.buf.references, { noremap = true, silent = true, desc = "LSP: go to references" })
vim.keymap.set(
  "n",
  "gi",
  vim.lsp.buf.implementation,
  { noremap = true, silent = true, desc = "LSP: go to implementation" }
)

-- vim.api.nvim_set_keymap('n', '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<leader>do", function()
  vim.diagnostic.open_float({ scope = "buffer" })
end, { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>d[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>d]", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = true })
-- The following command requires plug-ins "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", and optionally "kyazdani42/nvim-web-devicons" for icon support
vim.api.nvim_set_keymap("n", "<leader>dd", "<cmd>Telescope diagnostics<CR>", { noremap = true, silent = true })
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
--

-- Open PopUp window with Menu key
vim.diagnostic.config({
  update_in_insert = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
})

-- keep original handler
-- local default_publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]

-- hide rustc errors from LSP diagnostics
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
--   if not result or not result.diagnostics then
--     return default_publish_diagnostics(err, result, ctx, config)
--   end
--   if vim.api.nvim_get_option_value("filetype", { buf = ctx.bufnr }) ~= "rust" then
--     return default_publish_diagnostics(err, result, ctx, config)
--   end
--   -- filter: drop diagnostics that come from "rustc" and have severity = Error
--   result.diagnostics = vim.tbl_filter(function(d)
--     if not d.source then
--       return true
--     end
--     if d.source == "rustc" then
--       local sev = d.severity or 1
--       -- LSP severities: Error=1, Warning=2, Information=3, Hint=4
--       if sev == vim.diagnostic.severity.ERROR or sev == 1 then
--         return false -- drop rustc errors
--       end
--     end
--     return true
--   end, result.diagnostics)
--   return default_publish_diagnostics(err, result, ctx, config)
-- end

-- consolidate LSP signs to show only the highest severity per line
local ns = vim.api.nvim_create_namespace("consolidated_signs")
local orig_signs_handler = vim.diagnostic.handlers.signs
vim.diagnostic.handlers.signs = {
  show = function(_, bufnr, _, opts)
    local diagnostics = vim.diagnostic.get(bufnr)
    local max_severity_per_line = {}
    for _, d in pairs(diagnostics) do
      local m = max_severity_per_line[d.lnum]
      if not m or d.severity < m.severity then
        max_severity_per_line[d.lnum] = d
      end
    end
    orig_signs_handler.show(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
  end,
  hide = function(_, bufnr)
    orig_signs_handler.hide(ns, bufnr)
  end,
}

vim.keymap.set({ "n", "v" }, "<Menu>", "<Cmd>popup PopUp<CR>")
vim.keymap.set("i", "<Menu>", "<C-\\><C-n><Cmd>popup PopUp<CR>")
