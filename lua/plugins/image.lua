-- 🖼️ Bringing images to Neovim.
-- https://github.com/3rd/image.nvim
return {
  "3rd/image.nvim",
  -- todo: remove commit when https://github.com/3rd/image.nvim/issues/292 is fixed
  -- this affects only neo-tree
  commit = "21909e3eb03bc738cce497f45602bf157b396672",
  lazy = false,
  enabled = vim.fn.has("unix") == 1 and not vim.g.is_server, -- no Windows Support, see https://github.com/3rd/image.nvim/issues/115
  config = function()
    require("image").setup({
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          only_render_image_at_cursor_mode = "popup",
          floating_windows = false, -- if true, images will be rendered in floating markdown windows
          filetypes = { "markdown" }, -- markdown extensions (ie. quarto) can go here
        },
        html = {
          enabled = true,
        },
        css = {
          enabled = true,
        },
      },
    })
  end,
}
