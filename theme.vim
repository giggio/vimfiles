" set t_Co=256                    " todo: maybe remove? forces terminal to use 256 colors
call g:CatchError('colorscheme slate') " set to a dark theme until the material theme is loaded
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#close_symbol = ''
let g:airline#extensions#tabline#buffer_nr_format = 'b%s: '
"let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#fnamecollapse = 1
let g:airline_theme='dark'

" enable/disable coc integration >
let g:airline#extensions#coc#enabled = 1
" change error symbol: >
let g:airline#extensions#coc#error_symbol = 'E:'
" change warning symbol: >
let g:airline#extensions#coc#warning_symbol = 'W:'
" enable/disable coc status display >
let g:airline#extensions#coc#show_coc_status = 1
" change the error format (%C - error count, %L - line number): >
let g:airline#extensions#coc#stl_format_err = '%C(L%L)'
" change the warning format (%C - error count, %L - line number): >
let g:airline#extensions#coc#stl_format_warn = '%C(L%L)'

set background=dark
let g:material_theme_style = 'darker' " 'default' | 'palenight' | 'ocean' | 'lighter' | 'darker' | 'default-community' | 'palenight-community' | 'ocean-community' | 'lighter-community' | 'darker-community'
let g:material_terminal_italics = 1
let g:airline_theme = 'material'
" Enable true colors
if (has("termguicolors"))
  set termguicolors
endif

autocmd VimEnter * call g:CatchError('colorscheme material')
