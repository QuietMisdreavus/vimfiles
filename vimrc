" basic settings {{{

" use filetype info, let plugins set it, use indent info from filetype data
filetype plugin indent on
syntax on           " syntax highlighting

set encoding=utf-8    " default encoding for new files
set number            " line numbers
set expandtab         " automatically emit spaces instead of tab characters
set smarttab          " tab/backspace 'shiftwidth' characters of leading indent
set softtabstop=4     " insert 4 spaces when pressing Tab in insert mode
set shiftwidth=4      " shift 4 spaces with << and >>
set autoindent        " automatically set indent on new lines based on syntax
set cursorline        " highlight the line the cursor's in
set hidden            " set buffers to hidden when you move to a new one
set incsearch         " incremental search with /?
set hlsearch          " highlight all search matches
set ignorecase        " when typing searches in lowercase, be case-insensitive
set smartcase         " ...but if you include uppercase, be case-sensitive
set showcmd           " show current command in the bottom-right corner
set foldopen-=block   " when navigating with {} don't open folds
set showmatch         " jump cursor to the opening ([{ when you type a matching }])
set matchtime=1       " ...but only for 100ms
set visualbell        " flash screen instead of sending BEL
set textwidth=100     " default text-wrap width
set diffopt+=iwhite   " ignore leading whitespace in diff mode
set foldcolumn=1      " display information about folds in gutter behind line numbers
set foldlevelstart=99 " start with all folds open
set scrolloff=5       " always keep 5 lines between the cursor and the edge of the screen
set scrolljump=5      " scroll 5 lines at a time when the cursor moves off the edge
set splitbelow        " split new horizontal windows underneath the current one
set splitright        " split new vertical windows to the right of the current one
set path+=**          " allow `:find`, tab-completion et al to search through subdirectories
set laststatus=2      " always show status line
set ttimeoutlen=500   " time out commands at 0.5sec, so the mode display is a little faster

" show tab complete menu and tab-complete to the longest substring
set wildmenu
set wildmode=list:longest

" show trailing spaces, tab characters, and NBSP characters in the editor, and also mark when lines
" extend past the screen when 'nowrap' is set
set list
set listchars=trail:~,tab:>-,nbsp:%,extends:*

" make backspace not stupid on windows
set backspace=indent,eol,start

" use ripgrep as :grep backend if available
if executable('rg')
    set grepprg=rg\ --vimgrep\ --color=never
endif

" don't save these settings in session files, so we can overwrite them with vimrc changes
set sessionoptions-=options

" if mouse support is available, set it for normal and visual modes
" (this will enable it for terminal vim and diable insert-mode mouse for gvim)
if has('mouse')
    set mouse=nv
endif

set background=light
colorscheme lucius

" }}}

" custom commands {{{

" function to wrap a command and preserve its search string and cursor position
function! Preserve(command)
    " Preparation: save last search, and cursor position.
    let l:_s=@/
    let l:l = line('.')
    let l:c = col('.')
    " Do the business:
    execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=l:_s
    call cursor(l:l, l:c)
endfunction

" command :TrimTrailing removes trailing whitespace in the file
command TrimTrailing call Preserve("%s/\\s\\+$")

" use <leader><space> to clear search and :match highlights
nnoremap <silent> <leader><space> :nohlsearch<Bar>match none<CR>

" use <leader>h to highlight the word under the cursor
nnoremap <Leader>h :match Search /<C-R><C-W>/<CR>

" navigate buffers like you would tabs
nnoremap gB :<C-U>exe ':' . v:count . 'bprevious'<CR>
nnoremap gb :<C-U>exe (v:count ? ':' . v:count . 'b' : ':bnext')<CR>

" press space in visual-block mode to prepend a space to the block (and re-select it)
xnoremap <Space> I<Space><Esc>gvlolo

" stolen from defaults.vim
augroup loadFile
    autocmd!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
augroup END

command DisableCursorRecall augroup loadFile | autocmd! | augroup END

" also stolen from defaults.vim, this shows a diff between a buffer and the file on disk
command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis

" commands to clear out the quickfix/location lists
command ClearQuickfixList cgetexpr ''
command ClearLocationList lgetexpr ''

" navigate the quickfix/location lists
nnoremap <leader>qq :cnext<CR>
nnoremap <leader>q<leader> :cprevious<CR>
nnoremap <leader>ll :lnext<CR>
nnoremap <leader>l<leader> :lprevious<CR>

" }}}

" filetype-specific settings {{{

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
    autocmd Filetype rust setlocal foldmethod=syntax
augroup END

augroup markdown
    autocmd!
    " .md and .mmd files are markdown
    autocmd BufRead,BufNewFile *.md set filetype=markdown
    autocmd BufRead,BufNewFile *.mmd set filetype=markdown

    " use spaces in multi-markdown files
    autocmd BufRead,BufNewFile *.mmd set expandtab

    " enable spell-check for markdown files
    autocmd FileType markdown setlocal spell
    autocmd FileType markdown setlocal spelllang=en_us
augroup END

augroup vimscript
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

augroup quickfix
    autocmd!
    " don't include quickfix/location lists in the buffer list
    autocmd FileType qf setlocal nobuflisted
augroup END

" }}}

" plugin-specfic settings {{{

" detectindent settings
" set 'shiftwidth'/'tabstop' to 4 when detectindent fails
let g:detectindent_preferred_indent = 4
" use the above setting when mixed indentation is detected
let g:detectindent_preferred_when_mixed = 1

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

" }}}

" load per-machine settings {{{
" per-machine settings can go in a file named after its hostname
let s:home_dir = $USERPROFILE
if empty(s:home_dir)
    let s:home_dir = $HOME
endif

if filereadable(s:home_dir . "/.vim/" . hostname() . ".vim") ||
            \ filereadable(s:home_dir . "/vimfiles/" . hostname() . ".vim")
    execute "runtime " . hostname() . ".vim"
endif
" }}}

" super-janky session management {{{
" use :Saveoff to dump current session to './session.vim' and quit
command -nargs=0 Saveoff :mksession! session.vim | :qa

" ...and load the 'session.vim' file if it's there
if filereadable("session.vim") && filewritable("session.vim") && argc() == 0
    source session.vim
endif
" }}}
