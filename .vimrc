set number
set smartindent
syntax on
set mouse=a
set ruler
set bs=2

if has('vim_starting')
set nocompatible               " Be iMproved

" Required:
set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'tpope/vim-fugitive'               " git supporm
NeoBundle 'kien/ctrlp.vim'                   " fuzzy matching
NeoBundle 'bling/vim-airline'                " neat statusline
NeoBundle 'jeffkreeftmeijer/vim-numbertoggle'
NeoBundle 'tpope/vim-jdaddy'                 " json manipulation
NeoBundle 'bronson/vim-trailing-whitespace'  " highlight trailing whitespace
NeoBundle 'mhinz/vim-signify'                " Use sign column to show VCS changes
NeoBundle 'mileszs/ack.vim'                  " Ack search
NeoBundle 'ciaranm/detectindent'             " detects tabstop/shiftwidth from file
NeoBundle 'rodjek/vim-puppet'
NeoBundle 'godlygeek/tabular'
NeoBundle 'fatih/vim-go'                     " fancy golang stuff

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

autocmd BufNewFile,BufReadPost *.md set filetype=markdown

set tabstop=4
set shiftwidth=4
set expandtab


set pastetoggle=<F2>
set wildmenu

set ignorecase
set smartcase
set incsearch
set hlsearch

runtime macros/matchit.vim

"Ctrlp.vim
set runtimepath^=~/.vim/bundle/ctrlp.vim

"Disable X mode
noremap Q <Nop>

set encoding=utf-8
set laststatus=2
filetype plugin indent on
"let g:Powerline_theme = 'ellie'


let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 2
autocmd BufReadPost * :DetectIndent
let g:airline_powerline_fonts = 1

let g:airline_section_z = airline#section#create(['%{&shiftwidth}', ' %3p%% ',g:airline_symbols.linenr,'%3l:%c'])

"Because I keep typing :W
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'w')?('W'):('w'))

" what even is modula2
autocmd BufNewFile,BufRead *.md set filetype=markdown

set listchars=tab:»\ 
set list
