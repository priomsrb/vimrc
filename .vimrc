set nocompatible
filetype off

" let Vundle manage Vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'xoria256.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'ShowPairs'
Bundle 'repeat.vim'
Bundle 'surround.vim'
Bundle 'Shougo/neocomplcache'
Bundle 'mhinz/vim-startify'
Bundle 'sukima/xmledit'
Bundle 'elixir-lang/vim-elixir'
Bundle 'klen/python-mode'
Bundle 'mileszs/ack.vim'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/nerdtree'

" XML edit
let xml_use_xhtml = 1

filetype plugin indent on

set backspace=2

set expandtab
filetype plugin on
syntax on

set incsearch
set ignorecase
set smartcase

set mouse=a

set background=dark
set t_Co=256
colorscheme xoria256

set hidden

set shiftwidth=4
set tabstop=4

set nobackup
set nowritebackup
set noswapfile

set wildignore=*.o,*.png,*.jpg,*.pyc

" Gui
set guioptions=cr
if has('gui_running')
  set guifont=DejaVu\ Sans\ Mono:h10
endif
source $VIMRUNTIME/mswin.vim

" Highlight current line
set cul
hi CursorLine term=none cterm=none ctermbg=236


" Don't highlight matching bracket
"hi MatchParen ctermbg=black

" Always keep 5 lines from bottom/top
set scrolloff=5

" switch quickfix easily
map <C-n> :cn<CR>
map <C-p> :cp<CR>


" Use ; instead of :
"nnoremap ; :

" Write with sudo using w!!
cmap w!! %!sudo tee > /dev/null %

" Return to old position when reopening files
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" Run current file with F5 if it starts with #!
function! RunShebang()
  if (match(getline(1), '^\#!') == 0)
    :!./%
  else
    echo "No shebang in this file."
  endif
endfunction
map <F5> :call RunShebang()<CR>



" F4 to switch header/source
"map <F4> :A<return>

" Ctrl+Space to omni-complete
inoremap <Nul> <C-x><C-o>

" Automatically insert closing brace after pressing enter
inoremap {<CR> {<CR>}<Esc>O

" Map Ctrl+k to open command-t
"map <C-k> <Leader>t

" toggle comment with <Ctrl-/>
noremap  :call NERDComment(0, 'toggle')<CR>j
noremap <C-k> :call NERDComment(0, 'toggle')<CR>j


" Show lusty explorer
"map <C-k> <Leader>lr

"let g:neocomplcache_enable_at_startup = 1
"let g:neocomplcache_enable_auto_select = 1
let g:neocomplcache_enable_camel_case_completion = 1
" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

map <F8> :NeoComplCacheEnable<CR>



"""""""""""""""""""""""""""""""""""""""""""
"" Improved status line

set laststatus=2

hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black
hi Modified guibg=orange guifg=black ctermbg=lightred ctermfg=black

function! MyStatusLine(mode)
    let statusline=""
    if a:mode == 'Enter'
        let statusline.="%#StatColor#"
    endif
    let statusline.="\(%n\)\ %f\ "
    if a:mode == 'Enter'
        let statusline.="%*"
    endif
    let statusline.="%#Modified#%m"
    if a:mode == 'Leave'
        let statusline.="%*%r"
    elseif a:mode == 'Enter'
        let statusline.="%r%*"
    endif
    let statusline .= "\ (%l/%L,\ %c)\ %P%=%h%w\ %y\ [%{&encoding}:%{&fileformat}]\ \ "
    return statusline
endfunction

au WinEnter * setlocal statusline=%!MyStatusLine('Enter')
au WinLeave * setlocal statusline=%!MyStatusLine('Leave')
set statusline=%!MyStatusLine('Enter')

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi StatColor guibg=orange ctermbg=lightred
  elseif a:mode == 'r'
    hi StatColor guibg=#e454ba ctermbg=magenta
  elseif a:mode == 'v'
    hi StatColor guibg=#e454ba ctermbg=magenta
  else
    hi StatColor guibg=red ctermbg=red
  endif
endfunction 

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black

" /Improved status line
"""""""""""""""""""""""""""""""""

" Protect large files from sourcing and other overhead.
" Files become read only
if !exists("my_auto_commands_loaded")
  let my_auto_commands_loaded = 1
  " Large files are > 10M
  " Set options:
  " eventignore+=FileType (no syntax highlighting etc
  " assumes FileType always on)
  " noswapfile (save copy of file)
  " bufhidden=unload (save memory when other file is viewed)
  " buftype=nowritefile (is read-only)
  " undolevels=-1 (no undo possible)
  let g:LargeFile = 1024 * 1024 * 10
  augroup LargeFile
    autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
    augroup END
  endif



" startify
let g:startify_bookmarks = [ '~/.vimrc' ]
let g:startify_show_files_number = 5


" CTRL-A to copy all to clipboard
"map <c-q> <c-a>
"map <c-a> :%y+<CR>

" Create dirs on save if required
function! s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END


" Split open vimrc
map <leader>v :vs ~/.vimrc<CR>

" Replace using current search term
map <leader>r :%s///g<left><left>

" Use ack on visual selection
map <leader>a y:Ack! <c-r>"<CR>

" Disable pylint warnings for:
" - Comments with no leading space
" - Lines too long
let g:pymode_lint_ignore = "E265,E501"
" Disable python folding
"let g:pymode_folding = 0
set foldlevelstart=2
" Disable automatic python doc (use 'K' instead when required)
set completeopt-=preview
" Exended autocompletion (Not sure if it actually does anything)
let g:pymode_rope_autoimport = 1

" Ctrl-P mapping
let g:ctrlp_map = '<c-t>'

" Toggle highlighting
map <leader>h :set hlsearch!<CR>

" Nerd Tree options
let NERDTreeIgnore = ['\.pyc$']
map <leader>t :NERDTreeToggle<CR>

" Format json
" :%!python -m json.tool



" mswin.vim from here =====================

" Set options and add mapping such that Vim behaves a lot like MS-Windows
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2006 Apr 02

" bail out if this isn't wanted (mrsvim.vim uses this).
if exists("g:skip_loading_mswin") && g:skip_loading_mswin
  finish
endif

" set the 'cpoptions' to its Vim default
if 1	" only do this when compiled with expression evaluation
  let s:save_cpo = &cpoptions
endif
set cpo&vim

" set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
behave mswin

" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,]

" backspace in Visual mode deletes selection
vnoremap <BS> d

" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
vnoremap <S-Del> "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y

" CTRL-V and SHIFT-Insert are Paste
map <C-V>		"+gP
map <S-Insert>		"+gP

cmap <C-V>		<C-R>+
cmap <S-Insert>		<C-R>+

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.

exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

imap <S-Insert>		<C-V>
vmap <S-Insert>		<C-V>

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q>		<C-V>

" Use CTRL-S for saving, also in Insert mode
noremap <C-S>		:update<CR>
vnoremap <C-S>		<C-C>:update<CR>
inoremap <C-S>		<C-O>:update<CR>

" For CTRL-V to work autoselect must be off.
" On Unix we have two selections, autoselect can be used.
if !has("unix")
  set guioptions-=a
endif

" CTRL-Z is Undo; not in cmdline though
noremap <C-Z> u
inoremap <C-Z> <C-O>u

" CTRL-Y is Redo (although not repeat); not in cmdline though
noremap <C-Y> <C-R>
inoremap <C-Y> <C-O><C-R>

" Alt-Space is System menu
if has("gui")
  noremap <M-Space> :simalt ~<CR>
  inoremap <M-Space> <C-O>:simalt ~<CR>
  cnoremap <M-Space> <C-C>:simalt ~<CR>
endif

" CTRL-A is Select all
"noremap <C-A> gggH<C-O>G
"inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
"cnoremap <C-A> <C-C>gggH<C-O>G
"onoremap <C-A> <C-C>gggH<C-O>G
"snoremap <C-A> <C-C>gggH<C-O>G
"xnoremap <C-A> <C-C>ggVG

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w

" CTRL-F4 is Close window
noremap <C-F4> <C-W>c
inoremap <C-F4> <C-O><C-W>c
cnoremap <C-F4> <C-C><C-W>c
onoremap <C-F4> <C-C><C-W>c

" restore 'cpoptions'
set cpo&
if 1
  let &cpoptions = s:save_cpo
  unlet s:save_cpo
endif
