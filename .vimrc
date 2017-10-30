set number
set smartindent
syntax on
set mouse=a
set ruler
set bs=2

if has('vim_starting')
set nocompatible               " Be iMproved
endif

autocmd BufNewFile,BufReadPost *.md set filetype=markdown

set tabstop=2
set shiftwidth=2
set expandtab


set pastetoggle=<F2>
set wildmenu

set ignorecase
set smartcase
set incsearch
set hlsearch

runtime macros/matchit.vim

"Disable X mode
noremap Q <Nop>

set encoding=utf-8
set laststatus=2
filetype plugin indent on

"Because I keep typing :W
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'w')?('W'):('w'))

" what even is modula2
autocmd BufNewFile,BufRead *.md set filetype=markdown

set listchars=tab:»\
set list
