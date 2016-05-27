execute pathogen#infect()

filetype plugin indent on
syntax on
set encoding=utf-8
set number
set tabstop=4
set shiftwidth=4
set autoindent
set cursorline
set hidden
set incsearch
set ignorecase

command TrimTrailing %s/\s\+$

"navigate buffers like you would tabs
nnoremap gB :<C-U>exe ':' . v:count . 'bprevious'<CR>
nnoremap gb :<C-U>exe (v:count ? ':' . v:count . 'b' : ':bnext')<CR>

autocmd Filetype rust setlocal expandtab
autocmd Filetype rust setlocal foldmethod=syntax
autocmd Filetype rust setlocal foldlevel=9

autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.mmd set filetype=markdown
autocmd BufRead,BufNewFile *.mmd set expandtab

let g:zenburn_force_dark_Background = 1
colorscheme zenburn

set sessionoptions-=options

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

command -nargs=0 Saveoff :mksession! session.vim | :qa

let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#fnamemod = ':p:~:.'
set laststatus=2
set ttimeoutlen=500

if filereadable($HOME . "/.vim/" . hostname() . ".vim") ||
			\ filereadable($HOME . "/vimfiles/" . hostname() . ".vim")
	execute "runtime " . hostname() . ".vim"
endif

if filereadable("session.vim") && filewritable("session.vim") && argc() == 0
	source session.vim
endif
