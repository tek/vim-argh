vnoremap <silent> <Plug>ArghI :<C-U>call argh#process('i')<cr>
onoremap <silent> <Plug>ArghI :call argh#process('i')<cr>
vnoremap <silent> <Plug>ArghA :<C-U>call argh#process('a')<cr>
onoremap <silent> <Plug>ArghA :call argh#process('a')<cr>

if tek_misc#want('g:argh_maps')
   vmap <silent> ia <Plug>ArghI
   omap <silent> ia <Plug>ArghI
   vmap <silent> aa <Plug>ArghA
   omap <silent> aa <Plug>ArghA
endif
