function s:BufferReopen()
  if len(s:LastBuffer) == 0
    echo "Last buffer is not set, cannot reopen"
  else
    let fname = s:LastBuffer[-1]
    call VerboseEchomsg("Reopening last buffer: " . fname . ". Buffer stack: " . string(s:LastBuffer))
    let s:LastBuffer = s:LastBuffer[:-2]
    execute 'e ' .. fnameescape(fname)
  endif
endfunction

function s:BufferDelete()
  let current_buffer = bufnr('%')
  let s:LastBuffer = s:LastBuffer + [bufname('%')]
  call VerboseEchomsg("Buffer to delete: " . current_buffer)
  if buflisted(bufnr('#'))
    call VerboseEchomsg("Switching to alternate buffer")
    execute 'b#'
  else
    call VerboseEchomsg("The file in the alternate buffer is not loaded, switching to previous buffer")
    execute 'normal [b'
  endif
  let all_buffers = s:AllBuffersOpenedInAllTabs()
  if index(all_buffers, current_buffer) == -1
    call VerboseEchomsg("Buffer " . current_buffer . " is not hidden and loaded after replacing the opened buffer in current window.")
  else
    execute "bd " . current_buffer
  endif
endfunction

function s:BufferDeleteOrQuit()
  call VerboseEchomsg("Starting BufferDeleteOrQuit()")
  if &buftype != '' || &filetype == 'git' || &previewwindow
    call VerboseEchomsg("Quitting not normal buffer")
    quit
    return
  endif
  let listed_buffers = s:AllBuffersOpenedInAllTabs()
  call VerboseEchomsg("Listed buffers: " . string(listed_buffers))
  if len(listed_buffers) == 1
    call VerboseEchomsg("Quitting with last buffer")
    quitall
    return
  endif
  if tabpagenr('$') > 1
    call VerboseEchomsg("Quitting with multiple tabs")
    quit
    return
  endif
  let current_buffer = bufnr('%')
  call VerboseEchomsg("Current buffer: " . current_buffer)
  let hidden_buffers = filter(listed_buffers, 'v:val != bufnr("%")')
  call VerboseEchomsg("These are hidden buffers: " . string(hidden_buffers))
  call s:BufferDelete()
  call VerboseEchomsg("Finished BufferDeleteOrQuit()")
endfunction

function s:AllBuffersOpenedInAllTabs ()
  return map(getbufinfo({'bufloaded': 0, 'buflisted': 1}), 'v:val.bufnr')
endfunction

let s:LastBuffer = []
cnoreabbrev <expr> q ((getcmdtype() == ':' && getcmdline() ==# 'q') ? 'call <SID>BufferDeleteOrQuit()' : 'q')
command -nargs=0 BufferReopen call <SID>BufferReopen()
nmap <leader>br :BufferReopen<CR>
