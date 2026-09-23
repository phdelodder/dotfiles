set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin('~/.vim/plugged')
" Add plugins here, e.g:
" Plug 'tpope/vim-sensible'
call plug#end()

filetype plugin indent on    " required

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
