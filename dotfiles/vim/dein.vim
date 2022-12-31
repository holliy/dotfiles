if !(g:vimrc#is_nvim || v:version >= 802)
  echomsg 'no plugins loaded.'
  finish
endif

let s:dein_dir = g:vimrc#dotvim . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  if !executable('git')
    echomsg 'no plugins installed.'
    finish
  endif

  call system('git clone https://github.com/Shougo/dein.vim ' .
      \ shellescape(s:dein_repo_dir))
  execute 'helptags' s:dein_repo_dir . '/doc'
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath

let g:dein#auto_recache = 1
let g:dein#enable_name_conversion = 1
" let g:dein#install_process_timeout = 60
let g:dein#install_progress_type = 'tabline'
let g:dein#install_message_type = 'echo'

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, [expand('<sfile>')])

  call dein#add(s:dein_repo_dir)
  call dein#add('airblade/vim-gitgutter')
  call dein#add('cohama/lexima.vim')
  " call dein#add('derekwyatt/vim-scala', {'on_ft': 'scala'})
  " call dein#add('eagletmt/ghcmod-vim', {'on_ft': 'haskell'})
  " call dein#add('eagletmt/neco-ghc', {'on_ft': 'haskell'})
  " call dein#add('gamoutatsumi/ddc-sorter_ascii', {'depends': ['ddc']})
  call dein#add('holliy/ddc-sorter_ascii', {'depends': ['ddc'], 'rev': 'bump-ddc'})
  call dein#add('itchyny/landscape.vim')
  call dein#add('itchyny/vim-haskell-indent', {'on_ft': 'haskell'})
  call dein#add('kana/vim-operator-user')
  call dein#add('kana/vim-repeat')
  call dein#add('LumaKernel/ddc-source-file')
  call dein#add('mattn/benchvimrc-vim')
  call dein#add('mattn/vim-lsp-settings', {'depends': ['lsp']})
  call dein#add('mbbill/undotree')
  call dein#add('prabirshrestha/vim-lsp')
  call dein#add('rbtnn/vim-ambiwidth')
  call dein#add('rhysd/conflict-marker.vim')
  " call dein#add('Shougo/neocomplete.vim')
  " call dein#add('Shougo/neosnippet.vim')
  " call dein#add('Shougo/neosnippet-snippets')
  " call dein#add('Shougo/vimproc.vim', {'build': 'make', 'if': !g:vimrc#is_windows})
  call dein#add('Shougo/ddc.vim', {'depends': ['denops']})
  call dein#add('Shougo/ddc-around', {'depends': ['ddc']})
  call dein#add('Shougo/ddc-matcher_head', {'depends': ['ddc']})
  call dein#add('Shougo/ddc-sorter_rank', {'depends': ['ddc']})
  call dein#add('Shougo/ddc-ui-native', {'depends': ['ddc']})
  call dein#add('Shougo/ddc-ui-none', {'depends': ['ddc']})
  call dein#add('shun/ddc-vim-lsp', {'depends': ['ddc', 'lsp']})
  call dein#add('thinca/vim-prettyprint')
  call dein#add('tpope/vim-fugitive')
  call dein#add('tpope/vim-surround')
  call dein#add('tyru/caw.vim', {'depends': ['operator-user', 'repeat']})
  call dein#add('vim-denops/denops.vim', {'if': executable('deno')})
  call dein#add('vim-jp/vimdoc-ja')

  if g:vimrc#is_windows
    call dein#add('mattn/vimtweak', {'if': !g:vimrc#is_nvim && g:vimrc#is_gui})
  endif

  call dein#end()

  if g:vimrc#is_starting && dein#check_install()
    call dein#install()
  endif

  if !(g:vimrc#is_unix && $USER ==# 'root')
    call dein#save_state()
  endif
endif

Autocmd VimEnter * call dein#call_hook('post_source')

" caw "{{{
if dein#tap('caw')
  let g:caw_dollarpos_sp_left = ' '
  let g:caw_hatpos_align = 0
  let g:caw_hatpos_skip_blank_line = 1
  " let g:caw_no_default_keymappings = 1
  let g:caw_operator_keymappings = 1

  AutocmdFT haskell let b:caw_wrap_oneline_comment = ['{-', '-}']
  AutocmdFT haskell let b:caw_wrap_multiline_comment = {'left': '{-', 'right': '-}', 'top': '-', 'bottom': '-'}

  " nmap <silent><expr> <Space>cc '<C-c>V' . (v:count <= 1 ? 'V' : v:count - 1 . 'gj') . '<Plug>(caw:hatpos:toggle)'
  nmap <Space>cc <Plug>(caw:hatpos:toggle)
  vmap <Space>cc <Plug>(caw:hatpos:toggle)
  noremap <silent> <Space>ct :normal 1 cc<CR>
  nmap <Space>cu <Plug>(caw:hatpos:uncomment)
  vmap <Space>cu <Plug>(caw:hatpos:uncomment)
  nmap <Space>cd <Plug>(caw:hatpos:toggle:operator)
  nmap <Space>ca <Plug>(caw:dollarpos:toggle)
  nmap <Space>cw <Plug>(caw:wrap:toggle:operator)
  vmap <Space>cw <Plug>(caw:wrap:toggle)
  nmap <Space>co <Plug>(caw:jump:comment-next)
  nmap <Space>cO <Plug>(caw:jump:comment-prev)
endif "}}}

" conflict-marker.vim "{{{
if dein#tap('conflict-marker')
  let g:conflict_marker_highlight_group = ''

  Highlight link ConflictMarkerBegin Error
  Highlight link ConflictMarkerEnd Error
  Highlight link ConflictMarkerOurs DiffDelete
  Highlight link ConflictMarkerCommonAncestors Error
  Highlight link ConflictMarkerCommonAncestorsHunk Folded
  Highlight link ConflictMarkerTheirs DiffAdd

  Autocmd BufReadPost *
      \ if conflict_marker#detect#markers() |
      \   GitGutterLineHighlightsDisable |
      \ endif
  Autocmd BufWritePost *
      \ if !conflict_marker#detect#markers() |
      \   GitGutterLineHighlightsEnable |
      \ endif
endif "}}}

" ddc.vim "{{{
if dein#tap('ddc')
  function s:ddc_sourced() abort "{{{
    if execute('augroup') !~# '\<denops_plugin_internal\>'
      " denopsがサポートされてない
      return
    endif

    call ddc#custom#patch_global('sources', ['vim-lsp', 'around'])
    call ddc#custom#patch_global('ui', 'none')

    call ddc#custom#patch_global('sourceOptions', {
        \ '_': {
        \   'dup': 'keep',
        \   'ignoreCase': v:true,
        \   'matchers': ['matcher_head'],
        \   'minAutoCompleteLength': 0,
        \   'sorters': ['sorter_rank'],
        \   'timeout': 5000
        \ },
        \ 'around': {'mark': 'A'},
        \ 'vim-lsp': {
        \   'mark': 'L',
        \   'sorters': ['sorter_rank', 'sorter_ascii']
        \ },
        \ 'file': {
        \   'sorters': ['sorter_ascii']
        \ }
        \ })
    call ddc#custom#patch_global('sourceParams', {
        \ 'around': {
        \   'maxSize': 500
        \ },
        \ 'file': {
        \   'displayCwd': 'c',
        \   'displayBuf': 'b',
        \ }
        \ })

    " call ddc#custom#patch_global('autoCompleteDelay', 50)

    call ddc#enable()

    inoremap <silent><expr> <C-n> pumvisible() ? '<C-n>' : ddc#map#complete('native')
    inoremap <silent><expr> <C-p> pumvisible() ? '<C-p>' : ddc#map#complete('native')
    inoremap <silent><expr> <Plug>(vimrc_complete-file) ddc#map#manual_complete('file', 'native')
    " imap <C-Space> <C-n>

    " 進捗表示などで高速で画面を書き換えるコマンドを実行しているとdenoがメモリを食いすぎるので端末ウィンドウ中のautocommandを無効化
    if g:vimrc#is_nvim
      Autocmd TermOpen * call ddc#custom#patch_buffer('autoCompleteEvents', [])
      Autocmd TermOpen * autocmd! ddc TextChangedT
    elseif has('terminal')
      if exists('##TerminalWinOpen')
        Autocmd TerminalWinOpen * call ddc#custom#patch_buffer('autoCompleteEvents', [])
        Autocmd TerminalWinOpen * autocmd! ddc TextChangedT
      else
        Autocmd TerminalOpen * call ddc#custom#patch_buffer('autoCompleteEvents', [])
        Autocmd TerminalOpen * autocmd! ddc TextChangedT
      endif
    endif
  endfunction "}}}
  call dein#set_hook('ddc', 'hook_post_source', function('s:ddc_sourced'))
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

  inoremap <expr><silent> <Plug>(vimrc_cr) lexima#expand('<lt>CR>', 'i')

  if g:vimrc#is_nvim
    Autocmd TermOpen * let b:lexima_disabled = 1
  elseif has('terminal')
    if exists('##TerminalWinOpen')
      Autocmd TerminalWinOpen * let b:lexima_disabled = 1
    else
      Autocmd TerminalOpen * let b:lexima_disabled = 1
    endif
  endif

  function! s:lexima_sourced(...) abort "{{{
    let quotes = [
        \   {'start': "'", 'end': "'"}, {'start': '"', 'end': '"'}
        \ ]
    let brackets = [
        \   {'start': '(', 'end': ')'}, {'start': '{', 'end': '}'},
        \   {'start': '[', 'end': ']'}
        \ ]
    let comments = [
        \   {'start': '/*', 'end': '*/', 'head': '*',
        \     'filetype': ['c', 'cpp', 'cs', 'java', 'rust', 'scala']},
        \   {'start': '{-', 'end': '-}', 'with_bracket': 1, 'filetype': ['haskell']},
        \   {'start': '{-#', 'end': '#-}', 'filetype': ['haskell']},
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
    for c in comments
      call lexima#add_rule({
          \   'at': '\V' . c.start[:-2] . '\%#\$',
          \   'char': c.start[-1:],
          \   'input_after': c.end,
          \   'filetype': c.filetype
          \ })
      call lexima#add_rule({
          \   'at': '\V' . c.start . '\%#' . c.end,
          \   'char': '<Space>',
          \   'input_after': '<Space>',
          \   'filetype': c.filetype
          \ })
      call lexima#add_rule({
          \   'at': '\V' . c.start . '\%#' . c.end,
          \   'char': '<BS>',
          \   'input': repeat('<BS>', len(c.start)),
          \   'delete': len(c.end),
          \   'filetype': c.filetype
          \ })
      call lexima#add_rule({
          \   'at': '\V' . c.start . ' \%# ' . c.end,
          \   'char': '<BS>',
          \   'delete': 1,
          \   'filetype': c.filetype
          \ })

      if has_key(c, 'head')
        call lexima#add_rule({
            \   'at': '\V\^ ' . c.head . ' \%# \?' . c.end,
            \   'char': '<BS>',
            \   'input': '<BS><BS>',
            \   'filetype': c.filetype
            \ })
        call lexima#add_rule({
            \   'at': '^ \%#',
            \   'char': '<Space>',
            \   'input': c.head . '<Space>',
            \   'filetype': c.filetype,
            \   'syntax': ['Comment']
            \ })
      endif

      if get(c, 'with_bracket', 0)
        call lexima#add_rule({
            \   'at': '\V' . c.start[:-2] . '\%#' . c.end[1:] . '\$',
            \   'char': c.start[-1:],
            \   'input_after': c.end[:0],
            \   'filetype': c.filetype
            \ })
      endif

    endfor
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
      " () の間に改行を入力時、継続行にして3行に展開
      call lexima#add_rule({
          \   'at': pair.start . '\%#$',
          \   'except': '\C\v^(\s*)\S.*%#\n%(%(\s*|\1\s*\\.*)\n)*\1\s*\\\s*\' . pair.end,
          \   'char': '<CR>',
          \   'input': '<CR>\ ',
          \   'input_after': '<CR>\ ' . pair.end,
          \   'filetype': ['vim']
          \ })
      " ↑の展開後の途中の改行でも行継続
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

    " 補完した文字の後ろに<Tab>で移動 "{{{
    for pair in brackets + quotes
      call lexima#add_rule({
          \   'at': '\V\S\%# \?' . pair.end,
          \   'char': '<Tab>',
          \   'leave': pair.end
          \ })
    endfor

    for c in comments
      call lexima#add_rule({
          \   'at': '\V\S\%# \?' . c.end,
          \   'char': '<Tab>',
          \   'leave': c.end,
          \   'filetype': c.filetype,
          \   'syntax': ['Comment']
          \ })
    endfor
    "}}}

    imap <expr><silent> <CR> pumvisible() ? '<Plug>(vimrc_complete-select)' : '<Plug>(vimrc_cr)'
  endfunction "}}}
  call dein#set_hook('lexima', 'hook_post_source', function('s:lexima_sourced'))
endif "}}}

" undotree "{{{
if dein#tap('undotree')
  let g:undotree_DiffpanelHeight = 8
  let g:undotree_SetFocusWhenToggle = 1
  let g:undotree_WindowLayout = 2

  nmap <Space>u :<C-u>UndotreeToggle<CR>

  Autocmd BufWinEnter undotree_* GitGutterLineHighlightsDisable
  Autocmd BufWinLeave undotree_* GitGutterLineHighlightsEnable
endif "}}}

" vim-fugitive "{{{
if dein#tap('fugitive')
  call add(g:vimrc#generate_filetypes, 'fugitive')

  " コミットメッセージ入力時に先頭の行へ移動
  Autocmd BufWinEnter COMMIT_EDITMSG goto 1

  AutocmdFT fugitive noremap <buffer><silent> q :<C-u>bwipeout<CR>
  AutocmdFT fugitiveblame noremap <buffer><silent> q gq
endif "}}}

" vim-gitgutter "{{{
if dein#tap('gitgutter')
  let g:gitgutter_highlight_lines = 1
  " let g:gitgutter_set_sign_backgrounds = 0
  let g:gitgutter_sign_priority = 9

  if &encoding !=# 'utf-8'
    let g:gitgutter_sign_removed_first_line = '_'
    let g:gitgutter_sign_removed_above_and_below = '_'
  endif

  if g:vimrc#is_windows
    " リポジトリが認識されないのでファイルのディレクトリから認識するように指定
    Autocmd BufWinEnter * let g:gitgutter_git_args = '-C ' . expand('%:p:h')
  endif

  Autocmd BufWritePost * GitGutter

  function! s:gitgutter_sourced() abort
    " autocmd! gitgutter CursorHold,CursorHoldI
  endfunction
  call dein#set_hook('gitgutter', 'hook_post_source', function('s:gitgutter_sourced'))
endif "}}}

" vim-haskell-indent "{{{
if dein#tap('haskell-indent')
  let g:haskell_indent_disable_case = 1
endif "}}}

" vim-lsp "{{{
if dein#tap('lsp')
  let g:lsp_completion_documentation_enabled = 0
  let g:lsp_diagnostics_echo_cursor = 1
  let g:lsp_diagnostics_highlights_insert_mode_enabled = 0
  " let g:lsp_diagnostics_signs_enabled = 0
  let g:lsp_diagnostics_signs_insert_mode_enabled = 0
  " let g:lsp_hover_ui = 'preview'

  let g:lsp_diagnostics_signs_error = {'text': '!'}
  let g:lsp_diagnostics_signs_warning = {'text': '*'}
  let g:lsp_diagnostics_signs_hint = {'text': '.'}
  let g:lsp_diagnostics_signs_information = {'text': '.'}
  let g:lsp_document_code_action_signs_hint = {'text': ':'}

  let g:lsp_diagnostics_signs_priority_map = {
      \   'LspError': 12,
      \   'LspWarning': 11
      \ }

  nnoremap <Space>lh <Plug>(lsp-hover)
  nnoremap <Space>ls <Plug>(lsp-signature-help)
  nnoremap <Space>ld <Plug>(lsp-peek-definition)
  nnoremap <Space>lt <Plug>(lsp-peek-type-definition)
  nnoremap <Space>li <Plug>(lsp-peek-implementation)
  nnoremap <Space>ll <Plug>(lsp-document-diagnostics)
  nnoremap <Space>lr <Plug>(lsp-rename)
  nnoremap <Space>lc <Plug>(lsp-code-action)

  Highlight link LspHintText Question

  Autocmd User lsp_buffer_enabled
      \ if &filetype !=# 'vim' |
      \   setlocal foldmethod=expr |
      \ endif
  Autocmd User lsp_buffer_enabled setlocal foldexpr=lsp#ui#vim#folding#foldexpr()
  " Autocmd User lsp_buffer_enabled setlocal foldtext=lsp#ui#vim#folding#foldtext()
  Autocmd User lsp_buffer_enabled setlocal signcolumn=yes

  if g:vimrc#is_nvim
    Autocmd User lsp_float_opened
        \ if lsp#document_hover_preview_winid() isnot v:null |
        \   call nvim_win_set_option(lsp#document_hover_preview_winid(), 'winhighlight', 'MatchParen') |
        \ endif
  else
    Autocmd User lsp_float_opened
        \ if lsp#document_hover_preview_winid() isnot v:null |
        \   call setwinvar(lsp#document_hover_preview_winid(), '&wincolor', 'MatchParen') |
        \ endif
  endif
endif "}}}

