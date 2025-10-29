return {
  "xzbdmw/colorful-menu.nvim",
  config = function()
    require("colorful-menu").setup({
      ls = {
        lua_ls = {
          arguments_hl = "@comment", -- Maybe you want to dim arguments a bit.
        },
        ts_ls = { -- for lsp_config or typescript-tools
          extra_info_hl = "@comment", -- false means do not include any extra info, see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
        },
        ["rust-analyzer"] = {
          extra_info_hl = "@comment", -- Such as (as Iterator), (use std::io).
          align_type_to_right = true, -- Similar to the same setting of gopls.
          preserve_type_when_truncate = false, -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
        },
        roslyn = {
          extra_info_hl = "@comment",
        },
        fallback = true, -- If true, try to highlight "not supported" languages.
        fallback_extra_info_hl = "@comment", -- this will be applied to label description for unsupport languages
      },
      fallback_highlight = "@variable", -- If the built-in logic fails to find a suitable highlight group for a label, this highlight is applied to the label.
      max_width = 60,
    })
  end,
}
