function! g:CatchError(expr)
  try
    execute a:expr
  catch /^Vim\%((\a\+)\)\=:E\w\+/
    call add(g:StartupErrors, {'exception': v:exception, 'stacktrace': v:stacktrace})
  endtry
endfunction

function! g:AddError(err)
  call add(g:StartupErrors, {'txt': err})
endfunction

function! g:ShowStartupErrors()
  if !empty(g:StartupErrors) |
    tabnew
    " make it a no-file buffer so Vim won't nag us to save it
    setlocal buftype=nofile bufhidden=wipe nobuflisted
    file [Startup Errors] " name in the tabline
    call append(0, ['=== Startup Errors ==='])
    for ex in g:StartupErrors
      if has_key(ex, 'txt')
        call append(line('$'), ex.txt)
      endif
      if has_key(ex, 'exception')
        call append(line('$'), ex.exception)
      endif
      if has_key(ex, 'stacktrace')
        for stack_item in ex.stacktrace
          call append(line('$'), 'at line ' . g:Pad(stack_item.lnum, 5) . "\tin file" . stack_item.filepath)
          if has_key(stack_item, 'funcref')
            call append(line('$'), 'in function ' . get(stack_item.funcref, 'name'))
          endif
          if has_key(stack_item, 'event')
            call append(line('$'), 'event: ' . stack_item.event)
          endif
        endfor
      endif
      call append(line('$'), '')
    endfor
    normal! gg
  endif
endfunction

function! g:Pad(number, number_of_zeroes)
  let char = '0'
  return repeat('0', a:number_of_zeroes - len(string(a:number))) . a:number
endfunction

function! g:VerboseEchomsg(msg)
  if &verbose > 0
    echomsg a:msg
  endif
endfunction
