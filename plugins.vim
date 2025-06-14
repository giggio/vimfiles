if !has('nvim')
  if empty(glob(g:vimHome . '/autoload/plug.vim'))
    if has('unix')
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    elseif has('win32')
      execute 'silent !powershell -noprofile -c "Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | New-Item $env:USERPROFILE/.vim/autoload/plug.vim -Force"'
    endif
  endif

  if has("autocmd")
    augroup InstallPlugins
      autocmd!
      " Run PlugInstall if there are missing plugins
      autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
            \| PlugInstall --sync | source $MYVIMRC
            \| endif
    augroup END
  endif
endif

let g:pluginInstallPath = g:vimHome . '/plugged'
let g:vimPluginInstallPath = g:pluginInstallPath . '/vim'
let g:nvimPluginInstallPath = g:pluginInstallPath . '/nvim'
runtime manage_plugins.vim

if has('nvim') " editorconfig is on by default on nvim
  if filereadable(".editorconfig")
    let g:editorconfig_is_enabled=1
  else
    let g:editorconfig_is_enabled=0
  endif
else
  let g:editorconfig_is_enabled=0
  if &verbose == 0 " todo: Error when loading with verbose, remove when https://github.com/editorconfig/editorconfig-vim/issues/221 is fixed
    packadd! editorconfig
    if filereadable(".editorconfig")
      let g:editorconfig_is_enabled=1
    endif
  endif
endif

if !has('nvim')
  call plug#begin(g:vimPluginInstallPath)
endif

" Using 'Plugin' instead of 'Plug' because of the adapter from manage_plugins.vim
if !has('nvim')
  " LSP support for Vim. Neovim has built-in LSP support.
  Plugin 'neoclide/coc.nvim', {'branch': 'release'}
endif
let g:vim_nerdtree_plug_args = { }
if has('nvim')
  let g:vim_nerdtree_plug_args['lazy'] = 'false'
endif
" file explorer
Plugin 'scrooloose/nerdtree', g:vim_nerdtree_plug_args
" icons
Plugin 'ryanoasis/vim-devicons', {'dependencies': ['scrooloose/nerdtree']}
if !has('nvim')
  Plugin 'ctrlpvim/ctrlp.vim'
  Plugin 'mattn/emmet-vim'
endif
if !has('nvim')
  " snippets:
  " (using snippes in coc-vim, so that is why only the snipped sources are installed here)
  " nvim is using its own snippet sources and providers
  Plugin 'honza/vim-snippets'
endif

Plugin 'Shougo/vimproc.vim', {'do' : 'make'}
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'easymotion/vim-easymotion'
Plugin 'vim-scripts/ReplaceWithRegister'
Plugin 'kaicataldo/material.vim', { 'branch': 'main' }
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
Plugin 'AndrewRadev/bufferize.vim'
" we don't need to strip whitespace on save if editorconfig is enabled
" as it has its own configuration for this
" this config is for ntpeters/vim-better-whitespace
let g:strip_whitespace_on_save=!g:editorconfig_is_enabled
Plugin 'ntpeters/vim-better-whitespace'
if !has('nvim')
  " nvim already has a built-in comment system
  Plugin 'tpope/vim-commentary'
  " using telescope instead of fzf in nvim
  Plugin 'junegunn/fzf', { 'lazy': 'true', 'do': { -> fzf#install() } }
  " loading in the end as fzf has issues with Buffers (specially NERDTree)
  Plugin 'junegunn/fzf.vim', { 'for': 'nerdtree', 'lazy': 'true', 'event': 'VeryLazy', 'dependencies': ['junegunn/fzf'] }
endif
if version >= 900 || has('nvim')
let g:copilot_lsp_settings = {
\   'telemetry': {
\     'telemetryLevel': 'off',
\   },
\ }
  Plugin 'github/copilot.vim'
endif

if has('nvim')
  lua require("config.lazy")
else
  call plug#end()
endif

