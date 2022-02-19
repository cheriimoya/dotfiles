" latex
let g:vimtex_quickfix_mode=0
" set conceallevel = 0
" set concealcursor = ''
let g:tex_conceal = ''
let g:indentLine_concealcursor = ''
let g:indentLine_conceallevel = 1

inoremap <buffer> <C-t> \texttt{
inoremap <buffer> <C-g> \includegraphics[width=\textwidth]{Figure/

setlocal textwidth=0
setlocal spell
setlocal spelllang=en
