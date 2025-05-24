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

call plug#begin(g:vimHome . '/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'plasticboy/vim-markdown'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'digitaltoad/vim-pug'
Plug 'tpope/vim-commentary'
Plug 'vim-syntastic/syntastic'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-fugitive'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'christoomey/vim-tmux-navigator'
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'kevinoid/vim-jsonc'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jpo/vim-railscasts-theme'
if version >= 900 || has('nvim')
  Plug 'github/copilot.vim'
endif

call plug#end()

if !has('nvim')
  packadd! editorconfig " editorconfig is on by default on nvim
endif
