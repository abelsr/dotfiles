" Enable syntax highlighting
syntax enable

" Set the tab width to 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" Enable line number
set number

" Enable relative numbers
set relativenumber

" Enable auto-indentation
set autoindent

" Enable smart indentation
set smartindent

" Enable mouse support
set mouse=a

" Enable searching as you type
set incsearch

" Enable case-insensitive searching
set ignorecase

" Enable highlighting of search results
set hlsearch

" Enable line wrapping
set wrap

" Enable file encoding detection
set fileencodings=utf-8,latin1

" Enable UTF-8 encoding
set encoding=utf-8

" Enable colors
set termguicolors

" Enable colors for Apple Terminal
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Enable file type detection
filetype plugin indent on

" Check OS
if has('win32') || has('win64')
    source ~/Appdata/Local/nvim/Plugins/plugins.vim
    source ~/Appdata/Local/nvim/Themes/themes.vim
    source ~/Appdata/Local/nvim/Keybindings/keybindings.vim
endif
