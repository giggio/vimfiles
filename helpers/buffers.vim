function s:BufferDeleteOrQuit()
  call VerboseEchomsg("Starting BufferDeleteOrQuit()")
  if &buftype != ''
    call VerboseEchomsg("Quitting not normal buffer")
    quit
    return
  endif
  let listed_buffers = filter(range(1, bufnr('$')), "buflisted(v:val) && v:val != bufnr('%')")
  call VerboseEchomsg("Listed buffers: " . string(listed_buffers))
  if len(listed_buffers) == 0
    call VerboseEchomsg("Quitting with no buffers")
    quitall
  else
    if len(filter(tabpagebuflist(), 'buflisted(v:val)')) > 1
      call VerboseEchomsg("There is more than one buffer in the current tab, closing it: " . string(len(filter(tabpagebuflist(), 'buflisted(v:val)'))))
      let current_buffer = bufnr('%')
      if tabpagenr('$') > 1
        call VerboseEchomsg("Quitting with buffer: " . current_buffer)
        quit
      else
        call VerboseEchomsg("Buffer to delete: " . current_buffer)
        execute "bd " . current_buffer
      endif
      return
    endif
    let current_buffer = bufnr('%')
    call VerboseEchomsg("Current buffer: " . current_buffer)
    let all_buffers_opened_in_all_tabs = []
    for tab in range(1, tabpagenr('$'))
      let list = tabpagebuflist(tab)
      let all_buffers_opened_in_all_tabs += filter(list, 'buflisted(v:val)')
    endfor
    let all_buffers_opened_in_all_tabs = filter(all_buffers_opened_in_all_tabs, 'v:val != bufnr("%")')
    let hidden_buffers = filter(listed_buffers, 'index(all_buffers_opened_in_all_tabs, v:val) == -1')
    if len(hidden_buffers) == 0
      call VerboseEchomsg("There are no hidden buffers")
      quit
    else
      call VerboseEchomsg("There are hidden buffers: " . string(hidden_buffers))
      execute 'normal [b'
      execute "bd " . current_buffer
    endif
  endif
  call VerboseEchomsg("Finished BufferDeleteOrQuit()")
endfunction

cnoreabbrev <expr> q ((getcmdtype() == ':' && getcmdline() ==# 'q') ? 'call <SID>BufferDeleteOrQuit()' : 'q')
