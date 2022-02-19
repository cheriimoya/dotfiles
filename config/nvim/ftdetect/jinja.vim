" Figure out which type of hilighting to use for html.
fun! s:SelectHTML()
  let n = 1
  while n < 50 && n <= line("$")
    " check for jinja
    if getline(n) =~ '{{.*}}\|{%-\?\s*\(end.*\|extends\|block\|macro\|set\|if\|for\|include\|trans\)\>'
      set ft=jinja.html
      return
    endif
    let n = n + 1
  endwhile
endfun
autocmd BufNewFile,BufRead *.html,*.htm call s:SelectHTML()
autocmd BufNewFile,BufRead *.jinja2,*.j2,*.jinja,*.nunjucks,*.nunjs,*.njk set ft=jinja
autocmd BufNewFile,BufRead *.sh.jinja2,*.sh.j2,*.sh.jinja,*.sh.nunjucks,*.sh.nunjs,*.sh.njk set ft=sh
autocmd BufNewFile,BufRead *.cfg.jinja2,*.cfg.j2,*.cfg.jinja,*.cfg.nunjucks,*.cfg.nunjs,*.cfg.njk set ft=cfg
