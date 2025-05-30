function s:OpenNERDTree(bootstrap)
  " if the current tab is the first one, open a new NERDTree,
  " otherwise mirror the existing NERDTree.
  if &filetype =~# 'dap' || g:dap_debugger_running || exists('t:NERDTreeBufName')
    return
  endif

  if g:NERDTreeShouldBeOpen == 1
    if &buftype == '' && getcmdwintype() == ''
      if a:bootstrap
        if tabpagenr() == 1
          silent NERDTree
        else
          silent NERDTreeMirror
        endif
      else
        if g:NERDTree.ExistsForTab()
          silent NERDTreeToggle
        else
          silent NERDTreeMirror
        endif
      endif
    endif
    if &filetype ==# 'nerdtree' | wincmd w | endif " move the cursor to code window
  endif
endfunction

function s:ToggleNERDTreeOnTabEnter()
  if &filetype =~# 'dap' || g:dap_debugger_running
    return
  endif

  if g:NERDTreeShouldBeOpen == 1
    if g:NERDTree.ExistsForTab()
      if !g:NERDTree.IsOpen()
        silent NERDTreeToggle
      endif
    else
      if &buftype == '' && getcmdwintype() == ''
        silent NERDTreeMirror
      endif
    endif
    if &filetype ==# 'nerdtree' | wincmd w | endif " move the cursor to code window
  else
    if g:NERDTree.ExistsForTab()
      if g:NERDTree.IsOpen()
        silent NERDTreeToggle
      endif
    endif
  endif
endfunction

function s:SelectFileOnNERDTree()
  if &filetype =~# 'dap' || g:dap_debugger_running
    return
  endif
  if g:NERDTreeShouldBeOpen == 0
    return
  endif
  if &filetype ==# 'nerdtree' | wincmd w | endif " move the cursor to code window
  if &buftype == '' && getcmdwintype() == ''
    silent NERDTreeFind
  endif
endfunction

function s:OpenInitialNERDTreeWindows()
    let s:number_of_tabs  = tabpagenr('$')
    if (argc() == 0 || s:number_of_tabs > 1) && !exists('s:std_in')
      let s:current_tab  = tabpagenr()
      for i in range(1, s:number_of_tabs)
        exec 'tabnext ' . i
        call s:OpenNERDTree(1)
      endfor
      for i in range(1, s:number_of_tabs)
        exec 'tabnext ' . i
        call s:SelectFileOnNERDTree()
      endfor
      exec 'tabnext ' . s:current_tab
      if &filetype ==# 'nerdtree' | wincmd w | endif " move the cursor to code window
    endif
endfunction

function! g:ToggleNERDTreeOnKeyPress()
  if g:NERDTree.IsOpen()
    let g:NERDTreeShouldBeOpen=0
  else
    let g:NERDTreeShouldBeOpen=1
  endif
  if g:NERDTree.ExistsForTab()
    silent NERDTreeToggle
  else
    silent NERDTreeMirror
  endif
  if &filetype ==# 'nerdtree' | wincmd w | endif " move the cursor to code window
endfunction

function s:ConfigureNERDTree()
  if exists("g:NERDTree")
    " from the box NERDTree settings
    let g:NERDTreeShowHidden=1
    let g:NERDTreeAutoDeleteBuffer=1
    let g:NERDTreeExtensionHighlightColor = {}
    let g:NERDTreeExtensionHighlightColor['nix'] = "689FB6"
    let g:NERDTreeWinPos = "right"
    let g:NERDTreeCustomOpenArgs = {'file': {'reuse': 'all', 'where': 't', 'keepopen': 1, 'stay': 0}, 'dir': {}} " always open new files in new tabs, and reuse existing tabs if they are already open
    " my custom NERDTree settings
    let g:NERDTreeShouldBeOpen=1
    if !exists("g:dap_debugger_running")
      let g:dap_debugger_running=0
    endif
    augroup MyNERDTreeConfig
      autocmd!
      autocmd BufWinEnter * call s:OpenNERDTree(0)
      autocmd BufWinEnter * call s:SelectFileOnNERDTree()
      " Exit Vim if NERDTree is the only window remaining in the only tab.
      autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
      " Close the tab if NERDTree is the only window remaining in it.
      autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
      " always select the code window when a tab changes
      autocmd TabEnter * call s:ToggleNERDTreeOnTabEnter()
      autocmd TabEnter * if &filetype ==# 'nerdtree' | wincmd w | endif
      " If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
      autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
        \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
    augroup END
    map <S-A-l> :NERDTreeFind<CR>
    noremap <silent> <F2> :call g:ToggleNERDTreeOnKeyPress()<CR>
  endif
endfunction

augroup NERDTreeSetup
  autocmd!
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * call s:ConfigureNERDTree()
  autocmd VimEnter * call s:OpenInitialNERDTreeWindows()
augroup END
