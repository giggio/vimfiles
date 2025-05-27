function! ConfigureNERDTree()
  if exists("g:NERDTree")
    noremap <F2> :NERDTreeToggle<CR>
    let g:NERDTreeShowHidden=1
    " Open the existing NERDTree on each new tab.
    autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == ''
          \ | if tabpagenr('$') == 1 " if the current tab is the first one, open a new NERDTree
          \ |   silent NERDTree
          \ | else
          \ |   silent NERDTreeMirror
          \ | endif
    " Exit Vim if NERDTree is the only window remaining in the only tab.
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
    " Close the tab if NERDTree is the only window remaining in it.
    autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
    let s:number_of_tabs  = tabpagenr('$')
    if (argc() == 0 || s:number_of_tabs > 1) && !exists('s:std_in')
      NERDTree
      for i in range(1, s:number_of_tabs - 1)
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
  augroup MyNERDTreeConfig
    autocmd!
    autocmd TabEnter * if &filetype ==# 'nerdtree' | wincmd w | endif " always select the code window when a tab changes
  augroup END
endfunction

let g:NERDTreeExtensionHighlightColor = {}
let g:NERDTreeExtensionHighlightColor['nix'] = "689FB6"
let g:NERDTreeWinPos = "right"
let g:NERDTreeCustomOpenArgs = {'file': {'reuse': 'all', 'where': 't', 'keepopen': 1, 'stay': 0}, 'dir': {}} " always open new files in new tabs, and reuse existing tabs if they are already open
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * call ConfigureNERDTree()
