set guicursor=a:block-Cursor
set guioptions-=a guioptions-=e guioptions-=m guioptions-=t guioptions-=T
set guioptions+=c

if g:vimrc#is_windows
  set guifont=Consolas:h9
  set guifontwide=Terminal:h9
  silent! set guifont=Myrica\ M:h10 guifontwide=Myrica\ M:h10
elseif g:vimrc#is_unix
  set guifont=DejaVu\ Sans\ Mono\ 12
  silent! set guifont=MyricaM\ M\ 12 guifontwide=MyricaM\ M\ 12
endif

if has('kaoriya')
  Autocmd GUIEnter * set transparency=210
endif

if get(g:, 'colors_name', 'desert') ==# 'desert'
  colorscheme torte
endif

source $VIMRUNTIME/delmenu.vim
if g:vimrc#is_windows
  set langmenu=ja_jp.cp932
elseif g:vimrc#is_unix
  set langmenu=ja_jp.utf-8
endif
" source $VIMRUNTIME/menu.vim
