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
" ripgrep is used by fzf and by telescope
let $RIPGREP_CONFIG_PATH=expand(vimHome . "/.ripgreprc")

" Ths if for the futitive command, which uses Git, with the first letter capitalized
cnoreabbrev <expr> git ((getcmdtype() == ':' && getcmdline() ==# 'git') ? 'Git' : 'git')

" Better whitespace options
let g:better_whitespace_operator='_s'
let g:better_whitespace_enabled=1
let g:strip_whitespace_confirm=0
let g:better_whitespace_filetypes_blacklist=['diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'fugitive'] " removing markdown from this list

" vim-airline key maps:
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>0 <Plug>AirlineSelectTab0
nmap ]b :wincmd t<CR><Plug>AirlineSelectNextTab
nmap [b :wincmd t<CR><Plug>AirlineSelectPrevTab
