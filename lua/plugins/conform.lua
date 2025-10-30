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

    local group_format_when_diags_change =
      vim.api.nvim_create_augroup("FormatWhenDiagnosticsChange", { clear = true })

    vim.api.nvim_create_autocmd("DiagnosticChanged", {
      group = group_format_when_diags_change,
      callback = function(args)
        local mode = vim.api.nvim_get_mode().mode
        if mode ~= "n" and not mode:match("v") then
          return
        end
        local errors =
          vim.diagnostic.get(args.buf, { severity = { min = vim.diagnostic.severity.ERROR } })
        if #errors > 0 then
          return
        end
        if vim.api.nvim_get_option_value("readonly", { buf = args.buf }) ~= "noreadonly" then
          return
        end
        require("conform").format({ bufnr = args.buf })
      end,
    })

    local state_buffer_had_errors = {}

    vim.api.nvim_create_autocmd("InsertEnter", {
      group = group_format_when_diags_change,
      callback = function(args)
        local errors =
          vim.diagnostic.get(args.buf, { severity = { min = vim.diagnostic.severity.ERROR } })
        state_buffer_had_errors[args.buf] = #errors > 0
      end,
    })

    vim.api.nvim_create_autocmd("InsertLeave", {
      group = group_format_when_diags_change,
      callback = function(args)
        if state_buffer_had_errors[args.buf] then
          local errors =
            vim.diagnostic.get(args.buf, { severity = { min = vim.diagnostic.severity.ERROR } })
          if #errors == 0 then
            require("conform").format({ bufnr = args.buf })
          end
        end
      end,
    })
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
