"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"UPDATES
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! HasVundle()
    return isdirectory(expand('$HOME/.vim/bundle/Vundle.vim'))
endfunction
if !HasVundle()
    !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
endif
set nocompatible
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim
if HasVundle()
    call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'vim-scripts/visualstar.vim'
    Plugin 'mhinz/vim-hugefile'
    Plugin 'bogado/file-line'
    Plugin 'tpope/vim-surround'
    Plugin 'tpope/vim-repeat'
    Plugin 'hexHighlight.vim'
    Plugin 'toggle_option'
    Plugin 'chrisbra/Recover.vim'
    Plugin 'clang-complete'
    Plugin 'sjl/gundo.vim'
    Plugin 'tpope/vim-markdown'
    Plugin 'tpope/vim-abolish'
    Plugin 'tpope/vim-sleuth'
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'tpope/vim-rsi'
    Plugin 'fatih/vim-go'
    Plugin 'ycm-core/YouCompleteMe'
    Plugin 'tpope/vim-sensible'
    Plugin 'derekwyatt/vim-scala'
    Plugin 'chriskempson/base16-vim'
    Plugin 'godlygeek/tabular'
    call vundle#end()
endif

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

" Checks the previous value. Triggers quickfix accordingly and replaces
" the cursor in the right window.
function! UpdateTabState()
    if g:quickfix_state == 1
        copen | silent! cgetfile
    else
        cclose
    endif
    execute "normal \<c-w>\<c-w>"
endfunction

" When a tab is entered, its state is updated
augroup tabs
    autocmd TabEnter * call UpdateTabState()
augroup END

map <silent> <space> :Toggle g:quickfix_state<CR>:doautocmd tabs TabEnter<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"LOAD/SAVE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap ,s :source ~/.vimrc<CR>
nmap ,v :e ~/.vimrc<CR>
cmap w!! %!sudo tee > /dev/null %
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
set listchars=tab:>-,trail:\ ,extends:>,precedes:<
augroup aspect
    autocmd BufRead * highlight SpecialKey cterm=reverse gui=reverse
    autocmd BufRead * highlight NonText    cterm=reverse gui=reverse
    autocmd BufRead * highlight Trail      cterm=reverse gui=reverse
    autocmd BufRead * 2match Trail /\s\+$\| \+\ze\t/
augroup end
let g:load_doxygen_syntax=1
set foldmethod=syntax
set foldopen=all
set nofoldenable
set background=dark
if &t_Co == 256
    try
        colorscheme base16
    catch E185
        colorscheme default
    endtry
else
    colorscheme default
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"STATUS BAR
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set showmode
set ch=1
set wildmode=list:longest,full

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"SEARCH OPTIONS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set ignorecase
set smartcase
set magic
set hlsearch
nnoremap N Nzz
nnoremap n nzz
"nnoremap <silent> <esc> :noh<return><esc>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"VIM-GO
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:go_fmt_command = "goimports"

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

let g:ycm_server_python_interpreter = '/usr/bin/python3'
