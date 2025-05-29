function! s:SessionAutoStart()
  let g:session_autoloading=0
  if exists("g:session_disable_autoload") && g:session_disable_autoload == 1
    return
  endif
  if argc() > 0
    let s:session_autoload=0
    return
  endif
  let s:session_autoload=1
  let g:session_autoloading=1
  if filereadable(".session.vim")
    source .session.vim
  endif
  let g:session_autoloading=0
endfunction

function! SaveSession()
  if s:session_autoload == 0
    return
  endif
  if exists("g:session_disable_autoload") && g:session_disable_autoload == 1
    return
  endif
  set lazyredraw
  silent! call CloseNERDTreeOnAllTabs()
  silent! mksession! .session.vim
  " silent! call OpenNERDTreeOnAllTabs() " it is failing, but it would only run when quitting Vim, so it is not needed
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

set sessionoptions-=buffers
set sessionoptions-=options
set sessionoptions-=blank
set sessionoptions-=help
set sessionoptions-=terminal
let s:session_autoload=0

augroup SessionAuto
  autocmd!
  autocmd VimLeavePre * call SaveSession()
  autocmd VimEnter * nested call s:SessionAutoStart()
augroup END
