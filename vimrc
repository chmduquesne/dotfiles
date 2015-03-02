"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"UPDATES
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"git clone http://github.com/gmarik/vundle.git ~/.vim/vundle.git
set nocompatible
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'matchit.zip'
Plugin 'DrawIt'
Plugin 'Align'
Plugin 'AnsiEsc.vim'
Plugin 'Zenburn'
Plugin 'pydoc.vim'
Plugin 'cecutil'
Plugin 'netrw.vim'
Plugin 'visualstar.vim'
Plugin 'Vimball'
Plugin 'LargeFile'
Plugin 'ajh17/VimCompletesMe'
Plugin 'The-NERD-tree'
Plugin 'file-line'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'CTAGS-Highlighting'
Plugin 'Tag-Signature-Balloons'
Plugin 'hexHighlight.vim'
Plugin 'rename.vim'
Plugin 'toggle_option'
Plugin 'recover.vim'
Plugin 'clang-complete'
Plugin 'Gundo'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-sleuth'
Plugin 'greplace.vim'
Plugin 'junegunn/seoul256.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'smokey42/lighttpd-syntax.git'
Plugin 'tpope/vim-rsi'
call vundle#end()            " required
filetype plugin indent on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MOTIONS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap w W
nnoremap W B
nnoremap e E
nnoremap E gE

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
set shiftwidth=4
set shiftround
set tabstop=4
set softtabstop=4
set expandtab
set backspace=indent,eol,start
set textwidth=74
set formatoptions+=t
nmap <F2> :Toggle paste<CR>
nmap <F6> :Toggle spell<CR>
nmap Q <Nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"FAST SCROLLING
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set lazyredraw

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"ASPECT
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set showcmd
set number
set cursorline
set list
set listchars=tab:>-
syntax on
let g:load_doxygen_syntax=1
set foldmethod=syntax
set foldopen=all
set nofoldenable
"augroup aspect
"    autocmd BufRead * highlight OverLength ctermbg=darkblue guibg=darkblue
"    autocmd BufRead * match OverLength /\%75v.*/
"    autocmd BufRead * highlight RedundantSpaces ctermbg=red guibg=red
"    autocmd BufRead * 2match RedundantSpaces /\s\+$\| \+\ze\t/
"augroup END
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
nnoremap N Nzz
nnoremap n nzz
"nnoremap <silent> <esc> :noh<return><esc>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"GSEARCH PLUGIN
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"MOUSE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=nvch
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
set clipboard=unnamed,unnamedplus
"set clipboard=unnamed

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
nmap t :tabedit ./
nmap T :tabedit <C-R>%
map H <C-o>
map L <C-i>
set switchbuf=usetab,useopen,newtab
let mapleader = ","

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"PARENTHESIS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set showmatch
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

" reminders
" delete empty lines
" :g/^$/d

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CONCEAL
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tex_conceal="agm"

function! ToggleConceal()
    exec 'let newconceallevel = ' (2 - &conceallevel)
    exec 'set conceallevel=' . newconceallevel
    exec 'set conceallevel? '
endfunction
nmap <F8> :call ToggleConceal()<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"FILETYPE SPECIFIC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup filetypedetect
    autocmd BufNewFile,BufRead *.wiki set filetype=Wikipedia
    autocmd BufNewFile,Bufread *.h set filetype=c
    autocmd BufNewFile,BufRead *.md set filetype=markdown
augroup END
augroup lang_c
    autocmd FileType c map <F4> :e %:p:s,.h$,.X123X,:s,.c$,.h,:s,.X123X$,.c,<CR>
augroup END
"C/C++
augroup lang_cpp
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
    autocmd FileType tex setlocal spell spelllang=en
    "z= for suggestions
augroup END

"MARKDOWN
augroup lang_markdown
    autocmd Filetype markdown let g:trim_blank=0
augroup END
