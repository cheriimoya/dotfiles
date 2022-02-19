set nocompatible

source $HOME/.config/nvim/vimrc

" Startify
let g:startify_lists = [
  \ { 'type': 'files',     'header': ['   MRU']            },
  \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
\ ]

let g:startify_bookmarks = [
  \ '~/.zshrc',
  \ '~/.config/nvim/init.vim',
\ ]

let g:startify_skiplist = [ 'COMMIT_EDITMSG', ]

let g:startify_session_dir = '~/.local/share/nvim/session'
let g:startify_session_autoload = 'no'
let g:startify_change_to_dir = 0

nnoremap <leader>so :SLoad<Space>
nnoremap <leader>ss :SSave<Space>
nnoremap <leader>sd :SDelete<CR>
nnoremap <leader>sc :SClose<CR>

luafile $HOME/.config/nvim/lua/init.lua
