return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'main',
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local languages = {
      'javascript',
      'lua',
      'rust',
      'diff',
    }
    local installed = vim.fn.glob(vim.fn.stdpath('data') .. '/site/parser/*.so', 0, 1)
    local missing = {}
    for _, lang in ipairs(languages) do
      local found = false
      for _, file in ipairs(installed) do
        if file:match(lang .. '%.so$') then
          found = true
          break
        end
      end
      if not found then
        table.insert(missing, lang)
      end
    end
    if #missing > 0 then
      print("Missing parsers: " .. table.concat(missing, ", "))
      require'nvim-treesitter'.install(missing)
    else
      print("All tree-sitter parsers are installed.")
    end
  end,
}
