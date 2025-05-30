{ pkgs ? import <nixpkgs> { }, ... }:

pkgs.mkShell {
  name = "vimfiles";
  nativeBuildInputs = with pkgs; [
    vim-language-server # VImScript language server, LSP for vim script https://github.com/iamcco/vim-language-server
    lua-language-server # Lua language server https://github.com/LuaLS/lua-language-server
    (luajit.withPackages (ps: [
      ps.luarocks # A package manager for Lua modules https://luarocks.org/
      # luacheck # A static analyzer and a linter for Lua
    ]))
  ];
  shellHook = ''
    echo "Let's (Neo)Vim!"
  '';
}
