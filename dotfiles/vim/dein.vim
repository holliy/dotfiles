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
  call dein#add('itchyny/lightline.vim')
  call dein#add('itchyny/vim-haskell-indent', {'on_ft': 'haskell'})
  call dein#add('kana/vim-operator-user')
  call dein#add('kana/vim-repeat')
  call dein#add('kana/vim-textobj-user')
  call dein#add('LumaKernel/ddc-source-file')
  call dein#add('nathanaelkane/vim-indent-guides') " unmaintained
  call dein#add('mattn/benchvimrc-vim')
  call dein#add('mattn/vim-lsp-settings', {'depends': ['lsp']})
  call dein#add('mbbill/undotree')
  call dein#add('prabirshrestha/vim-lsp')
  call dein#add('rbtnn/vim-ambiwidth')
  call dein#add('rhysd/conflict-marker.vim')
  call dein#add('rhysd/vim-operator-surround', {'depends': ['operator-user']})
  call dein#add('rhysd/vim-textobj-word-column', {'depends': ['textobj-user']})
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
  call dein#add('thinca/vim-ft-help_fold', {'name': 'help-fold'})
  call dein#add('thinca/vim-prettyprint')
  call dein#add('tpope/vim-fugitive')
  " call dein#add('tpope/vim-surround')
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

" lightline "{{{
if dein#tap('lightline')
  " g:lightline "{{{
  let g:lightline = {
      \ 'colorscheme' : 'landscape',
      \ 'active' : {
      \   'left' : [['mode', 'paste'], ['bufnum', 'directory', 'filename', 'readonly', 'modified']],
      \   'right' : [['trailing', 'lineinfo'], ['percent'], ['fileinfo', 'filetype']]
      \ },
      \ 'inactive' : {
      \   'left' : [['bufnum', 'directory', 'filename', 'readonly', 'modified']],
      \   'right' : [['lineinfo'], ['percent']]
      \ },
      \ 'tabline' : {
      \   'left' : [['tabs']],
      \   'right' : [['close']]
      \ },
      \ 'tab' : {
      \   'active' : ['tabnum', 'filename', 'modified'],
      \   'inactive' : ['bufnum', 'filename', 'modified'],
      \ },
      \ 'component' : {
      \   'close' : '%999X x ',
      \   'directory' : '%{&filetype!~"netrw"?pathshorten(fnamemodify(expand("%:h"),":~")):""}',
      \   'lineinfo' : "L %3l:%-2v",
      \   'paste' : '%{&paste?"P":""}',
      \   'percent' : '%2p%%'
      \ },
      \ 'component_function' : {
      \   'filename' : 'MyFilename',
      \   'fileinfo' : 'MyFileinfo',
      \   'filetype' : 'MyFiletype',
      \   'mode' : 'MyMode',
      \   'modified' : 'MyModified',
      \   'readonly' : 'MyReadonly'
      \ },
      \ 'component_expand' : {
      \   'trailing' : 'MyTrailingSpaceWarning'
      \ },
      \ 'component_visible_condition' : {'directory' : '&filetype!~"netrw\\|vimshell\\|vimfiler"'},
      \ 'component_type' : {
      \   'trailing' : 'error'
      \ },
      \ 'tab_component_function' : {
      \   'modified' : 'MyModifiedT', 'bufnum' : 'MyBufnumber'
      \ },
      \ 'buf_component' : {},
      \ 'buf_component_function' : {
      \   'modified' : 'MyModifiedB', 'bufnum' : 'bufnr',
      \   'filename' : 'MyFilenameB', 'tabnum' : 'MyTabnum'
      \ },
      \ 'separator' : {'left' : "", 'right' : ""},
      \ 'subseparator' : {'left' : "|", 'right' : "|"},
      \ }
  "}}}

  function s:ignore(...) abort "{{{
    return 0
  endfunction "}}}

  " タブラインにバッファを表示 "{{{
  function! s:lightline_sourced() "{{{
    function! lightline#tabs() abort "{{{
      " return:タブが5個以上の時ウィンドウの幅によって5個から17個表示する
      let [l:t, l:l, l:x, l:y, l:z, l:u, l:d] = [bufnr('%'), bufnr('$'), [], [], [], '...', min([max([&columns / 40, 2]), 8])]

      for l:i in range(1, l:l)
        if l:i ==# l:t
          call add(l:y, '%' . l:i . 'T%{lightline#onetab(' . l:i . ', 1)}')
        elseif bufexists(l:i) && !s:ignore(l:i) && (getbufvar(l:i, '&bufhidden') ==# 'hide' || empty(getbufvar(l:i, '&buftype'))) && getbufvar(l:i, '&buflisted')
          call add(l:i < l:t ? (l:x) : l:z, '%' . l:i . 'T%{lightline#onetab(' . l:i . ', 0)}' . (l:i ==# l:l ? '%T' : ''))
        endif
      endfor

      let [l:a, l:b, l:c] = [len(l:x), len(l:z), l:d * 2]
      " return [l:a > l:d && l:b > l:d ? extend(add(l:x[ : l:d/2 - 1], l:u), l:x[-(l:d + 1)/2 : ]) :
      "     \ l:a + l:b > l:c && l:a > l:d ? extend(add(l:x[ : (l:c - l:b)/2 - 1], l:u), l:x[-(l:c - l:b + 1)/2 : ]) : l:x, l:y,
      "     \ l:a > l:d && l:b > l:d ? extend(add(l:z[ : (l:d + 1)/2 - 1], l:u), l:z[-l:d / 2 : ]) :
      "     \ l:a + l:b > l:c && l:b > l:d ? extend(add(l:z[ : (l:c - l:a + 1)/2 - 1], l:u), l:z[-(l:c - l:a)/2 : ]) : l:z]
      return l:a > l:d && l:b > l:d ? [extend(add(l:x[ : l:d/2 - 1], l:u), l:x[-(l:d + 1)/2 : ]), l:y, extend(add(l:z[ : (l:d + 1)/2 - 1], l:u), l:z[-l:d / 2 : ])] :
          \ l:a + l:b > l:c && l:a > l:d ? [extend(add(l:x[ : (l:c - l:b)/2 - 1], l:u), l:x[-(l:c - l:b + 1)/2 : ]), l:y,
          \   extend(add(l:z[ : (l:c - l:a + 1)/2 - 1], l:u), l:z[-(l:c - l:a)/2 : ])] : [l:x, l:y, l:z]
    endfunction "}}}

    function! lightline#onetab(n, active) abort "{{{
      let [l:_, l:a] = ['', g:lightline.tab[a:active ? 'active' : 'inactive']]
      let [l:c, l:f] = [g:lightline.buf_component, g:lightline.buf_component_function]

      for l:i in range(len(l:a))
        let l:s = has_key(l:f, l:a[l:i]) ? eval(l:f[l:a[l:i]] . '(' . a:n . ')') : get(l:c, l:a[l:i], '')
        if strlen(l:s)
          let l:_ .= (len(l:_) ? ' ' : '') . l:s
        endif
      endfor

      return l:_
    endfunction "}}}

    augroup lightline
      " autocmd!
      " autocmd WinEnter,BufWinEnter,FileType,ColorScheme,SessionLoadPost * call lightline#update()
      " autocmd ColorScheme,SessionLoadPost * call lightline#highlight()
      " autocmd CursorMoved,BufUnload * call lightline#update_once()
      autocmd BufWinEnter,WinEnter,SessionLoadPost * set tabline=%!CallInternalFunc('autoload/lightline.vim:line(1,0)')
    augroup END
  endfunction "}}}
  call dein#set_hook('lightline', 'hook_post_source', function('s:lightline_sourced'))
  "}}}

  function! MyModifiedB(bufnr) "{{{
    return s:ignore(a:bufnr) ? '' : getbufvar(a:bufnr, '&modified') ? '+' : getbufvar(a:bufnr, '&modifiable') ? '' : '-'
  endfunction "}}}

  function! MyFilenameB(bufnr) "{{{
    let l:fname = fnamemodify(bufname(a:bufnr), ':t')
    return empty(l:fname) ? '[No Name]' : l:fname
  endfunction "}}}

  function! MyTabnum(...) "{{{
    return tabpagenr()
  endfunction "}}}

  function! MyBufnumber(tabnr) "{{{
    return get(tabpagebuflist(a:tabnr), tabpagewinnr(a:tabnr) - 1)
  endfunction "}}}

  function! MyModifiedT(tabnr) "{{{
    let l:bufnr = MyBufnumber(a:tabnr)
    return s:ignore(l:bufnr) ? '' : getbufvar(l:bufnr, '&modified') ? '+' : getbufvar(l:bufnr, '&modifiable') ? '' : '-'
  endfunction "}}}

  function! MyModified() "{{{
    return s:ignore() ? '' : &modified ? '+' : &modifiable ? '' : '-'
  endfunction "}}}

  let s:readonlychar = 'x'
  function! MyReadonly() "{{{
    return &readonly && !s:ignore() ? s:readonlychar : ''
  endfunction "}}}

  function! MyFilename() "{{{
    let l:fname = expand('%:t')
    return l:fname =~# '\[Command Line\]' ? '' :
        \ &filetype ==? 'netrw' ? fnamemodify(b:netrw_curdir, ':~') :
        \ empty(l:fname) ? '[No Name]' : l:fname
  endfunction "}}}

  function! MyFiletype() "{{{
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : '?') : ''
  endfunction "}}}

  function! MyFileinfo() "{{{
    return !s:ignore() && winwidth(0) > 75 ? (strlen(&fileencoding) ? &fileencoding : &encoding) . '/' . &fileformat : ''
  endfunction "}}}

  function! MyMode() "{{{
    let l:fname = expand('%:t')
    return l:fname ==# '[Command Line]' ? 'Ex' :
        \ &filetype ==? 'help' ? 'Help' :
        \ &filetype ==? 'qf' ? 'QuickFix' :
        \ (winwidth(0) > 60 ? lightline#mode() : '')
  endfunction "}}}

  function! MyTrailingSpaceWarning() "{{{
    if !s:ignore()
      let l:space_line = search('\S\zs\s\+$', 'nw')
      " if l:space_line != 0

      "   return 'space: L' . l:space_line
      " endif
      " return ''
      return l:space_line != 0 ? 'Space: L' . l:space_line : ''
    endif
    return ''
  endfunction

  autocmd Vimrc BufWritePost * call MyTrailingSpaceWarning() | call lightline#update()
  "}}}
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

" vim-indent-guides "{{{
if dein#tap('indent-guides')
  let g:indent_guides_auto_colors = 0
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_exclude_filetypes = ['help']
  let g:indent_guides_indent_levels = 15
  let g:indent_guides_start_level = 1

  function! s:indent_guides_sourced() "{{{
    augroup indent_guides
      autocmd!
      autocmd BufEnter,WinEnter,FileType,VimEnter * let g:indent_guides_guide_size = &shiftwidth
      autocmd BufEnter,WinEnter,FileType,ColorScheme * call indent_guides#process_autocmds()

      autocmd ColorScheme landscape highlight IndentGuidesOdd ctermbg=240 ctermfg=208 guifg=orange guibg=#606060
      autocmd ColorScheme landscape highlight IndentGuidesEven ctermbg=235 ctermfg=208 guifg=orange guibg=#353535
      autocmd ColorScheme desert highlight IndentGuidesOdd term=bold ctermbg=240 ctermfg=5 guifg=navajowhite guibg=#606060
      autocmd ColorScheme desert highlight IndentGuidesEven term=bold ctermbg=235 ctermfg=5 guifg=navajowhite guibg=#353535
    augroup end

    if exists('g:colors_name')
      execute 'doautocmd indent_guides ColorScheme ' . g:colors_name
    endif

    call indent_guides#enable()
  endfunction "}}}
  call dein#set_hook('indent-guides', 'hook_post_source', function('s:indent_guides_sourced'))
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

" vim-operator-surround "{{{
if dein#tap('operator-surround')
  nmap ys <Plug>(operator-surround-append)
  xmap ys <Plug>(operator-surround-append)
  nmap ds <Plug>(operator-surround-delete)a
  nmap dsi <Plug>(operator-surround-delete)i
  nmap cs <Plug>(operator-surround-replace)a
  nmap csi <Plug>(operator-surround-replace)i
endif "}}}

