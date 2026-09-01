# External tools on Windows

This configuration is shared between Linux and Windows. The Lua and Vimscript in this repo loads on its own, but a lot
of the plugins shell out to external programs: language servers, formatters, linters and a C compiler. On Linux those
usually come from the system package manager (or the nix flake in this repo). On Windows they have to be installed
by hand, and when one of them is missing Neovim complains about it on every buffer that would have used it, with
messages such as:

- `Spawning language server with cmd: { "vscode-json-language-server", "--stdio" } failed.`
- `Error during "tree-sitter build": Failed to compile parser ... program not found`
- `Formatters unavailable for lua file`

This file lists what to install and why. [scoop](https://scoop.sh) is used wherever a package exists for it.

## Prerequisites

These are the runtimes the rest of the tools are installed with:

```powershell
scoop install main/rustup main/go main/python main/pipx main/ruby
```

Node comes from the [official installer](https://nodejs.org) (`C:\Program Files\nodejs`) and the .NET SDK from
[dotnet.microsoft.com](https://dotnet.microsoft.com/download), neither through scoop. `pipx` is used for the Python
based servers so each gets its own virtualenv.

Ruby does not get scoop shims, it adds `~\scoop\apps\ruby\current\bin` and `...\gems\bin` to the `PATH` instead, so a
new shell is needed after installing it before `gem` resolves.

## C compiler (required)

`nvim-treesitter` compiles every parser locally, and `telescope-fzf-native` builds a small DLL. Both need a C compiler.
Visual Studio's C++ build tools are not installed on this machine, so MinGW is used instead:

```powershell
scoop install main/mingw
```

Two things depend on this:

- `tree-sitter build` picks its compiler through Rust's `cc` crate, which defaults to `cl.exe` on Windows. When the
  MSVC build tools are absent that fails with `program not found`, so `lua/plugins/treesitter.lua` sets `$CC` to
  `gcc`/`clang`/`cc` when `cl` is not on the `PATH`. This is guarded to Windows and is a no-op elsewhere.
- `telescope-fzf-native` is built with `make`, which MinGW also provides. If Telescope reports
  `'fzf' extension doesn't exist or isn't installed`, run `:Lazy build telescope-fzf-native.nvim`.

If `tree-sitter build` ever fails with `Lock file ... appears stale`, delete the leftovers in
`%LOCALAPPDATA%\tree-sitter\lock\`. They are left behind by builds that were killed halfway.

## Language servers

The servers enabled in `lua/lsp/init.lua`:

```powershell
npm i -g vscode-langservers-extracted typescript-language-server typescript@5 yaml-language-server bash-language-server
scoop install main/lua-language-server main/marksman
go install golang.org/x/tools/gopls@latest
dotnet tool install -g csharp-ls
gem install ruby-lsp
pipx install basedpyright
```

`vscode-langservers-extracted` is the one package that provides the json, css, html and eslint servers.

**`typescript` has to be pinned to 5.x.** TypeScript 7 is a native rewrite that no longer ships `lib/tsserver.js`, and
`typescript-language-server` refuses to start against it with
`Could not find a valid TypeScript installation`. When the config eventually moves to `tsgo` (the TypeScript 7 native
language server, already available as `lspconfig`'s `tsgo`) this pin can be dropped.

Not installed yet, no Windows package that is worth the trouble: `clangd`, `nil` (nix), `sqls`, `systemd-lsp`,
`emmet-language-server`, `vim-language-server`, `docker-langserver`. They are enabled in the config but Neovim skips
servers whose command is missing, so they cost nothing.

### npm and gem wrappers

npm and RubyGems install two files per executable on Windows: an extensionless shell script (for MSYS/Cygwin) and a
`.cmd`/`.bat` wrapper. Neovim's `exepath()` resolves to the extensionless one, which `CreateProcess` cannot run, so
every server installed this way fails to spawn even though it is on the `PATH`. `lua/lsp/init.lua` wraps
`vim.lsp.rpc.start` on Windows to rewrite the command to its `.cmd`/`.bat` sibling. It has to happen there rather than
per server because some `lspconfig` definitions (`jsonls`, `ts_ls`, ...) build their command inside a function.

## Formatters and linters

Used by `conform.nvim` and `nvim-lint`:

```powershell
scoop install main/stylua main/shfmt main/yamlfmt main/shellcheck main/hadolint
npm i -g @fsouza/prettierd markdownlint-cli2
```

The prettier daemon is published as `@fsouza/prettierd`; there is no plain `prettierd` package.

`rustfmt` comes with rustup. `nixfmt` is Linux only and is simply unavailable here, which is harmless: conform reports
`Formatters unavailable for nix file` and leaves the buffer alone.

`stylua` reads this repo's `.editorconfig` because conform passes `--stdin-filepath`, so formatting on save keeps the
two-space indentation instead of falling back to stylua's default tabs.

## Rust

```powershell
rustup component add rust-analyzer rust-src
```

`rust-src` is what lets rust-analyzer resolve the standard library; without it every buffer gets
`sysroot ... is missing a core library`. If `rustup component add rust-src` fails with
`detected conflict: 'lib\rustlib\src\rust\library\.cargo\config.toml'`, an earlier install was interrupted and left a
truncated tree behind. Delete `<toolchain>\lib\rustlib\src` and add the component again.

Note that `rust-analyzer` reports `Failed to discover workspace` for a `.rs` file that is not part of a cargo project.
That is expected and not a configuration problem.

## Known gaps

### lua-json5

`nvim-dap` uses [lua-json5](https://github.com/Joakker/lua-json5) to read `launch.json` files with comments and trailing
commas. It is a Rust cdylib, and rustup's default toolchain on Windows is `x86_64-pc-windows-msvc`, which needs the
MSVC linker. Visual Studio is installed on this machine but without the C++ workload, so the build fails with
`linking with link.exe failed`. Adding `x86_64-pc-windows-gnu` as a target does not help either, because the
proc-macro build scripts are still compiled for the host.

To fix it, add the **Desktop development with C++** workload:

```powershell
winget install Microsoft.VisualStudio.2026.Community --override "--add Microsoft.VisualStudio.Workload.NativeDesktop"
```

then `:Lazy build lua-json5`. Until that happens `lua/plugins/dap.lua` falls back to nvim-dap's own decoder and prints
a warning at startup, rather than failing the whole nvim-dap setup as it used to.

That workload would also give `cl.exe`, making the `$CC` fallback described above unnecessary.

### Debug adapters

`:checkhealth dap` reports four adapters whose command is missing: `codelldb` and `lldb-dap` (Rust and C/C++) and
`js-debug` (Node). None of them are in a scoop bucket:

- `codelldb` ships in the [vscode-lldb](https://github.com/vadimcn/codelldb) releases.
- `js-debug` ships in the [vscode-js-debug](https://github.com/microsoft/vscode-js-debug) releases.
- `lldb-dap` comes with LLVM (`scoop install main/llvm`, around 2 GB).

Debugging simply does not start without them; nothing else is affected.

### busted

`neotest-busted` needs `busted`, which comes from luarocks against Lua 5.1 (`scoop install main/luarocks`
and `main/lua-for-windows`). It is not installed, so `:checkhealth neotest-busted` warns about it.

## Where plugins are installed

On Windows the Neovim config directory is `%LOCALAPPDATA%\nvim`, which is this repository, and `lazy.nvim`'s root is
derived from it, so plugins are cloned into `<repo>\plugins\`. That directory is in `.gitignore`. Be careful with
`git clean -xfd` in this repository: it would wipe every installed plugin.
