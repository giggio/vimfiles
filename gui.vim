if has("gui_running")
  if has('autocmd')
    augroup SetVisualBell
      autocmd!
      autocmd GUIEnter * set visualbell t_vb=
    augroup END
  endif
  set lines=999 columns=999
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    " au GUIEnter * simalt ~x " todo: maximize the window on Windows only, maybe not necessary, verify, if it works with set lines above, remove
    set guifont=CaskaydiaCove\ NF:h11:cANSI,DejaVu_Sans_Mono_for_Powerline:h11:cANSI,Consolas:h11:cANSI,Courier:h12:cANSI
  endif
  if ! has('nvim')
    :set guioptions+=m  "add menu bar
    :set guioptions+=R  "remove right-hand scroll bar
    :set guioptions-=T  "remove toolbar
    :set guioptions-=r  "remove right-hand scroll bar
    :set guioptions-=l  "remove left-hand scroll bar
    :set guioptions-=L  "remove left-hand scroll bar
  endif
endif

