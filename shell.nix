{ pkgs ? import <nixpkgs> { }, ... }:

pkgs.mkShell {
  name = "vimfiles";
  nativeBuildInputs = with pkgs; [
    vim-language-server # VImScript language server, LSP for vim script https://github.com/iamcco/vim-language-server
    lua-language-server # Lua language server https://github.com/LuaLS/lua-language-server
    # I'd add luajit here, but I'm installing it globally, as I need some packages for shared
    # extensions, like tiktoken_core, used by Github Copilot Chat.
  ];
  shellHook = ''
    echo "Let's (Neo)Vim!"
  '';
}
