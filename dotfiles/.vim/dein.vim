let s:dein_dir = g:vimrc#dotvim . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' .
      \ shellescape(s:dein_repo_dir))
  execute('helptags ' . s:dein_repo_dir . '/doc')
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath

let g:dein#enable_name_conversion = 1
" let g:dein#install_process_timeout = 60
let g:dein#install_progress_type = 'echo'
let g:dein#install_message_type = 'tabline'

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, [g:vimrc#dotvim . '/dein.vim'])

  call dein#add(s:dein_repo_dir)
  call dein#add('cohama/lexima.vim')
  call dein#add('derekwyatt/vim-scala', {'on_ft': 'scala'})
  call dein#add('eagletmt/ghcmod-vim', {'on_ft': 'haskell'})
  call dein#add('eagletmt/neco-ghc', {'on_ft': 'haskell'})
  call dein#add('itchyny/landscape.vim')
  call dein#add('itchyny/vim-haskell-indent', {'on_ft': 'haskell'})
  call dein#add('kana/vim-operator-user')
  call dein#add('mattn/benchvimrc-vim')
  " call dein#add('Shougo/neocomplete.vim')
  " call dein#add('Shougo/neosnippet.vim')
  " call dein#add('Shougo/neosnippet-snippets')
  " call dein#add('Shougo/vimproc.vim', {'build': 'make', 'if': !g:vimrc#is_windows})
  call dein#add('Shougo/ddc.vim')
  call dein#add('Shougo/ddc-around')
  call dein#add('Shougo/ddc-matcher_head')
  call dein#add('Shougo/ddc-sorter_rank')
  call dein#add('thinca/vim-prettyprint')
  call dein#add('tyru/caw.vim')
  call dein#add('vim-denops/denops.vim')
  call dein#add('vim-jp/vimdoc-ja')

  call dein#end()

  if !(g:vimrc#is_unix && $USER ==# 'root')
    call dein#save_state()
  endif
endif

if g:vimrc#is_starting && dein#check_install()
  call dein#install()
endif

" caw "{{{
if dein#tap('caw')
  let g:caw_dollarpos_sp_left = ' '
  " let g:caw_no_default_keymappings = 1
  let g:caw_operator_keymappings = 1

  AutocmdFT haskell let b:caw_wrap_oneline_comment = ['{-', '-}']
  AutocmdFT haskell let b:caw_wrap_multiline_comment = {'left': '{-', 'right': '-}', 'top': '-', 'bottom': '-'}

  nmap <silent><expr> <Space>cc '<C-c>V' . (v:count <= 1 ? 'V' : v:count - 1 . 'gj') . '<Plug>(caw:hatpos:toggle)'
  nnoremap <silent> <Space>ct :normal 1 cc<CR>
  nmap <Space>cd <Plug>(caw:hatpos:toggle:operator)
  nmap <Space>ca <Plug>(caw:dollarpos:toggle)
  nmap <Space>cw <Plug>(caw:wrap:toggle:operator)
  nmap <Space>co <Plug>(caw:jump:comment-next)
  nmap <Space>cO <Plug>(caw:jump:comment-prev)
  vmap <Space>cc <Plug>(caw:hatpos:comment)
  vmap <Space>cC <Plug>(caw:hatpos:toggle)
  vmap <Space>cw <Plug>(caw:wrap:toggle)
endif "}}}

" ddc.vim "{{{
if dein#tap('ddc')
  call ddc#custom#patch_global('sources', ['around'])

  call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']
      \ }})
  call ddc#custom#patch_global('sourceOptions', {
      \ 'around': {'mark': 'A'},
      \ })

  call ddc#custom#patch_global('completionMode', 'manual')

  call ddc#enable()

  inoremap <silent><expr> <C-n> ddc#map#pum_visible() ? '<C-n>' : ddc#map#manual_complete()
  " imap <C-Space> <C-n>
endif "}}}

" ghcmod-vim "{{{
if dein#tap('ghcmod')
  Autocmd Filetype haskell nnoremap <buffer><silent> <Space>ft :<C-u>GhcModType!<CR>
  Autocmd Filetype haskell nnoremap <buffer><silent> <Space>fi :<C-u>GhcModInfo!<CR>
  Autocmd Filetype haskell nnoremap <buffer><silent> <Space><Tab> :<C-u>nohlsearch<Bar>GhcModTypeClear<CR>
  Autocmd Filetype haskell nnoremap <buffer><silent> <Space>fc :<C-u>GhcModCheckAsync<CR>
  Autocmd Filetype haskell nnoremap <buffer><silent> <Space>fl :<C-u>GhcModLintAsync<CR>
endif "}}}

" landscape "{{{
if dein#tap('landscape')
  Autocmd VimEnter * nested colorscheme landscape
endif "}}}

" lexima "{{{
if dein#tap('lexima')
  let g:lexima_map_escape = 'jk'

  function! s:lexima_sourced(...) "{{{
    let quotes = [
        \   {'start': "'", 'end': "'"}, {'start': '"', 'end': '"'}
        \ ]
    let brackets = [
        \   {'start': '(', 'end': ')'}, {'start': '{', 'end': '}'},
        \   {'start': '[', 'end': ']'}
        \ ]

    call filter(g:lexima#default_rules,
        \ '!has_key(v:val, "at") || v:val.at !=# "\\\\\\%#"')
    call lexima#set_default_rules()

    " quote in lisp "{{{
    call lexima#add_rule({
        \   'char': "'",
        \   'filetype': ['lisp', 'scheme']
        \ })
    call lexima#add_rule({
        \   'char': "'",
        \   'input_after': "'",
        \   'filetype': ['lisp', 'scheme'],
        \   'syntax': ['Comment', 'Constant', 'String']
        \ })
    call lexima#add_rule({
        \   'at': "\\%#'",
        \   'char': "'",
        \   'leave': 1,
        \   'filetype': ['lisp', 'scheme'],
        \   'syntax': ['Comment', 'Constant', 'String']
        \ }) "}}}

    " comment{{{
    " C style "{{{
    call lexima#add_rule({
        \   'at': '/\%#$',
        \   'char': '*',
        \   'input_after': '*/',
        \   'filetype': ['c', 'cpp', 'cs', 'java', 'scala']
        \ })
    call lexima#add_rule({
        \   'at': '/\*\%#\*/',
        \   'char': '<Space>',
        \   'input_after': '<Space>',
        \   'filetype': ['c', 'cpp', 'cs', 'java', 'scala']
        \ })
    call lexima#add_rule({
        \   'at': '/\*\%#\*/',
        \   'char': '<BS>',
        \   'input': '<BS><BS>',
        \   'delete': 2,
        \   'filetype': ['c', 'cpp', 'cs', 'java', 'scala']
        \ })
    call lexima#add_rule({
        \   'at': '/\* \%# \*/',
        \   'char': '<BS>',
        \   'delete': 1,
        \   'filetype': ['c', 'cpp', 'cs', 'java', 'scala']
        \ })
    call lexima#add_rule({
        \   'at': '/\*\%#\*/',
        \   'char': '<BS>',
        \   'delete': 2,
        \   'input': '<BS><BS>',
        \   'filetype': ['c', 'cpp', 'cs', 'java', 'scala']
        \ })
    call lexima#add_rule({
        \   'at': '^ \* \%# \?\*/',
        \   'char': '<BS>',
        \   'input': '<BS><BS>',
        \   'filetype': ['c', 'cpp', 'cs', 'java', 'scala']
        \ })
    call lexima#add_rule({
        \   'at': '^ \%#',
        \   'char': '<Space>',
        \   'input': '*<Space>',
        \   'filetype': ['c', 'cpp', 'cs', 'java', 'scala'],
        \   'syntax': ['Comment']
        \ }) "}}}

    " Haskell "{{{
    call lexima#add_rule({
        \   'at': '{\%#$',
        \   'char': '-',
        \   'input_after': '-}',
        \   'filetype': ['haskell']
        \ })
    call lexima#add_rule({
        \   'at': '{\%#}$',
        \   'char': '-',
        \   'input_after': '-',
        \   'filetype': ['haskell']
        \ })
    call lexima#add_rule({
        \   'at': '{-\%#-}',
        \   'char': '#',
        \   'input_after': '#',
        \   'filetype': ['haskell']
        \ })
    call lexima#add_rule({
        \   'at': '{-\%#-}',
        \   'char': '<Space>',
        \   'input_after': '<Space>',
        \   'filetype': ['haskell']
        \ })
    call lexima#add_rule({
        \   'at': '{-#\%##-}',
        \   'char': '<Space>',
        \   'input_after': '<Space>',
        \   'filetype': ['haskell']
        \ })
    call lexima#add_rule({
        \   'at': '{-\%#-}',
        \   'char': '<BS>',
        \   'input': '<BS><BS>',
        \   'delete': 2,
        \   'filetype': ['haskell']
        \ })
    call lexima#add_rule({
        \   'at': '{-#\%##-}',
        \   'char': '<BS>',
        \   'delete': 1,
        \   'filetype': ['haskell']
        \ })
    call lexima#add_rule({
        \   'at': '{- \%# -}',
        \   'char': '<BS>',
        \   'delete': 1,
        \   'filetype': ['haskell']
        \ })
    call lexima#add_rule({
        \   'at': '{-# \%# #-}',
        \   'char': '<BS>',
        \   'delete': 1,
        \   'filetype': ['haskell']
        \ })
    call lexima#add_rule({
        \   'at': '^ - \%# \?-}',
        \   'char': '<BS>',
        \   'input': '<BS><BS>',
        \   'filetype': ['haskell']
        \ })
    call lexima#add_rule({
        \   'at': '^ \%#',
        \   'char': '<Space>',
        \   'input': '-<Space>',
        \   'filetype': ['haskell'],
        \   'syntax': ['Comment']
        \ }) "}}}
    "}}}

    " bracket "{{{
    for pair in brackets
      call lexima#add_rule({
          \   'at': '\V' . pair.start . '\%#' . pair.end,
          \   'char': '<CR>',
          \   'input': '<CR>\ ',
          \   'input_after': '<CR>\ ',
          \   'filetype': ['vim']
          \ })
      call lexima#add_rule({
          \   'at': pair.start . '\%#$',
          \   'except': '\C\v^(\s*)\S.*%#\n%(%(\s*|\1\s*\\.*)\n)*\1\s*\\\s*\' . pair.end,
          \   'char': '<CR>',
          \   'input': '<CR>\ ',
          \   'input_after': '<CR>\ ' . pair.end,
          \   'filetype': ['vim']
          \ })
      call lexima#add_rule({
          \   'at': '\C\v^(\s*)\S.*\' . pair.start . '%#\n%(%(\s*|\1\s*\\.*)\n)*\1\s*\\\s*\' . pair.end,
          \   'char': '<CR>',
          \   'input': '<CR>\ ',
          \   'filetype': ['vim']
          \ })
      call lexima#add_rule({
          \   'at': '\%#\w',
          \   'char': pair.start
          \ })
    endfor

    call lexima#add_rule({
        \   'at': '\\\%#',
        \   'char': '(',
        \   'input_after': '\)',
        \   'filetype': ['vim']
        \ }) "}}}

    " <Tab>で補完した文字の後ろに移動 "{{{
    for pair in brackets + quotes
      call lexima#add_rule({
          \   'at': '\S\%# \?' . pair.end,
          \   'char': '<Tab>',
          \   'leave': pair.end
          \ })
    endfor

    call lexima#add_rule({
        \   'at': '\%# \?\*/',
        \   'char': '<Tab>',
        \   'leave': '/',
        \   'filetype': ['c', 'cpp', 'cs', 'java', 'scala']
        \ })
    call lexima#add_rule({
        \   'at': '\%# \?-}',
        \   'char': '<Tab>',
        \   'leave': '}',
        \   'filetype': ['haskell']
        \ })
    "}}}

    imap <expr><silent> <CR> pumvisible() ? '<Plug>(vimrc_complete-select)' : '<Plug>(vimrc_cr)'
  endfunction "}}}
  call dein#set_hook('lexima', 'hook_source', function('s:lexima_sourced'))

  inoremap <expr><silent> <Plug>(vimrc_cr) lexima#expand('<CR>', 'i')
endif "}}}

" neocomplete "{{{
if dein#tap('neocomplete')
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_auto_close_preview = 1
  let g:neocomplete#enable_auto_delimiter = 1
  let g:neocomplete#enable_camel_case = 1
  let g:neocomplete#disable_auto_complete = 0
  let g:neocomplete#enable_fuzzy_completion = 1
  let g:neocomplete#enable_insert_char_pre = 1
  let g:neocomplete#enable_smart_case = 1
  let g:neosnippet#expand_word_boundary = 1
  let g:neocomplete#sources#syntax#min_keyword_length = 3

  let g:neocomplete#force_omni_input_patterns =
      \ get(g: , 'neocomplete#force_omni_input_patterns', {})
  let g:neocomplete#keyword_patterns =
      \ get(g:, 'neocomplete#keyword_patterns', {})
  let g:neocomplete#same_filetypes =
      \ get(g:, 'neocomplete#same_filetypes', {})
  let g:neocomplete#sources#dictionary#dictionaries =
      \ get(g:, 'neocomplete#sources#dictionary#dictionaries', {})
  let g:neocomplete#sources#omni#input_patterns =
      \ get(g:, 'neocomplete#sources#omni#input_patterns', {})
  let g:neocomplete#sources#omni#functions =
      \ get(g:, 'neocomplete#sources#omni#functions', {})

  let g:neocomplete#keyword_patterns._ = '\h\w*'

  let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'

  let g:neocomplete#keyword_patterns.scheme = '[[:alpha:]+*/@$_=.!?-][[:alnum:]+*/@$_:=.!?-]*'

  let g:neocomplete#sources#omni#input_patterns.cs = '.*[^=\);]'
  let g:neocomplete#force_omni_input_patterns.cs = '.*[^=\);]'

  let g:neocomplete#sources#omni#input_patterns.java = '\k\.\k*'
  let g:neocomplete#force_omni_input_patterns.java = '\k\.\k*'

  autocmd Vimrc BufReadPost,BufWritePost ?* if &filetype !~# 'qf' | NeoCompleteBufferMakeCache % | endif

  inoremap <expr><silent> <C-n> pumvisible() ? '<C-n>' : neocomplete#start_manual_complete()
  inoremap <expr><silent> <C-u> pumvisible() ? '<C-p>' : neocomplete#start_manual_complete()

  if dein#tap('neco-ghc')
    let g:neocomplete#sources#omni#functions.haskell = 'necoghc#omnifunc'
  endif

  " neosnippet "{{{
  if dein#tap('neosnippet') && dein#tap('neosnippet-snippets')
    let g:neosnippet#snippets_directory = expand(g:dein#plugin['path'] . '/neosnippets')

    inoremap <expr><silent> <C-u> pumvisible() ? '<C-u>' : neosnippet#jumpable() ? neosnippet#mappings#jump_impl() : neocomplete#start_manual_complete()
    snoremap <expr><silent> <C-u> neosnippet#jumpable() ? neosnippet#mappings#jump_impl() : '<C-u>'
    inoremap <expr><silent> <Plug>(vimrc_complete-select) neosnippet#expandable() ? neosnippet#mappings#expand_impl() : '<C-y>'

    if has('conceal')
      set conceallevel=2 concealcursor=iv
    endif
  else
  endif "}}}
endif "}}}

" vim-haskell-indent "{{{
if dein#tap('haskell-indent')
  let g:haskell_indent_disable_case = 1
endif "}}}

call dein#call_hook('source')

