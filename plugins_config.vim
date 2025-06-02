" Easymotion config:
let g:EasyMotion_smartcase = 1 " Turn on case insensitive feature

if !has('nvim')
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
  let g:ctrlp_open_new_file = 'r' " open new file in current window
  let g:ctrlp_open_multiple_files = 'v' " open multiple files in vertical splits

  " FZF config:
  nmap <leader>f :Rg<CR>
endif

" EditorConfig config:
let g:EditorConfig_exclude_patterns = ['fugitive://.*'] " exclude fugitive from editorconfig

" Used by ripgrep to find the config file hosted at ~/.vim/.ripgreprc
" See more at: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file
" ripgrep is used by fzf and by mini pick
let $RIPGREP_CONFIG_PATH=expand(vimHome . "/.ripgreprc")

" Better whitespace options
let g:better_whitespace_operator='_s'
let g:better_whitespace_enabled=1
let g:strip_whitespace_confirm=0
