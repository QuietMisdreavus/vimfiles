" tell pathogen to load up everything in bundle/
execute pathogen#infect()

" use filetype info, let plugins set it, use indent info from filetype data
filetype plugin indent on
syntax on           " syntax highlighting
set encoding=utf-8  " default encoding for new files
set number          " line numbers
set tabstop=4       " tabstop/shiftwidth handle how vim handles tabs and indent
set shiftwidth=4    " i honestly forget which does which >_>
set autoindent      " automatically set indent on new lines based on syntax
set cursorline      " highlight the line the cursor's in
set hidden          " set buffers to hidden when you move to a new one
set incsearch       " incremental search with /?
set ignorecase      " when typing searches in lowercase, be case-insensitive
set smartcase       " ...but if you include uppercase, be case-sensitive
set showcmd         " show current command in the bottom-right corner
set foldopen-=block " when navigating with {} don't open folds
set showmatch       " jump cursor to the opening ([{ when you type a matching }])
set visualbell      " flash screen instead of sending BEL
set textwidth=100   " default text-wrap width

command TrimTrailing %s/\s\+$

" navigate buffers like you would tabs
nnoremap gB :<C-U>exe ':' . v:count . 'bprevious'<CR>
nnoremap gb :<C-U>exe (v:count ? ':' . v:count . 'b' : ':bnext')<CR>

" for rust files, set the compiler command for :make
function Cargo()
	if filereadable("Cargo.toml")
		compiler cargo
	endif
endfunction

" for rust files, emit spaces instead of tabs
augroup rust
	autocmd!
	autocmd Filetype rust setlocal expandtab
	autocmd Filetype rust call Cargo()
augroup END

" .md and .mmd files are markdown
" also, use spaces in multi-markdown files
augroup markdown
	autocmd!
	autocmd BufRead,BufNewFile *.md set filetype=markdown
	autocmd BufRead,BufNewFile *.mmd set filetype=markdown
	autocmd BufRead,BufNewFile *.mmd set expandtab
augroup END

if has("gui_running")
	set background=light
	colorscheme lucius
else
	set background=dark
	let g:zenburn_force_dark_Background = 1
	colorscheme zenburn
endif

" don't save these settings in session files, so we can overwrite them with vimrc changes
set sessionoptions-=options

" syntastic settings
" ...it's been long enough since i've set up syntastic that i don't remember what these do >_>
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" airline settings
" use powerline font symbols
let g:airline_powerline_fonts=1
" use airline's tab line, to show buffers and tabs
let g:airline#extensions#tabline#enabled = 1
" show buffer number on the tabline (helpful for gb command above)
let g:airline#extensions#tabline#buffer_nr_show = 1
" show tab number if tabs are in use
let g:airline#extensions#tabline#tab_nr_type = 1
" show a condensed filename in the tabline
let g:airline#extensions#tabline#fnamemod = ':p:~:.'
" always show status line, so we always have airline
set laststatus=2
" time out commands at 0.5sec, so the mode display is a little faster
set ttimeoutlen=500

" per-machine settings can go in a file named after its hostname
if filereadable($HOME . "/.vim/" . hostname() . ".vim") ||
			\ filereadable($HOME . "/vimfiles/" . hostname() . ".vim")
	execute "runtime " . hostname() . ".vim"
endif

" super-janky session management
" use :Saveoff to dump current session to './session.vim' and quit
command -nargs=0 Saveoff :mksession! session.vim | :qa

" ...and load the 'session.vim' file if it's there
if filereadable("session.vim") && filewritable("session.vim") && argc() == 0
	source session.vim
endif
