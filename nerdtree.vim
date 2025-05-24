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

