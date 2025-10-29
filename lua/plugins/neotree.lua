-- Neovim plugin to manage the file system and other tree like structures.
-- (a replacement for NERDTree)
-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim",
    {
      "s1n7ax/nvim-window-picker",
      version = "2.*",
      config = function()
        require("window-picker").setup({
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { "neo-tree", "neo-tree-popup", "notify" },
              -- if the buffer type is one of following, the window will be ignored
              buftype = { "terminal", "quickfix" },
            },
          },
        })
      end,
    },
  },
  lazy = false,
  config = function()
    -- vim.diagnostic.config({
    --   signs = {
    --     text = {
    --       [vim.diagnostic.severity.ERROR] = '',
    --       [vim.diagnostic.severity.WARN] = '',
    --       [vim.diagnostic.severity.INFO] = '',
    --       [vim.diagnostic.severity.HINT] = '󰌵',
    --     },
    --   }
    -- })
    vim.keymap.set("n", "<F2>", "<Cmd>Neotree toggle<CR>")
    require("neo-tree").setup({
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
      },
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      enable_git_status = true,
      enable_diagnostics = true,
      open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
      sort_case_insensitive = true,
      filesystem = {
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false, -- only works on Windows for hidden files/directories
          hide_by_name = {
            ".git",
            ".direnv",
            "node_modules",
            "target", -- rust build output
            "dist", -- common build output
            "plugged", -- vim/nvim installed plugins
          },
          hide_by_pattern = {},
          always_show = {},
          always_show_by_pattern = {},
          never_show = {
            ".session.vim",
          },
          never_show_by_pattern = {},
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
        group_empty_dirs = true,
        use_libuv_file_watcher = true,
      },
      window = {
        position = "right",
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["Z"] = "expand_all_nodes",
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
        },
      },
    })
    vim.api.nvim_create_autocmd({ "VimEnter" }, {
      group = vim.api.nvim_create_augroup("NeoTreeCmds", { clear = true }),
      callback = function()
        vim.cmd("Neotree reveal")
        vim.cmd("wincmd t")
      end,
    })
  end,
}
