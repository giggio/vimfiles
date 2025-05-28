function! s:CheckIfInitialTabIsEmpty()
  if g:session_autoloading == 1
    return
  endif
  let g:ace_prev_buf = bufnr('%')
  let g:ace_prev_tab = tabpagenr()
  " no filename, not modified, exactly 1 liner, that line is empty
  let g:ace_prev_empty = empty(bufname(g:ace_prev_buf))
        \ && !getbufvar(g:ace_prev_buf, '&modified')
        \ && line("$", bufwinid(g:ace_prev_buf)) == 1
        \ && getbufline(g:ace_prev_buf, 1)[0] ==# ''
endfunction
function! s:CloseInitialEmptyTab()
  if g:session_autoloading == 1
    return
  endif
  if tabpagenr('$') == 1 " do not close the only tab
    unlet g:ace_prev_empty g:ace_prev_buf g:ace_prev_tab
    return
  endif
  if exists('g:ace_prev_empty') && g:ace_prev_empty && bufloaded(g:ace_prev_buf)
    execute 'tabclose' g:ace_prev_tab
    execute 'silent! bdelete' g:ace_prev_buf
    unlet g:ace_prev_empty g:ace_prev_buf g:ace_prev_tab
  endif
endfunction
augroup AutoCloseEmptyTab
  autocmd!
  autocmd TabLeave * call s:CheckIfInitialTabIsEmpty()
  autocmd TabEnter * call s:CloseInitialEmptyTab()
augroup END


