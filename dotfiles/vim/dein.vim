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

if dein#load_state(s:dein_dir) "{{{
  call dein#begin(s:dein_dir, [expand('<sfile>')])

  call dein#add(s:dein_repo_dir)
  call dein#add('airblade/vim-gitgutter')
  call dein#add('cohama/lexima.vim')
  " call dein#add('derekwyatt/vim-scala', #{ on_ft: 'scala' })
  " call dein#add('eagletmt/ghcmod-vim', #{ on_ft: 'haskell' })
  " call dein#add('eagletmt/neco-ghc', #{ on_ft: 'haskell' })
  call dein#add('gamoutatsumi/ddc-sorter_ascii', #{ depends: ['ddc'] })
  call dein#add('itchyny/landscape.vim')
  call dein#add('itchyny/lightline.vim')
  call dein#add('itchyny/vim-haskell-indent', #{ on_ft: 'haskell' })
  call dein#add('junegunn/fzf', #{ merged: 0 })
  call dein#add('junegunn/fzf.vim', #{ name: 'fzf-plugin', depends: ['fzf'] })
  call dein#add('kana/vim-operator-user')
  call dein#add('kana/vim-repeat')
  call dein#add('kana/vim-textobj-user')
  call dein#add('lambdalisue/kensaku.vim', #{ depends: ['denops'] })
  call dein#add('lambdalisue/kensaku-command.vim', #{ depends: ['kensaku'] })
  call dein#add('LumaKernel/ddc-source-file', #{ depends: ['ddc'] })
  call dein#add('nathanaelkane/vim-indent-guides') " unmaintained
  call dein#add('mattn/benchvimrc-vim')
  call dein#add('mattn/vim-lsp-settings', #{ depends: ['lsp'] })
  call dein#add('mbbill/undotree')
  call dein#add('prabirshrestha/vim-lsp')
  call dein#add('rbtnn/vim-ambiwidth')
  call dein#add('rhysd/conflict-marker.vim')
  call dein#add('rhysd/vim-operator-surround', #{ depends: ['operator-user'] })
  call dein#add('rhysd/vim-textobj-word-column', #{ depends: ['textobj-user'] })
  call dein#add('Shougo/neosnippet.vim', #{ depends: ['ddc'] })
  call dein#add('Shougo/neosnippet-snippets', #{ depends: ['neosnippet'] })
  call dein#add('Shougo/ddc.vim', #{ depends: ['denops'] })
  call dein#add('Shougo/ddc-around', #{ depends: ['ddc'] })
  call dein#add('Shougo/ddc-matcher_head', #{ depends: ['ddc'] })
  call dein#add('Shougo/ddc-sorter_rank', #{ depends: ['ddc'] })
  call dein#add('Shougo/ddc-ui-native', #{ depends: ['ddc'] })
  call dein#add('Shougo/ddc-ui-none', #{ depends: ['ddc'] })
  call dein#add('Shougo/neco-vim', #{ depends: ['ddc'] })
  call dein#add('shun/ddc-source-vim-lsp', #{ depends: ['ddc', 'lsp'] })
  call dein#add('thinca/vim-ft-help_fold', #{ name: 'help-fold' })
  call dein#add('thinca/vim-prettyprint')
  call dein#add('thomasfaingnaert/vim-lsp-snippets', #{ depends: ['lsp'] })
  call dein#add('thomasfaingnaert/vim-lsp-neosnippet', #{ depends: ['lsp', 'neosnippet'] })
  call dein#add('tpope/vim-fugitive')
  " call dein#add('tpope/vim-surround')
  call dein#add('tyru/caw.vim', #{ depends: ['operator-user', 'repeat'] })
  call dein#add('vim-denops/denops.vim', #{ if: executable('deno') })
  call dein#add('vim-jp/vimdoc-ja')
  call dein#add('yuki-yano/fuzzy-motion.vim', #{ depends: ['denops'] })

  if g:vimrc#is_nvim
    call dein#add('kevinhwang91/nvim-bqf')
  else
    call dein#add('bfrg/vim-qf-preview')
  endif

  if g:vimrc#is_windows
    call dein#add('mattn/vimtweak', #{ if: !g:vimrc#is_nvim && g:vimrc#is_gui })
  endif

  call dein#end()

  if g:vimrc#is_starting && dein#check_install()
    Autocmd VimEnter * ++once call dein#install()
  endif

  if !(g:vimrc#is_unix && $USER ==# 'root')
    call dein#save_state()
  endif
endif "}}}

if !g:vimrc#is_starting
  " post source フックの関数に変更があったときに反映できるように読み込み済みフラグを消す
  for s:p in values(dein#_plugins)
    if !has_key(s:p, 'called')
      continue
    endif

    for s:f in keys(s:p['called'])
      if string(s:f) =~# expand('<SID>') .. '.\+_sourced'
        call remove(s:p['called'], s:f)
      endif
    endfor
  endfor
endif

Autocmd VimEnter * ++once call dein#call_hook('post_source')
"}}}

" caw "{{{
if dein#tap('caw')
  let g:caw_dollarpos_sp_left = ' '
  let g:caw_hatpos_align = 1
  let g:caw_hatpos_skip_blank_line = 1
  " let g:caw_no_default_keymappings = 1
  let g:caw_operator_keymappings = 1

  AutocmdFT haskell let b:caw_wrap_oneline_comment = ['{-', '-}']
  AutocmdFT haskell let b:caw_wrap_multiline_comment = #{ left: '{-', right: '-}', top: '-', bottom: '-' }

  " nmap <silent><expr> <Space>cc '<C-c>V' .. (v:count <= 1 ? 'V' : v:count - 1 .. 'gj') .. '<Plug>(caw:hatpos:toggle)'
  nmap <Space>cc <Plug>(caw:hatpos:toggle)
  xmap <Space>cc <Plug>(caw:hatpos:toggle)
  noremap <silent> <Space>ct :normal 1 cc<CR>
  sunmap <Space>ct
  nmap <Space>cu <Plug>(caw:hatpos:uncomment)
  xmap <Space>cu <Plug>(caw:hatpos:uncomment)
  nmap <Space>cd <Plug>(caw:hatpos:toggle:operator)
  nmap <Space>ca <Plug>(caw:dollarpos:toggle)
  nmap <Space>cw <Plug>(caw:wrap:toggle:operator)
  xmap <Space>cw <Plug>(caw:wrap:toggle)
  nmap <Space>co <Plug>(caw:jump:comment-next)
  nmap <Space>cO <Plug>(caw:jump:comment-prev)
endif "}}}

" conflict-marker "{{{
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

" ddc "{{{
if dein#tap('ddc')
  function! s:ddc_sourced() abort "{{{
    if execute('augroup') !~# '\<denops_plugin_internal\>'
      " denopsがサポートされてない
      return
    endif

    call ddc#custom#set_global({})
    call ddc#custom#patch_global('sources', ['vim-lsp', 'around'])
    call ddc#custom#patch_global('ui', 'none')

    call ddc#custom#patch_filetype('vim', 'sources', ['necovim', 'around'])

    call ddc#custom#patch_global('sourceOptions', #{
        \ _: #{
        \   dup: 'keep',
        \   ignoreCase: v:true,
        \   matchers: ['matcher_head'],
        \   sorters: ['sorter_rank'],
        \   minAutoCompleteLength: 0,
        \   timeout: 5000
        \ },
        \ around: #{
        \   mark: 'A',
        \   minAutoCompleteLength: 2
        \ },
        \ vim-lsp: #{
        \   mark: 'L',
        \   sorters: ['sorter_rank', 'sorter_ascii']
        \ },
        \ file: #{
        \   sorters: ['sorter_ascii'],
        \   isVolatile: v:true,
        \   forceCompletionPattern: '/'
        \ },
        \ necovim: #{
        \   mark: 'vim'
        \ },
        \ neosnippet: #{ mark: 'snip' }
        \ })
    call ddc#custom#patch_global('sourceParams', #{
        \ around: #{
        \   maxSize: 500
        \ },
        \ file: #{
        \   displayCwd: 'c',
        \   displayBuf: 'b',
        \   filenameChars: '\-@.[:alnum:]_~'
        \ }
        \ })

    call ddc#enable()

    inoremap <silent><expr> <C-n> pumvisible() ? '<C-n>' : ddc#map#complete('native')
    inoremap <silent><expr> <C-p> pumvisible() ? '<C-p>' : ddc#map#complete('native')
    inoremap <silent><expr> <Plug>(vimrc_complete-file)
        \ ddc#map#manual_complete(#{
        \   sources: ['file'], ui: 'native'
        \ })
    inoremap <silent><expr> <C-l>
        \ ddc#map#manual_complete(#{
        \   sources: ['neosnippet'], ui: 'native'
        \ })
    " imap <C-Space> <C-n>

    Autocmd InsertLeave * if !IsCommandLineWindow() | pclose | endif

    " 進捗表示などで高速に画面が書き変わるとdenoがメモリを食いすぎるので端末ウィンドウ中のautocommandを無効化
    if !g:vimrc#is_nvim && has('terminal')
      Autocmd TerminalWinOpen * autocmd! ddc TextChangedT
    endif
  endfunction "}}}
  call dein#set_hook('ddc', 'hook_post_source', function('s:ddc_sourced'))
endif "}}}

" fuzzy-motion "{{{
if dein#tap('fuzzy-motion')
  if dein#is_available('kensaku')
    let g:fuzzy_motion_matchers = ['fzf', 'kensaku']
  endif

  nnoremap <silent> <Space>f :<C-u>FuzzyMotion<CR>
endif "}}}

" fzf "{{{
if dein#tap('fzf')
  " call dein#set_hook('fzf', 'hook_post_source', 'call fzf#install()')

  nnoremap <Space>b :<C-u>Buffers<CR>
  nnoremap <Space>e :<C-u>Files<CR>
endif "}}}

" ghcmod-vim "{{{
if dein#tap('ghcmod')
  Autocmd Filetype haskell nnoremap <buffer><silent> <Space>ft :<C-u>GhcModType!<CR>
  Autocmd Filetype haskell nnoremap <buffer><silent> <Space>fi :<C-u>GhcModInfo!<CR>
  Autocmd Filetype haskell nnoremap <buffer><silent> <Space><Tab> :<C-u>nohlsearch<Bar>GhcModTypeClear<CR>
  Autocmd Filetype haskell nnoremap <buffer><silent> <Space>fc :<C-u>GhcModCheckAsync<CR>
  Autocmd Filetype haskell nnoremap <buffer><silent> <Space>fl :<C-u>GhcModLintAsync<CR>
endif "}}}

" kensaku-command "{{{
if dein#tap('kensaku-command')
  nnoremap <Space>/ :<C-u>Kensaku<Space>
endif "}}}

" landscape "{{{
if dein#tap('landscape') && (g:vimrc#is_gui || &t_Co > 16)
  Autocmd VimEnter * ++once nested colorscheme landscape
endif "}}}

" lexima "{{{
if dein#tap('lexima')
  let g:lexima_map_escape = 'jk'
  " let g:lexima_accept_pum_with_enter = 1

  inoremap <expr><silent> <Plug>(vimrc_cr) lexima#expand('<lt>CR>', 'i')
  inoremap <expr><silent> <Plug>(vimrc_tab) lexima#expand('<lt>TAB>', 'i')

  if g:vimrc#is_nvim
    Autocmd TermOpen * let b:lexima_disabled = 1
  elseif has('terminal')
    Autocmd TerminalWinOpen * let b:lexima_disabled = 1
  endif

  function! s:lexima_sourced() abort "{{{
    let save_cr_mapping = maparg('<CR>', 'i', 0, 1)
    let save_tab_mapping = maparg('<Tab>', 'i', 0, 1)

    let quotes = [
        \   #{ start: "'", end: "'" }, #{ start: '"', end: '"' }
        \ ]
    let brackets = [
        \   #{ start: '(', end: ')' }, #{ start: '{', end: '}' },
        \   #{ start: '[', end: ']' }
        \ ]
    let comments = [
        \   #{ start: '/*', end: '*/', head: '*',
        \     filetype: ['c', 'cpp', 'cs', 'java', 'rust', 'scala'] },
        \   #{ start: '{-', end: '-}', with_bracket: 1, filetype: ['haskell'] },
        \   #{ start: '{-#', end: '#-}', filetype: ['haskell'] },
        \ ]

    " call filter(g:lexima#default_rules,
    "    \ { _, v -> !has_key(v, 'at') || v.at !=# '\\\%#' })
    call lexima#set_default_rules()

    " quote in lisp "{{{
    call lexima#add_rule(#{
        \   char: "'",
        \   filetype: ['lisp', 'scheme']
        \ })
    call lexima#add_rule(#{
        \   char: "'",
        \   input_after: "'",
        \   filetype: ['lisp', 'scheme'],
        \   syntax: ['Comment', 'Constant', 'String']
        \ })
    call lexima#add_rule(#{
        \   at: "\\%#'",
        \   char: "'",
        \   leave: 1,
        \   filetype: ['lisp', 'scheme'],
        \   syntax: ['Comment', 'Constant', 'String']
        \ })
    "}}}

    " comment "{{{
    for c in comments
      call lexima#add_rule(#{
          \   at: '\V' .. c.start[:-2] .. '\%#\$',
          \   char: c.start[-1:],
          \   input_after: c.end,
          \   filetype: c.filetype
          \ })
      call lexima#add_rule(#{
          \   at: '\V' .. c.start .. '\%#' .. c.end,
          \   char: '<Space>',
          \   input_after: '<Space>',
          \   filetype: c.filetype
          \ })
      call lexima#add_rule(#{
          \   at: '\V' .. c.start .. '\%#' .. c.end,
          \   char: '<BS>',
          \   input: repeat('<BS>', len(c.start)),
          \   delete: len(c.end),
          \   filetype: c.filetype
          \ })
      call lexima#add_rule(#{
          \   at: '\V' .. c.start .. ' \%# ' .. c.end,
          \   char: '<BS>',
          \   delete: 1,
          \   filetype: c.filetype
          \ })

      if has_key(c, 'head')
        call lexima#add_rule(#{
            \   at: '\V\^ ' .. c.head .. ' \%# \?' .. c.end,
            \   char: '<BS>',
            \   input: '<BS><BS>',
            \   filetype: c.filetype
            \ })
        call lexima#add_rule(#{
            \   at: '^ \%#',
            \   char: '<Space>',
            \   input: c.head .. '<Space>',
            \   filetype: c.filetype,
            \   syntax: ['Comment']
            \ })
      endif

      if get(c, 'with_bracket', 0)
        call lexima#add_rule(#{
            \   at: '\V' .. c.start[:-2] .. '\%#' .. c.end[1:] .. '\$',
            \   char: c.start[-1:],
            \   input_after: c.end[:0],
            \   filetype: c.filetype
            \ })
      endif
    endfor "}}}

    " bracket "{{{
    for pair in brackets
      call lexima#add_rule(#{
          \   at: '\V' .. pair.start .. '\%#' .. pair.end,
          \   char: '<CR>',
          \   input: '<CR>\ ',
          \   input_after: '<CR>\ ',
          \   filetype: ['vim']
          \ })
      " カッコの間に改行を入力時、継続行にして3行に展開
      call lexima#add_rule(#{
          \   at: pair.start .. '\%#$',
          \   except: '\C\v^(\s*)\S.*%#\n%(%(\s*|\1\s*\\.*)\n)*\1\s*\\\s*\' .. pair.end,
          \   char: '<CR>',
          \   input: '<CR>\ ',
          \   input_after: '<CR>\ ' .. pair.end,
          \   filetype: ['vim']
          \ })
      " ↑の展開後の途中の改行でも行継続
      call lexima#add_rule(#{
          \   at: '\C\v^(\s*)\S.*\' .. pair.start .. '%#\n%(%(\s*|\1\s*\\.*)\n)*\1\s*\\\s*\' .. pair.end,
          \   char: '<CR>',
          \   input: '<CR>\ ',
          \   filetype: ['vim']
          \ })
      call lexima#add_rule(#{
          \   at: '\%#\w',
          \   char: pair.start
          \ })
    endfor

    call lexima#add_rule(#{
        \   at: '\\%\?\%#',
        \   char: '(',
        \   input_after: '\)',
        \   filetype: ['vim']
        \ })
    "}}}

    call lexima#add_rule(#{
        \   at: '^\s*\\\(\s*\).\{-}\%#',
        \   char: '<CR>',
        \   input: '<CR>\\\1',
        \   with_submatch: 1,
        \   filetype: ['vim']
        \ })

    " 補完した文字の後ろに<Tab>で移動 "{{{
    for pair in brackets + quotes
      call lexima#add_rule(#{
          \   at: '\V\S\%# \?' .. pair.end,
          \   char: '<Tab>',
          \   leave: pair.end
          \ })
    endfor

    for c in comments
      call lexima#add_rule(#{
          \   at: '\V\S\%# \?' .. c.end,
          \   char: '<Tab>',
          \   leave: c.end,
          \   filetype: c.filetype,
          \   syntax: ['Comment']
          \ })
    endfor

    call lexima#add_rule(#{
        \   at: '\%#\\)',
        \   char: '<Tab>',
        \   leave: '\\)',
        \   filetype: ['vim']
        \ })
    "}}}

    " prehook for neosnippet "{{{
    " 補完メニューを開いている間に入力したときにleximaのマッピングの途中でCompleteDoneが発火してそう
    " 先にCompleteDoneを処理させると選択モードになる場合があって<C-]>が誤爆するので適当に入力して選択モードを抜ける
    for char in keys(lexima#insmode#get_rules())
      execute printf("inoremap <expr><silent> %s (pumvisible() ? '<C-y>a<BS>' : '') .. lexima#expand(%s, 'i')",
          \   char,
          \   string(lexima#string#to_mappable(char))
          \ )
    endfor "}}}

    " imap <expr><silent> <CR> pumvisible() ? '<Plug>(vimrc_complete-select)' : '<Plug>(vimrc_cr)'
    call mapset('i', 0, save_cr_mapping)
    call mapset('i', 0, save_tab_mapping)
  endfunction "}}}
  call dein#set_hook('lexima', 'hook_post_source', function('s:lexima_sourced'))
endif "}}}

" lightline "{{{
if dein#tap('lightline')
  " g:lightline "{{{
  let g:lightline = #{
      \ colorscheme: 'landscape',
      \ active: #{
      \   left: [['mode', 'paste'], ['bufnum', 'branch', 'directory', 'filename', 'readonly', 'modified'], ['showcmd']],
      \   right: [['trailing', 'lineinfo'], ['percent'], ['fileinfo', 'filetype']]
      \ },
      \ inactive: #{
      \   left: [['bufnum', 'directory', 'filename', 'readonly', 'modified']],
      \   right: [['lineinfo'], ['percent']]
      \ },
      \ tabline: #{
      \   left: [['buffers']],
      \   right: [['close']]
      \ },
      \ tab: #{
      \   active: ['tabnum', 'filename', 'modified'],
      \   inactive: ['bufnum', 'filename', 'modified'],
      \ },
      \ component: #{
      \   close: '%999X x ',
      \   lineinfo: "L %3l:%-2v",
      \   paste: '%{&paste?"P":""}',
      \   percent: '%4P',
      \   showcmd: exists('+showcmdloc') ? '%S' : ''
      \ },
      \ component_function: #{
      \   branch: 'FugitiveHead',
      \   directory: 'MyDirectory',
      \   filename: 'MyFilename',
      \   fileinfo: 'MyFileinfo',
      \   filetype: 'MyFiletype',
      \   mode: 'MyMode',
      \   modified: 'MyModified',
      \   readonly: 'MyReadonly'
      \ },
      \ component_expand: #{
      \   buffers: 'MyBuffers',
      \   trailing: 'MyTrailingSpaceWarning'
      \ },
      \ component_function_visible_condition: #{
      \   directory: '&filetype!=#"netrw"'
      \ },
      \ component_type: #{
      \   buffers: 'tabsel',
      \   trailing: 'error'
      \ },
      \ tab_component_function: #{
      \   bufnum: 'lightline#tab#tabnum',
      \   filename: 'MyFilenameB',
      \   modified: 'MyModified',
      \   tabnum: 'MyTabnum'
      \ },
      \ separator: #{ left: "", right: "" },
      \ }

  if g:vimrc#is_windows && g:vimrc#is_gui
    let g:lightline.subseparator = #{ left: "|", right: "|" }
  else
    let g:lightline.subseparator = #{ left: "│", right: "│" }
  endif
  "}}}

  " タブラインにバッファ一覧を表示 "{{{
  function! MyBuffers() abort "{{{
    " return:タブが5個以上の時ウィンドウの幅によって5個から17個表示する
    let [active_bn, alt_bn, last_bn, tn] = [bufnr(), winbufnr(winnr('#')), bufnr('$'), tabpagenr()]
    let [left, mid, right] = [[], [], []]
    let fold = '...'
    let max_side_tabs = min([max([&columns/40, 2]), 8]) " left, rightそれぞれから表示する数

    if IgnoreBuffer(active_bn)
      if !IgnoreBuffer(alt_bn)
        let active_bn = alt_bn
      else
        " タブページ内のウィンドウから探す
        for wn in range(1, winnr('$'))
          let bn = winbufnr(wn)

          if !IgnoreBuffer(bn)
            let active_bn = bn
            break
          endif
        endfor
      endif
    endif

    for bn in range(1, last_bn)
      if bn ==# active_bn
        call add(mid, printf('%%%dT%%{lightline#onetab(%d, 1)}', tn, bn))
        continue
      endif

      if IgnoreBuffer(bn)
        continue
      endif

      call add(bn < active_bn ? left : right, printf('%%%dT%%{lightline#onetab(%d, 0)}', tn, bn) .. (bn ==# last_bn ? '%T' : ''))
    endfor

    let left_len = len(left)
    let right_len = len(right)
    if left_len + right_len > max_side_tabs*2
      " let max_left_tabs = max([left_len])
      if left_len > max_side_tabs
        let left = [fold] + left[-max_side_tabs:]
      endif

      if right_len > max_side_tabs
        let right = right[:max_side_tabs - 1] + [fold]
      endif
    endif
    return [left, mid, right]
  endfunction "}}}

  " 更新されないので再度セットすることで更新
  Autocmd BufAdd,BufDelete * execute 'set tabline=' .. &tabline
  "}}}

  function! MyModified(bn = 0) "{{{
    let bn = a:bn
    if bn ==# 0
      let bn = bufnr()
    endif

    return IgnoreBuffer(bn) ? '' :
        \ getbufvar(bn, '&filetype') =~# 'netrw' ? '' :
        \ getbufvar(bn, '&modified') ? '+' :
        \ getbufvar(bn, '&modifiable') ? '' : '-'
  endfunction "}}}

  function! MyFilenameB(bufnr) "{{{
    let l:fname = fnamemodify(bufname(a:bufnr), ':t')
    let l:alt_fname = fnamemodify(bufname(0), ':t')
    return IsCommandLineWindow(a:bufnr) ? l:alt_fname :
        \ empty(l:fname) ? gettext('[No Name]') : l:fname
  endfunction "}}}

  function! MyTabnum(_ = v:none) "{{{
    return tabpagenr()
  endfunction "}}}

  let s:readonlychar = 'x'
  function! MyReadonly() "{{{
    return IgnoreBuffer() ? '' :
        \ &filetype =~# 'netrw' ? '' :
        \ &readonly ? s:readonlychar : ''
  endfunction "}}}

  function! MyFilename() "{{{
    if &filetype ==# 'netrw'
      let save_shellslash = &shellslash
      set shellslash

      let curdir = fnamemodify(b:netrw_curdir, ':~:.:s?[^/]\zs$?/?')

      let &shellslash = save_shellslash
      return curdir
    else
      let l:fname = expand('%:t')
      return IsCommandLineWindow() ? '' :
          \ &filetype ==# 'qf' ?
          \   win_gettype() ==# 'loclist' ? '[Location List]' : '[Quickfix List]' :
          \ &filetype =~# '\<lsp-hover\>' ? '[LSP Hover Information]' :
          \ empty(l:fname) ? gettext('[No Name]') : l:fname
    endif
  endfunction "}}}

  function! MyFiletype() "{{{
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : '?') : ''
  endfunction "}}}

  function! MyFileinfo() "{{{
    return IgnoreBuffer() || winwidth(0) <= 75 ? '' :
        \ (strlen(&fileencoding) ? &fileencoding : &encoding) ..
        \ '/' .. &fileformat
  endfunction "}}}

  function! MyMode() "{{{
    return IsCommandLineWindow() ? 'Cmd' :
        \ &filetype ==# 'help' && !&modifiable ? 'Help' :
        \ &filetype ==# 'qf' ? 'QuickFix' :
        \ (winwidth(0) > 60 ? lightline#mode() : '')
  endfunction "}}}

  function! MyTrailingSpaceWarning() "{{{
    if IgnoreBuffer()
      return ''
    endif

    let l:space_line = search('\S\zs\s\+$', 'nw')
    return l:space_line != 0 ? 'Space: L' .. l:space_line : ''
  endfunction

  Autocmd BufWritePost * call MyTrailingSpaceWarning() | call lightline#update()
  "}}}

  function! MyDirectory() "{{{
    if &filetype ==# 'netrw'
      return ''
    endif

    let save_shellslash = &shellslash
    set shellslash

    let dir = fnamemodify(expand('%:p:h'), ':~:.')
    let dir = substitute(dir, '[^/]\zs$', '/', '')

    let &shellslash = save_shellslash
    return pathshorten(dir)
  endfunction "}}}

  if !g:vimrc#is_starting
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
  endif
endif "}}}

" neosnippet "{{{
if dein#tap('neosnippet')
  let g:neosnippet#disable_select_mode_mappings = 0
  let g:neosnippet#enable_auto_clear_markers = 0
  " let g:neosnippet#enable_completed_snippet = 1
  " let g:neosnippet#enable_complete_done = 1

  smap <expr> <Tab> neosnippet#jumpable() ?
     \ '<Esc>a<Plug>(neosnippet_jump)' : '<Plug>(vimrc_tab)'
  imap <expr> <Tab>
      \ pumvisible() ?
      \   neosnippet#expandable_or_jumpable() ? '<Plug>(neosnippet_expand_or_jump)' : '' :
      \   neosnippet#jumpable() ? '<Plug>(neosnippet_jump)' : '<Plug>(vimrc_tab)'
  imap <expr> <CR> pumvisible() ?
      \ neosnippet#expandable() ? '<Plug>(neosnippet_expand)' :
      \ '<Plug>(vimrc_complete-select)' : '<Plug>(vimrc_cr)'
  snoremap <silent> <CR> <C-r>"a<BS><C-r>"
  snoremap <silent> <BS> <C-r>_a<BS>

  Autocmd InsertLeave * NeoSnippetClearMarkers
  " Autocmd User lsp_complete_done call neosnippet#complete_done()

  if has('conceal')
    set conceallevel=2 concealcursor=iv
  endif
endif "}}}

" neosnippet-snippets "{{{
if dein#tap('neosnippet-snippets')
  let g:neosnippet#snippets_directory = g:dein#plugin.path .. '/neosnippet'
endif "}}}

" nvim-bqf "{{{
if dein#tap('bqf')
  lua require('bqf').setup({
      \   func_map = {
      \     pscrollup = '<C-u>',
      \     pscrolldown = '<C-d>',
      \   },
      \   magic_window = false,
      \   preview = {
      \     border_chars = {'', '', '─', '─', '─', '─', '─', '─', '█'},
      \     show_title = true
      \   },
      \   wrap = true
      \ })

  " Highlight link BqfPreviewBorder Pmenu
  Highlight BqfPreviewFloat ctermbg=18 guibg=midnightblue
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
  AutocmdFT gitcommit normal! gg

  AutocmdFT fugitive setlocal nobuflisted nofoldenable
  AutocmdFT fugitive noremap <buffer><silent> q :<C-u>bwipeout<CR>
  AutocmdFT fugitive resize 15
  AutocmdFT fugitiveblame noremap <buffer><silent> q gq

  Autocmd BufEnter fugitive://* setlocal nomodifiable
  Autocmd User FugitiveStageBlob GitGutterLineHighlightsDisable
  Autocmd User FugitiveStageBlob call lsp#disable_diagnostics_for_buffer()
endif "}}}

" vim-gitgutter "{{{
if dein#tap('gitgutter')
  let g:gitgutter_highlight_lines = 1
  let g:gitgutter_set_sign_backgrounds = 1
  let g:gitgutter_sign_priority = 9

  if &encoding !=# 'utf-8'
    let g:gitgutter_sign_removed_first_line = '_'
    let g:gitgutter_sign_removed_above_and_below = '_'
  endif

  nnoremap <silent> <Space>gp :<C-u>GitGutterPreviewHunk<CR>
  nnoremap <silent> <Space>gs :<C-u>GitGutterStageHunk<CR>
  nnoremap <silent> <Space>gu :<C-u>GitGutterUndoHunk<CR>
  nnoremap <silent> <Space>gg :<C-u>GitGutterToggle<CR>

  if g:vimrc#is_windows
    " リポジトリが認識されないのでファイルのディレクトリから認識するように指定
    Autocmd BufWinEnter * let g:gitgutter_git_args = '-C ' .. expand('%:p:h')
  endif

  " Autocmd BufWritePost * GitGutter
  Autocmd BufEnter gitgutter://hunk-preview setlocal nobuflisted nofoldenable
  Autocmd VimEnter * ++once call gitgutter#highlight#define_highlights()

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
  let g:indent_guides_auto_colors = 1
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_exclude_filetypes = ['help', 'diff', 'fugitive']
  let g:indent_guides_indent_levels = 15
  let g:indent_guides_start_level = 1

  " Highlight link IndentGuidesOdd Comment
  " Highlight link IndentGuidesEven Folded

  function! s:indent_guides_sourced() "{{{
    " augroup indent_guides
    "   autocmd!
    "   autocmd BufEnter,WinEnter,FileType,VimEnter * let g:indent_guides_guide_size = &shiftwidth
    "   autocmd BufEnter,WinEnter,FileType,ColorScheme * call indent_guides#process_autocmds()
    " augroup end

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
  let g:lsp_diagnostics_virtual_text_enabled = 1
  let g:lsp_inlay_hints_enabled = 1
  let g:lsp_inlay_hints_mode = #{ normal: ['curline'], insert: [] }
  let g:lsp_hover_ui = 'preview'
  let g:lsp_preview_float = 0
  let g:lsp_preview_keep_focus = 1
  let g:lsp_untitled_buffer_enabled = 0
  let g:lsp_use_native_client = 0

  let g:lsp_diagnostics_signs_error = #{ text: '!' }
  let g:lsp_diagnostics_signs_warning = #{ text: '*' }
  let g:lsp_diagnostics_signs_hint = #{ text: '.' }
  let g:lsp_diagnostics_signs_information = #{ text: '.' }
  let g:lsp_document_code_action_signs_hint = #{ text: ':' }

  let g:lsp_diagnostics_signs_priority_map = #{
      \   LspError: 12,
      \   LspWarning: 11
      \ }

  nnoremap <Space>lh <Plug>(lsp-hover)
  nnoremap <Space>ls <Plug>(lsp-signature-help)
  nnoremap <Space>ld <Plug>(lsp-definition)zvzz
  nnoremap <Space>lt <Plug>(lsp-peek-type-definition)
  nnoremap <Space>li <Plug>(lsp-implementation)zvzz
  nnoremap <Space>ll <Plug>(lsp-document-diagnostics)
  nnoremap <Space>lr <Plug>(lsp-rename)
  nnoremap <Space>lc <Plug>(lsp-code-action)

  Highlight link LspHintText Question
  Highlight link LspInlayHintsType Comment
  Highlight link LspInlayHintsParameter Comment

  " 重いことがあるので一旦無効化
  " Autocmd User lsp_buffer_enabled
  "    \ if &filetype !=# 'vim' |
  "    \   setlocal foldmethod=expr |
  "    \ endif
  " Autocmd User lsp_buffer_enabled setlocal foldexpr=lsp#ui#vim#folding#foldexpr()
  " Autocmd User lsp_buffer_enabled setlocal foldtext=lsp#ui#vim#folding#foldtext()
  Autocmd User lsp_buffer_enabled setlocal signcolumn=yes
  AutocmdFT lsp-hover noremap <buffer><silent> q :<C-u>bwipeout<CR>

  " inlay表示でカーソル位置がずれるので
  " https://github.com/vim/vim/issues/5713
  Autocmd User lsp_buffer_enabled setlocal nobreakindent breakindentopt= showbreak=NONE

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

" vim-qf-preview "{{{
if dein#tap('qf-preview')
  let g:qfpreview = #{
      \   close: 'q',
      \   halfpageup: "\<C-u>",
      \   harlpagedown: "\<C-d>",
      \   next: 'n',
      \   number: 1,
      \   offset: 2,
      \   previous: 'p',
      \ }

  Highlight QfPreview ctermbg=18 guibg=midnightblue

  AutocmdFT qf nnoremap <buffer> p <Plug>(qf-preview-open)
  AutocmdFT qf execute "normal! \<Plug>(qf-preview-open)"
  " AutocmdFT qf Autocmd CursorMoved <buffer> execute "normal! \<Plug>(qf-preview-open)"
endif "}}}

