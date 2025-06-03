" init.vim - Neovim entrypoint configuration file
" In my configuration, ~/.vimrc is also loading this file

if has('nvim')
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
  " reset runtime path to be the same for all platforms
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
  " todo: check how to work with nvim on Windows, it'll probably have problems
  " with the runtimepath
endif

if has('win32unix')
  let g:vimHome = $HOME . '/.vim'
elseif has('unix')
  let g:vimHome = '~/.vim'
elseif has('win32')
  let g:vimHome = $USERPROFILE . "\\.vim"
else
  let g:vimHome = '~/.vim'
endif

runtime helpers/functions.vim

" startup errors will accumulate in this list
let g:StartupErrors = []

" Disable beep
set noerrorbells visualbell t_vb=
" Based on @mislav post http://mislav.uniqpath.com/2011/12/vim-revisited/
set nocompatible                " choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation
if has("autocmd")
  augroup FileTypes
    autocmd!
    autocmd BufRead,BufNewFile launch.json set filetype=json5
    autocmd BufRead,BufNewFile settings.json set filetype=json5
  augroup END
endif

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

" My customizations
set ls=2                        " always show status bar
set number                      " show line numbers
set cursorline                  " display a marker on current line

set completeopt=menuone,longest,preview " simple autocomplete for anything
set wildmenu
set wildmode=list:longest,full  " autocomplete for paths and files
set wildignore+=.git            " ignore these extensions on autocomplete

set hidden                      " change buffers without warnings even when there are unsaved changes

set backupdir=/tmp              " directory used to save backup files
set directory=/tmp              " directory used to save swap files
if has("win32")
  set backupdir=$TEMP
  set directory=$TEMP
endif
set nobackup
set nowritebackup

let &t_SI = "\e[1 q"            " Insert mode, blinking block
let &t_SR = "\e[4 q"            " Replace mode, solid underscore
let &t_EI = "\e[2 q"            " Normal mode, solid block

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

let vimlocal = expand("%:p:h") . "/.vimrc.local"
if filereadable(vimlocal)
  execute 'source '.vimlocal
endif
imap jj <Esc>
nmap oo o<Esc>k
nmap OO O<Esc>j
set switchbuf+=usetab,newtab
set wrapscan

set mouse=a

" remap split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" open splits in a more natural way:
set splitbelow
set splitright

set number relativenumber
set diffopt=filler,vertical

if has("autocmd")
  augroup ContinueOnTheSameLineNumber
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  augroup END
  augroup SetBufferNotListed
    autocmd!
    autocmd BufNew * if &buftype != '' | setlocal nobuflisted | endif
  augroup END
endif

set completeopt=longest,menuone,preview
" this setting controls how long to wait (in ms) before fetching type / symbol information.
set updatetime=500
" Remove 'Press Enter to continue' message when type information is longer than one line.
set cmdheight=2
" start with all unfolded.
set foldlevelstart=99

runtime session_management.vim

runtime plugins_config.vim

runtime gui.vim

runtime nerdtree.vim

runtime helpers/autosave.vim

runtime helpers/close_initial_empty_tab.vim

runtime theme.vim

if !has('nvim')
  runtime coc_nvim.vim
endif

runtime plugins.vim

call g:CatchError('colorscheme material')

if has("autocmd")
  augroup ShowStartupErrorsGroup
    autocmd!
    autocmd VimEnter * call g:ShowStartupErrors()
  augroup END
endif

if has('nvim')
  lua require('init')
endif
