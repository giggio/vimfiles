" init.vim - Neovim entrypoint configuration file, not loaded by vim

" vimHome is a variable used for compatibility with both Vim and Neovim.
if has('win32unix')
  let g:vimHome = $HOME . '/.vim'
elseif has('unix')
  let g:vimHome = '~/.vim'
elseif has('win32')
  let g:vimHome = $USERPROFILE . "\\.vim"
else
  let g:vimHome = '~/.vim'
endif

runtime .vimrc

lua require('init')
