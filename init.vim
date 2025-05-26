" init.vim - Neovim entrypoint configuration file, not loaded by vim

if has('win32unix')
  let vimHome = $HOME . '/.vim'
elseif has('unix')
  let vimHome = '~/.vim'
elseif has('win32')
  let vimHome = $USERPROFILE . "\\.vim"
else
  let vimHome = '~/.vim'
endif
exe 'set runtimepath^=' . vimHome
exe 'set runtimepath+=' . vimHome . '/after'
let &packpath = &runtimepath
runtime .vimrc

lua require('init')
