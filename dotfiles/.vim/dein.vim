" WIP

let s:dein_dir = g:vimrc#dotvim . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' .
      \ shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath

let g:dein#enable_name_conversion = 1
" let g:dein#install_process_timeout = 60
let g:dein#install_progress_type = 'echo'

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, [g:vimrc#dotvim . '/dein.vim', $MYVIMRC])

  call dein#add(s:dein_repo_dir)
  call dein#add('vim-jp/vimdoc-ja')
  call dein#add('itchyny/landscape.vim')
  call dein#add('derekwyatt/vim-scala')

  call dein#end()

  if !(g:vimrc#is_unix && $USER ==# 'root')
    call dein#save_state()
  endif
endif

if g:vimrc#is_starting && dein#check_install()
  call dein#install()
endif

Autocmd VimEnter * nested colorscheme landscape
