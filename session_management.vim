function! s:SessionAutoStart()
  let g:session_autoloading=0
  if exists("g:session_disable_autoload") && g:session_disable_autoload == 1
    return
  endif
  if argc() > 0
    let s:session_autoload=0
    return
  endif
  let s:session_autoload=1
  let g:session_autoloading=1
  if filereadable(".session.vim")
    source .session.vim
  endif
  let g:session_autoloading=0
endfunction

function! SaveSession()
  call VerboseEchomsg("Saving session...")
  if s:session_autoload == 0
    return
  endif
  if exists("g:session_disable_autoload") && g:session_disable_autoload == 1
    return
  endif
  silent! mksession! .session.vim
  call VerboseEchomsg("Session saved.")
endfunction

set sessionoptions-=options
set sessionoptions-=blank
set sessionoptions-=help
set sessionoptions-=terminal
let s:session_autoload=0

if has("autocmd")
  augroup SessionAuto
    autocmd!
    autocmd VimLeavePre * call SaveSession()
    autocmd VimEnter * nested call s:SessionAutoStart()
  augroup END
endif
