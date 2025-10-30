# Agent Guidelines for Neovim Configuration

This is a personal system wide Vim/Neovim configuration, written in Lua and Vimscript.
Neovim has precedence over Vim configuration, Vim is maintained for compatibility, but many features are still written
in Vimscript.
Check for oficial documentation when in doubt about Neovim or Vim features, including for plugins.

## Project Structure

- Plugins setup is managed via `lazy.nvim` in `lua/plugins/`, and lazy itself is configured in `lua/config/lazy.lua`.
- LSP configurations are in `lua/lsp/`
- Helper functions are in `lua/helpers/`
- There aren't automated tests; this is a personal Neovim config.

## Formatting & Linting

- Format on save enabled via conform.nvim (only when no errors present)
- Formatters: stylua (Lua)
- Linters: markdownlint-cli2 (Markdown)

## Code Style

- **Indentation**: 2 spaces (tabs expanded), configured in `.editorconfig`
- **Lua**: Use `require()` at top, follow plugin structure in `lua/plugins/`, return table with lazy.nvim spec
- **VimScript**: Use `runtime` for sourcing, functions in `helpers/`, autocmds in augroups
- **LSP**: Enable via `vim.lsp.enable()` in `lua/lsp/init.lua`
- **Naming**: kebab-case for files, snake_case for Lua vars/functions, PascalCase for augroups
- **Types**: Use LSP for type checking, inlay hints enabled
- **Error Handling**: For Vimscript Use `g:CatchError()` for startup errors, store in `g:StartupErrors`, for Lua follow
  Lua conventions and best practices.
