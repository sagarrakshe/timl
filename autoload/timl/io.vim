" Maintainer: Tim Pope <http://tpo.pe>

if exists("g:autoloaded_timl_io")
  finish
endif
let g:autoloaded_timl_io = 1

function! timl#io#echon(_) abort
  echon join(map(copy(a:_), 'timl#str(v:val)'), ' ')
  return g:timl#nil
endfunction

function! timl#io#echo(_) abort
  echo join(map(copy(a:_), 'timl#str(v:val)'), ' ')
  return g:timl#nil
endfunction

function! timl#io#echomsg(_) abort
  echomsg join(map(copy(a:_), 'timl#str(v:val)'), ' ')
  return g:timl#nil
endfunction

function! timl#io#println(_) abort
  echon join(map(copy(a:_), 'timl#str(v:val)'), ' ')."\n"
  return g:timl#nil
endfunction

function! timl#io#newline() abort
  echon "\n"
  return g:timl#nil
endfunction

function! timl#io#printf(fmt, ...) abort
  echon call('printf', [timl#str(a:fmt)] + a:000)."\n"
  return g:timl#nil
endfunction

function! timl#io#pr(_)
  echon join(map(copy(a:_), 'timl#printer#string(v:val)'), ' ')
  return g:timl#nil
endfunction

function! timl#io#prn(_)
  echon join(map(copy(a:_), 'timl#printer#string(v:val)'), ' ')."\n"
  return g:timl#nil
endfunction

function! timl#io#spit(filename, body)
  if type(body) == type([])
    call writefile(body, a:filename)
  else
    call writefile(split(body, "\n"), a:filename, 'b')
endfunction

function! timl#io#slurp(filename)
  return join(readfile(a:filename, 'b'), "\n")
endfunction