" Plugins and themes
call plug#begin()
    " Nerdtree
    Plug 'preservim/nerdtree'
    " NERD Commenter
    Plug 'preservim/nerdcommenter'
    " Github Copilot
    Plug 'github/copilot.vim'
    " Vim-airline
    Plug 'vim-airline/vim-airline'
    " Vim-airline-themes
    Plug 'vim-airline/vim-airline-themes'
    " Vim-devicons
    Plug 'ryanoasis/vim-devicons'
    " Dracula theme
    Plug 'dracula/vim'
    " Auto-pairs
    Plug 'jiangmiao/auto-pairs'
    " Coc
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Barbar
    Plug 'nvim-tree/nvim-web-devicons' " OPTIONAL: for file icons
    Plug 'lewis6991/gitsigns.nvim'     " OPTIONAL: for git status
    Plug 'romgrk/barbar.nvim'
    " Split-term
    Plug 'vimlab/split-term.vim'
call plug#end()

" Nerdtree
let g:NERDTreeWinSize = 35
let g:NERDTreeShowHidden = 1
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeShowFiles = 1

" Split-term
let g:split_term_splitbelow = 1
" Default shell (Windows = 'powershell', Linux = 'bash')
if has('win32') || has('win64')
    let g:split_term_default_shell = 'powershell'
else
    let g:split_term_default_shell = 'bash'
endif
