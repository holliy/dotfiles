if has('win32')
  let g:python3_host_prog = 'py.exe'
endif

execute 'source' expand('$HOME') . '/.vimrc'
Autocmd UIEnter *
    \ if g:vimrc#is_gui |
    \   execute 'source' expand('$HOME') . '/.gvimrc' |
    \ endif

