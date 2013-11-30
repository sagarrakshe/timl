" Maintainer:   Tim Pope <http://tpo.pe/>

if exists("g:autoloaded_timl_printer")
  finish
endif
let g:autoloaded_timl_printer = 1

let s:escapes = {
      \ "\n": '\n',
      \ "\r": '\r',
      \ "\t": '\t',
      \ "\"": '\"',
      \ "\\": '\\'}

function! timl#printer#string(x)
  " TODO: guard against recursion
  if timl#symbolp(a:x)
    return a:x[0]
  elseif a:x is# g:timl#nil
    return 'nil'
  elseif type(a:x) == type([])
    return '(' . join(map(copy(a:x), 'timl#printer#string(v:val)'), ' ') . ')'
  elseif type(a:x) == type({})
    let acc = []
    for [k, V] in items(a:x)
      call add(acc, timl#printer#string(k) . ' ' . timl#printer#string(V))
      unlet! V
    endfor
    return '#dict(' . join(acc, ' ') . ')'
  elseif type(a:x) == type('')
    return '"'.substitute(a:x, "[\n\r\t\"\\\\]", '\=get(s:escapes, submatch(0))', 'g').'"'
  elseif type(a:x) == type(function('tr'))
    let name = join([a:x])
    if name =~# '^{.*}$'
      return "#'" . name[1:-2]
    elseif name =~# '#' || name =~# '^[[:digit:]<]'
      return "#'" . timl#demunge(name)
    else
      return "#'" . 'f:' . timl#demunge(name)
    endif
  else
    return string(a:x)
  endif
endfunction

" Section: Tests {{{1

if !exists('$TEST')
  finish
endif

command! -nargs=1 TimLPAssert
      \ try |
      \ if !eval(<q-args>) |
      \ echomsg "Failed: ".<q-args> |
      \   endif |
      \ catch /.*/ |
      \  echomsg "Error:  ".<q-args>." (".v:exception.")" |
      \ endtry

TimLPAssert timl#printer#string('foo') ==# '"foo"'
TimLPAssert timl#printer#string(timl#symbol('foo')) ==# 'foo'
TimLPAssert timl#printer#string([1,2]) ==# '(1 2)'
TimLPAssert timl#printer#string({"a": 1, "b": 2}) ==# '#dict("a" 1 "b" 2)'

delcommand TimLPAssert

" }}}1

" vim:set et sw=2: