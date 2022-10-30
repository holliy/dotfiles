if has('win32')
  let g:python3_host_prog = 'py.exe'
endif

execute 'source' expand('$HOME') . '/.vimrc'

if g:vimrc#is_gui
  Autocmd UIEnter * execute 'source' expand('$HOME') . '/.gvimrc'
endif

