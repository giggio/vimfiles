if !has('nvim')
  if empty(glob(vimHome . '/autoload/plug.vim'))
    if has('unix')
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    elseif has('win32')
      execute 'silent !powershell -noprofile -c "Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | New-Item $env:USERPROFILE/.vim/autoload/plug.vim -Force"'
    endif
  endif

  " Run PlugInstall if there are missing plugins
  autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \| PlugInstall --sync | source $MYVIMRC
        \| endif
endif

let g:pluginInstallPath = g:vimHome . '/plugged'
runtime manage_plugins.vim

if !has('nvim')
  call plug#begin(g:pluginInstallPath)
endif

" Using 'Plugin' instead of 'Plug' because of the adapter from manage_plugins.vim
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'plasticboy/vim-markdown'
Plugin 'Shougo/vimproc.vim', {'do' : 'make'}
Plugin 'digitaltoad/vim-pug'
Plugin 'tpope/vim-commentary'
Plugin 'vim-syntastic/syntastic'
Plugin 'honza/vim-snippets'
Plugin 'tpope/vim-fugitive'
Plugin 'mattn/emmet-vim'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'easymotion/vim-easymotion'
Plugin 'vim-scripts/ReplaceWithRegister'
Plugin 'kevinoid/vim-jsonc'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'kaicataldo/material.vim', { 'branch': 'main' }
Plugin 'ryanoasis/vim-devicons'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
Plugin 'AndrewRadev/bufferize.vim'
if version >= 900 || has('nvim')
  Plugin 'github/copilot.vim'
endif

if has('nvim')
  lua require("config.lazy")
  " lazy sets runtime path, removes the default runtime path, and everything fails
  " so, here we are setting them back
  " todo: if nvim and vim dirs are unified, this probably can be removed
  exe 'set runtimepath^=' . vimHome
  exe 'set runtimepath+=' . vimHome . '/after'
else
  call plug#end()
endif

if !has('nvim')
  packadd! editorconfig " editorconfig is on by default on nvim
endif
