if !(g:vimrc#is_nvim || v:version >= 900)
  echomsg 'no plugins loaded.'
  finish
endif

if !g:vimrc#is_nvim
  scriptversion 4
endif

" install & load "{{{
let s:dein_dir = g:vimrc#dotvim .. '/dein'
let s:dpp_dir = g:vimrc#dotvim .. '/dpp'
let s:dpp_repo_dir = s:dpp_dir .. '/repos/github.com/Shougo/dpp.vim'
let s:denops_repo_dir = s:dpp_dir .. '/repos/github.com/vim-denops/denops.vim'
let s:dpp_ext_toml_repo_dir = s:dpp_dir .. '/repos/github.com/Shougo/dpp-ext-toml'
let s:dpp_protocol_git_repo_dir = s:dpp_dir .. '/repos/github.com/Shougo/dpp-protocol-git'

if !executable('git')
  echomsg 'no plugins installed.'
  finish
endif

if !isdirectory(s:dpp_repo_dir)
  " deinのインストール済みのプラグインがあればリンクを作成する
  if isdirectory(s:dein_dir)
    if g:vimrc#is_windows
      " WIP
    else
      call mkdir(s:dpp_dir, 'p')
      call system(printf('ln -s %s/repos %s/repos', s:dein_dir, s:dpp_dir))
    endif
  else
    call mkdir(s:dpp_dir .. '/repos', 'p')
  endif
endif

let dpp_plugins = [
    \   'Shougo/dpp.vim',
    \   'Shougo/dpp-ext-toml',
    \   'Shougo/dpp-protocol-git',
    \   'vim-denops/denops.vim',
    \ ]
for s:p in dpp_plugins
  let s:dir = printf('/repos/github.com/', s:dpp_dir, s:p)
  if !isdirectory(s:dir)
    call system(printf(
        \   'git clone --filter=blob:none https://github.com/%s %s',
        \   s:p,
        \   shellescape(s:dir)
        \ ))
  endif

  execute 'helptags' s:dir .. '/doc'
endfor
unlet s:p s:dir

if index(split(&runtimepath, ','), s:dpp_repo_dir) < 0
  let &runtimepath = join([
      \   s:dpp_repo_dir,
      \   s:denops_repo_dir,
      \   s:dpp_ext_toml_repo_dir,
      \   s:dpp_protocol_git_repo_dir,
      \ ], ',') .. ',' .. &runtimepath

  " 読み込まれない場合があるので直接読み込む
  runtime! plugin/denops.vim
endif

if dpp#min#load_state(s:dpp_dir)
  echomsg 'making dpp cache...'
  let s:dpp_ts = expand('<sfile>:p:h') .. '/dpp.ts'

  Autocmd User DenopsReady call dpp#make_state(s:dpp_dir, s:dpp_ts)
  Autocmd User Dpp:makeStatePost call dpp#min#load_state(s:dpp_dir)

  function! s:after_make_state() abort
    call dpp#util#_call_hook('source', values(g:dpp#_plugins))
    runtime! plugin/**/*.vim
    call dpp#source()
    call dpp#util#_call_hook('post_source', values(g:dpp#_plugins))
    redraw
    echomsg 'done'
  endfunction
else
  call dpp#util#_call_hook('source', values(g:dpp#_plugins))
  runtime! plugin/**/*.vim
  call dpp#source()
  call dpp#util#_call_hook('post_source', values(g:dpp#_plugins))

  function! s:after_make_state() abort
  endfunction
endif
"}}}

" let g:denops#debug = 1
" let g:denops#trace = ['dpp']
Autocmd User Dpp:makeStatePost call s:after_make_state()

Autocmd BufWritePost *.vim,*.ts,*.toml call dpp#check_files()
doautocmd denops_plugin_internal_startup VimEnter

