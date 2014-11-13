syntax on

" Colors!
syntax enable
set background=dark
colorscheme solarized
" Solarized background strangeness fix
highlight Normal ctermbg=none

"Set linenumber stuff
set numberwidth=5
"Setting number then relativenumber gives us relative numbering with the
"current line having the absolute line number
set number
set relativenumber
highlight LineNr ctermbg=darkgrey

filetype on
filetype plugin on
filetype plugin indent on

"tabs
set softtabstop=4
set shiftwidth=4
set expandtab
set tabstop=4
set smarttab
set smartindent
set autoindent

"Search config
set ignorecase
set smartcase
set incsearch

"Leave insert mode with `jk` (avoid escape!)
imap jk <Esc>
