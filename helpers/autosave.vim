if has('timers') && ((!exists("g:scrollback")) || g:scrollback == 0)
  let g:autosave_enabled = 1
  let g:autosave_timer = 0

  function! RunAutosaveTimer() abort
    if !g:autosave_enabled
      return
    endif
    if g:autosave_timer > 0
      call timer_stop(g:autosave_timer)
    endif
    let g:autosave_timer = timer_start(3000, 'WriteAllFiles')
  endfunction

  function! WriteAllFiles(_)
    if mode() != 'i'
      execute 'wall'
    endif
  endfunction

  augroup AutoSaveDebounce
    autocmd!
    autocmd TextChanged,InsertLeave * call RunAutosaveTimer()
  augroup END
endif

" Auto save on focus lost:
" todo: not working if using Zellij, see: https://github.com/zellij-org/zellij/issues/2612
" 1. Prevent Vim's terminal exit sequence from disabling focus tracking
if &t_te =~# '\e\[?1004l'
  let &t_te = substitute(&t_te, '\e\[?1004l', '', 'g')
endif

" 2. Re-enable focus tracking every time focus returns
augroup FocusTrackingFix
  autocmd!
  autocmd FocusGained * call s:ReenableFocus()
  autocmd FocusLost * silent! wall
  " for test only
  "autocmd FocusLost * echom "FocusLost: " . strftime("%H:%M:%S")
augroup END

" 3. Send the focus-tracking enable escape sequence directly to the terminal
function! s:ReenableFocus() abort
  if has('nvim')
    call chansend(v:stderr, "\e[?1004h")
  else
    " Fallback for older Vim
    call system("printf '\e[?1004h' >/dev/tty")
  endif
endfunction
