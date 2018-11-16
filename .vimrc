syntax on
set mouse=
"filetype off
set background=dark

" When there is a previous search pattern, highlight all its matches.
set hlsearch

set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital l

set laststatus=2								" always show status line

" Copy indent from current line when starting a new line.
set autoindent

" Do smart autoindenting when starting a new line.
set smartindent

" Four spaces looks nice when coding.
set softtabstop=4

" Number of spaces to use for each step of (auto)indent
" Looks best to match softtabstop.
set shiftwidth=4

" Use the appropriate number of spaces to insert a <Tab>
set expandtab

" Highlight whitespace(s) at the end of line.
autocmd VimEnter * :call matchadd('Error', '\s\+$', -1) | call matchadd('Error', '\%u00A0')
