set number
set smartindent
syntax on
set mouse=a
set ruler
set bs=2

set tabstop=4
set shiftwidth=4
set expandtab


set pastetoggle=<F2>
set wildmenu

set ignorecase
set smartcase
set incsearch
set hlsearch

"Because I keep typing :W
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'w')?('W'):('w'))

call pathogen#infect()
