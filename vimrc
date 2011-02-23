"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"GVIM SPECIFICS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set guifont=monospace\ 9
set guioptions=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"FAST SCROLLING
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set lazyredraw

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"UPDATES
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"git clone http://github.com/gmarik/vundle.git ~/.vim/vundle.git
set runtimepath+=~/.vim/vundle.git/
call vundle#rc()

Bundle "matchit.zip"
Bundle "DrawIt"
Bundle "Align"
Bundle "AnsiEsc.vim"
Bundle "Zenburn"
Bundle "ManPageView"
Bundle "pydoc.vim"
Bundle "cecutil"
Bundle "netrw.vim"
Bundle "vis"
Bundle "visualstar.vim"
Bundle "Vimball"
Bundle "LargeFile"
Bundle "SuperTab-continued."
Bundle "The-NERD-tree"
Bundle "surround.vim"
Bundle "file-line"
Bundle "repeat.vim"
Bundle "snipMate"
Bundle "CTAGS-Highlighting"
Bundle "Tag-Signature-Balloons"
Bundle "hexHighlight.vim"
Bundle "bisect"
Bundle "rename.vim"
Bundle "toggle_option"
Bundle "recover.vim"
Bundle "clang-complete"
Bundle "Command-T"
Bundle "EasyGrep"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"GLOBAL WINDOWS HANDLING
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:quickfix_state = 0 " 0 is closed, 1 is open
let g:NERDTree_state = 0 " 0 is closed, 1 is open

" Checks the two previous values. Triggers quickfix and nerdtree
" accordingly and replaces the cursor in the right window.
function! UpdateTabState()
    if g:quickfix_state == 1
        copen | silent! cgetfile
    else
        cclose
    endif
    if g:NERDTree_state == 1
        NERDTree
        NERDTreeMirror
    else
        NERDTreeClose
    endif
    execute "normal \<c-w>\<c-w>"
endfunction

" When a tab is entered, its state is updated
augroup tabs
    autocmd TabEnter * call UpdateTabState()
augroup END

map <silent> <F3> :Toggle g:NERDTree_state<CR>:doautocmd tabs TabEnter<CR>
map <silent> <space> :Toggle g:quickfix_state<CR>:doautocmd tabs TabEnter<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"BROWSING (NETRW-NERDTree)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let NERDTreeHijackNetrw=0
let g:netrw_browsex_viewer="gnome-open"
let g:netrw_liststyle=3
let g:netrw_hide=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"LOAD/SAVE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap ,s :source ~/.vimrc<CR>
nmap ,v :e ~/.vimrc<CR>
nmap mk :mksession!<CR>
nmap ml :so Session.vim<CR>
cmap w!! %!sudo tee > /dev/null %
set autoread
set hidden
set nobackup
set wildignore+=*.o,*.class,*.ps,*.dvi
set nocompatible
let g:trim_blank=1
augroup load_save
    " When editing a file, always jump to the last known cursor position
    autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \     exe "normal! g`\"" |
                \ endif
    " When writing a file, remove trailing whitespaces and retab
    autocmd BufWritePre *
                \ if g:trim_blank == 1 |
                \     %smagic/\s\+$//e |
                \     retab            |
                \ endif
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"INSERTION
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set joinspaces
set autoindent
set smartindent
filetype plugin indent on
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set backspace=indent,eol,start
set textwidth=74
set formatoptions+=t
map <F2> :Toggle paste<CR>
map <F6> :Toggle spell<CR>
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabRetainCompletionType = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"ASPECT
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number
set cursorline
set list
set listchars=tab:▶- "eol:¬
syntax on
let g:load_doxygen_syntax=1
"set foldmethod=syntax
"set foldopen=all
set nofoldenable
augroup aspect
    autocmd BufRead * highlight OverLength ctermbg=darkblue guibg=darkblue
    autocmd BufRead * match OverLength /\%75v.*/
    autocmd BufRead * highlight RedundantSpaces ctermbg=red guibg=red
    autocmd BufRead * 2match RedundantSpaces /\s\+$\| \+\ze\t/
augroup END
if &t_Co == 256
    try
        colorscheme zenburn
    catch E185
        colorscheme default
    endtry
else
    colorscheme default
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"STATUS BAR
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ruler
set laststatus=2
set showcmd
set showmode
set ch=1
set wildmenu
set wildmode=list:longest,full

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"SEARCH OPTIONS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ignorecase
set smartcase
set incsearch
set magic
set hlsearch

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"EASYGREP PLUGIN
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:EasyGrepRecursive = 1
let g:EasyGrepOptionPrefix = ''
let g:EasyGrepMode = 2
map <silent> ,go <plug>EgMapGrepOptions
map <silent> ,S <plug>EgMapGrepCurrentWord_v
xmap <silent> ,S <plug>EgMapGrepSelection_v
map <silent> ,s <plug>EgMapGrepCurrentWord_V
xmap <silent> ,s <plug>EgMapGrepSelection_V
map <silent> ,a <plug>EgMapGrepCurrentWord_a
xmap <silent> ,a <plug>EgMapGrepSelection_a
map <silent> ,A <plug>EgMapGrepCurrentWord_A
xmap <silent> ,A <plug>EgMapGrepSelection_A
map <silent> ,R <plug>EgMapReplaceCurrentWord_r
xmap <silent> ,R <plug>EgMapReplaceSelection_r
map <silent> ,r <plug>EgMapReplaceCurrentWord_R
xmap <silent> ,r <plug>EgMapReplaceSelection_R

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"MOUSE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=a
inoremap <LeftDrag> <LeftMouse>
"xnoremap <MiddleMouse> <Nop>
nnoremap <C-LeftMouse>
    \ <LeftMouse> :tab ptag <C-r>=expand("<cword>")<CR><CR>:set nopvw<CR>
"nnoremap <2-LeftMouse>
"inoremap <MiddleMouse> <esc>"+pi
set virtualedit=block

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"CLIPBOARD
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set clipboard=unnamed

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"CODE BROWSING
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <PageDown> :cnext<CR>
map <PageUp> :cprevious<CR>
map <C-PageDown> :cnext<CR>
map <C-PageUp> :cprevious<CR>
set previewheight=20
if has("cscope")
    if filereadable("cscope.out")
        cs add cscope.out
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    "set cscopetag
    set cscopeverbose
    set cscopequickfix=s-,g-,d-,c-,t-,e-,f-,i-
    nmap _s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap __ :cs<CR>
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"FAST TABS EDITING
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <C-h> :tabprevious<cr>
nmap <C-l> :tabnext<cr>
map <C-h> :tabprevious<cr>
map <C-l> :tabnext<cr>
imap <C-h> <ESC>:tabprevious<cr>i
imap <C-l> <ESC>:tabnext<cr>i
"nmap t :tabedit ./
nmap T :tabedit <C-R>%
map H <C-o>
map L <C-i>
set switchbuf=usetab,useopen,newtab

" command-t mappings
let mapleader = ","
nmap <silent> t :CommandT<cr>
let g:CommandTAcceptSelectionTabMap="<cr>"
let g:CommandTAcceptSelectionMap="<C-o>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"PARENTHESIS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertIfNoTrailingClosingChar(closingChar)
    let trailing = strpart(getline("."), col("."))
    let regexp = '\S' . a:closingChar
    if trailing !~ regexp
        execute "normal! a" . a:closingChar
        execute "normal! h"
    endif
endfunction

inoremap ( (<esc>:call InsertIfNoTrailingClosingChar(")")<cr>a
inoremap " "<esc>:call InsertIfNoTrailingClosingChar('"')<cr>a
inoremap [ [<esc>:call InsertIfNoTrailingClosingChar("]")<cr>a
inoremap { {<esc>:call InsertIfNoTrailingClosingChar("}")<cr>a

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"BISECT
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <C-Left>  <Plug>BisectLeft
nmap <C-Right> <Plug>BisectRight
nmap <C-Up>    <Plug>BisectUp
nmap <C-Down>  <Plug>BisectDown
xmap <C-Left>  <Plug>VisualBisectLeft
xmap <C-Right> <Plug>VisualBisectRight
xmap <C-Up>    <Plug>VisualBisectUp
xmap <C-Down>  <Plug>VisualBisectDown

" reminders
" delete empty lines
" :g/^$/d

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"FILETYPE SPECIFIC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup filetypedetect
    au BufNewFile,BufRead *.wiki setf Wikipedia
augroup END

"C/C++
augroup lang_cpp
    autocmd FileType cpp set omnifunc=omni#cpp#complete#Main
    autocmd FileType cpp let OmniCpp_MayCompleteScope = 0
    autocmd FileType cpp set makeprg=make\ -j3\ -s
    autocmd BufNewFile *.{hpp} execute "normal inewclasshpp"
    autocmd BufNewFile *.{cpp} execute "normal inewclasscpp"
    autocmd FileType cpp set tags+=~/.vim/tags/cpp
    autocmd FileType cpp map <F4> :e %:p:s,.hpp$,.X123X,:s,.cpp$,.hpp,:s,.X123X$,.cpp,<CR>
    "autocmd BufWritePost *.{hpp,cpp}
    "            \ silent execute "!cppcheck % > /tmp/cpperrors 2>&1 &" |
    "            \ silent execute "!notify-send \"`cat /tmp/cpperrors`\" &" |
    "            \ redraw!
augroup END
set completeopt=menu

"PYTHON
augroup lang_python
    autocmd FileType python compiler pyunit
    autocmd FileType python map K :Pydoc <C-r>=expand("<cword>")<CR><CR>
augroup END

"LATEX
augroup lang_latex
    autocmd FileType tex setlocal spell spelllang=fr
    "z= for suggestions
augroup END

