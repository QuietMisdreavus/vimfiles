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

" custom status bar {{{
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

        if !skip && spaces_before_tabs
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
" }}}

" custom tabline {{{

" always show tabline, even when only one tab is active
set showtabline=2

function! MisdreavusTabline()
    let s = ''

    if tabpagenr('$') > 1
        " tabs are being used, display the tab number
        let s .= '%#TODO#'
        let s .= ' tab #' . tabpagenr()
        let s .= ' %999X[X]%X ' " close button
    endif

    let curbuf = bufnr()
    let altbuf = bufnr('#')
    let visbufs = tabpagebuflist()
    let firstbuf = v:true

    let s .= '%#TabLine#'

    for b in range(1, bufnr('$'))
        if !bufexists(b)
            continue
        elseif !buflisted(b) && (b != curbuf)
            continue
        endif

        if firstbuf
            let firstbuf = v:false
        else
            let s .= '|'
        endif

        if b == curbuf
            let s .= '%#TabLineSel#'
        elseif index(visbufs, b) != -1
            let s .= '%#SignColumn#'
        endif

        " number buffers, but signify the alternate buffer with ^N instead of #N
        let hash = '#'
        if b == altbuf
            let hash = '^'
        endif

        if !buflisted(b)
            " help files are not listed, but i want to be able to see my current buffer in the tab
            " bar regardless. i don't want to print the full path tho, so just grab the filename
            let name = bufname(b)->fnamemodify(':t')
        else
            let name = bufname(b)->pathshorten()
        endif

        if name == ''
            let name = '[no name]'
        endif

        let s .= ' ' . hash . b . ':'
        let s .= ' ' . name . ' '

        if getbufvar(b, '&mod')
            let s .= '[+] '
        endif

        if b == curbuf || index(visbufs, b) != -1
            let s .= '%#TabLine#'
        endif
    endfor

    " color remainder light
    let s .= '%#Folded#'

    return s
endfunction

set tabline=%!MisdreavusTabline()

" }}}

" custom commands {{{

" command :TrimTrailing removes trailing whitespace in the file
command TrimTrailing %s/\s\+$

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
