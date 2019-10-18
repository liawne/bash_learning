" enable syntax processing
syntax enable           

" number of visual spaces per TAB
" tabstop is the number of spaces a tab counts for. So, when Vim opens a file and reads a <TAB>
" character, it uses that many spaces to visually show the <TAB>.
set tabstop=4                                   

" number of spaces in tab when editing
" softabstop is the number of spaces a tab counts for when editing. So this value is the number 
" of spaces that is inserted when you hit <TAB> and also the number of spaces that are removed when you backspace.
set softtabstop=4

" tabs are spaces
" expandtab turns <TAB>s into spaces. That's it. So <TAB> just becomes a shortcut for "insert four spaces".
set expandtab

" show line numbers
set number

" show command in bottom bar
" showcmd shows the last command entered in the very bottom right of Vim.
set showcmd

" highlight current line
" cursorline draws a horizontal highlight (or underline, depending on your colorscheme) on the line 
" your cursor is currently on.
set cursorline

" load filetype-specific indent files
" This both turns on filetype detection and allows loading of language specific indentation files based 
" on that detection. For me, this means the python indentation file that lives at ~/.vim/indent/python.vim 
" gets loaded every time I open a *.py file.
filetype indent on

" visual autocomplete for command menu
" This is a pretty cool feature I didn't know Vim had. You know how Vim automatically autocompletes things 
" like filenames when you, for instance, run :e ~/.vim<TAB>? Well it will provide a graphical menu of all 
" the matches you can cycle through if you turn on wildmenu.
set wildmenu

" highlight matching [{()}]
" With showmatch, when your cursor moves over a parenthesis-like character, the matching one will be highlighted as well.
set showmatch

" search as characters are entered
set incsearch

" highlight matches
set hlsearch

" leader is comma
let mapleader=","

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" jk is escape
inoremap jk <esc>

" auto indent
set autoindent

" smart indent
set smartindent

" auto wrap if the line longer than a line
set wrap

" set ruler
set ruler

" ignore the Capital format
set ignorecase

" set mouse locate 
set mouse=a

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

set pastetoggle=<F3>

" set theme
colorscheme grb256
"colorscheme guardian2
"colorscheme distinguish
"colorscheme jellybeans
"colorscheme railscasts
"colorscheme solarized

"""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""
" set the key map <leader>
let mapleader=";"

" set the key map to fast copy and paste
nmap <Leader>y "+y
nmap <Leader>p "+p

" 让配置保存后立即生效
autocmd BufWritePost $MYVIMRC source $MYVIMRC
