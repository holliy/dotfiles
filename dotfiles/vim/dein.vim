let s:dein_dir = g:vimrc#dotvim . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  if executable('git')
    call system('git clone https://github.com/Shougo/dein.vim ' .
        \ shellescape(s:dein_repo_dir))
    execute 'helptags' s:dein_repo_dir . '/doc'
  else
    echomsg 'no plugins installed.'
    finish
  endif
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath

let g:dein#enable_name_conversion = 1
let g:dein#enable_notification = v:true
" let g:dein#install_process_timeout = 60
let g:dein#install_progress_type = 'tabline'
let g:dein#install_message_type = 'echo'

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, [g:vimrc#dotvim . '/dein.vim'])

  call dein#add(s:dein_repo_dir)
  call dein#add('airblade/vim-gitgutter')
  call dein#add('cohama/lexima.vim')
  " call dein#add('derekwyatt/vim-scala', {'on_ft': 'scala'})
  " call dein#add('eagletmt/ghcmod-vim', {'on_ft': 'haskell'})
  " call dein#add('eagletmt/neco-ghc', {'on_ft': 'haskell'})
  call dein#add('gamoutatsumi/ddc-sorter_ascii', {'depends': ['ddc']})
  call dein#add('itchyny/landscape.vim')
  call dein#add('itchyny/vim-haskell-indent', {'on_ft': 'haskell'})
  call dein#add('kana/vim-operator-user')
  call dein#add('mattn/benchvimrc-vim')
  call dein#add('mattn/vim-lsp-settings', {'depends': ['lsp']})
  call dein#add('mattn/vimtweak', {'if': g:vimrc#is_windows})
  call dein#add('prabirshrestha/vim-lsp')
  call dein#add('rbtnn/vim-ambiwidth')
  " call dein#add('Shougo/neocomplete.vim')
  " call dein#add('Shougo/neosnippet.vim')
  " call dein#add('Shougo/neosnippet-snippets')
  " call dein#add('Shougo/vimproc.vim', {'build': 'make', 'if': !g:vimrc#is_windows})
  call dein#add('Shougo/ddc.vim', {'depends': ['denops']})
  call dein#add('Shougo/ddc-around', {'depends': ['ddc']})
  call dein#add('Shougo/ddc-matcher_head', {'depends': ['ddc']})
  call dein#add('Shougo/ddc-sorter_rank', {'depends': ['ddc']})
  call dein#add('shun/ddc-vim-lsp', {'depends': ['ddc', 'lsp']})
  call dein#add('thinca/vim-prettyprint')
  call dein#add('tpope/vim-fugitive')
  call dein#add('tpope/vim-surround')
  call dein#add('tyru/caw.vim')
  call dein#add('vim-denops/denops.vim', {'if': executable('deno')})
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

  " nmap <silent><expr> <Space>cc '<C-c>V' . (v:count <= 1 ? 'V' : v:count - 1 . 'gj') . '<Plug>(caw:hatpos:toggle)'
  nmap <Space>cc <Plug>(caw:hatpos:toggle)
  nmap <C-_> <Space>cc
  nnoremap <silent> <Space>ct :normal 1 cc<CR>
  nmap <Space>cd <Plug>(caw:hatpos:toggle:operator)
  nmap <Space>ca <Plug>(caw:dollarpos:toggle)
  nmap <Space>cw <Plug>(caw:wrap:toggle:operator)
  nmap <Space>co <Plug>(caw:jump:comment-next)
  nmap <Space>cO <Plug>(caw:jump:comment-prev)
  vmap <Space>cc <Plug>(caw:hatpos:toggle)
  vmap <Space>cw <Plug>(caw:wrap:toggle)
endif "}}}

" ddc.vim "{{{
if dein#tap('ddc') && executable('deno')
  call ddc#custom#patch_global('sources', ['vim-lsp', 'around'])

  call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'ignoreCase': v:true,
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']
      \ }})
  call ddc#custom#patch_global('sourceOptions', {
      \ 'around': {'mark': 'A'},
      \ 'vim-lsp': {
      \   'mark': 'L',
      \   'sorters': ['sorter_rank', 'sorter_ascii']
      \ }
      \ })

  " call ddc#custom#patch_global('autoCompleteDelay', 50)
  call ddc#custom#patch_global('completionMode', 'manual')

  call ddc#enable()

  inoremap <silent><expr> <C-n> ddc#map#pum_visible() ? '<C-n>' : ddc#map#manual_complete()
  inoremap <silent><expr> <C-p> ddc#map#pum_visible() ? '<C-p>' : ddc#map#manual_complete()
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
if dein#tap('landscape') && (g:vimrc#is_gui || &t_Co > 16)
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

    " call filter(g:lexima#default_rules,
    "    \ '!has_key(v:val, "at") || v:val.at !=# "\\\\\\%#"')
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

  inoremap <expr><silent> <Plug>(vimrc_cr) lexima#expand('<lt>CR>', 'i')
endif "}}}

" vim-fugitive "{{{
if dein#tap('fugitive')
  " コミットメッセージ入力時に先頭の行へ移動
  Autocmd BufWinEnter COMMIT_EDITMSG goto 1
endif "}}}

" vim-gitgutter "{{{
if dein#tap('gitgutter')
  let g:gitgutter_highlight_lines = 1

  if &encoding !=# 'utf-8'
    let g:gitgutter_sign_removed_first_line = '_'
    let g:gitgutter_sign_removed_above_and_below = '_'
  endif
endif "}}}

" vim-haskell-indent "{{{
if dein#tap('haskell-indent')
  let g:haskell_indent_disable_case = 1
endif "}}}

" vim-lsp "{{{
if dein#tap('lsp')
  let g:lsp_completion_documentation_enabled = 0
  let g:lsp_diagnostics_echo_cursor = 1
  " let g:lsp_diagnostics_signs_enabled = 0
  let g:lsp_diagnostics_signs_insert_mode_enabled = 0
  " let g:lsp_hover_ui = 'preview'

  let g:lsp_diagnostics_signs_error = {'text': '!'}
  let g:lsp_diagnostics_signs_warning = {'text': '*'}
  let g:lsp_diagnostics_signs_hint = {'text': '.'}
  let g:lsp_diagnostics_signs_information = {'text': '.'}
  let g:lsp_document_code_action_signs_hint = {'text': ':'}

  nnoremap <Space>lh <Plug>(lsp-hover)
  nnoremap <Space>ls <Plug>(lsp-signature-help)
  nnoremap <Space>ld <Plug>(lsp-peek-definition)
  nnoremap <Space>lt <Plug>(lsp-peek-type-definition)
  nnoremap <Space>li <Plug>(lsp-peek-implementation)
  nnoremap <Space>ll <Plug>(lsp-document-diagnostics)
  nnoremap <Space>lr <Plug>(lsp-rename)
  nnoremap <Space>lc <Plug>(lsp-code-action)

  Autocmd User lsp_buffer_enabled setlocal foldmethod=expr
  Autocmd User lsp_buffer_enabled setlocal foldexpr=lsp#ui#vim#folding#foldexpr()
  " Autocmd User lsp_buffer_enabled setlocal foldtext=lsp#ui#vim#folding#foldtext()
  Autocmd User lsp_buffer_enabled setlocal signcolumn=yes

  " https://github.com/prabirshrestha/vim-lsp/issues/1281
  if has('nvim')
    " Autocmd User lsp_float_opened
    "    \ call nvim_win_set_option(lsp#ui#vim#output#getpreviewwinid(), 'winhighlight', 'MatchParen')
    Autocmd User lsp_float_opened
        \ call nvim_win_set_option(lsp#ui#vim#output#getpreviewwinid() is v:false ?
        \   g:CallInternalFunc('lsp/internal/document_hover/under_cursor.vim:get_doc_win()').get_winid() :
        \   lsp#ui#vim#output#getpreviewwinid(), 'winhighlight', 'MatchParen')
  else
    " Autocmd User lsp_float_opened
    "    \ call setwinvar(lsp#ui#vim#output#getpreviewwinid(), '&wincolor', 'MatchParen')
    Autocmd User lsp_float_opened
        \ call setwinvar(lsp#ui#vim#output#getpreviewwinid() is v:false ?
        \   g:CallInternalFunc('lsp/internal/document_hover/under_cursor.vim:get_doc_win()').get_winid() :
        \   lsp#ui#vim#output#getpreviewwinid(), '&wincolor', 'MatchParen')
  endif
endif "}}}

call dein#call_hook('source')

