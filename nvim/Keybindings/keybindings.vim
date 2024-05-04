" Set Ctrl + S to save
inoremap <silent> <C-s> <Esc>:w<CR>i
nnoremap <C-s> :w<CR>

" Set Ctrl + W to quit
inoremap <silent> <C-w> <Esc>:q<CR>
nnoremap <C-w> :q<CR>

" Set Ctrl + Alt + R to reload init.vim file
inoremap <silent> <C-A-r> <Esc>:source $MYVIMRC<CR>i
nnoremap <C-A-r> <Esc>:source $MYVIMRC<CR>

" Set Ctrl + B to open NERDTree
inoremap <silent> <C-b> <Esc>:NERDTreeToggle<CR>
nnoremap <C-b> :NERDTreeToggle<CR>

" Set Ctrl + Arrow keys to move between windows
nnoremap <C-Right> <C-w>l
nnoremap <C-Left> <C-w>h
nnoremap <C-Up> <C-w>k
nnoremap <C-Down> <C-w>j

" Set Ctrl + Shift + Arrow keys to resize windows
nnoremap <C-S-Right> :vertical resize +5<CR>
nnoremap <C-S-Left> :vertical resize -5<CR>
nnoremap <C-S-Up> :resize -5<CR>
nnoremap <C-S-Down> :resize +5<CR>

" Set Ctrl + T to open a new tab
inoremap <silent> <C-t> <Esc>:tabnew<CR>
nnoremap <C-t> :tabnew<CR>

" Set Ctrl + Z to undo
inoremap <silent> <C-z> <Esc>u i
nnoremap <C-z> u

" Set Ctrl + Alt + K for comment line(s)
inoremap <silent> <C-A-k> <ESC>:call nerdcommenter#Comment(0, 'toggle')<CR>i
nnoremap <C-A-k> :call nerdcommenter#Comment(0, 'toggle')<CR>
vnoremap <C-A-k> :call nerdcommenter#Comment(0, 'toggle')<CR>

" Set Ctrl + J for open terminal
inoremap <silent> <C-j> <Esc>:Term<CR>i
nnoremap <C-j> :Term<CR>

" Set Ctrl + F to search
inoremap <silent> <C-f> <Esc>/
nnoremap <C-f> /

" Set Ctrl + T to change tab
inoremap <silent> <C-t> <Esc>:BufferNext<CR>
nnoremap <C-t> :BufferNext<CR>

" Set Ctrl + Alt + T to close tab
inoremap <silent> <C-A-w> <Esc>:BufferClose!<CR>
nnoremap <C-A-w> :BufferClose!<CR>
