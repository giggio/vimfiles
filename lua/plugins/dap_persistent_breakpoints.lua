-- Neovim plugin for persistent breakpoints.
-- https://github.com/Weissle/persistent-breakpoints.nvim
return {
  "Weissle/persistent-breakpoints.nvim",
  event = "VeryLazy",
  opts = {
    load_breakpoints_event = { "BufReadPost" },
    always_reload = true,
  },
}
