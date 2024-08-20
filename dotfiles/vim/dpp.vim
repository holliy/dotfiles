if !(g:vimrc#is_nvim || v:version >= 900)
  echomsg 'no plugins loaded.'
  finish
endif

if !g:vimrc#is_nvim
  scriptversion 4
endif

" install & load "{{{
if !executable('git')
  echomsg 'no plugins installed.'
  finish
endif

let s:dein_dir = g:vimrc#dotvim .. '/dein'
let s:dpp_dir = g:vimrc#dotvim .. '/dpp'
let s:dpp_repos_dir = s:dpp_dir .. '/repos/github.com'
let s:dpp_repo_dir = s:dpp_repos_dir .. '/Shougo/dpp.vim'
let s:denops_repo_dir = s:dpp_repos_dir .. '/vim-denops/denops.vim'
let s:dpp_ext_installer_repo_dir = s:dpp_repos_dir .. '/Shougo/dpp-ext-installer'
let s:dpp_ext_toml_repo_dir = s:dpp_repos_dir .. '/Shougo/dpp-ext-toml'
let s:dpp_protocol_git_repo_dir = s:dpp_repos_dir .. '/Shougo/dpp-protocol-git'

let s:dpp_plugins = [
    \   'vim-denops/denops.vim',
    \   'Shougo/dpp.vim',
    \   'Shougo/dpp-ext-installer',
    \   'Shougo/dpp-ext-toml',
    \   'Shougo/dpp-protocol-git',
    \ ]
let s:rtps = []
for s:p in s:dpp_plugins
  let s:dir = printf('%s/repos/github.com/%s', s:dpp_dir, s:p)
  if !isdirectory(s:dir)
    execute printf(
        \   '!git clone --filter=blob:none https://github.com/%s %s',
        \   s:p,
        \   shellescape(s:dir),
        \ )
  endif

  execute 'helptags' s:dir .. '/doc'
  call add(s:rtps, s:dir)
endfor
unlet s:p s:dir

if index(split(&runtimepath, ','), s:dpp_repo_dir) < 0
  let &runtimepath = join(s:rtps, ',') .. ',' .. &runtimepath

  " 読み込まれない場合があるので直接読み込む
  runtime! plugin/denops.vim
endif

function! s:source_plugins() abort
  call dpp#source()
  runtime! plugin/**/*.vim
  call dpp#util#_call_hook('post_source', keys(dpp#get()))

  if !g:vimrc#is_starting
    redraw
    echomsg 'done'
    call denops#plugin#discover()
  endif
endfunction

function! s:install_plugins(prompt) abort
  let plugins = dpp#sync_ext_action('installer', 'getNotInstalled')
  let names = map(plugins, { _, v -> v.name})
  if empty(plugins)
    return
  endif

  echomsg 'Not installed plugins: ' .. join(names, ', ')
  " if a:prompt
  "   if confirm('Install now? ', "&Y\n&n") !=# 1
  "     return
  "   endif
  " endif

  call dpp#async_ext_action('installer', 'install', #{ names: names })
endfunction
Autocmd User Dpp:ext:installer:updateDone :

Autocmd User Dpp:makeStatePost call dpp#min#load_state(s:dpp_dir)
Autocmd User Dpp:makeStatePost call s:install_plugins(!g:vimrc#is_starting)
Autocmd User Dpp:makeStatePost call s:source_plugins()

if dpp#min#load_state(s:dpp_dir)
  echomsg 'making dpp cache...'
  let s:dpp_ts = expand('<sfile>:p:h') .. '/dpp.ts'

  Autocmd User DenopsReady call dpp#make_state(s:dpp_dir, s:dpp_ts)
else
  call s:source_plugins()
endif
"}}}

" let g:denops#debug = 1
" let g:denops#trace = ['dpp']

Autocmd BufWritePost dpp.{ts,toml} call dpp#check_files()

function! s:complete_plugin_names(arglead, cmdline, cursorpos) abort
  return join(keys(dpp#get()), "\n")
endfunction

command! -bar -nargs=* -complete=custom,s:complete_plugin_names DppUpdate call dpp#async_ext_action('installer', 'update', #{ names: [<f-args>] })

doautocmd denops_plugin_internal_startup VimEnter

