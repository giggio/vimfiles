-- An asynchronous linter plugin for Neovim complementary to the built-in Language Server Protocol support.
-- https://github.com/mfussenegger/nvim-lint
return {
  'mfussenegger/nvim-lint',
  opts = {},
  lazy = true,
  event = "VeryLazy",
  init = function()
    vim.api.nvim_create_augroup("LintOnOpenAndSave", { clear = true })
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
      group = "LintOnOpenAndSave",
      callback = function()
        local path = vim.fn.expand("%:p")
        if vim.bo.buftype == "" and vim.loop.fs_stat(path) then
          require("lint").try_lint()
        end
      end,
    })
  end,
  config = function()
    require('lint').linters_by_ft = {
      markdown = { 'markdownlint-cli2' },
    }
  end,
}
