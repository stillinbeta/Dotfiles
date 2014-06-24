set number
set smartindent
syntax on
set mouse=a
set ruler
set bs=2

call pathogen#infect()

set tabstop=4
set shiftwidth=4
set expandtab


set pastetoggle=<F2>
set wildmenu

set ignorecase
set smartcase
set incsearch
set hlsearch


"Ctrlp.vim
set runtimepath^=~/.vim/bundle/ctrlp.vim

"Disable X mode
noremap Q <Nop>

set encoding=utf-8
set laststatus=2
filetype plugin indent on
let g:Powerline_theme = 'ellie'


let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 4
autocmd BufReadPost * :DetectIndent
let g:airline_powerline_fonts = 1

"Because I keep typing :W
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'w')?('W'):('w'))

set listchars=tab:»\ 
set list
