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
  call OpenBuffersNotInTabs()
endfunction

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

function! OpenBuffersNotInTabs()
  " useful for cases where the user passes new files to vim
  let tabbufs = []
  for t in range(1, tabpagenr('$'))
    call extend(tabbufs, tabpagebuflist(t))
  endfor
  let buffers_not_in_tabs = filter(range(1, bufnr('$')), '
        \ filereadable(bufname(v:val))
        \ && index(tabbufs, v:val) < 0
        \ ')
  for bufnr in buffers_not_in_tabs
    execute 'tab sbuffer ' . bufnr
  endfor
endfunction

set sessionoptions-=buffers
set sessionoptions-=options
set sessionoptions-=blank
set sessionoptions-=help
set sessionoptions-=terminal
augroup SessionAuto
  autocmd!
  autocmd VimEnter * nested call SessionAutoStart()
  autocmd VimLeavePre * call SaveSession()
augroup END
