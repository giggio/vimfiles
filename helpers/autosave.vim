if has('timers')
  let g:autosave_enabled = 1
  let g:autosave_timer = 0

  function! RunAutosaveTimer() abort
    if !g:autosave_enabled
      return
    endif
    if g:autosave_timer > 0
      call timer_stop(g:autosave_timer)
    endif
    let g:autosave_timer = timer_start(3000, {-> execute('wall')})
  endfunction

  augroup AutoSaveDebounce
    autocmd!
    autocmd TextChanged,TextChangedI * call RunAutosaveTimer()
  augroup END
endif
