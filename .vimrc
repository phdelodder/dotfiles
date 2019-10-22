set nocompatible              " be iMproved, required
filetype off                  " required

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" my settings --------------------------------------------------------------
set number
set encoding=utf-8
set modelines=0
set autoindent
set showmode
set hidden
set ttyfast
set title
set showcmd
set t_Co=256:
set cursorline
set shiftwidth=2
syntax on

set autoread "set autoread when a file changes
set noswapfile "dont use swap files. I just delete them anyway
set nosmd "disable show mode

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Get rid of ^^^^^ in statusline
set fillchars+=stl:\ ,stlnc:\

" colorscheme settings ----------------------------------------------------
set background=dark

" powerline settings ------------------------------------------------------
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
