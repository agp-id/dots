" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    "Color Sceme
    Plug 'sainnhe/gruvbox-material'
    "Coloring color code
    Plug 'ap/vim-css-color'
    "Airline
    Plug 'vim-airline/vim-airline'
    "suda, write as root. Not work with doas
    Plug 'lambdalisue/suda.vim'
    "Indent-blankline
    Plug 'lukas-reineke/indent-blankline.nvim'

call plug#end()

" Automatic install missing plugin on startup
autocmd VimEnter *
    \ if len(filter(values(g:plugs),    '!isdirectory(v:val.dir)'))
    \|  PlugInstall --sync | q
    \|endif
