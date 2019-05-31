" VIM-PLU:pg
" --------

set nocompatible
filetype off

if has("autocmd")
  au BufReadPost *.rkt,*.rktl set filetype=racket
  au filetype racket set lisp
  au filetype racket set autoindent
endif


" Install vim-plug if it isn't installed and call plug#begin() out of box
function s:download_vim_plug()
  if !empty(&rtp)
    let vimfiles = split(&rtp, ',')[0]
  else
    echohl ErrorMsg
    echomsg 'Unable to determine runtime path for Vim.'
    echohl NONE
  endif
  if empty(glob(vimfiles . '/autoload/plug.vim'))
    let plug_url =
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    if executable('curl')
      let downloader = '!curl -fLo '
    elseif executable('wget')
      let downloader = '!wget -O '
    else
      echohl ErrorMsg
      echomsg 'Missing curl or wget executable'
      echohl NONE
    endif
    if !isdirectory(vimfiles . '/autoload')
      call mkdir(vimfiles . '/autoload', 'p')
    endif
    if has('win32')
      silent execute downloader . vimfiles . '\\autoload\\plug.vim ' . plug_url
    else
      silent execute downloader . vimfiles . '/autoload/plug.vim ' . plug_url
    endif
    unlet plug_url
    unlet downloader

    " Install plugins at first
    autocmd VimEnter * PlugInstall | quit
  endif
  call plug#begin(vimfiles . '/plugged')
  unlet vimfiles
endfunction

function s:version_requirement(val, min)
  for idx in range(0, len(a:min) - 1)
    let v = get(a:val, idx, 0)
    if v < a:min[idx]
      return 0
    elseif v > a:min[idx]
      return 1
    endif
  endfor
  return 1
endfunction

call s:download_vim_plug()

" Colorscheme
Plug 'w0ng/vim-hybrid'

" General
" PreserveNoEOL
Plug 'yous/PreserveNoEOL', {
      \ 'commit': '9ef2f01',
      \ 'frozen': 1 }
" EditorConfig
Plug 'editorconfig/editorconfig-vim'
" Full path finder
Plug 'kien/ctrlp.vim'
" Go to Terminal or File manager
Plug 'justinmk/vim-gtfo'
" Much simpler way to use some motions
Plug 'Lokaltog/vim-easymotion'
" Extended % matching
Plug 'tmhedberg/matchit'
" Autocomplete if end
Plug 'tpope/vim-endwise'
" Easily delete, change and add surroundings in pairs
Plug 'tpope/vim-surround'
" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'
" Vim sugar for the UNIX shell commands
Plug 'tpope/vim-eunuch'
" Syntax checking plugin
Plug 'scrooloose/syntastic'
" Automated tag file generation and syntax highlighting of tags
Plug 'xolox/vim-misc'
Plug 'xolox/vim-easytags'
"AutoComplete
Plug 'ervandew/supertab'
" Git wrapper
Plug 'tpope/vim-fugitive'
" Enable repeating supported plugin maps with "."
Plug 'tpope/vim-repeat'
" Distraction-free writing in Vim
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
"rainbow
Plug 'losingkeys/vim-niji'
" Vim UI
" Status, tabline
Plug 'bling/vim-airline'
" Explore filesystem
Plug 'scrooloose/nerdtree'
" Show a git diff in the gutter and stages/reverts hunks
Plug 'airblade/vim-gitgutter'

" ConqueTerm
" Plug 'Conque-Shell'
Plug 'yous/conque', { 'on': [
      \ 'ConqueTerm',
      \ 'ConqueTermSplit',
      \ 'ConqueTermVSplit',
      \ 'ConqueTermTab'] }

" Support file types
" AdBlock
Plug 'mojako/adblock-filter.vim', { 'for': 'adblockfilter' }
" Aheui
Plug 'yous/aheui.vim', { 'for': 'aheui' }
" Coffee script
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
" Crystal
Plug 'rhysd/vim-crystal', { 'for': 'crystal' }
" Cucumber
Plug 'tpope/vim-cucumber', { 'for': 'cucumber' }
" HTML5
Plug 'othree/html5.vim'
" Jade
Plug 'digitaltoad/vim-jade', { 'for': 'jade' }
" JSON
Plug 'elzr/vim-json', { 'for': 'json' }
" Liquid
Plug 'tpope/vim-liquid'
" Markdown
Plug 'godlygeek/tabular', { 'for': 'mkd' }
Plug 'plasticboy/vim-markdown', { 'for': 'mkd' }
" Racket
Plug 'wlangstroth/vim-racket', { 'for': 'racket' }
" XML
Plug 'othree/xml.vim', { 'for': 'xml' }

" Ruby
" Rake
Plug 'tpope/vim-rake'
" RuboCop
Plug 'ngmy/vim-rubocop', { 'on': 'RuboCop' }
" Rails
Plug 'tpope/vim-rails'
if v:version >= 700
  " ANSI escape sequences concealed, but highlighted as specified (conceal)
  Plug 'powerman/vim-plugin-AnsiEsc', { 'for': 'railslog' }
endif
" TomDoc
Plug 'wellbredgrapefruit/tomdoc.vim', { 'for': 'ruby' }

Plug 'Shirk/vim-gas'

" Mac OS
if has('mac') || has('macunix')
  " Launch queries for Dash.app from inside Vim
  Plug 'rizzatti/dash.vim', { 'on': [
        \ 'Dash',
        \ 'DashKeywords',
        \ '<Plug>DashSearch',
        \ '<Plug>DashGlobalSearch'] }
endif

call plug#end()
filetype plugin indent on
syntax on

" General
" -------

if &shell =~# 'fish$'
  set shell=sh
endif
set autoread
set background=dark
set backspace=indent,eol,start
" Use the clipboard register '*'
set clipboard=unnamed
set fileencodings=ucs-bom,utf-8,cp949,latin1
set fileformats=unix,mac,dos
" Number of remembered ":" commands
set history=1000
" Ignore case in search
set ignorecase
" Show where the pattern while typing a search command
set incsearch
" Don't make a backup before overwriting a file
set nobackup
" Override the 'ignorecase' if the search pattern contains upper case
set smartcase
" Enable list mode
set list
" Strings to use in 'list' mode and for the :list command
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
" List of file patterns to ignore when expanding wildcards, completing file or
" directory names, and influences the result of expand(), glob() and globpath()
set wildignore+=.git,.hg,.svn
set wildignore+=*.bmp,*.gif,*.jpeg,*.jpg,*.png
set wildignore+=*.dll,*.exe,*.o,*.obj
set wildignore+=*.sw?
set wildignore+=*.DS_Store
set wildignore+=*.pyc
if exists('&wildignorecase')
  " Ignore case when completing file names and directories
  set wildignorecase
endif
" Enhanced command-line completion
set wildmenu

if has('win32')
  " Enable the Input Method only on Insert mode
  autocmd InsertEnter * set noimdisable
  autocmd InsertLeave * set imdisable
  autocmd FocusGained * set imdisable
  autocmd FocusLost * set noimdisable
  language messages en
  " Directory names for the swap file
  set directory=.,$TEMP
  " Use a forward slash when expanding file names
  set shellslash
endif
" Exit Paste mode when leaving Insert mode
autocmd InsertLeave * set nopaste

" Vim UI
" ------

if has('gui_running') && &t_Co > 16
  " Highlight the screen line of the cursor
  set cursorline
endif
" Show as much as possible of the last line
set display+=lastline
" Show unprintable characters as a hex number
set display+=uhex
set hlsearch
" Always show a status line
set laststatus=2
set number
" Don't consider octal number when using the CTRL-A and CTRL-X commands
set nrformats-=octal
set scrolloff=3
" Show command in the last line of the screen
set showcmd
" Briefly jump to the matching one when a bracket is inserted
set showmatch
" The minimal number of columns to scroll horizontally
set sidescroll=1
set sidescrolloff=10
set splitbelow
set splitright
set title
set background=dark
colorscheme hybrid

augroup colorcolumn
  autocmd!
  if exists('+colorcolumn')
    set colorcolumn=81
  else
    autocmd BufWinEnter * let w:m2 = matchadd('ErrorMsg', '\%>80v.\+', -1)
  endif
augroup END

" GUI
" ---

if has('gui_running')
  set encoding=utf-8
  set guifont=Consolas:h10:cANSI
  set guioptions-=m " Menu bar
  set guioptions-=T " Toolbar
  set guioptions-=r " Right-hand scrollbar
  set guioptions-=L " Left-hand scrollbar when window is vertically split

  source $VIMRUNTIME/delmenu.vim
  set langmenu=ko.UTF-8
  source $VIMRUNTIME/menu.vim

  if has('win32')
    set guifontwide=DotumChe:h10:cDEFAULT
  endif

  function! ScreenFilename()
    if has('amiga')
      return 's:.vimsize'
    elseif has('win32')
      return $HOME.'\_vimsize'
    else
      return $HOME.'/.vimsize'
    endif
  endfunction
  function! ScreenRestore()
    " Restore window size (columns and lines) and position
    " from values stored in vimsize file.
    " Must set font first so columns and lines are based on font size.
    let f = ScreenFilename()
    if has('gui_running') && g:screen_size_restore_pos && filereadable(f)
      let vim_instance =
            \ (g:screen_size_by_vim_instance == 1 ? (v:servername) : 'GVIM')
      for line in readfile(f)
        let sizepos = split(line)
        if len(sizepos) == 5 && sizepos[0] == vim_instance
          silent! execute 'set columns='.sizepos[1].' lines='.sizepos[2]
          silent! execute 'winpos '.sizepos[3].' '.sizepos[4]
          return
        endif
      endfor
    endif
  endfunction
  function! ScreenSave()
    " Save window size and position.
    if has('gui_running') && g:screen_size_restore_pos
      let vim_instance =
            \ (g:screen_size_by_vim_instance == 1 ? (v:servername) : 'GVIM')
      let data = vim_instance.' '.&columns.' '.&lines.' '.
            \ (getwinposx() < 0 ? 0: getwinposx()).' '.
            \ (getwinposy() < 0 ? 0: getwinposy())
      let f = ScreenFilename()
      if filereadable(f)
        let lines = readfile(f)
        call filter(lines, "v:val !~ '^".vim_instance."\\>'")
        call add(lines, data)
      else
        let lines = [data]
      endif
      call writefile(lines, f)
    endif
  endfunction
  if !exists('g:screen_size_restore_pos')
    let g:screen_size_restore_pos = 1
  endif
  if !exists('g:screen_size_by_vim_instance')
    let g:screen_size_by_vim_instance = 1
  endif
  autocmd VimEnter *
        \ if g:screen_size_restore_pos == 1 |
        \   call ScreenRestore() |
        \ endif
  autocmd VimLeavePre *
        \ if g:screen_size_restore_pos == 1 |
        \   call ScreenSave() |
        \ endif
endif

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace //
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
if version >= 702
  autocmd BufWinLeave * call clearmatches()
endif

" Text formatting
" ---------------

set autoindent
set expandtab
set smartindent
" Number of spaces that a <Tab> counts for while editing
set softtabstop=2
" Number of spaces to use for each setp of (auto)indent
set shiftwidth=2
" Number of spaces that a <Tab> in the file counts for
set tabstop=2
autocmd FileType c,cpp,java,mkd,markdown,python
      \ setlocal softtabstop=4 shiftwidth=4 tabstop=4
" Disable automatic comment insertion
autocmd FileType *
      \ setlocal formatoptions-=c formatoptions-=o

" Mappings
" --------

" We do line wrap
noremap j gj
noremap k gk
noremap <Down> gj
noremap <Up> gk
noremap gj j
noremap gk k
noremap H ^
noremap L $
" Unix shell behavior
inoremap <C-A> <ESC>I
inoremap <C-E> <ESC>A
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
" Break the undo block when Ctrl-u
inoremap <C-U> <C-G>u<C-U>

" Tab
map <C-S-T> :tabnew<CR>

" Move cursor between splitted windows
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l

" Auto close brackets
inoremap (<CR> (<CR>)<ESC>O
inoremap [<CR> [<CR>]<ESC>O
inoremap {<CR> {<CR>}<ESC>O

" Reselect visual block after shifting
vnoremap < <gv
vnoremap > >gv

" Search regex
" All ASCII characters except 0-9, a-z, A-Z and '_' have a special meaning
nnoremap / /\v
vnoremap / /\v
cnoremap %s/ %smagic/
cnoremap \>s/ \>smagic/

" Search for visually selected text
vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR>

" Center display after searching
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Zoom and restore window
function! s:ZoomToggle()
  if exists('t:zoomed') && t:zoomed
    execute t:zoom_winrestcmd
    let t:zoomed = 0
  else
    let t:zoom_winrestcmd = winrestcmd()
    resize
    vertical resize
    let t:zoomed = 1
  endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <Leader>z :ZoomToggle<CR>

" Help
function SetHelpMapping()
  nnoremap <buffer> q :q<CR>
endfunction
autocmd FileType help call SetHelpMapping()

" Quickfix
function SetQuickfixMapping()
  nnoremap <buffer> q :ccl<CR>
endfunction
autocmd FileType qf call SetQuickfixMapping()

" Auto quit Vim when actual files are closed
function! CheckLeftBuffers()
  if tabpagenr('$') == 1
    let i = 1
    while i <= winnr('$')
      if getbufvar(winbufnr(i), '&buftype') == 'help' ||
            \ getbufvar(winbufnr(i), '&buftype') == 'quickfix' ||
            \ exists('t:NERDTreeBufName') &&
            \   bufname(winbufnr(i)) == t:NERDTreeBufName ||
            \ bufname(winbufnr(i)) == '__Tag_List__'
        let i += 1
      else
        break
      endif
    endwhile
    if i == winnr('$') + 1
      call feedkeys(":qall\<CR>", 'n')
    endif
    unlet i
  endif
endfunction
autocmd BufEnter * call CheckLeftBuffers()

" C, C++ compile & execute
autocmd FileType c,cpp map <F5> :w<CR>:make %<CR>
autocmd FileType c,cpp imap <F5> <ESC>:w<CR>:make %<CR>
autocmd FileType c
      \ if !filereadable('Makefile') && !filereadable('makefile') |
      \   setlocal makeprg=gcc\ -o\ %< |
      \ endif
autocmd FileType cpp
      \ if !filereadable('Makefile') && !filereadable('makefile') |
      \   setlocal makeprg=g++\ -o\ %< |
      \ endif
if has('win32')
  map <F6> :!%<.exe<CR>
  imap <F6> <ESC>:!%<.exe<CR>
elseif has('unix')
  map <F6> :!./%<<CR>
  imap <F6> <ESC>:!./%<<CR>
endif

" Python execute
autocmd FileType python map <F5> :w<CR>:!python %<CR>
autocmd FileType python imap <F5> <ESC>:w<CR>:!python %<CR>

" Ruby execute
autocmd FileType ruby map <F5> :w<CR>:!ruby %<CR>
autocmd FileType ruby imap <F5> <ESC>:w<CR>:!ruby %<CR>

" man page settings
autocmd FileType c,cpp set keywordprg=man
autocmd FileType ruby set keywordprg=ri

" Ruby configuration files view
autocmd BufNewFile,BufRead Gemfile,Guardfile setlocal filetype=ruby

" Gradle view
autocmd BufNewFile,BufRead *.gradle setlocal filetype=groovy

" Json view
autocmd BufNewFile,BufRead *.json setlocal filetype=json

" zsh-theme view
autocmd BufNewFile,BufRead *.zsh-theme setlocal filetype=zsh

" mobile.erb view
augroup rails_subtypes
  autocmd!
  autocmd BufNewFile,BufRead *.mobile.erb let b:eruby_subtype = 'html'
  autocmd BufNewFile,BufRead *.mobile.erb setfiletype eruby
augroup END

" Plugins
" -------

" PreserveNoEOL
let g:PreserveNoEOL = 1

" EasyMotion
let g:EasyMotion_leader_key = '<Leader>'

" unimpaired.vim
" Center display on move between SCM conflicts
nnoremap [n [nzz
nnoremap ]n ]nzz

" Syntastic
" Display all of the errors from all of the checkers together
let g:syntastic_aggregate_errors = 1
" Check header files
let g:syntastic_c_check_header = 1
let g:syntastic_cpp_check_header = 1
" Extend max error count for JSLint
let g:syntastic_javascript_jslint_args = '--white --nomen --regexp --plusplus
      \ --bitwise --newcap --sloppy --vars --maxerr=1000'

" Fugitive
let s:fugitive_insert = 0
augroup colorcolumn
  autocmd!
  autocmd FileType gitcommit
        \ if exists('+colorcolumn') |
        \   set colorcolumn=73 |
        \ else |
        \   let w:m2 = matchadd('ErrorMsg', '\%>72v.\+', -1) |
        \ endif
augroup END
autocmd FileType gitcommit
      \ if byte2line(2) == 2 |
      \   let s:fugitive_insert = 1 |
      \ endif
autocmd VimEnter *
      \ if (s:fugitive_insert) |
      \   startinsert |
      \ endif
autocmd FileType gitcommit let s:open_sidebar = 0
autocmd FileType gitrebase let s:open_sidebar = 0

" goyo.vim
nnoremap <Leader>G :Goyo<CR>

" airline
let g:airline_left_sep = ''
let g:airline_right_sep = ''

" NERD Tree and Tag List
let s:open_sidebar = 1
" Windows Vim
if !empty(&t_Co) && &t_Co <= 16
  let s:open_sidebar = 0
endif
if &diff
  let s:open_sidebar = 0
endif
let Tlist_Inc_Winwidth = 0

function! OpenSidebar()
  if !exists(':NERDTree') || !exists(':TlistOpen')
    return
  endif
  NERDTree
  TlistOpen
  wincmd J
  wincmd W
  wincmd L
  NERDTreeFocus
  normal AA
  wincmd p
endfunction

autocmd VimEnter *
      \ if (s:open_sidebar) |
      \   call OpenSidebar() |
      \ endif

" ConqueTerm
let g:ConqueTerm_InsertOnEnter = 1
let g:ConqueTerm_CWInsert = 1
let g:ConqueTerm_ReadUnfocused = 1
autocmd FileType conque_term highlight clear ExtraWhitespace
command -nargs=* Sh ConqueTerm <args>
command -nargs=* Shsp ConqueTermSplit <args>
command -nargs=* Shtab ConqueTermTab <args>
command -nargs=* Shvs ConqueTermVSplit <args>

" Adblock
let g:adblock_filter_auto_checksum = 1

" Markdown Vim Mode
let g:vim_markdown_folding_disabled = 1

" Rake
nmap <Leader>ra :Rake<CR>

" RuboCop
let g:vimrubocop_extra_args = '--display-cop-names'
let g:vimrubocop_keymap = 0
nmap <Leader>ru :RuboCop<CR>

" ANSI escape for Rails log
autocmd FileType railslog :AnsiEsc

" Mac OS
if has('mac') || has('macunix')
  " dash.vim
  let g:dash_map = {
        \   'java' : 'android'
        \ }
  nmap <Leader>d <Plug>DashSearch
endif
map <F1> v]}zf

au BufRead,BufNewFile *.s   let asmsyntax='gas'|let filetype_inc='gas'


let g:syntastic_cpp_compiler="g++"
let g:syntastic_cpp_compiler_options="-std=c++11 -stdlib=libc++"

set mouse=a
set ttymouse=xterm2

cabbrev ㅂ q
cabbrev ㅈ w
cabbrev ㅈㅂ wq
