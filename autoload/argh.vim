function! s:char() "{{{
  return getline('.')[col('.')-1]
endfunction "}}}

function! s:skip() "{{{
  let name = synIDattr(synID(line('.'), col('.'), 0), 'name')
  return name =~? 'comment\|docstring'
endfunction "}}}

function! s:parens_search(pat, flags) "{{{
  return searchpair('(', a:pat, ')', a:flags.'W', 's:skip()')
endfunction "}}}

function! s:cursor_inside_parens() "{{{
  return s:parens_search('', 'nb') && s:parens_search('', 'n')
endfunction "}}}

function! s:mark_left_boundary() "{{{
  call s:parens_search(',', 'b')
  let s:comma_left = s:char() == ','
  if s:char() == '(' || s:mode == 'i'
    call s:parens_search('\S', '')
  endif
  normal! m<
endfunction "}}}

function! s:mark_right_boundary() "{{{
  while s:vcount && s:char() != ')'
    call s:parens_search(',', '')
    let s:vcount -= 1
  endwhile
  if s:mode == 'a' && s:char() == ',' && !s:comma_left
    call search('\s*,\s*', 'ceW')
  else
    normal! h
  endif
  normal! m>
endfunction "}}}

function! s:process() "{{{
  if s:cursor_inside_parens()
    call s:mark_left_boundary()
    call s:mark_right_boundary()
    normal! gv
  endif
endfunction "}}}

function! s:update_tick() "{{{
  let g:repeat_tick = b:changedtick
  autocmd! repeat_tick
endfunction "}}} 
  
function! s:repeat_set() "{{{
  let cmd = v:operator.s:mode.'a' . (v:operator == 'c' ? "\<c-r>." : '')
  silent! call repeat#set(cmd)
  augroup repeat_tick
    autocmd!
    autocmd CursorMoved <buffer> call s:update_tick()
  augroup END
endfunction "}}}

function! argh#process(mode) "{{{
  let s:mode = a:mode
  let s:comma_left = 0
  let s:vcount = v:count1
  call s:process()
  call s:repeat_set()
endfunction "}}}
