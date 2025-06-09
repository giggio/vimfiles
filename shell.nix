{ pkgs ? import <nixpkgs> { }, ... }:

pkgs.mkShell {
  name = "vimfiles";
  nativeBuildInputs = with pkgs; [
  ];
  shellHook = ''
    echo "Let's (Neo)Vim!"
  '';
}
