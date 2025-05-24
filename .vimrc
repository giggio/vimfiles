" reset runtime path to be the same for all platforms
set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
" Disable beep
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif
" Based on @mislav post http://mislav.uniqpath.com/2011/12/vim-revisited/
set nocompatible                " choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation

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

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

set t_Co=256                    " forces terminal to use 256 colors
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    set guifont=CaskaydiaCove\ NF:h11:cANSI,DejaVu_Sans_Mono_for_Powerline:h11:cANSI,Consolas:h11:cANSI,Courier:h12:cANSI
  endif
endif

function! SessionAutoStart()
  if filereadable(".session.vim")
    source .session.vim
  endif
endfunction
augroup SessionAuto
  autocmd!
  autocmd VimEnter * nested call SessionAutoStart()
  autocmd VimLeavePre * call SaveSession()
augroup END

function! SaveSession()
  set lazyredraw
  silent! call CloseNERDTreeOnAllTabs()
  silent! mksession! .session.vim
  silent! call OpenNERDTreeOnAllTabs()
  set nolazyredraw
  redraw!
endfunction

function! CloseNERDTreeOnAllTabs()
  if exists("g:NERDTree")
    let s:orig = tabpagenr()
    tabdo NERDTreeClose
    execute 'tabnext' s:orig
  endif
endfunction

function! OpenNERDTreeOnAllTabs()
  if exists("g:NERDTree")
    let s:orig = tabpagenr()
    silent! NERDTree
    silent! tabdo if tabpagenr() != s:orig
      \| silent! NERDTreeMirror
      \| wincmd p
      \| endif
    silent! execute 'tabnext' s:orig
    wincmd p
  endif
endfunction

function! ConfigureNERDTree()
  if exists("g:NERDTree")
    noremap <F2> :NERDTreeToggle<CR>
    let g:NERDTreeShowHidden=1
    " Open the existing NERDTree on each new tab.
    autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif
    " Exit Vim if NERDTree is the only window remaining in the only tab.
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
    " Close the tab if NERDTree is the only window remaining in it.
    autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
    if !exists('s:std_in') 
      NERDTree
      let s:orig = tabpagenr()               " remember where we started
      let s:last  = tabpagenr('$')           " total number of tabs
      for i in range(1, s:last - 1)
        silent! tabnext
        silent! NERDTreeMirror
        silent! wincmd p
      endfor
      tabnext
      silent! wincmd p
    endif
    " Start NERDTree. If a file is specified, move the cursor to its window.
    if argc() > 0 || exists("s:std_in") | wincmd p | endif
    map <S-A-l> :NERDTreeFind<CR>
  endif
endfunction
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * call ConfigureNERDTree()

if ! has('nvim')
  :set guioptions+=m  "add menu bar
  :set guioptions+=R  "remove right-hand scroll bar
endif
:set guioptions-=T  "remove toolbar
:set guioptions-=r  "remove right-hand scroll bar
:set guioptions-=l  "remove left-hand scroll bar
:set guioptions-=L  "remove left-hand scroll bar

let g:loaded_syntastic_typescript_tsc_checker = 1 "don't do syntax checking

let vimlocal = expand("%:p:h") . "/.vimrc.local"
if filereadable(vimlocal)
  execute 'source '.vimlocal
endif
imap jj <Esc>
nmap oo o<Esc>k
nmap OO O<Esc>j
au GUIEnter * simalt ~x
set switchbuf+=usetab,newtab
set wrapscan
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#close_symbol = ''
let g:airline#extensions#tabline#buffer_nr_format = 'b%s: '
"let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#fnamecollapse = 1
let g:airline_theme='dark'

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
au BufReadPost fugitive:* set bufhidden=delete
if ! has('nvim')
  fun! QuitPrompt(cmd)
    if tabpagenr("$") == 1 && winnr("$") == 1
      let choice = confirm("Close?", "&yes\n&no", 1)
      if choice == 1 | return a:cmd | endif
      return ""
    else | return a:cmd | endif
  endfun
  cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == 'q' ? QuitPrompt(getcmdline()) : 'q'
  cnoreabbrev <expr> qa getcmdtype() == ":" && getcmdline() == 'q' ? QuitPrompt(getcmdline()) : 'qa'
  cnoreabbrev <expr> wq getcmdtype() == ":" && getcmdline() == 'wq' ? QuitPrompt(getcmdline()) : 'wq'
  cnoreabbrev <expr> wqa getcmdtype() == ":" && getcmdline() == 'wq' ? QuitPrompt(getcmdline()) : 'wqa'
  cnoreabbrev <expr> x getcmdtype() == ":" && getcmdline() == 'x' ? QuitPrompt(getcmdline()) : 'x'
  cnoreabbrev <expr> xa getcmdtype() == ":" && getcmdline() == 'x' ? QuitPrompt(getcmdline()) : 'xa'
endif

" highlight trailing white spaces:
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

set completeopt=longest,menuone,preview
" this setting controls how long to wait (in ms) before fetching type / symbol information.
set updatetime=500
" Remove 'Press Enter to continue' message when type information is longer than one line.
set cmdheight=2
" start with all unfolded.
set foldlevelstart=99

" Easymotion config:
" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1
let g:ctrlp_max_files=0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|yarn)|node_modules$',
  \ 'file': '\v\.(exe|so|dll)$'
  \ }

set mouse=a

" continue on the same line number
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"
" remap for complete to use tab and <cr>
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1):
    \ <SID>check_back_space() ? "\<Tab>" :
    \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()

if has('win32unix')
  let vimHome = $HOME . '/.vim'
elseif has('unix')
  let vimHome = '~/.vim'
elseif has('win32')
  let vimHome = $USERPROFILE . "\\.vim"
endif

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

let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-css', 'coc-snippets', 'coc-sh', 'coc-rust-analyzer', 'coc-angular']
let g:coc_snippet_next="<tab>"
let g:coc_snippet_prev="<s-tab>"

call plug#begin(vimHome . '/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
Plug 'kien/ctrlp.vim'
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
Plug 'ervandew/ag'
Plug 'jpo/vim-railscasts-theme'
if version >= 900 || has('nvim')
  Plug 'github/copilot.vim'
endif

call plug#end()

colorscheme railscasts          " set colorscheme

