-- Lightweight yet powerful formatter plugin for Neovim
-- https://github.com/stevearc/conform.nvim
return {
  "stevearc/conform.nvim",
  opts = {},
  lazy = true,
  event = "VeryLazy",
  config = function()
    require("conform").setup({
      log_level = vim.log.levels.DEBUG,
      default_format_opts = {
        timeout_ms = 2000,
        lsp_format = "fallback",
      },
      format_on_save = function(bufnr)
        local errors =
          vim.diagnostic.get(bufnr, { severity = { min = vim.diagnostic.severity.ERROR } })
        if #errors > 0 then
          return
        end
        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
      formatters_by_ft = {
        css = { "prettierd" },
        html = { "prettierd" },
        javascript = { "prettierd" },
        json = { "prettierd" },
        lua = { "stylua" },
        markdown = { "markdownlint-cli2" },
        nix = { "nixfmt" },
        rust = { "rustfmt" },
        scss = { "prettierd" },
        sh = { "shfmt" },
        typescript = { "prettierd" },
        yaml = { "yamlfmt" },
      },
    })
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({ async = true, range = range })
    end, { range = true })
  end,
  keys = {
    {
      "<leader>j",
      "<cmd>Format<CR>",
      mode = { "n", "x", "v" },
      desc = "Reformat",
      noremap = true,
      silent = true,
    },
  },
}
