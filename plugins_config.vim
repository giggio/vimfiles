" Easymotion config:
" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1
let g:ctrlp_max_files=0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|yarn)|node_modules$',
  \ 'file': '\v\.(exe|so|dll)$'
  \ }
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
" exclude fugitive from editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
