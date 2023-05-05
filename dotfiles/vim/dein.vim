if !(g:vimrc#is_nvim || v:version >= 802)
  echomsg 'no plugins loaded.'
  finish
endif

if !g:vimrc#is_nvim
  scriptversion 4
endif

" dein "{{{
let s:dein_dir = g:vimrc#dotvim .. '/dein'
let s:dein_repo_dir = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  if !executable('git')
    echomsg 'no plugins installed.'
    finish
  endif

  call system('git clone --filter=blob:none https://github.com/Shougo/dein.vim ' ..
      \ shellescape(s:dein_repo_dir))
  execute 'helptags' s:dein_repo_dir .. '/doc'
endif
if index(split(&runtimepath, ','), s:dein_repo_dir) < 0
  let &runtimepath = s:dein_repo_dir .. ',' .. &runtimepath
endif

let g:dein#auto_recache = 1
let g:dein#enable_name_conversion = 1
let g:dein#install_check_diff = 1
let g:dein#install_copy_vim = 0
let g:dein#install_log_filename = s:dein_dir .. '/dein.log'
" let g:dein#install_process_timeout = 60
let g:dein#install_progress_type = 'floating'
let g:dein#install_message_type = 'echo'
let g:dein#types#git#enable_partial_clone = 1

let s:dein_toml = expand('<sfile>:r') .. '.toml'
if dein#load_state(s:dein_dir) "{{{
  call dein#begin(s:dein_dir, [expand('<sfile>'), s:dein_toml])

  call dein#add(s:dein_repo_dir)
  call dein#load_toml(s:dein_toml)

  call dein#end()

  if g:vimrc#is_starting && dein#check_install()
    Autocmd VimEnter * ++once call dein#install()
  endif

  if !(g:vimrc#is_unix && $USER ==# 'root')
    call dein#save_state()
  endif
endif "}}}

runtime! plugin/**/*.vim
call dein#call_hook('source')

" if !g:vimrc#is_starting
"   " post source フックの関数に変更があったときに反映できるように読み込み済みフラグを消す
"   " .toml に書かれたフックは autoload/dein/util.vim から読み込まれる
"   for s:p in values(dein#_plugins)
"     if !has_key(s:p, 'called')
"       continue
"     endif

"     for s:f in keys(s:p['called'])
"       if string(s:f) =~# expand('<SID>') .. '.\+_sourced'
"         call remove(s:p['called'], s:f)
"       endif
"     endfor
"   endfor
" endif

Autocmd BufEnter dein.toml call dein#toml#syntax()

Autocmd VimEnter * ++once call dein#call_hook('post_source')
"}}}

