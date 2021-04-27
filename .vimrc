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
colorscheme railscasts          " set colorscheme

set completeopt=menuone,longest,preview " simple autocomplete for anything
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

map <F2> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
autocmd BufWinEnter * silent NERDTreeMirror

:set guioptions+=m  "add menu bar
:set guioptions-=T  "remove toolbar
:set guioptions-=r  "remove right-hand scroll bar

let g:loaded_syntastic_typescript_tsc_checker = 1 "don't do syntax checking

let vimlocal = expand("%:p:h") . "/.vimrc.local"
if filereadable(vimlocal) 
  execute 'source '.vimlocal
endif
map <S-A-l> :NERDTreeFind<CR>
imap jj <Esc>
nmap oo o<Esc>k
nmap OO O<Esc>j
au GUIEnter * simalt ~x
nmap <F9> :mksession! <cr> " Quick write session with F9
nmap <F10> :source Session.vim <cr> " And load session with F10
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
fun! QuitPrompt(cmd)
  if tabpagenr("$") == 1 && winnr("$") == 1
    let choice = confirm("Close?", "&yes\n&no", 1)
    if choice == 1 | return a:cmd | endif
    return ""
  else | return a:cmd | endif
endfun
cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == 'q' ? QuitPrompt(getcmdline()) : 'q'
cnoreabbrev <expr> wq getcmdtype() == ":" && getcmdline() == 'wq' ? QuitPrompt(getcmdline()) : 'wq'
cnoreabbrev <expr> x getcmdtype() == ":" && getcmdline() == 'x' ? QuitPrompt(getcmdline()) : 'x'

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

" Easymotion config:
" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1
let g:ctrlp_max_files=0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|yarn)|node_modules$',
  \ 'file': '\v\.(exe|so|dll)$'
  \ }

set mouse=a

" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <NUL> coc#refresh()

if has('unix')
  let vimHome = '~/.vim'
elseif has('win32')
  let vimHome = $USERPROFILE . "\\vimfiles"
endif

if empty(glob(vimHome . '/autoload/plug.vim'))
  if has('unix')
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  elseif has('win32')
    execute 'silent !powershell -noprofile -c "Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | New-Item $env:USERPROFILE/vimfiles/autoload/plug.vim -Force"'
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
Plug 'kchmck/vim-coffee-script'
Plug 'kien/ctrlp.vim'
Plug 'plasticboy/vim-markdown'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'digitaltoad/vim-pug'
Plug 'tpope/vim-commentary'
Plug 'vim-syntastic/syntastic'
Plug 'honza/vim-snippets'
" Plug 'SirVer/ultisnips'
Plug 'tpope/vim-fugitive'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'christoomey/vim-tmux-navigator'
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'kevinoid/vim-jsonc'

call plug#end()

