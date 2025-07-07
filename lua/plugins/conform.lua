-- Lightweight yet powerful formatter plugin for Neovim
-- https://github.com/stevearc/conform.nvim
return {
  'stevearc/conform.nvim',
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
      formatters_by_ft = { -- todo: add more formatters
        markdown = { "markdownlint-cli2" },
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
      require("conform").format({ async = true, lsp_format = "fallback", range = range })
    end, { range = true })
  end,
}
