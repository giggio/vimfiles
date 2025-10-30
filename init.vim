" init.vim - Neovim entrypoint configuration file
" In my configuration, ~/.vimrc is also loading this file

" vimHome is a variable used for compatibility with both Vim and Neovim.
if has('win32unix')
  let g:vimHome = $HOME . '/.vim'
elseif has('win32')
  let g:vimHome = $USERPROFILE . '/.vim'
else
  let g:vimHome = '~/.vim'
endif
" reset runtime path to be the same for all platforms
if has('nvim')
  set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
else
  let &runtimepath = g:vimHome . ',$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,' . g:vimHome . '/after'
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
if has("nvim")                  " Show sign column when needed (for glyphs etc)
  set signcolumn=auto:3
elseif has("signs")
  set signcolumn=auto             " Show sign column when needed (for glyphs etc)
endif
set cursorline                  " display a marker on current line

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

let vimlocal = expand("%:p:h") . "/.vimrc.local"
if filereadable(vimlocal)
  execute 'source '.vimlocal
endif
set switchbuf+=usetab,newtab
set wrapscan

set mouse=a

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
    autocmd BufEnter * if &buftype != '' | setlocal nobuflisted | endif
  augroup END
endif

set completeopt=longest,menuone,preview
" this setting controls how long to wait (in ms) before fetching type / symbol information.
set updatetime=300
" Remove 'Press Enter to continue' message when type information is longer than one line.
set cmdheight=2
" start with all unfolded.
set foldlevelstart=99

runtime maps.vim

runtime session_management.vim

runtime plugins_config.vim

runtime gui.vim

runtime nerdtree.vim

runtime helpers/buffers.vim

runtime helpers/autosave.vim

runtime helpers/close_initial_empty_tab.vim

runtime theme.vim

if !has('nvim')
  runtime coc_nvim.vim
endif

runtime plugins.vim

call g:CatchError('colorscheme material')
" remove background from vim:
hi Normal guibg=NONE ctermbg=NONE

if has("autocmd")
  augroup ShowStartupErrorsGroup
    autocmd!
    autocmd VimEnter * call g:ShowStartupErrors()
  augroup END
endif

if has('nvim')
  " disable popup menu "Disable mouse" message
  aunmenu PopUp.How-to\ disable\ mouse
  aunmenu PopUp.-2-
  lua require('init')
endif
