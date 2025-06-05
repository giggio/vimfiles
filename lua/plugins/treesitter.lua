return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'main',
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "HiPhish/rainbow-delimiters.nvim",
    "nvim-treesitter/nvim-treesitter-context",
  },
  config = function()
    local languages = { -- also remeber to add to the autocmd for FileType below
      'awk',
      'bash',
      'c',
      'cpp',
      'css',
      'csv',
      'c_sharp',
      'desktop',
      'editorconfig',
      'diff',
      'fsharp',
      'javascript',
      'git_config',
      'git_rebase',
      'gitattributes',
      'gitcommit',
      'gitignore',
      'go',
      'gotmpl',
      'html',
      'ini',
      'json',
      'json5',
      'jsonc',
      'json',
      'just',
      'lua',
      'make',
      'markdown',
      'nix',
      'nu',
      'powershell',
      'python',
      'razor',
      'regex',
      'ruby',
      'rust',
      'scss',
      'sql',
      'ssh_config',
      'terraform',
      'toml',
      'typescript',
      'vim',
      'xml',
      'yaml',
    }
    local installed = vim.api.nvim_get_runtime_file("parser/*.so", true)
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
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = languages,
      callback = function()
        vim.treesitter.start()
        vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.opt.foldmethod = 'expr'
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    require'treesitter-context'.setup{
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      multiwindow = true, -- Enable multiwindow support.
      max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
      zindex = 20, -- The Z-index of the context window
    }
  end,
}
