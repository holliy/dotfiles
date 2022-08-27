" don't load when -eval(vim-tiny, vim-small)
if 0 | endif

" Initialize "{{{
if &compatible | set compatible! | endif

if !exists('g:vimrc#is_starting')
  let g:vimrc#is_windows = has('win32')
  let g:vimrc#is_cygwin = has('win32unix')
  let g:vimrc#is_unix = has('unix') && !g:vimrc#is_cygwin
  let g:vimrc#is_wsl = g:vimrc#is_unix && system('uname -r') =~? 'microsoft'
  let g:vimrc#is_gui = has('gui_running')
  let g:vimrc#is_starting = 1
  let g:vimrc#dotvim = expand('~/.vim')
endif

augroup Vimrc
  autocmd!
  autocmd VimEnter * let g:vimrc#is_starting = 0
augroup END "}}}

" use Vim with singleton "{{{
if has('clientserver') && !exists('g:loaded_editexisting')
  let g:loaded_editexisting = 1
  if exists(':packadd')
    packadd! editexisting
  else
    runtime macros/editexisting.vim
  endif
endif "}}}

" print startup time "{{{
if g:vimrc#is_starting && has('reltime')
  let s:startuptime = reltime()
  augroup vimrc-startuptime
    autocmd! VimEnter *
        \ echomsg 'startuptime: ' . reltimestr(reltime(s:startuptime)) |
        \ unlet s:startuptime | autocmd! vimrc-startuptime
  augroup END
endif "}}}

" encoding "{{{
" if &encoding !=# 'utf-8'
if &term ==# 'win32' " command prompt
  set encoding=cp932
else
  set encoding=utf-8
endif

if g:vimrc#is_windows
  set termencoding=cp932
  setglobal fileencoding=cp932
else
  set termencoding=utf-8
  setglobal fileencoding=utf-8
endif

" setglobal fileencoding=japan
" endif

scriptencoding utf-8 "}}}

" setup for Windows "{{{
if g:vimrc#is_windows
  let $SHELL = 'cmd.exe'
  let $HOME = $USERPROFILE
  let $PATH .= ';C:\Windows\Microsoft.NET\Framework64\v4.0.30319'
  let $PATH .= ';C:\Program Files\Cygwin\bin'
  let $PATH .= ';C:\Program Files\Cygwin\usr\local\bin'
  let $VIM = $HOME . '\.vim\vim-kaoriya-win64'
  let $VIMRUNTIME = $VIM . '\vimfiles'
  let g:vimrc#dotvim = $HOME . '\.vim'

  set helpfile=$VIMRUNTIME\doc\help.txt
  set shell=$SHELL shellcmdflag=/c noshellslash

  if &runtimepath !~# '\V' . substitute($VIMRUNTIME, '\v(/|\\)', '\[/\\\]', 'g')
    set runtimepath^=$VIMRUNTIME
  endif
  if &runtimepath !~# '\V' . substitute(g:vimrc#dotvim . '/after', '\v(/|\\)', '\[/\\\]', 'g')
    let &runtimepath .= ',' . substitute(g:vimrc#dotvim . '/after', '\v(/|\\)', '\', 'g')
  endif
elseif g:vimrc#is_cygwin
  command! Gui !~/.vim/vim-kaoriya-win64/gvim.exe &
  cnoreabbrev gui Gui
endif "}}}

" コマンド "{{{
command! -bar -nargs=0 Evimrc edit $MYVIMRC
command! -bar -nargs=0 Egvimrc edit $MYGVIMRC
command! -bar -nargs=0 Svimrc source $MYVIMRC
cnoreabbrev ev Evimrc
cnoreabbrev egv Egvimrc
cnoreabbrev sv Svimrc
cnoreabbrev newtab tabnew

if g:vimrc#is_gui
  command! -bar -nargs=0 Sgvimrc source $MYGVIMRC
  cnoreabbrev sgv Sgvimrc
endif

command! -complete=event -nargs=* Autocmd autocmd Vimrc <args>
command! -bar -complete=highlight -nargs=*
    \ Highlight Autocmd ColorScheme * highlight <args>

if g:vimrc#is_starting
  command -complete=filetype -nargs=*
      \ AutocmdFT Autocmd VimEnter * Autocmd FileType <args>
  command -bar -complete=option -nargs=*
      \ SetG setglobal <args> | set <args>

  Autocmd VimEnter * command! -complete=filetype -nargs=*
      \   AutocmdFT Autocmd FileType <args>
  Autocmd VimEnter * command! -bar -complete=option -nargs=*
      \   SetG setglobal <args>
else
  command! -complete=filetype -nargs=* AutocmdFT Autocmd FileType <args>
  command! -bar -complete=option -nargs=* SetG setglobal <args>
endif

" syntax "{{{
AutocmdFT vim
    \ syntax keyword vimAutoCmd Autocmd skipwhite nextgroup=vimAutoEventList
AutocmdFT vim
    \ syntax keyword vimAutoCmd AutocmdFT skipwhite nextgroup=vimAutoCmdSpace
AutocmdFT vim
    \ syntax keyword vimHighlight Highlight skipwhite nextgroup=vimHiBang,@vimHighlightCluster
AutocmdFT vim
    \ syntax keyword vimCommand contained SetG
AutocmdFT vim
    \ syntax region vimSet matchgroup=vimCommand start='\<\%(SetG\)\>' skip='\%(\\\\\)*\\.' end='$' matchgroup=vimNotation end='<[cC][rR]>' keepend oneline contains=vimSetEqual,vimOption,vimErrSetting,vimComment,vimSetString,vimSetMod
 "}}}

if !exists(':DiffOrig')
  command -bar -nargs=0 DiffOrig
      \ vertical new | setlocal buftype=nofile |
      \ read ++edit # | 0d_ | diffthis | wincmd p | diffthis
endif "}}}

" オプション "{{{
" options "{{{
set ambiwidth=single
SetG autoindent cindent copyindent smartindent
SetG expandtab shiftwidth=2 softtabstop=2 tabstop=4
set shiftround smarttab
SetG autoread
set backspace=indent,eol,start whichwrap+=h,l
set backup backupskip+=*~,*.o
let &backupdir = g:vimrc#dotvim . '/.backup'
set browsedir=buffer
SetG complete-=u | set completeopt=menuone,longest,preview pumheight=8
set cmdheight=2
set confirm
SetG cursorline
set diffopt+=context:2,vertical
set display=lastline,uhex
set fillchars=fold:\ ,stl:\ ,stlnc:\ ,vert:\|
SetG foldenable foldmethod=marker
SetG formatoptions+=Bjmr
set helpheight=10 helplang=ja
set hidden
set history=1000
set hlsearch ignorecase incsearch smartcase | nohlsearch
SetG iminsert=0 imsearch=-1
set laststatus=2
setglobal statusline =\ %{mode(1)}%{&paste?'\ \ \|\ p':''}
setglobal statusline+=\ \|\ %n
setglobal statusline+=\ \|\ %{pathshorten(fnamemodify(expand('%:p'),':.:h').'/')}
setglobal statusline+=\ \|\ %{&filetype!=#'netrw'?expand('%:t'):''}
setglobal statusline+=\ %R%M%{&modified\|\|&readonly?'\ ':''}%<%#StatusLineNC#%=%*
setglobal statusline+=\ %{(empty(&fileencoding)?&encoding:&fileencoding).'/'.&fileformat}
setglobal statusline+=\ \|\ %{empty(&filetype)?'?':&filetype}
setglobal statusline+=\ \|\ %3P
setglobal statusline+=\ \|\ %3l:%-2c\ %#StatusLineNC#
set lazyredraw
SetG list | set listchars=tab:>\ ,nbsp:%
SetG matchpairs+=<:> | set showmatch
SetG modeline
set mouse=a
SetG nrformats+=alpha
SetG number relativenumber
set pastetoggle=<F2>
set scrolloff=2
set sessionoptions+=localoptions,resize,slash,unix sessionoptions-=blank
set shortmess+=mrx shortmess-=i shortmess-=t shortmess-=T
set showcmd
set showtabline=2
set splitbelow splitright
set nostartofline
set switchbuf=useopen,usetab,split
SetG synmaxcol=800
set timeout ttimeout timeoutlen=700 ttimeoutlen=50
set title
set ttymouse=xterm2
set undoreload=20000 | SetG undofile undolevels=800
let &undodir = g:vimrc#dotvim . '/.undo'
set updatecount=0 | SetG noswapfile
set updatetime=2000
set viewoptions+=localoptions,slash,unix
let &viewdir = g:vimrc#dotvim . '/.view'
set viminfo-=<50 viminfo+=<100
set virtualedit+=block
set wildcharm=<Tab> wildignore+=*~,*.o wildignorecase wildmenu wildmode=longest:full
set winaltkeys=yes
" set <xUp>=OA <xDown>=OB <xRight>=OC <xLeft>=OD

if exists('+ballooneval')
  set ballooneval
endif
if exists('+balloonevalterm')
  set balloonevalterm
endif
if exists('+breakindent')
  SetG breakindent breakindentopt=shift:2
endif
if exists('+fixendofline')
  SetG nofixendofline
endif
if exists('+packpath')
  let &packpath .= ',' . g:vimrc#dotvim . '/pack'
endif
if exists('+termguicolors') && !g:vimrc#is_windows
  " set termguicolors
endif

if g:vimrc#is_wsl
  set clipboard=exclude:.*
else
  set clipboard=exclude:console\|linux
endif
if has('unnamedplus')
  set clipboard^=unnamedplus
else
  set clipboard^=unnamed
endif
if has('patch-7.4.314')
  set shortmess+=c
endif
if has('patch-8.2.4325')
  set wildoptions=pum
endif "}}}

" $VIMRUNTIME 以下の不要なプラグインを読み込まない "{{{
let g:loaded_2html_plugin = 1
let g:loaded_gzip = 1
let g:loaded_tar = 1

let g:loaded_tarPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1
let g:loaded_rrhelper = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1

let g:newtw_clipboard = 0
let g:netrw_keepj = ""
let g:netrw_liststyle = 3
let g:netrw_sizestyle = "H"
let g:netrw_use_errorwindow = 2
let g:netrw_winsize=30
let g:vim_indent_cont = shiftwidth()*2 "}}}
"}}}

" キーマップ "{{{
map <Nul> <C-Space>
map! <Nul> <C-Space>

" minttyだけ?
" map <C-j> <S-CR>
" map! <C-j> <S-CR>

noremap - ^
noremap ^ $
sunmap -
sunmap ^

" nnoremap gi '[v']
nnoremap go gi

vnoremap za zo

noremap iq i'
noremap iQ i"
nunmap iq
nunmap iQ
sunmap iq
sunmap iQ

noremap j gj
noremap k gk
noremap gj j
noremap gk k
sunmap j
sunmap k
sunmap gj
sunmap gk

noremap c "_c
nnoremap C "_C
noremap D "_d
nnoremap DD "_dd
noremap x "_x
noremap X x
xnoremap p "_dP
sunmap c
ounmap c
sunmap D
ounmap D
sunmap x
ounmap x
sunmap X
ounmap X

noremap n nzzzv
noremap N Nzzzv
" nnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>
" vnoremap <silent> * :let stay_star_view = winsaveview()<cr>*:call winrestview(stay_star_view)<cr>
noremap * g*<C-o>
noremap # g#<C-o>
noremap g* *<C-o>
noremap g# #<C-o>
sunmap n
sunmap N
sunmap *
sunmap #
sunmap g*
sunmap g#

noremap <C-e> <C-e>j
noremap <C-y> <C-y>k
noremap <C-u> <C-u>zz
noremap <C-d> <C-d>zz
noremap <C-f> <C-f>zz
noremap <C-b> <C-b>zz
" noremap <ScrollWheelUp> 3<C-y>
" noremap <ScrollWheelDown> 3<C-e>

" inoremap <C-u> <C-p>
" cnoremap <C-u> <C-p>
cnoremap <C-g> <C-u>

nnoremap Y y$
noremap! jk <Esc>
nnoremap <Tab> <C-i>
nnoremap <S-Tab> <C-o>
" cnoremap <Esc><Esc> <C-c>

" noremap! <C-p> <Up>
" noremap! <C-l> <Down>
" inoremap <C-k> <Left>
" cnoremap <C-k> <Space><BS><Left>
" inoremap <C-@> <Right>
" cnoremap <C-@> <Space><BS><Right>

inoremap <C-y> <C-o>^
cnoremap <C-y> <Home>
noremap! <C-b> <End>
cnoremap <C-e> <C-y>

inoremap <BS> <C-g>u<BS>
inoremap <CR> <C-]><C-g>u<CR>

nnoremap gs :%s/
xnoremap gs :s/

noremap <F1> <Esc>:help<Space>
nnoremap <F1> :<C-u>help<Space>
inoremap <F1> <Esc>:help<Space>

nnoremap <CR> o<Esc>
nnoremap <expr> <S-CR> 'O<Esc>j' . v:count . 'k'
nnoremap <C-Space> i<CR><Esc>

inoremap <silent> <C-z> <C-o>:update<CR>
nnoremap <silent> <Space><Tab> :<C-u>nohlsearch<CR>

nnoremap <silent> <Space>tt :<C-u>tabnew<CR>
nnoremap <expr> gt <SID>delcount(v:count) .
    \ ((tabpagenr() + max([v:count - 1, 0])) % tabpagenr('$') + 1) . 'gt'

nnoremap <silent> <C-n> :<C-u><C-r>=v:count<CR>bnext<CR>
nnoremap <silent> <C-p> :<C-u><C-r>=v:count<CR>bprevious<CR>
nnoremap <silent> <Space>bn :<C-u><C-r>=v:count<CR>bnext<CR>
nnoremap <silent> <Space>bN :<C-u><C-r>=v:count<CR>bNext<CR>
nnoremap <silent> <Space>bp :<C-u><C-r>=v:count<CR>bprevious<CR>

nnoremap <silent> <Space>cn :<C-u><C-r>=v:count<CR>cnext<CR>
nnoremap <silent> <Space>cN :<C-u><C-r>=v:count<CR>cNext<CR>
nnoremap <silent> <Space>cp :<C-u><C-r>=v:count<CR>cprevious<CR>

nnoremap <silent> <Space>ln :<C-u><C-r>=v:count<CR>lnext<CR>
nnoremap <silent> <Space>lN :<C-u><C-r>=v:count<CR>lNext<CR>
nnoremap <silent> <Space>lp :<C-u><C-r>=v:count<CR>lprevious<CR>

nnoremap <silent> <Space>h
    \ :<C-u>echo map(synstack(line('.'),col('.')),'synIDattr(v:val,"name")')<CR>

nnoremap <silent> <Space>sf
    \ :<C-u>setlocal foldmethod=<C-r>=&foldmethod==#'marker'?'indent':'marker'<CR> foldmethod?<CR>zv

inoremap <Plug>(vimrc_cr) <CR>
inoremap <Plug>(vimrc_complete-select) <C-y>
imap <expr><silent> <CR> pumvisible() ? '<Plug>(vimrc_complete-select)' : '<Plug>(vimrc_cr)'
cnoremap <expr> <Tab> wildmenumode() ? '<C-n>' : '<Tab>'
"}}}

" エンコード "{{{
set fileformats=unix,dos,mac
set fileencodings=utf-8

if g:vimrc#is_cygwin
  set fileencodings+=cp932,euc-jp
elseif g:vimrc#is_windows
  set fileencodings+=cp932
else
  set fileencodings+=euc-jp,sjis
endif

" ファイルの漢字コード自動判別のために必要。(要iconv)
if has('iconv')
  set fileencodings-=euc-jp

  " iconvがeucJP-msに対応しているかをチェック
  if iconv('\x87\x64\x87\x6a', 'cp932', 'eucjp-ms') ==# '\xad\xc5\xad\xcb'
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
    " iconvがJISX0213に対応しているかをチェック
  elseif iconv('\x87\x64\x87\x6a', 'cp932', 'euc-jisx0213') ==# '\xad\xc5\xad\xcb'
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  else
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'
  endif

  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    set fileencodings-=cp932 fileencodings-=sjis
    let &fileencodings = s:enc_jis . ',' . s:enc_euc .
        \ (g:vimrc#is_windows ? ',cp932,' : ',sjis,') . &fileencodings
  else
    set fileencodings-=utf-8 fileencodings-=ucs-2le fileencodings-=ucs-2
    let &fileencodings .= ',' . s:enc_jis . ',utf-8,ucs-2le,ucs-2'

    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings-=euc-jp fileencodings-=euc-jisx0213 fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &g:fileencoding = s:enc_euc
    else
      let &fileencodings .= ',' . s:enc_euc
    endif
  endif

  unlet s:enc_euc
  unlet s:enc_jis
endif

" encodingをfileencodingsの最後に移動
execute 'set fileencodings-=' . &encoding
execute 'set fileencodings+=' . &encoding

" 日本語を含まない場合は fileencoding に encoding を使うようにする
Autocmd FileReadPost *
    \ if &fileencoding=~#'iso-2022-jp' && search("[^\x01-\x7e]", 'n')==0 |
    \   let &fileencoding = &encoding | endif "}}}

" terminal "{{{
" https://ttssh2.osdn.jp/manual/4/ja/usage/tips/vim.html
if !g:vimrc#is_gui && &term !~# 'cygwin\|win32\|linux' " &term =~# 'xterm' &&
  " set t_Co=256

  " modifyOtherKeys "{{{
  " let &t_TI = "\<Esc>[>4;1m"
  " let &t_TE = "\<Esc>[>4;m"
  map <special> <Esc>[27;2;13~ <S-CR>
  map! <special> <Esc>[27;2;13~ <S-CR>
  map <special> <Esc>[27;2;9~ <S-Tab>
  imap <special> <Esc>[27;2;9~ <S-Tab>
  cnoremap <special><expr> <Esc>[27;2;9~ wildmenumode() ? '<C-p>' : '<Tab>'
  map <special> <Esc>[27;2;8~ <S-BS>
  map! <special> <Esc>[27;2;8~ <S-BS>
  map <special> <Esc>[27;5;8~ <C-BS>
  map! <special> <Esc>[27;5;8~ <C-BS>
  "}}}

  " Shift-Insertのペースト時に自動でpastetoggle "{{{
  " https://qiita.com/ringo/items/bb9cf61a3ccfe6183c7b
  " https://qiita.com/kefir_/items/415a30930a80b9b42adb
  if !has("patch-8.0.0238")
    if g:vimrc#is_starting
      if has("patch-8.0.0210")
          set t_BE=
      endif

      let &t_ti .= "\e[?2004h"
      " let &t_te .= "\e[?2004l"
      let &t_te = "\e[?2004l" . &t_te
      let &pastetoggle = "\e[201~"
    endif

    function! s:xTermPasteBegin(ret) abort
      set paste
      return a:ret
    endfunction

    " noremap <special> <expr> <Esc>[200~ XTermPasteBegin('0i')
    noremap <special> <expr> <Esc>[200~ <SID>xTermPasteBegin('i')
    inoremap <special> <expr> <Esc>[200~ <SID>xTermPasteBegin('')
    cnoremap <special> <Esc>[200~ <nop>
    cnoremap <special> <Esc>[201~ <nop>

    map <F2> <Esc>[201~
    imap <F2> <Esc>[201~
  endif "}}}

  " OSC52でのコピー "{{{
  function s:paste64(text) abort
    let l:s = join(systemlist('base64', a:text), '')
    call writefile([printf("\e]52;;%s\e\\", l:s)], '/dev/tty', 'a')
  endfunction

  nnoremap <silent> <Space>y :<C-u>call <SID>paste64(@")<CR>
  "}}}

  " 挿入モードを出るときにIME を自動で切る "{{{
  " https://qiita.com/U25CE/items/0b40662a22162907efae#%E7%AB%AF%E6%9C%AB%E3%82%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3
  if g:vimrc#is_starting
    let &t_SI .= "\e[<r"
    let &t_EI .= "\e[<s\e[<0t"
    let &t_te .= "\e[<0\e[<s"
  endif "}}}

  " 挿入モードでのESCキーの待ちをなくす "{{{
  inoremap <special> <Esc>O[ <Esc>
  inoremap <special> <C-V><Esc>O[ <C-V><Esc>

  if g:vimrc#is_starting
    let &t_SI .= "\e[?7727h"
    let &t_EI .= "\e[?7727l"
  endif "}}}

  " 縦分割時のスクロールの高速化 "{{{
  " https://qiita.com/kefir_/items/c725731d33de4d8fb096
  if 0
    set nottyfast
    function! s:enableVsplitMode() abort "{{{
      " enable origin mode and left/right margins
      let &t_CS = 'y'
      let &t_CV = "\e[%i%p1%d;%p2%ds"
      let &t_te = "\e[?6;69l" . &t_te
      " let &t_te = "\e[?6;69l\e[999H" . &t_te
      " let &t_te = "\e7\e[?6;69l\e8" . &t_te
      " let &t_te .= "\e[?6;69l"
      " let &t_te .= "\e[?6;69l\e[999H"
      " let &t_te .= "\e7\e[?6;69l\e8"
      let &t_ti .= "\e[?6;69h"
      "   call writefile(["\e[?6h\e[?69h"], '/dev/tty', 'a')
      call writefile(["\e[?6;69h"], '/dev/tty', 'a')
    endfunction "}}}

    " old vim does not ignore CPR
    " map <special> <Esc>[3;9R <Nop>

    " new vim can't handle CPR with direct mapping
    " map <expr> [3;3R <SID>enableVsplitMode()
    " set t_F9=[3;3R
    map <Esc>[3;3R <t_F9>
    map <expr> <t_F9> <SID>enableVsplitMode()

    if g:vimrc#is_starting
      let &t_RV .= "\e[?6;69h\e[1;3s\e[3;9H\e[6n\e[0;0s\e[?6;69l"
    endif
  endif "}}}
endif "}}}

" functions "{{{
function! s:mkdir(path) abort "{{{
  " return: ディレクトリを読み込めない(作成できない)とき0, それ以外は1
  if a:path =~# '^.\{-}://' " Non local file, ignore
    return 0
  endif

  for p in split(a:path, ',')
    if !isdirectory(p)
      if !filereadable(p) && !filewritable(p)
        call mkdir(p, 'p')
        return 1
      endif
    else
      return 1
    endif
  endfor

  echoerr a:path . ' should be directory and readable.'
  return 0
endfunction "}}}

" バックアップフォルダ等を作成 "{{{
for s:d in filter(
    \ [&backup || &writebackup || &patchmode !=# '' ? 'backupdir' : '',
    \   &swapfile ? 'directory' : '', &undofile ? 'undodir' : '',
    \   exists('+loadplugins') && &loadplugins ? 'packpath' : '',
    \   'viewdir'], 'v:val !=# ""')
  if s:d != '' && !s:mkdir(eval('&' . s:d))
    execute 'set' s:d . '&'
  endif
endfor
unlet s:d "}}}

" quickfixの文字化け回避 "{{{
function! QfMakeConv(fenc, enc) abort
  let qflist = getqflist()
  for i in qflist
    let i.text = iconv(i.text, a:fenc, a:enc)
  endfor
  call setqflist(qflist, 'r')
endfunction "}}}

" 外部スクリプトのローカル関数を呼び出す "{{{
" https://thinca.hatenablog.com/entry/20111228/1325077104
function! CallInternalFunc(f, ...) abort
  let [file, func] = a:f =~# ':' ?  split(a:f, ':') : [expand('%:p'), a:f]
  let fname = matchstr(func, '^\w*')
  let cfunc = ''

  " Get sourced scripts.
  redir => slist
  silent scriptnames
  redir END

  let filepat = '\V' . substitute(file, '\\', '/', 'g') . '\v%(\.vim)?$'
  for s in split(slist, "\n")
    let p = matchlist(s, '^\s*\(\d\+\):\s*\(.*\)$')
    if empty(p)
      continue
    endif
    let [nr, sfile] = p[1 : 2]
    let sfile = fnamemodify(sfile, ':p:gs?\\?/?')
    if sfile =~# filepat && exists(printf("*\<SNR>%d_%s", nr, fname))
      let cfunc = printf("\<SNR>%d_%s", nr, func)
      break
    endif
  endfor

  if !exists('nr')
    echoerr 'Not sourced: ' . file
    return
  elseif !exists('cfunc')
    let file = fnamemodify(file, ':p')
    echoerr printf(
        \ 'File found, but function is not defined: %s: %s()', file, fname)
    return
  endif

  return 0 <= match(func, '^\w*\s*(.*)\s*$')
      \ ? eval(cfunc) : call(cfunc, a:000)
endfunction "}}}

" マップ時のv:countを<Esc>を使わずに削除 "{{{
" ex. noremap <expr> j <SID>delcount(v:count) . 'gj'
function! s:delcount(count) abort
  return !a:count ? '' : repeat("\<Del>", strlen(string(a:count)))
endfunction "}}}

" 自動で生成されるバッファか判定 "{{{
let g:vimrc#generate_filetypes = ['help', 'netrw', 'qf']

" a:1 - バッファ番号 (0 だと現在のバッファの番号)
function! s:ignore(...) abort
  if a:0 && a:1 !=# 0
    let bh = getbufvar(a:1, '&bufhidden')
    let bl = getbufvar(a:1, '&buflisted')
    let bname = fnamemodify(bufname(a:1), ':t')
    let bt = getbufvar(a:1, '&buftype')
    let fts = getbufvar(a:1, '&filetype')
  else
    let bh = &bufhidden
    let bl = &buflisted
    let bname = expand('%:t')
    let bt = &buftype
    let fts = &filetype
  endif

  if !(bl && empty(bt) && (bh ==# '' ? &hidden : bh ==# 'hide'))
    return 1
  endif

  for ft in split(fts, '\.')
    if index(g:vimrc#generate_filetypes, ft) !=# -1
      return 1
    endif
  endfor

  return bname =~# '^\[Command\ Line\]$'
endfunction "}}}

function! Highlight() abort "{{{
  if s:ignore()
    if get(w:, 'spaceid', 0)
      call matchdelete(w:spaceid)
      let w:spaceid = 0
    endif
  else
    highlight TrailingWhiteSpace ctermbg=darkred guibg=#ff0000
    if !get(w:, 'spaceid', 0)
      " 行末の空白をハイライト
      let w:spaceid = matchadd('TrailingWhiteSpace', '\s\+$', 11)
    endif
  endif
endfunction
Autocmd BufWinEnter,ColorScheme,FileType * call Highlight()
"}}}

" 指定範囲の空行を削除 "{{{
function! s:delemptyline(start, last) abort
  " return: 削除した行の数
  let save_cursor = getcurpos()

  let n = 0 | let end = a:last
  call cursor(a:start, 1)
  while 1
    let l = search('^$', 'c', end)
    if l <= 0 | break | endif

    execute l . 'delete' '_'
    let n += 1 | let end -= 1
  endwhile

  call setpos('.', save_cursor)
  return n
endfunction "}}}

" バックスラッシュを消して結合(J) "{{{
function! s:J() range
  set operatorfunc=Concat
  return 'g@' . max([a:lastline - a:firstline - 1, 1]) . 'j'
endfunction

" TODO:
" let s:line_separator = {'vim' : '|'}

function! Concat(type) abort
  let js_save = &joinspaces
  let sel_save = &selection
  set selection=inclusive

  let startline = line("'[")
  let endline = line("']")

  let synname = synIDattr(synID(startline, col('$') - 1, 1), "name")
  if startline ==# endline
    let endline += 1
  endif

  let endline -= s:delemptyline(startline, endline)
  if startline < endline
    let lines = getline(startline + 1, endline)

    if &filetype !~# '\v(\.|^)text(\.|$)'
      if synname !~# '\v(Comment|String)$'
        set nojoinspaces
      else
        " call map(lines, "substitute(v:val, '^\\s*' . substitute(&commentstring, '^\\s*\\|%s', '', 'g'), '', '')")
      endif
    endif

    if &filetype =~# '\v(\.|^)vim(\.|$)'
      call map(lines, "substitute(v:val, '^\\s*\\\\', '', '')")
      let lines = [getline(startline)] + lines
    else
      let lastline = lines[-1]
      let lines = [getline(startline)] + lines[:-2]
      call map(lines, "substitute(v:val, '\\\\$', '', '')")
      let lines += [lastline]
    endif

    call setline(startline, lines)
    execute 'join' endline - startline + 1
  endif

  let &joinspaces = js_save
  let &selection = sel_save
endfunction

noremap <expr> J <SID>J()
noremap <Space>J J
sunmap J
ounmap J
sunmap <Space>J
ounmap <Space>J

nnoremap <silent> <Space><Space>J :<C-u>set operatorfunc=Concat<CR>g@
nnoremap <silent> <Space><Space>JJ :<C-u>set operatorfunc=Concat<CR>g@g@
"}}}

" ウィンドウの左側の余白の幅 "{{{
function! s:winleftpad() abort
  if &number
    let lnrwidth = max([strlen(string(line('$'))) + 1, &numberwidth])
  elseif &relativenumber
    let lnrwidth = max([strlen(string(winheight('.'))) + 1, &numberwidth])
  else
    let lnrwidth = 0
  endif

  " TODO: signの幅を計算
  return lnrwidth + &foldcolumn
endfunction "}}}

set foldtext=Foldtext() "{{{
function! Foldtext() abort
  let save_cursor = getcurpos()
  call cursor(v:foldstart, 1)

  let indentstart = 0
  let pattern = '^\S'
  while indentstart == 0
    let indentstart = search(pattern, 'bcnW')
    let pattern = '^\s' . strpart(pattern, 1)
  endwhile
  let shift = repeat(' ', v:foldlevel -
      \ (indentstart == v:foldstart ? 1 : foldlevel(indentstart) + 1))

  call setpos('.', save_cursor)

  let linelen = winwidth('.') - s:winleftpad()
  let marker = strpart(&foldmarker, 0, stridx(&foldmarker, ',')) . '\d\*'
  let range = foldclosedend(v:foldstart) - foldclosed(v:foldstart) + 1

  let comment = split(substitute(&commentstring, '\s', '', 'g'), '%s')
  let commentstart = len(comment) < 1 ? '' : comment[0]
  let commentend = len(comment) < 2 ? '' : comment[1]

  let left = getline(v:foldstart)
  let pattern = printf('\V\(%s\)\?\s\*%s\s\*\(%s\|\.\*\$\)',
      \ commentstart, marker, commentend)
  let left = substitute(left, pattern, '', '')
  let pattern = printf('\V\^\s\*\zs\(%s\)\?\s\*', commentstart)
  let left = substitute(left, pattern, '', '')
  let left = substitute(left, '\t', repeat(' ', &tabstop), 'g')
  let left = shift . left
  let leftlen = strdisplaywidth(left)

  let right = range . ' [' . v:foldlevel . ']'
  let rightlen = len(right)

  let tmp = strpart(left, 0, linelen - rightlen)
  let tmplen = len(tmp)

  if leftlen > tmplen
    let left = strpart(tmp, 0, tmplen - 4) . '... '
    let leftlen = tmplen
  endif

  let fill = repeat(' ', linelen - (leftlen + rightlen))

  return left . fill . right
endfunction "}}}
"}}}

" ColorScheme等 "{{{
set background=dark
Highlight ColorColumn ctermbg=233 guibg=#353535
Highlight CursorLineNr ctermbg=NONE guibg=NONE
" Highlight DiffChange ctermbg=25 guibg=#004060
" Highlight DiffText ctermbg=18 guibg=#000080
Highlight Folded ctermfg=247 ctermbg=234 guibg=#303030
" Highlight LineNr ctermfg=darkgreen guifg=#00c000
" Highlight Pmenu ctermfg=black ctermbg=lightgray guifg=black guibg=lightgray
" Highlight PmenuSbar ctermfg=black guifg=black
" Highlight PmenuSel ctermfg=yellow ctermbg=darkblue guifg=yellow guibg=blue
" Highlight PmenuThumb ctermfg=darkblue guifg=blue
Highlight SignColumn ctermbg=NONE guibg=NONE

Highlight StatusLineNC ctermfg=235
Highlight TabLineFill ctermfg=236

" 画面の80桁目にcolorcolumnを表示 (signは考慮しない)
Autocmd BufEnter,BufWinEnter,ColorScheme,FileType *
    \ let &colorcolumn = 81 - s:winleftpad()
"}}}

" autocmd "{{{
" カレントウィンドウのみカーソル行を強調 "{{{
Autocmd WinLeave * setlocal nocursorline
Autocmd WinEnter,BufWinEnter * setlocal cursorline
"}}}

" カーソル位置や折りたたみの状態を保存 "{{{
Autocmd BufReadPost ?*
    \ if line("'\"") > 0 && line ("'\"") <= line('$') |
    \   execute "normal! g'\"zzzv" | endif
" }}}

" その他 "{{{
" Autocmd QuickfixCmdPost make call QfMakeConv(&fileencoding, &encoding)
" if g:vimrc#is_windows
"   Autocmd QuickfixCmdPost make call QfMakeConv('utf-8', 'cp932')
" else
"   Autocmd QuickfixCmdPost make call QfMakeConv('cp932', 'utf-8')
" endif

AutocmdFT * setlocal formatoptions-=o
" AutocmdFT * if &commentstring !~# '^ ' |
"    \ let &commentstring = ' ' . &commentstring | endif
AutocmdFT c setlocal omnifunc=ccomplete#Complete
AutocmdFT * if &omnifunc ==# '' |
    \ setlocal omnifunc=syntaxcomplete#Complete | endif
AutocmdFT help,netrw,qf,quickrun
    \ noremap <buffer><silent> q :<C-u>bwipeout<CR>
AutocmdFT qf
    \ nnoremap <buffer><silent> <CR> :<C-u>execute 'cc' line('.')<CR>
Autocmd CmdwinEnter * nnoremap <buffer><silent> q :<C-u>q<CR>
AutocmdFT vim,help setlocal keywordprg=:help
if g:vimrc#is_windows
  AutocmdFT cs edit ++fileformat=dos
endif
AutocmdFT text setlocal textwidth=78
execute 'Autocmd BufReadPre' &backupskip 'setlocal noundofile'
" Autocmd CmdlineChanged : if !wildmenumode() && len(getcompletion(getcmdline(), 'cmdline')) > 1 | call feedkeys("\<Tab>") | endif

augroup Vimrc_bin
  autocmd!
  autocmd BufReadPre *.bin,*.exe,*.dll setlocal binary
  autocmd BufReadPost *
      \ if &binary |
      \   execute 'silent %!xxd -g 1' |
      \   setlocal filetype=xxd noendofline |
      \   execute 'Autocmd BufWritePre <buffer=abuf> %!xxd -r' |
      \   execute 'Autocmd BufWritePost <buffer=abuf> silent %!xxd -g 1' |
      \   execute 'Autocmd BufWritePost <buffer=abuf> setlocal nomodified' |
      \ endif
augroup END
"}}}}}}

" plugin "{{{
if has('patch-7.4.1674')
  packadd! matchit
else
  runtime macros/matchit.vim
endif

execute 'source' g:vimrc#dotvim . '/dein.vim'
"}}}

Autocmd VimEnter * doautocmd Vimrc FileType

if get(g:, 'colors_name', '') ==# ''
  colorscheme desert
endif

filetype plugin indent on
syntax on

if !g:vimrc#is_starting
  doautocmd Vimrc VimEnter
endif
