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
  call dein#add('derekwyatt/vim-scala', {'on_ft': 'scala'})
  call dein#add('itchyny/landscape.vim')
  call dein#add('Shougo/neocomplete.vim')
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('vim-jp/vimdoc-ja')

  call dein#end()

  if !(g:vimrc#is_unix && $USER ==# 'root')
    call dein#save_state()
  endif
endif

if g:vimrc#is_starting && dein#check_install()
  call dein#install()
endif

" landscape "{{{
if dein#tap('landscape')
  Autocmd VimEnter * nested colorscheme landscape
endif "}}}

" neocomplete "{{{
if dein#tap('neocomplete')
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_auto_close_preview = 1
  let g:neocomplete#enable_auto_delimiter = 1
  let g:neocomplete#enable_camel_case = 1
  let g:neocomplete#disable_auto_complete = 1
  let g:neocomplete#enable_fuzzy_completion = 1
  let g:neocomplete#enable_insert_char_pre = 1
  let g:neocomplete#enable_smart_case = 1
  let g:neosnippet#expand_word_boundary = 1
  let g:neocomplete#sources#syntax#min_keyword_length = 3

  inoremap <expr><silent> <C-n> pumvisible() ? '<C-n>' : neocomplete#start_manual_complete()
  inoremap <expr><silent> <C-u> pumvisible() ? '<C-p>' : neocomplete#start_manual_complete()
  autocmd Vimrc BufReadPost,BufWritePost ?* if &filetype !~# 'qf' | NeoCompleteBufferMakeCache % | endif

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

  let g:neocomplete#keyword_patterns._ = '\h\w*'
  let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
  let g:neocomplete#keyword_patterns.scheme = '[[:alpha:]+*/@$_=.!?-][[:alnum:]+*/@$_:=.!?-]*'
  let g:neocomplete#sources#omni#input_patterns.cs = '.*[^=\);]'
  let g:neocomplete#force_omni_input_patterns.cs = '.*[^=\);]'
  let g:neocomplete#sources#omni#input_patterns.java = '\k\.\k*'
  let g:neocomplete#force_omni_input_patterns.java = '\k\.\k*'
endif "}}}

" neosnippet "{{{
if dein#tap('neosnippet') && dein#tap('neosnippet-snippets')
  let g:neosnippet#snippets_directory = expand(g:dein#plugin['path'] . '/neosnippet')

  imap <expr><silent> <C-n> pumvisible() ? '<C-n>' : neosnippet#jumpable() ? '<Plug>(neosnippet_jump)' : neocomplete#start_manual_complete()
  smap <expr><silent> <C-n> neosnippet#jumpable() ? '<Plug>(neosnippet_jump)' : '<C-n>'
  imap <expr><silent> <CR> pumvisible() ? neosnippet#expandable() ? '<Plug>(neosnippet_expand)' : neocomplete#close_popup() : '<CR>'

  if has('conceal')
    set conceallevel=2 concealcursor=iv
  endif
endif "}}}
