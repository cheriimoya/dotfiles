"vim-airline
"set ft=tmux

" Activate vim only features
set nocompatible

" Set a few core features
set encoding=utf-8
set ruler
set number
set relativenumber
set cursorline
set wrap
set backspace=indent,eol,start
set wildmenu

" Search options
set hlsearch
set incsearch
set ignorecase
set smartcase

" Some indentation settings
set shiftwidth=4
set tabstop=4
set expandtab

" Open files with the cursor on the last saved position
if has("autocmd")
      au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
          \| exe "normal! g'\"" | endif
  endif

" if working with a hardlink, save as new file
set backupcopy=auto,breakhardlink

" Always show tab and status lines
set laststatus=2
set showtabline=2  " Show tabline
set showcmd
"set guioptions-=e  " Don't use GUI tabline


" Set this before setting the colorscheme
set t_Co=256
set background=dark

" Show maximum text width
set colorcolumn=79
"set textwidth=80

" Split windows accordingly
set splitbelow
set splitright

set foldmethod=marker
set directory^=$HOME/.vim/swapfiles//
set listchars=tab:»·,trail:·,nbsp:· list

" History stuff
set history=9999
set undofile
set undodir^=$HOME/.vim/undodir

set noerrorbells
set showcmd
set showmode
set autoindent
set showmatch
set smarttab

" Keep cursor 5 lines away from the top/bottom of the window
set scrolloff=5

set complete=.,w,b,u,t

" Spell checking
set spelllang=en,de
"set spell

" Syntax stuff
" Enable syntax highlighting without overwriting colors
syntax on
filetype plugin indent on

au FileType yaml setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2

command E Explore

" If saving as w!!, vim will force-save the file with sudo
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

let maplocalleader="\\"
let g:html_indent_tags = 'li\|p'

" Window navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

nnoremap WW :w<CR>

inoremap <C-t> \texttt{
inoremap <C-e> \includegraphics[width=\textwidth]{

" Jump lines as displayed, not number wise
nnoremap j gj
nnoremap k gk

" Tab navigation like Firefox.
nnoremap <C-t> :tabnew<CR>
"TODO why is this not working with the ctrl key but the shift key??
nnoremap <C-TAB> :tabnext<CR>
nnoremap <S-tab> :tabnext<CR>

nnoremap <C-o> :NERDTreeToggle<CR>

nnoremap <S-U> :GundoToggle<CR>

" " Delete this
" nnoremap <C-p> :!pdflatex %<CR>
" nnoremap <F3> :!find . -name "*\.aux" -exec rm {} \;<CR>

" Remove trailing whitespace on saving
autocmd BufWritePre * %s/\s\+$//e

" Lightline config
let g:lightline = { 'active': {} }
let g:lightline.colorscheme = 'wombat'

let g:lightline.active.left = [ [ 'mode', 'paste' ], [ 'gitbranch', 'filename', 'readonly', 'modified' ] ]
let g:lightline.active.right = [ [ 'lineinfo' ], [ 'percent' ], [ 'fileformat', 'fileencoding', 'filetype' ] ]

let g:lightline.tabline = { 'left': [ ['tabs'] ], 'right': [ ['gettime'] ] }

let g:lightline.component =  { 'lineinfo': '%3l:%-2v', 'gettime': 'strftime("%H:%M")' }
let g:lightline.component_function = { 'gitbranch': 'fugitive#head'}

let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '' }


let g:SuperTabDefaultCompletionType = "context"

let g:indent_guides_enable_on_vim_startup = 1

" Download vim-plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

    " Lightline for a neat status and tabline
    Plug 'itchyny/lightline.vim'
    " Plug 'itchyny/calendar.vim'

    " Nice file explorer
    Plug 'scrooloose/nerdtree'

    " Add todo list functionality for *.todo files
    "Plug 'freitass/todo.txt-vim', { 'for': 'todo' }
    Plug 'aserebryakov/vim-todo-lists'

    " Command line fuzzy finder
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

    " Vim UI linting
    Plug 'w0rp/ale'

    " Go back in history
    Plug 'sjl/gundo.vim'

    " Prettify markdown tables
    Plug 'dhruvasagar/vim-table-mode', { 'for': 'markdown'}

    " Essential git plugins
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'

    " Colorschemes
    Plug 'sjl/badwolf'
    Plug 'reedes/vim-colors-pencil'

    " Toggle comments with ctrl+/
    Plug 'tomtom/tcomment_vim'

    " Autocompletion
    Plug 'ervandew/supertab'

    " Distraction free mode
    Plug 'junegunn/goyo.vim'

    " Syntax and check tools
    Plug 'rust-lang/rust.vim', { 'for': 'rust' }
    Plug 'mboughaba/i3config.vim'
    Plug 'LnL7/vim-nix'
    Plug 'nvie/vim-flake8', { 'for': 'python' }
    Plug 'lervag/vimtex'

    " Show indentations
    Plug 'nathanaelkane/vim-indent-guides'

    " Taaag baaar
    Plug 'majutsushi/tagbar'

    Plug 'jceb/vim-orgmode'
    Plug 'tpope/vim-speeddating'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}


    "Plug 'Valloric/YouCompleteMe'
"    Plug 'janko-m/vim-test'

call plug#end()

function! s:goyo_enter()
    colorscheme pencil
endfunction

function! s:goyo_leave()
    colorscheme badwolf
endfunction

colorscheme badwolf

nmap <F8> :TagbarToggle<CR>

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
