" Easymotion config:
let g:EasyMotion_smartcase = 1 " Turn on case insensitive feature

" CtrlP config:
let g:ctrlp_max_files=0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|yarn)|node_modules$',
  \ 'file': '\v\.(exe|so|dll)$'
  \ }
let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git', 'cd %s && git ls-files -co --exclude-standard'],
    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
  \ }
let g:ctrlp_switch_buffer = 'ET' " switch to buffer in any tab or window, if file is already open
let g:ctrlp_open_new_file = 't' " open new file in new tab
let g:ctrlp_open_multiple_files = 't' " open multiple files in new tabs
let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("e")': ['<c-t>', '<2-LeftMouse>'],
  \ 'AcceptSelection("t")': ['<cr>'],
  \ } " always open files in new tab, and c-t now opens in current buffer, if we want that

" EditorConfig config:
let g:EditorConfig_exclude_patterns = ['fugitive://.*'] " exclude fugitive from editorconfig

let g:loaded_syntastic_typescript_tsc_checker = 1 "don't do syntax checking

" FZF config:
nmap <leader>f :Rg<CR>
