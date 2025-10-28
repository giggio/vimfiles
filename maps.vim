inoremap jj <Esc>
nnoremap oo o<Esc>k
nnoremap OO O<Esc>j

" remap split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

if !has('nvim')
  " reformat (visual and normal mode)
  function! s:Reformat()
    mark a
    normal! ggVGgq
    'a
    delmarks a
  endfunction
  nnoremap <silent> <leader>j :call <SID>Reformat()<CR>
  xnoremap <silent> <leader>j gq
endif
