# Giovanni Bassi's vim and nvim files

These are my personal vim and nvim files. These are personal, if you want to use
it, do it with care. Read the whole thing!

I am using Vim both on Ubuntu and Windows. Right now there are some nice
bundles, like NERDTree. I use Vim mostly for script editing in general.

## Installation instructions

### Linux

Vim:

```bash
git clone --recursive https://github.com/giggio/vimfiles.git ~/.vim
echo "source ~/.vim/.vimrc" > ~/.vimrc
```

Neovim:

```bash
# either clone directory to nvim config dir
git clone --recursive https://github.com/giggio/vimfiles.git ~/.config/nvim/
# or symlink this directory to ~/.config/nvim
ln -s /path/to/your/clone ~/.config/nvim/
# sharing with the vim directory, it would be:
ln -s $HOME/.vim ~/.config/nvim/
```

### Windows (PowerShell Core)

Vim:

```powershell
git clone --recursive https://github.com/giggio/vimfiles.git ~/.vim
# or git clone --recursive git@github.com:giggio/vimfiles.git ~/.vim
# I'm using scoop to install Python, adapt at your will:
Set-Content -NoNewline -Path ~/_vimrc -Value "let `$PYTHONHOME = '$env:USERPROFILE\scoop\apps\python\current\'`nsource $($($env:USERPROFILE).Replace('\', '/'))/.vim/.vimrc`n"
cd ~/.vim
```

Neovim:

```powershell
# TBD
```

Notes on Windows' version: The normal Vim home (`runtimepath`) would be at
`~/vimfiles`, but this is changed to `~/.vim` so that Linux and Windows work the
same way.
