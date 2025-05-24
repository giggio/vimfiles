function! SessionAutoStart()
  if has('nvim')
    if filereadable(".session.nvim")
      source .session.nvim
    endif
  else
    if filereadable(".session.vim")
      source .session.vim
    endif
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
  if has('nvim')
    silent! mksession! .session.nvim
  else
    silent! mksession! .session.vim
  endif
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
