return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    anti_conceal = {
      enabled = true,
      disabled_modes = false,
      above = 1,
      below = 1,
      ignore = {
        code_background = true,
      },
    },
  },
}
