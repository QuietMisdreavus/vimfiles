" use filetype info, let plugins set it, use indent info from filetype data
filetype plugin indent on
syntax on           " syntax highlighting
set encoding=utf-8  " default encoding for new files
set number          " line numbers
set expandtab       " automatically emit spaces instead of tab characters
set tabstop=4       " tabstop/shiftwidth handle how vim handles tabs and indent
set shiftwidth=4    " i honestly forget which does which >_>
set autoindent      " automatically set indent on new lines based on syntax
set cursorline      " highlight the line the cursor's in
set hidden          " set buffers to hidden when you move to a new one
set incsearch       " incremental search with /?
set hlsearch        " highlight all search matches
set ignorecase      " when typing searches in lowercase, be case-insensitive
set smartcase       " ...but if you include uppercase, be case-sensitive
set showcmd         " show current command in the bottom-right corner
set foldopen-=block " when navigating with {} don't open folds
set showmatch       " jump cursor to the opening ([{ when you type a matching }])
set visualbell      " flash screen instead of sending BEL
set textwidth=100   " default text-wrap width
set diffopt+=iwhite " ignore leading whitespace in diff mode
set foldcolumn=1    " display information about folds in gutter behind line numbers

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

" custom status bar
set statusline=
set statusline+=[\ %{mode('1')}\ ]                  " mode flag
set statusline+=%#Folded#                           " color next section medium
set statusline+=%(%{FugitiveStatusline()}%)         " git HEAD
set statusline+=%#SignColumn#                       " color next section light
set statusline+=\ #%n:\ %f                          " buf number: filename
set statusline+=%=                                  " right-align remaining items
set statusline+=%#Folded#                           " color next section medium
set statusline+=%h%w%m%y                            " flags: [help][preview][mod][filetype]
set statusline+=%*                                  " color next section dark (normal)
set statusline+=ln\ %l/%L\ cl\ %c\                  " line number, col number
set statusline+=%#Error#                            " color next section red
set statusline+=%{MisdreavusTrailingSpaceCheck()}   " trailing whitespace marker
set statusline+=%{MisdreavusTabsSpacesCheck()}      " mixed indent (in same line) marker
set statusline+=%{MisdreavusMixedIndentCheck()}     " mixed indent (across file) marker
set statusline+=%*                                  " reset statusline color at the end

" trailing whitespace check for statusline
function! MisdreavusTrailingSpaceCheck()
    if !exists("b:misdreavus_trailing_space_mark")
        let skip = (&filetype == 'help') && !&modifiable
        if !skip && search('\s\+$', 'nw') != 0
            let b:misdreavus_trailing_space_mark = '[tws]'
        else
            let b:misdreavus_trailing_space_mark = ''
        endif
    endif

    return b:misdreavus_trailing_space_mark
endfunction

" mixed indent (within the same line) check for statusline
function! MisdreavusTabsSpacesCheck()
    if !exists("b:misdreavus_tabs_spaces_mark")
        let skip = (&filetype == 'help') && !&modifiable
        let spaces_before_tabs = search('^ \+\t', 'nw') != 0
        let tabs_before_spaces = search('^\t\+ ', 'nw') != 0

        if !skip && (spaces_before_tabs || tabs_before_spaces)
            let b:misdreavus_tabs_spaces_mark = '[t/s]'
        else
            let b:misdreavus_tabs_spaces_mark = ''
        endif
    endif

    return b:misdreavus_tabs_spaces_mark
endfunction

" mixed indent (across the whole file) check for statusline
function! MisdreavusMixedIndentCheck()
    if !exists("b:misdreavus_mixed_indent_mark")
        let skip = (&filetype == 'help') && !&modifiable
        let tabs = search('^ \+', 'nw') != 0
        let spaces = search('^\t\+', 'nw') != 0

        if !skip && tabs && spaces
            let b:misdreavus_mixed_indent_mark = '[mi]'
        else
            let b:misdreavus_mixed_indent_mark = ''
        endif
    endif

    return b:misdreavus_mixed_indent_mark
endfunction

" clear statusline marker caches when idle or on write
augroup statusline
    autocmd!
    autocmd CursorHold,BufWritePost * unlet! b:misdreavus_trailing_space_mark
    autocmd CursorHold,BufWritePost * unlet! b:misdreavus_tabs_spaces_mark
    autocmd CursorHold,BufWritePost * unlet! b:misdreavus_mixed_indent_mark
augroup END

" command :TrimTrailing removes trailing whitespace in the file
command TrimTrailing %s/\s\+$

" use <leader><space> to clear search and :match highlights
nnoremap <silent> <leader><space> :nohlsearch<Bar>match none<CR>

" use <leader>h to highlight the word under the cursor
nnoremap <Leader>h :match Search /<C-R><C-W>/<CR>

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
    autocmd Filetype rust setlocal foldmethod=syntax
    autocmd Filetype rust setlocal foldlevel=99
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

set background=light
colorscheme lucius

" don't save these settings in session files, so we can overwrite them with vimrc changes
set sessionoptions-=options

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
" always show status line, so we always have airline
set laststatus=2
" time out commands at 0.5sec, so the mode display is a little faster
set ttimeoutlen=500

" per-machine settings can go in a file named after its hostname
let s:home_dir = $USERPROFILE
if empty(s:home_dir)
    let s:home_dir = $HOME
endif

if filereadable(s:home_dir . "/.vim/" . hostname() . ".vim") ||
            \ filereadable(s:home_dir . "/vimfiles/" . hostname() . ".vim")
    execute "runtime " . hostname() . ".vim"
endif

" super-janky session management
" use :Saveoff to dump current session to './session.vim' and quit
command -nargs=0 Saveoff :mksession! session.vim | :qa

" ...and load the 'session.vim' file if it's there
if filereadable("session.vim") && filewritable("session.vim") && argc() == 0
    source session.vim
endif
