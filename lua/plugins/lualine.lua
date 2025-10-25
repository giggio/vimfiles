-- https://github.com/nvim-lualine/lualine.nvim
-- A blazing fast and easy to configure neovim statusline plugin written in pure lua.
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        theme = 'ayu_dark',
      },
      extensions = {
        'neo-tree', 'lazy', 'fugitive', 'nvim-dap-ui', 'man', 'overseer', 'quickfix', 'trouble',
        { sections = { lualine_a = {'filename'} }, filetypes = {'neotest-summary'} }
      },
      sections = {
        lualine_c = {
          {
            'filename',
            path = 1,
            shorting_target = 50
          },
        },
        lualine_x = {
          'lsp_status',
          'encoding',
          'fileformat',
          {
            'filetype',
            icon_only = true,
          }
        },
      },
    }
  end,
}
