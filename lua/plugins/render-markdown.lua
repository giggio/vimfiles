-- Plugin to improve viewing Markdown files in Neovim
-- https://github.com/MeanderingProgrammer/render-markdown.nvim
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("render-markdown").setup({
      code = {
        enabled = true,
        language_name = true,
        conceal_delimiters = false,
        border = "thick",
      },
      anti_conceal = {
        enabled = true,
        disabled_modes = false,
        above = 1,
        below = 1,
        ignore = {
          code_background = true,
        },
      },
    })
    vim.api.nvim_create_autocmd({ "ColorScheme" }, {
      group = vim.api.nvim_create_augroup("RenderMarkdownColorScheme", { clear = true }),
      callback = function()
        vim.cmd("highlight RenderMarkdownCode guibg=#1D1D1D ctermbg=black")
      end,
    })
  end,
}
